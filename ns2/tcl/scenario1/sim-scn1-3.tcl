#sim-scn1-3.tcl 
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
set tracefd       [open sim-scn1-3-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-3-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-3-$val(rp).nam w]

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
$node_(0) set X_ 2245 
$node_(0) set Y_ 877 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 1421 
$node_(1) set Y_ 165 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 454 
$node_(2) set Y_ 65 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1696 
$node_(3) set Y_ 520 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1367 
$node_(4) set Y_ 849 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 124 
$node_(5) set Y_ 201 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 501 
$node_(6) set Y_ 502 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2973 
$node_(7) set Y_ 675 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2343 
$node_(8) set Y_ 394 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1831 
$node_(9) set Y_ 133 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 969 
$node_(10) set Y_ 776 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1473 
$node_(11) set Y_ 315 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1913 
$node_(12) set Y_ 51 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1051 
$node_(13) set Y_ 359 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 318 
$node_(14) set Y_ 276 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1394 
$node_(15) set Y_ 516 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1308 
$node_(16) set Y_ 607 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 749 
$node_(17) set Y_ 744 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2388 
$node_(18) set Y_ 173 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2236 
$node_(19) set Y_ 887 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 2509 
$node_(20) set Y_ 606 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 749 
$node_(21) set Y_ 169 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 225 
$node_(22) set Y_ 96 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2955 
$node_(23) set Y_ 213 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2190 
$node_(24) set Y_ 346 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1416 
$node_(25) set Y_ 631 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 909 
$node_(26) set Y_ 269 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 699 
$node_(27) set Y_ 533 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 443 
$node_(28) set Y_ 616 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1692 
$node_(29) set Y_ 959 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2394 
$node_(30) set Y_ 959 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1084 
$node_(31) set Y_ 321 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 164 
$node_(32) set Y_ 645 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1279 
$node_(33) set Y_ 447 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2105 
$node_(34) set Y_ 368 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 682 
$node_(35) set Y_ 698 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 734 
$node_(36) set Y_ 16 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2541 
$node_(37) set Y_ 942 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 784 
$node_(38) set Y_ 309 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2156 
$node_(39) set Y_ 859 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2339 
$node_(40) set Y_ 521 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2417 
$node_(41) set Y_ 202 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1826 
$node_(42) set Y_ 305 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 226 
$node_(43) set Y_ 117 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2079 
$node_(44) set Y_ 204 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1426 
$node_(45) set Y_ 569 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1121 
$node_(46) set Y_ 951 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 404 
$node_(47) set Y_ 275 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2719 
$node_(48) set Y_ 78 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 546 
$node_(49) set Y_ 248 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2119 
$node_(50) set Y_ 662 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1171 
$node_(51) set Y_ 219 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 1705 
$node_(52) set Y_ 252 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2556 
$node_(53) set Y_ 768 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 1643 
$node_(54) set Y_ 179 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 44 
$node_(55) set Y_ 926 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 825 
$node_(56) set Y_ 454 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2119 
$node_(57) set Y_ 397 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 677 
$node_(58) set Y_ 425 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 700 
$node_(59) set Y_ 310 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2623 
$node_(60) set Y_ 200 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 685 
$node_(61) set Y_ 581 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2129 
$node_(62) set Y_ 600 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2111 
$node_(63) set Y_ 575 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2455 
$node_(64) set Y_ 83 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2019 
$node_(65) set Y_ 700 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 321 
$node_(66) set Y_ 606 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 2350 
$node_(67) set Y_ 14 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 784 
$node_(68) set Y_ 929 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1902 
$node_(69) set Y_ 692 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 698 
$node_(70) set Y_ 176 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 2518 
$node_(71) set Y_ 412 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1112 
$node_(72) set Y_ 807 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 1333 
$node_(73) set Y_ 354 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1001 
$node_(74) set Y_ 322 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2980 
$node_(75) set Y_ 496 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 1642 
$node_(76) set Y_ 124 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1268 
$node_(77) set Y_ 353 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 899 
$node_(78) set Y_ 961 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2819 
$node_(79) set Y_ 95 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 1571 
$node_(80) set Y_ 308 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 725 
$node_(81) set Y_ 269 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 2833 
$node_(82) set Y_ 828 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 2218 
$node_(83) set Y_ 944 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1609 
$node_(84) set Y_ 805 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2797 
$node_(85) set Y_ 203 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 562 
$node_(86) set Y_ 56 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2193 
$node_(87) set Y_ 305 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 109 
$node_(88) set Y_ 378 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 895 
$node_(89) set Y_ 765 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 656 
$node_(90) set Y_ 11 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2856 
$node_(91) set Y_ 826 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 1925 
$node_(92) set Y_ 958 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2270 
$node_(93) set Y_ 482 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2939 
$node_(94) set Y_ 268 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 2147 
$node_(95) set Y_ 325 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 877 
$node_(96) set Y_ 518 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2626 
$node_(97) set Y_ 929 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1621 
$node_(98) set Y_ 833 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 722 
$node_(99) set Y_ 414 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2421 730 3.0" 
$ns at 19.19816421743743 "$node_(0) setdest 617 969 9.0" 
$ns at 61.929256779716084 "$node_(0) setdest 933 369 13.0" 
$ns at 134.49011588882587 "$node_(0) setdest 1305 245 10.0" 
$ns at 262.79151708778136 "$node_(0) setdest 687 721 18.0" 
$ns at 563.5410604423413 "$node_(0) setdest 2706 673 4.0" 
$ns at 0.0 "$node_(1) setdest 2426 477 18.0" 
$ns at 15.19123297970594 "$node_(1) setdest 851 42 1.0" 
$ns at 53.886367004973735 "$node_(1) setdest 1143 847 15.0" 
$ns at 240.70656739912812 "$node_(1) setdest 1810 812 1.0" 
$ns at 368.91150691347957 "$node_(1) setdest 2426 890 5.0" 
$ns at 611.318417092461 "$node_(1) setdest 643 188 12.0" 
$ns at 0.0 "$node_(2) setdest 2514 293 15.0" 
$ns at 140.36575723110394 "$node_(2) setdest 2271 223 9.0" 
$ns at 197.81213798064374 "$node_(2) setdest 912 86 1.0" 
$ns at 260.2672232970332 "$node_(2) setdest 1998 89 20.0" 
$ns at 488.7154232654567 "$node_(2) setdest 1203 41 6.0" 
$ns at 762.7979668424452 "$node_(2) setdest 194 840 14.0" 
$ns at 0.0 "$node_(3) setdest 1415 731 20.0" 
$ns at 69.69202954517255 "$node_(3) setdest 389 329 13.0" 
$ns at 187.95156861987294 "$node_(3) setdest 72 490 13.0" 
$ns at 309.1282033233426 "$node_(3) setdest 746 94 3.0" 
$ns at 429.638972051 "$node_(3) setdest 2804 773 6.0" 
$ns at 681.6771485501965 "$node_(3) setdest 1701 363 14.0" 
$ns at 0.0 "$node_(4) setdest 118 643 4.0" 
$ns at 19.635701366986446 "$node_(4) setdest 2231 520 12.0" 
$ns at 134.31699935742643 "$node_(4) setdest 1732 368 8.0" 
$ns at 221.86073050577028 "$node_(4) setdest 9 658 19.0" 
$ns at 363.5109759168107 "$node_(4) setdest 559 391 2.0" 
$ns at 615.323510368726 "$node_(4) setdest 2450 70 14.0" 
$ns at 0.0 "$node_(5) setdest 1235 131 20.0" 
$ns at 170.02172837378373 "$node_(5) setdest 2379 805 9.0" 
$ns at 257.72593830740925 "$node_(5) setdest 2815 373 2.0" 
$ns at 332.9303341694552 "$node_(5) setdest 1830 637 4.0" 
$ns at 464.7084332873882 "$node_(5) setdest 2976 229 3.0" 
$ns at 733.7025306306087 "$node_(5) setdest 208 76 19.0" 
$ns at 0.0 "$node_(6) setdest 1899 913 16.0" 
$ns at 163.4704334532022 "$node_(6) setdest 1834 277 10.0" 
$ns at 247.12364977597662 "$node_(6) setdest 2649 801 17.0" 
$ns at 322.145203647053 "$node_(6) setdest 2582 948 2.0" 
$ns at 456.0250567222584 "$node_(6) setdest 2708 548 8.0" 
$ns at 727.1063790358355 "$node_(6) setdest 149 650 11.0" 
$ns at 0.0 "$node_(7) setdest 2028 207 1.0" 
$ns at 19.457357539430824 "$node_(7) setdest 1162 72 3.0" 
$ns at 68.07384839426786 "$node_(7) setdest 2707 632 12.0" 
$ns at 173.22840695125316 "$node_(7) setdest 2149 160 11.0" 
$ns at 345.69445548442684 "$node_(7) setdest 179 616 7.0" 
$ns at 624.9943328669779 "$node_(7) setdest 103 213 14.0" 
$ns at 0.0 "$node_(8) setdest 2531 527 1.0" 
$ns at 24.078864721885544 "$node_(8) setdest 2139 303 1.0" 
$ns at 64.02072307367804 "$node_(8) setdest 1314 420 14.0" 
$ns at 180.525272366926 "$node_(8) setdest 1496 637 1.0" 
$ns at 304.51002440551076 "$node_(8) setdest 978 867 18.0" 
$ns at 548.0109457323738 "$node_(8) setdest 1870 723 3.0" 
$ns at 0.0 "$node_(9) setdest 1799 984 17.0" 
$ns at 58.81702573100964 "$node_(9) setdest 1836 455 20.0" 
$ns at 103.05704859303793 "$node_(9) setdest 2910 414 7.0" 
$ns at 225.9425998636179 "$node_(9) setdest 1839 476 2.0" 
$ns at 361.07388461403207 "$node_(9) setdest 2823 226 10.0" 
$ns at 675.3897254121746 "$node_(9) setdest 1022 434 4.0" 
$ns at 0.0 "$node_(10) setdest 2550 994 10.0" 
$ns at 55.95463099284052 "$node_(10) setdest 2862 999 3.0" 
$ns at 99.40060599109427 "$node_(10) setdest 2205 528 19.0" 
$ns at 249.46098340499333 "$node_(10) setdest 1383 752 5.0" 
$ns at 377.88352793310287 "$node_(10) setdest 691 7 14.0" 
$ns at 690.1570696044033 "$node_(10) setdest 1424 293 19.0" 
$ns at 0.0 "$node_(11) setdest 2869 484 10.0" 
$ns at 101.48777540217837 "$node_(11) setdest 1224 219 3.0" 
$ns at 135.62170653631733 "$node_(11) setdest 299 30 6.0" 
$ns at 201.3434095319062 "$node_(11) setdest 1307 794 18.0" 
$ns at 475.1385723596453 "$node_(11) setdest 457 973 6.0" 
$ns at 749.9940469346718 "$node_(11) setdest 2414 452 8.0" 
$ns at 0.0 "$node_(12) setdest 20 996 13.0" 
$ns at 99.1580742806036 "$node_(12) setdest 997 479 5.0" 
$ns at 146.58164505208828 "$node_(12) setdest 2607 69 19.0" 
$ns at 231.74817364432394 "$node_(12) setdest 487 507 15.0" 
$ns at 406.18523202870426 "$node_(12) setdest 2094 456 10.0" 
$ns at 686.2514034868593 "$node_(12) setdest 368 656 6.0" 
$ns at 0.0 "$node_(13) setdest 371 283 11.0" 
$ns at 27.55358444838706 "$node_(13) setdest 777 468 10.0" 
$ns at 82.02312297871929 "$node_(13) setdest 165 420 16.0" 
$ns at 191.70440456469032 "$node_(13) setdest 1140 969 10.0" 
$ns at 403.75211054097207 "$node_(13) setdest 1297 633 12.0" 
$ns at 714.3865093348281 "$node_(13) setdest 2082 493 4.0" 
$ns at 0.0 "$node_(14) setdest 2499 288 19.0" 
$ns at 100.97785865436803 "$node_(14) setdest 2617 115 1.0" 
$ns at 134.68747939001463 "$node_(14) setdest 2655 51 9.0" 
$ns at 205.02871140285342 "$node_(14) setdest 351 820 4.0" 
$ns at 358.63132867204695 "$node_(14) setdest 2099 358 1.0" 
$ns at 601.7375226947413 "$node_(14) setdest 205 760 8.0" 
$ns at 0.0 "$node_(15) setdest 2320 618 19.0" 
$ns at 189.9815651186463 "$node_(15) setdest 1900 222 12.0" 
$ns at 300.77424877998476 "$node_(15) setdest 225 410 19.0" 
$ns at 448.1008131551732 "$node_(15) setdest 200 163 2.0" 
$ns at 581.5286747160078 "$node_(15) setdest 802 134 9.0" 
$ns at 886.425989609188 "$node_(15) setdest 2658 429 13.0" 
$ns at 0.0 "$node_(16) setdest 821 886 9.0" 
$ns at 27.79821928205841 "$node_(16) setdest 1364 17 9.0" 
$ns at 84.9506288598607 "$node_(16) setdest 1939 519 16.0" 
$ns at 253.38617644647283 "$node_(16) setdest 936 2 1.0" 
$ns at 373.65482688128077 "$node_(16) setdest 1333 141 19.0" 
$ns at 659.3673476624672 "$node_(16) setdest 1763 982 18.0" 
$ns at 0.0 "$node_(17) setdest 1727 543 7.0" 
$ns at 15.547054401156103 "$node_(17) setdest 224 162 13.0" 
$ns at 127.13213045934033 "$node_(17) setdest 2440 277 4.0" 
$ns at 192.8364939550404 "$node_(17) setdest 2402 436 1.0" 
$ns at 315.5035292533489 "$node_(17) setdest 2818 395 2.0" 
$ns at 570.1770448452183 "$node_(17) setdest 521 81 11.0" 
$ns at 0.0 "$node_(18) setdest 2183 65 17.0" 
$ns at 15.399521603757414 "$node_(18) setdest 118 929 15.0" 
$ns at 69.25471471947893 "$node_(18) setdest 2157 577 4.0" 
$ns at 132.3913410407676 "$node_(18) setdest 682 125 1.0" 
$ns at 257.15993834342504 "$node_(18) setdest 2995 446 1.0" 
$ns at 506.1135904600966 "$node_(18) setdest 1265 843 8.0" 
$ns at 0.0 "$node_(19) setdest 1284 634 5.0" 
$ns at 15.294444139174011 "$node_(19) setdest 1305 560 3.0" 
$ns at 53.94206090607393 "$node_(19) setdest 140 107 7.0" 
$ns at 139.7279689708224 "$node_(19) setdest 667 765 16.0" 
$ns at 327.45681797651355 "$node_(19) setdest 1774 216 14.0" 
$ns at 624.1808118339445 "$node_(19) setdest 633 208 5.0" 
$ns at 0.0 "$node_(20) setdest 1040 654 7.0" 
$ns at 76.84435990993677 "$node_(20) setdest 2354 57 6.0" 
$ns at 110.10035566848595 "$node_(20) setdest 2343 967 18.0" 
$ns at 245.62308993150435 "$node_(20) setdest 2993 566 19.0" 
$ns at 444.7194803571602 "$node_(20) setdest 2024 853 9.0" 
$ns at 743.8530248531363 "$node_(20) setdest 2572 140 19.0" 
$ns at 0.0 "$node_(21) setdest 2099 754 8.0" 
$ns at 48.61339942099066 "$node_(21) setdest 2255 878 3.0" 
$ns at 89.25573904284596 "$node_(21) setdest 1963 460 13.0" 
$ns at 200.32240131193907 "$node_(21) setdest 2572 988 9.0" 
$ns at 344.4610287878326 "$node_(21) setdest 2444 724 4.0" 
$ns at 589.4165347874261 "$node_(21) setdest 1825 667 12.0" 
$ns at 0.0 "$node_(22) setdest 314 131 12.0" 
$ns at 64.19637984811388 "$node_(22) setdest 1676 320 7.0" 
$ns at 114.52639791069919 "$node_(22) setdest 136 691 10.0" 
$ns at 210.13704234284452 "$node_(22) setdest 660 223 5.0" 
$ns at 369.0628919630918 "$node_(22) setdest 2068 916 17.0" 
$ns at 722.1678754285281 "$node_(22) setdest 2120 4 15.0" 
$ns at 0.0 "$node_(23) setdest 2993 357 1.0" 
$ns at 24.57783284271293 "$node_(23) setdest 812 544 5.0" 
$ns at 83.36682886537918 "$node_(23) setdest 1097 833 13.0" 
$ns at 165.5082022887812 "$node_(23) setdest 175 170 15.0" 
$ns at 349.94260510430473 "$node_(23) setdest 761 866 19.0" 
$ns at 653.9969578797696 "$node_(23) setdest 2003 245 20.0" 
$ns at 0.0 "$node_(24) setdest 402 23 3.0" 
$ns at 24.072722970183836 "$node_(24) setdest 1043 528 2.0" 
$ns at 58.061659497421815 "$node_(24) setdest 620 191 12.0" 
$ns at 137.95754032547558 "$node_(24) setdest 2720 909 7.0" 
$ns at 273.82158259711053 "$node_(24) setdest 1772 991 9.0" 
$ns at 559.8211882614112 "$node_(24) setdest 2035 389 8.0" 
$ns at 0.0 "$node_(25) setdest 2859 848 10.0" 
$ns at 86.96305228603886 "$node_(25) setdest 342 408 7.0" 
$ns at 170.73322316703087 "$node_(25) setdest 2332 426 19.0" 
$ns at 405.21446458777234 "$node_(25) setdest 2523 901 1.0" 
$ns at 533.8743382096077 "$node_(25) setdest 2190 446 7.0" 
$ns at 799.3469300383874 "$node_(25) setdest 798 674 18.0" 
$ns at 0.0 "$node_(26) setdest 2504 102 2.0" 
$ns at 21.270859024056556 "$node_(26) setdest 169 985 3.0" 
$ns at 57.79709210187292 "$node_(26) setdest 1219 572 4.0" 
$ns at 145.1206711006814 "$node_(26) setdest 244 427 17.0" 
$ns at 378.07989015479484 "$node_(26) setdest 2868 367 6.0" 
$ns at 620.6787089200786 "$node_(26) setdest 1932 483 10.0" 
$ns at 0.0 "$node_(27) setdest 1571 497 17.0" 
$ns at 143.39530026465457 "$node_(27) setdest 270 367 2.0" 
$ns at 189.8699262391347 "$node_(27) setdest 422 703 8.0" 
$ns at 273.4971609308845 "$node_(27) setdest 353 11 12.0" 
$ns at 505.5955456626374 "$node_(27) setdest 1166 229 2.0" 
$ns at 747.0131354017478 "$node_(27) setdest 1142 314 8.0" 
$ns at 0.0 "$node_(28) setdest 748 884 6.0" 
$ns at 31.6265826684372 "$node_(28) setdest 619 16 10.0" 
$ns at 131.51832235094236 "$node_(28) setdest 2146 384 7.0" 
$ns at 233.25037500822174 "$node_(28) setdest 1559 809 17.0" 
$ns at 478.33995727606606 "$node_(28) setdest 2576 198 9.0" 
$ns at 789.353461472987 "$node_(28) setdest 898 547 16.0" 
$ns at 0.0 "$node_(29) setdest 958 400 5.0" 
$ns at 39.05468771678481 "$node_(29) setdest 449 673 20.0" 
$ns at 110.02752936831187 "$node_(29) setdest 1258 264 18.0" 
$ns at 294.6160530297612 "$node_(29) setdest 2461 225 10.0" 
$ns at 434.08278049614495 "$node_(29) setdest 1082 577 5.0" 
$ns at 719.6701063489462 "$node_(29) setdest 2279 23 19.0" 
$ns at 0.0 "$node_(30) setdest 634 928 9.0" 
$ns at 84.3292264915388 "$node_(30) setdest 73 927 19.0" 
$ns at 298.19945741040567 "$node_(30) setdest 1921 448 16.0" 
$ns at 455.3777992521677 "$node_(30) setdest 411 243 1.0" 
$ns at 583.4974709668471 "$node_(30) setdest 1812 739 17.0" 
$ns at 0.0 "$node_(31) setdest 2161 674 15.0" 
$ns at 83.62314939442145 "$node_(31) setdest 1337 989 19.0" 
$ns at 201.36971495731532 "$node_(31) setdest 2963 411 4.0" 
$ns at 278.48644080880456 "$node_(31) setdest 338 505 4.0" 
$ns at 403.94047797225994 "$node_(31) setdest 1271 225 11.0" 
$ns at 694.1258299449861 "$node_(31) setdest 1341 152 13.0" 
$ns at 0.0 "$node_(32) setdest 718 689 6.0" 
$ns at 49.56882710792976 "$node_(32) setdest 2280 439 1.0" 
$ns at 88.46292362444022 "$node_(32) setdest 1287 878 20.0" 
$ns at 170.13787885382874 "$node_(32) setdest 434 238 18.0" 
$ns at 462.3544442273277 "$node_(32) setdest 1547 166 19.0" 
$ns at 886.1710618525155 "$node_(32) setdest 705 378 17.0" 
$ns at 0.0 "$node_(33) setdest 938 983 11.0" 
$ns at 121.15206632594445 "$node_(33) setdest 1103 596 1.0" 
$ns at 151.70429393631832 "$node_(33) setdest 863 653 4.0" 
$ns at 213.11262718084475 "$node_(33) setdest 1064 591 3.0" 
$ns at 342.41480552158373 "$node_(33) setdest 1075 655 8.0" 
$ns at 627.0610260920214 "$node_(33) setdest 967 160 1.0" 
$ns at 0.0 "$node_(34) setdest 605 947 18.0" 
$ns at 52.21018557357685 "$node_(34) setdest 977 664 6.0" 
$ns at 120.51975669698595 "$node_(34) setdest 1235 197 3.0" 
$ns at 210.33803203156063 "$node_(34) setdest 2079 309 7.0" 
$ns at 386.9787390144952 "$node_(34) setdest 247 41 17.0" 
$ns at 702.4924639710842 "$node_(34) setdest 924 970 3.0" 
$ns at 0.0 "$node_(35) setdest 1970 733 16.0" 
$ns at 25.667047357812525 "$node_(35) setdest 873 570 4.0" 
$ns at 72.47246543781611 "$node_(35) setdest 333 797 17.0" 
$ns at 226.85064138876993 "$node_(35) setdest 2330 222 9.0" 
$ns at 363.15249496607055 "$node_(35) setdest 2464 543 7.0" 
$ns at 630.5014634628476 "$node_(35) setdest 2271 647 13.0" 
$ns at 0.0 "$node_(36) setdest 2042 571 1.0" 
$ns at 22.724782415050278 "$node_(36) setdest 560 600 10.0" 
$ns at 95.9024059399458 "$node_(36) setdest 923 608 17.0" 
$ns at 164.93188935592462 "$node_(36) setdest 2440 279 4.0" 
$ns at 285.1025387383874 "$node_(36) setdest 1279 305 7.0" 
$ns at 532.3704618411315 "$node_(36) setdest 1315 975 18.0" 
$ns at 0.0 "$node_(37) setdest 2240 861 1.0" 
$ns at 17.8541658852214 "$node_(37) setdest 1698 438 19.0" 
$ns at 121.53520348238479 "$node_(37) setdest 2795 565 14.0" 
$ns at 314.6461940059271 "$node_(37) setdest 1931 701 6.0" 
$ns at 479.4868359882179 "$node_(37) setdest 1441 647 3.0" 
$ns at 739.1321676564713 "$node_(37) setdest 1077 352 12.0" 
$ns at 0.0 "$node_(38) setdest 1830 37 15.0" 
$ns at 89.6132382073593 "$node_(38) setdest 2072 492 15.0" 
$ns at 150.96072562008231 "$node_(38) setdest 1407 887 11.0" 
$ns at 241.23485580038746 "$node_(38) setdest 2036 864 16.0" 
$ns at 468.472080701114 "$node_(38) setdest 789 992 7.0" 
$ns at 734.2559478957492 "$node_(38) setdest 340 891 1.0" 
$ns at 0.0 "$node_(39) setdest 376 451 15.0" 
$ns at 95.5983774207943 "$node_(39) setdest 1825 622 6.0" 
$ns at 167.38298082804064 "$node_(39) setdest 2443 193 4.0" 
$ns at 229.63899969064119 "$node_(39) setdest 2273 806 18.0" 
$ns at 420.58932086531036 "$node_(39) setdest 1714 235 17.0" 
$ns at 806.5858224414222 "$node_(39) setdest 1008 601 11.0" 
$ns at 0.0 "$node_(40) setdest 2152 767 7.0" 
$ns at 58.38923408624083 "$node_(40) setdest 2257 639 2.0" 
$ns at 101.67099562311967 "$node_(40) setdest 2475 453 10.0" 
$ns at 257.0327555495204 "$node_(40) setdest 626 455 1.0" 
$ns at 379.0365314041651 "$node_(40) setdest 1629 534 12.0" 
$ns at 636.9196685497493 "$node_(40) setdest 829 493 5.0" 
$ns at 0.0 "$node_(41) setdest 1230 625 11.0" 
$ns at 28.310233194840777 "$node_(41) setdest 2526 205 7.0" 
$ns at 64.54271596289988 "$node_(41) setdest 713 290 9.0" 
$ns at 169.77911912695055 "$node_(41) setdest 1896 960 17.0" 
$ns at 351.9351450828833 "$node_(41) setdest 2677 781 13.0" 
$ns at 598.9516525317238 "$node_(41) setdest 2331 759 6.0" 
$ns at 0.0 "$node_(42) setdest 1688 548 16.0" 
$ns at 145.15048447957443 "$node_(42) setdest 342 996 12.0" 
$ns at 185.62962810396576 "$node_(42) setdest 2524 368 20.0" 
$ns at 379.101953837802 "$node_(42) setdest 575 755 11.0" 
$ns at 509.36221409772287 "$node_(42) setdest 612 239 14.0" 
$ns at 786.2754071244983 "$node_(42) setdest 546 370 3.0" 
$ns at 0.0 "$node_(43) setdest 2156 363 2.0" 
$ns at 23.907554678351765 "$node_(43) setdest 472 250 1.0" 
$ns at 61.65478343619247 "$node_(43) setdest 190 867 3.0" 
$ns at 140.5468563972343 "$node_(43) setdest 1304 202 6.0" 
$ns at 311.45603468756804 "$node_(43) setdest 575 97 8.0" 
$ns at 616.1525584515082 "$node_(43) setdest 2858 732 12.0" 
$ns at 0.0 "$node_(44) setdest 659 620 12.0" 
$ns at 26.601807991799728 "$node_(44) setdest 2643 81 9.0" 
$ns at 85.44555160500742 "$node_(44) setdest 1117 281 16.0" 
$ns at 145.62722866652615 "$node_(44) setdest 2770 964 13.0" 
$ns at 285.91848487330867 "$node_(44) setdest 210 941 2.0" 
$ns at 542.7589757792302 "$node_(44) setdest 52 264 10.0" 
$ns at 0.0 "$node_(45) setdest 1451 746 11.0" 
$ns at 124.52838124323436 "$node_(45) setdest 1183 165 19.0" 
$ns at 297.5895048412854 "$node_(45) setdest 438 55 7.0" 
$ns at 419.83345201988976 "$node_(45) setdest 600 458 19.0" 
$ns at 572.0897527365237 "$node_(45) setdest 1346 380 12.0" 
$ns at 0.0 "$node_(46) setdest 404 18 18.0" 
$ns at 32.080663531419454 "$node_(46) setdest 311 953 7.0" 
$ns at 113.21639107403794 "$node_(46) setdest 2470 681 11.0" 
$ns at 209.01942690575356 "$node_(46) setdest 2727 784 11.0" 
$ns at 384.40181604757805 "$node_(46) setdest 2605 13 3.0" 
$ns at 641.537234213204 "$node_(46) setdest 1174 330 15.0" 
$ns at 0.0 "$node_(47) setdest 2384 712 7.0" 
$ns at 62.03167822552995 "$node_(47) setdest 499 123 17.0" 
$ns at 98.47909048471905 "$node_(47) setdest 1025 622 5.0" 
$ns at 183.54662424733127 "$node_(47) setdest 277 987 1.0" 
$ns at 305.8822044253311 "$node_(47) setdest 2440 616 15.0" 
$ns at 637.0051122267038 "$node_(47) setdest 1655 695 16.0" 
$ns at 0.0 "$node_(48) setdest 1312 806 9.0" 
$ns at 95.09859150617075 "$node_(48) setdest 1332 185 12.0" 
$ns at 197.61293789144582 "$node_(48) setdest 2842 855 6.0" 
$ns at 309.5854883972373 "$node_(48) setdest 2155 698 17.0" 
$ns at 494.74257053300624 "$node_(48) setdest 2520 348 11.0" 
$ns at 770.6063188209065 "$node_(48) setdest 1596 453 3.0" 
$ns at 0.0 "$node_(49) setdest 44 479 18.0" 
$ns at 91.75993020039482 "$node_(49) setdest 1088 711 8.0" 
$ns at 166.6551097349021 "$node_(49) setdest 2266 531 6.0" 
$ns at 258.2557244486686 "$node_(49) setdest 1981 362 5.0" 
$ns at 427.984003866211 "$node_(49) setdest 781 899 18.0" 
$ns at 724.6273072885367 "$node_(49) setdest 2607 375 3.0" 
$ns at 0.0 "$node_(50) setdest 526 634 16.0" 
$ns at 19.111927661106822 "$node_(50) setdest 2695 747 7.0" 
$ns at 91.81368482420689 "$node_(50) setdest 2518 747 19.0" 
$ns at 304.51244360763667 "$node_(50) setdest 1146 791 15.0" 
$ns at 491.19797474606696 "$node_(50) setdest 596 770 12.0" 
$ns at 791.9677171202666 "$node_(50) setdest 903 895 15.0" 
$ns at 0.0 "$node_(51) setdest 1791 307 5.0" 
$ns at 40.255043737361866 "$node_(51) setdest 2410 112 7.0" 
$ns at 137.37146814169898 "$node_(51) setdest 2696 552 6.0" 
$ns at 214.11793697195927 "$node_(51) setdest 923 180 1.0" 
$ns at 341.61406268883866 "$node_(51) setdest 1953 41 18.0" 
$ns at 735.8344348469968 "$node_(51) setdest 643 855 4.0" 
$ns at 0.0 "$node_(52) setdest 733 90 14.0" 
$ns at 71.42244967976468 "$node_(52) setdest 2445 660 10.0" 
$ns at 151.91420520443484 "$node_(52) setdest 825 689 15.0" 
$ns at 287.5787951157372 "$node_(52) setdest 676 410 17.0" 
$ns at 536.7097108632621 "$node_(52) setdest 1712 821 15.0" 
$ns at 0.0 "$node_(53) setdest 1282 136 6.0" 
$ns at 16.814310637290443 "$node_(53) setdest 1746 451 16.0" 
$ns at 59.2839846368674 "$node_(53) setdest 2252 263 2.0" 
$ns at 138.2313063083543 "$node_(53) setdest 302 675 18.0" 
$ns at 425.5936019153273 "$node_(53) setdest 1137 160 2.0" 
$ns at 679.1222557485145 "$node_(53) setdest 1526 758 7.0" 
$ns at 0.0 "$node_(54) setdest 2122 422 4.0" 
$ns at 46.94408313308436 "$node_(54) setdest 52 66 6.0" 
$ns at 95.97231490910961 "$node_(54) setdest 1914 502 15.0" 
$ns at 270.29153163756604 "$node_(54) setdest 1804 113 9.0" 
$ns at 467.89326361997905 "$node_(54) setdest 429 550 7.0" 
$ns at 748.5027986813815 "$node_(54) setdest 1761 220 5.0" 
$ns at 0.0 "$node_(55) setdest 2041 578 11.0" 
$ns at 92.0643731967786 "$node_(55) setdest 303 527 16.0" 
$ns at 244.23356919540433 "$node_(55) setdest 862 309 6.0" 
$ns at 317.6849952953756 "$node_(55) setdest 2502 334 16.0" 
$ns at 519.5541534825875 "$node_(55) setdest 1331 329 2.0" 
$ns at 777.4759456900435 "$node_(55) setdest 2494 29 13.0" 
$ns at 0.0 "$node_(56) setdest 86 403 13.0" 
$ns at 86.11423396862969 "$node_(56) setdest 791 66 6.0" 
$ns at 159.27880957375683 "$node_(56) setdest 2865 64 8.0" 
$ns at 292.06890860959516 "$node_(56) setdest 1158 759 14.0" 
$ns at 472.7020032099546 "$node_(56) setdest 956 842 8.0" 
$ns at 791.6752801982173 "$node_(56) setdest 422 856 8.0" 
$ns at 0.0 "$node_(57) setdest 403 754 2.0" 
$ns at 22.911692001368365 "$node_(57) setdest 349 147 11.0" 
$ns at 67.78095652993004 "$node_(57) setdest 5 896 8.0" 
$ns at 156.82499288530119 "$node_(57) setdest 2437 586 11.0" 
$ns at 378.4286775337812 "$node_(57) setdest 822 284 15.0" 
$ns at 664.0654872310436 "$node_(57) setdest 1265 669 9.0" 
$ns at 0.0 "$node_(58) setdest 1706 268 14.0" 
$ns at 36.04963611321654 "$node_(58) setdest 1762 59 9.0" 
$ns at 141.8792558480854 "$node_(58) setdest 2085 167 17.0" 
$ns at 347.87497491962927 "$node_(58) setdest 2516 687 6.0" 
$ns at 478.8813899220513 "$node_(58) setdest 1017 969 19.0" 
$ns at 866.8417797343099 "$node_(58) setdest 1993 826 15.0" 
$ns at 0.0 "$node_(59) setdest 233 210 12.0" 
$ns at 110.77694157573578 "$node_(59) setdest 1296 873 8.0" 
$ns at 167.9729144917887 "$node_(59) setdest 1699 404 16.0" 
$ns at 299.6802665470668 "$node_(59) setdest 1825 829 11.0" 
$ns at 452.45711844396715 "$node_(59) setdest 2907 635 6.0" 
$ns at 715.8997235095377 "$node_(59) setdest 2960 711 19.0" 
$ns at 0.0 "$node_(60) setdest 2917 161 10.0" 
$ns at 111.4770958589251 "$node_(60) setdest 2647 390 12.0" 
$ns at 224.17383834980848 "$node_(60) setdest 2892 166 9.0" 
$ns at 348.75704089086025 "$node_(60) setdest 1498 587 11.0" 
$ns at 507.44922482576885 "$node_(60) setdest 608 6 18.0" 
$ns at 764.763274616752 "$node_(60) setdest 2780 23 17.0" 
$ns at 0.0 "$node_(61) setdest 201 564 18.0" 
$ns at 145.5293944284749 "$node_(61) setdest 1416 953 12.0" 
$ns at 215.32507203512728 "$node_(61) setdest 2138 591 2.0" 
$ns at 294.2553551378723 "$node_(61) setdest 868 580 18.0" 
$ns at 455.8026040992675 "$node_(61) setdest 2169 124 7.0" 
$ns at 734.1116672259107 "$node_(61) setdest 1519 80 4.0" 
$ns at 0.0 "$node_(62) setdest 1731 365 13.0" 
$ns at 125.59264858990822 "$node_(62) setdest 929 233 15.0" 
$ns at 288.10083950188596 "$node_(62) setdest 90 624 16.0" 
$ns at 443.61062433455044 "$node_(62) setdest 2092 891 14.0" 
$ns at 692.8746763378357 "$node_(62) setdest 2172 190 2.0" 
$ns at 0.0 "$node_(63) setdest 2547 781 10.0" 
$ns at 58.02692506083283 "$node_(63) setdest 1871 242 14.0" 
$ns at 217.88833721040476 "$node_(63) setdest 989 372 1.0" 
$ns at 280.05306530529987 "$node_(63) setdest 294 170 19.0" 
$ns at 460.5385888108365 "$node_(63) setdest 1724 798 10.0" 
$ns at 738.1804017460565 "$node_(63) setdest 2218 914 17.0" 
$ns at 0.0 "$node_(64) setdest 1119 74 19.0" 
$ns at 15.812065345960232 "$node_(64) setdest 737 181 8.0" 
$ns at 48.171851702192555 "$node_(64) setdest 885 102 19.0" 
$ns at 181.55067417803093 "$node_(64) setdest 2850 664 19.0" 
$ns at 472.87473318702837 "$node_(64) setdest 842 186 7.0" 
$ns at 728.1615096007001 "$node_(64) setdest 2490 612 5.0" 
$ns at 0.0 "$node_(65) setdest 2526 67 10.0" 
$ns at 80.14836182558996 "$node_(65) setdest 236 381 2.0" 
$ns at 127.72132396897109 "$node_(65) setdest 1756 698 19.0" 
$ns at 228.0838055602067 "$node_(65) setdest 1703 811 12.0" 
$ns at 452.0130308089379 "$node_(65) setdest 31 260 2.0" 
$ns at 710.0970647879036 "$node_(65) setdest 2363 560 16.0" 
$ns at 0.0 "$node_(66) setdest 2397 145 10.0" 
$ns at 18.440556456678014 "$node_(66) setdest 282 741 16.0" 
$ns at 156.9636857319321 "$node_(66) setdest 123 912 11.0" 
$ns at 280.0518799907356 "$node_(66) setdest 1032 493 16.0" 
$ns at 497.88376254524616 "$node_(66) setdest 338 429 6.0" 
$ns at 743.494674780572 "$node_(66) setdest 760 335 16.0" 
$ns at 0.0 "$node_(67) setdest 479 721 1.0" 
$ns at 20.875273178053003 "$node_(67) setdest 177 423 12.0" 
$ns at 56.93742728562539 "$node_(67) setdest 1185 227 18.0" 
$ns at 246.8353014741836 "$node_(67) setdest 944 71 11.0" 
$ns at 402.18938401421036 "$node_(67) setdest 1995 488 10.0" 
$ns at 674.1240588728086 "$node_(67) setdest 2717 153 1.0" 
$ns at 0.0 "$node_(68) setdest 2984 479 7.0" 
$ns at 24.05470135741524 "$node_(68) setdest 1840 242 2.0" 
$ns at 69.3191503572717 "$node_(68) setdest 199 85 10.0" 
$ns at 147.11464953381358 "$node_(68) setdest 2430 610 19.0" 
$ns at 276.4556449517528 "$node_(68) setdest 2523 460 17.0" 
$ns at 560.0213201541736 "$node_(68) setdest 357 440 17.0" 
$ns at 0.0 "$node_(69) setdest 2326 251 19.0" 
$ns at 80.24544812831036 "$node_(69) setdest 358 871 7.0" 
$ns at 122.78318239301129 "$node_(69) setdest 1043 932 10.0" 
$ns at 184.40500558096613 "$node_(69) setdest 1286 742 17.0" 
$ns at 418.4227540339257 "$node_(69) setdest 2532 727 1.0" 
$ns at 659.8886209115799 "$node_(69) setdest 2238 139 10.0" 
$ns at 0.0 "$node_(70) setdest 1844 876 15.0" 
$ns at 80.50966166935333 "$node_(70) setdest 2057 111 18.0" 
$ns at 220.507693594409 "$node_(70) setdest 772 215 8.0" 
$ns at 327.9979883622443 "$node_(70) setdest 1460 182 16.0" 
$ns at 550.1321746679719 "$node_(70) setdest 1301 317 3.0" 
$ns at 795.926324901736 "$node_(70) setdest 2776 494 18.0" 
$ns at 0.0 "$node_(71) setdest 826 680 1.0" 
$ns at 20.346728182287816 "$node_(71) setdest 54 728 2.0" 
$ns at 50.69179124657074 "$node_(71) setdest 1774 711 19.0" 
$ns at 117.75830195310115 "$node_(71) setdest 1032 135 17.0" 
$ns at 359.93807245171706 "$node_(71) setdest 975 469 14.0" 
$ns at 736.7599065797505 "$node_(71) setdest 202 315 2.0" 
$ns at 0.0 "$node_(72) setdest 2930 436 20.0" 
$ns at 139.04327400196695 "$node_(72) setdest 2991 590 3.0" 
$ns at 190.612734480941 "$node_(72) setdest 2831 777 6.0" 
$ns at 253.27868984012883 "$node_(72) setdest 778 96 4.0" 
$ns at 379.21043818097377 "$node_(72) setdest 2958 851 2.0" 
$ns at 623.4262054400446 "$node_(72) setdest 1262 952 15.0" 
$ns at 0.0 "$node_(73) setdest 823 936 7.0" 
$ns at 20.375560801690085 "$node_(73) setdest 418 111 7.0" 
$ns at 55.70296884135682 "$node_(73) setdest 2192 439 6.0" 
$ns at 164.12009625751335 "$node_(73) setdest 2038 782 6.0" 
$ns at 337.552235807019 "$node_(73) setdest 1832 38 12.0" 
$ns at 623.1371492170654 "$node_(73) setdest 2612 502 8.0" 
$ns at 0.0 "$node_(74) setdest 1636 537 8.0" 
$ns at 26.437023823894037 "$node_(74) setdest 1022 248 4.0" 
$ns at 68.53092198636726 "$node_(74) setdest 1473 390 13.0" 
$ns at 143.53926973388533 "$node_(74) setdest 330 195 7.0" 
$ns at 328.4841902366039 "$node_(74) setdest 890 146 13.0" 
$ns at 580.2572694453752 "$node_(74) setdest 2621 969 20.0" 
$ns at 0.0 "$node_(75) setdest 2543 304 19.0" 
$ns at 174.14696772788002 "$node_(75) setdest 1670 538 7.0" 
$ns at 263.98763695690405 "$node_(75) setdest 2975 315 19.0" 
$ns at 505.39689360491917 "$node_(75) setdest 2924 67 1.0" 
$ns at 633.1157461211753 "$node_(75) setdest 2108 714 12.0" 
$ns at 893.9200468873269 "$node_(75) setdest 2035 390 3.0" 
$ns at 0.0 "$node_(76) setdest 571 625 13.0" 
$ns at 36.35901913945538 "$node_(76) setdest 957 926 2.0" 
$ns at 67.98747252727519 "$node_(76) setdest 2747 129 9.0" 
$ns at 141.2808324614133 "$node_(76) setdest 338 177 17.0" 
$ns at 367.85372299130825 "$node_(76) setdest 2142 233 2.0" 
$ns at 624.9792044565988 "$node_(76) setdest 713 160 1.0" 
$ns at 0.0 "$node_(77) setdest 1454 417 6.0" 
$ns at 54.19497842079218 "$node_(77) setdest 735 392 14.0" 
$ns at 92.42128720841409 "$node_(77) setdest 477 17 6.0" 
$ns at 203.76792450381873 "$node_(77) setdest 2456 284 4.0" 
$ns at 359.2713797391161 "$node_(77) setdest 2683 918 1.0" 
$ns at 604.9157486750976 "$node_(77) setdest 1381 65 5.0" 
$ns at 0.0 "$node_(78) setdest 2129 293 5.0" 
$ns at 42.48566689400039 "$node_(78) setdest 2813 596 5.0" 
$ns at 112.7760748457406 "$node_(78) setdest 49 394 8.0" 
$ns at 252.4717009191637 "$node_(78) setdest 1721 683 17.0" 
$ns at 526.7012138709135 "$node_(78) setdest 2250 612 4.0" 
$ns at 772.9125140691954 "$node_(78) setdest 2133 763 9.0" 
$ns at 0.0 "$node_(79) setdest 186 308 19.0" 
$ns at 54.36459362588861 "$node_(79) setdest 2800 65 2.0" 
$ns at 90.47061345111257 "$node_(79) setdest 2337 150 17.0" 
$ns at 300.5765762869522 "$node_(79) setdest 2626 616 9.0" 
$ns at 440.2344809161855 "$node_(79) setdest 251 938 3.0" 
$ns at 699.6607354434509 "$node_(79) setdest 2107 703 15.0" 
$ns at 0.0 "$node_(80) setdest 379 170 7.0" 
$ns at 49.58719665499916 "$node_(80) setdest 1784 653 13.0" 
$ns at 81.84760647854279 "$node_(80) setdest 1580 816 18.0" 
$ns at 259.0632484406829 "$node_(80) setdest 2443 50 17.0" 
$ns at 487.9210967694722 "$node_(80) setdest 2899 66 18.0" 
$ns at 863.4330205918459 "$node_(80) setdest 573 743 15.0" 
$ns at 0.0 "$node_(81) setdest 1005 8 7.0" 
$ns at 34.087283515808224 "$node_(81) setdest 314 270 1.0" 
$ns at 72.2758043552785 "$node_(81) setdest 408 500 18.0" 
$ns at 181.38764792769436 "$node_(81) setdest 905 547 8.0" 
$ns at 377.88503330308674 "$node_(81) setdest 313 718 1.0" 
$ns at 625.5695743733975 "$node_(81) setdest 361 948 2.0" 
$ns at 0.0 "$node_(82) setdest 755 106 4.0" 
$ns at 25.33305307402822 "$node_(82) setdest 2892 135 10.0" 
$ns at 110.48493409147932 "$node_(82) setdest 2361 733 14.0" 
$ns at 201.68447375279794 "$node_(82) setdest 302 247 16.0" 
$ns at 336.8010621538631 "$node_(82) setdest 1883 286 10.0" 
$ns at 640.7759537617253 "$node_(82) setdest 365 319 17.0" 
$ns at 0.0 "$node_(83) setdest 1349 190 14.0" 
$ns at 129.58314736867982 "$node_(83) setdest 1919 36 19.0" 
$ns at 276.13810778434987 "$node_(83) setdest 1484 588 2.0" 
$ns at 338.217742172511 "$node_(83) setdest 186 191 11.0" 
$ns at 567.9125614982988 "$node_(83) setdest 1735 183 7.0" 
$ns at 825.4843736698406 "$node_(83) setdest 1554 461 11.0" 
$ns at 0.0 "$node_(84) setdest 58 159 9.0" 
$ns at 61.71197505484933 "$node_(84) setdest 823 361 9.0" 
$ns at 116.59728874789745 "$node_(84) setdest 1309 696 19.0" 
$ns at 326.5151118011635 "$node_(84) setdest 651 485 12.0" 
$ns at 519.6696066801396 "$node_(84) setdest 1877 788 15.0" 
$ns at 797.6553046853685 "$node_(84) setdest 715 412 13.0" 
$ns at 0.0 "$node_(85) setdest 2922 376 16.0" 
$ns at 91.42436851912214 "$node_(85) setdest 1810 873 8.0" 
$ns at 174.53691383261827 "$node_(85) setdest 346 25 10.0" 
$ns at 323.4514239974862 "$node_(85) setdest 1903 56 17.0" 
$ns at 557.9938699003394 "$node_(85) setdest 2358 627 10.0" 
$ns at 896.7187321805767 "$node_(85) setdest 874 150 3.0" 
$ns at 0.0 "$node_(86) setdest 269 885 6.0" 
$ns at 64.90273810513786 "$node_(86) setdest 1446 501 1.0" 
$ns at 100.61615436545227 "$node_(86) setdest 1867 546 19.0" 
$ns at 275.8560618482496 "$node_(86) setdest 549 996 11.0" 
$ns at 424.53931942877864 "$node_(86) setdest 519 636 13.0" 
$ns at 704.9953798308729 "$node_(86) setdest 2112 519 8.0" 
$ns at 0.0 "$node_(87) setdest 2846 185 19.0" 
$ns at 182.2170668037483 "$node_(87) setdest 2039 618 17.0" 
$ns at 308.3063508036329 "$node_(87) setdest 1610 164 6.0" 
$ns at 385.13825294638605 "$node_(87) setdest 1845 727 9.0" 
$ns at 525.319219471362 "$node_(87) setdest 174 648 9.0" 
$ns at 800.4724679143117 "$node_(87) setdest 223 564 2.0" 
$ns at 0.0 "$node_(88) setdest 664 422 10.0" 
$ns at 85.71900548379509 "$node_(88) setdest 2513 572 13.0" 
$ns at 121.14840599378029 "$node_(88) setdest 697 522 9.0" 
$ns at 197.83384266103758 "$node_(88) setdest 1845 502 8.0" 
$ns at 318.59185315310253 "$node_(88) setdest 2296 464 10.0" 
$ns at 634.5571837804753 "$node_(88) setdest 427 524 8.0" 
$ns at 0.0 "$node_(89) setdest 1372 130 6.0" 
$ns at 35.86605276642754 "$node_(89) setdest 2242 453 19.0" 
$ns at 100.11810247252939 "$node_(89) setdest 1882 559 8.0" 
$ns at 191.18659737003617 "$node_(89) setdest 2144 976 1.0" 
$ns at 316.1984603135595 "$node_(89) setdest 550 131 20.0" 
$ns at 598.7228911369047 "$node_(89) setdest 95 981 10.0" 
$ns at 0.0 "$node_(90) setdest 2747 883 1.0" 
$ns at 23.01184678811675 "$node_(90) setdest 1046 352 7.0" 
$ns at 121.2303847888578 "$node_(90) setdest 1930 938 12.0" 
$ns at 268.44210924123 "$node_(90) setdest 706 845 1.0" 
$ns at 396.8803451801157 "$node_(90) setdest 2742 300 2.0" 
$ns at 643.5503795062214 "$node_(90) setdest 191 917 19.0" 
$ns at 0.0 "$node_(91) setdest 647 479 17.0" 
$ns at 92.127300305058 "$node_(91) setdest 305 599 16.0" 
$ns at 246.23917342939865 "$node_(91) setdest 2731 720 10.0" 
$ns at 327.50958047739925 "$node_(91) setdest 1947 802 13.0" 
$ns at 501.84756832752123 "$node_(91) setdest 1024 783 14.0" 
$ns at 843.0544457340081 "$node_(91) setdest 886 654 1.0" 
$ns at 0.0 "$node_(92) setdest 2480 545 20.0" 
$ns at 158.462086901943 "$node_(92) setdest 1905 731 8.0" 
$ns at 190.87173915163828 "$node_(92) setdest 1474 899 4.0" 
$ns at 267.8231666073367 "$node_(92) setdest 63 303 18.0" 
$ns at 460.98481221121006 "$node_(92) setdest 443 685 11.0" 
$ns at 726.3487026247733 "$node_(92) setdest 560 954 4.0" 
$ns at 0.0 "$node_(93) setdest 2048 651 10.0" 
$ns at 109.3950976367087 "$node_(93) setdest 2463 189 14.0" 
$ns at 159.8655460423564 "$node_(93) setdest 1957 672 15.0" 
$ns at 323.16563957824553 "$node_(93) setdest 1280 890 18.0" 
$ns at 557.1962629653246 "$node_(93) setdest 148 722 8.0" 
$ns at 857.3715745799701 "$node_(93) setdest 137 743 19.0" 
$ns at 0.0 "$node_(94) setdest 1333 341 14.0" 
$ns at 144.26138941999733 "$node_(94) setdest 2044 980 18.0" 
$ns at 295.47645424786714 "$node_(94) setdest 2880 569 1.0" 
$ns at 356.7355563784408 "$node_(94) setdest 1506 74 5.0" 
$ns at 507.2877676679037 "$node_(94) setdest 2356 606 2.0" 
$ns at 755.2673428448029 "$node_(94) setdest 466 234 19.0" 
$ns at 0.0 "$node_(95) setdest 562 671 15.0" 
$ns at 93.46551781175317 "$node_(95) setdest 2331 813 19.0" 
$ns at 166.6153953017456 "$node_(95) setdest 680 808 4.0" 
$ns at 260.40582948876977 "$node_(95) setdest 1585 3 18.0" 
$ns at 555.9444369333213 "$node_(95) setdest 1895 614 10.0" 
$ns at 805.8314301201066 "$node_(95) setdest 2209 420 8.0" 
$ns at 0.0 "$node_(96) setdest 1635 150 7.0" 
$ns at 34.63452166149295 "$node_(96) setdest 2944 446 11.0" 
$ns at 157.37129287242945 "$node_(96) setdest 270 496 6.0" 
$ns at 269.3584434377482 "$node_(96) setdest 2099 444 18.0" 
$ns at 523.8199257836233 "$node_(96) setdest 2923 713 12.0" 
$ns at 876.3368222154992 "$node_(96) setdest 439 205 6.0" 
$ns at 0.0 "$node_(97) setdest 1736 179 18.0" 
$ns at 15.505909797917734 "$node_(97) setdest 2373 242 17.0" 
$ns at 163.6560906948382 "$node_(97) setdest 731 555 5.0" 
$ns at 252.38713868259384 "$node_(97) setdest 1447 793 18.0" 
$ns at 390.4827165179606 "$node_(97) setdest 2125 859 7.0" 
$ns at 686.3933942096244 "$node_(97) setdest 2896 651 15.0" 
$ns at 0.0 "$node_(98) setdest 2735 390 1.0" 
$ns at 21.866721646141187 "$node_(98) setdest 1733 180 3.0" 
$ns at 62.63060415148956 "$node_(98) setdest 1820 482 17.0" 
$ns at 250.7133077264933 "$node_(98) setdest 637 126 1.0" 
$ns at 376.4380984295698 "$node_(98) setdest 1512 350 4.0" 
$ns at 620.8482993148276 "$node_(98) setdest 2631 98 13.0" 
$ns at 0.0 "$node_(99) setdest 2677 478 11.0" 
$ns at 49.51561360638677 "$node_(99) setdest 1295 824 15.0" 
$ns at 88.0645448736027 "$node_(99) setdest 2852 329 17.0" 
$ns at 236.8018448787638 "$node_(99) setdest 1006 542 11.0" 
$ns at 455.40980213163937 "$node_(99) setdest 608 335 15.0" 
$ns at 809.1025506095918 "$node_(99) setdest 1467 152 7.0" 


#Set a TCP connection between node_(82) and node_(41)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(0)
$ns attach-agent $node_(41) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(53) and node_(33)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(1)
$ns attach-agent $node_(33) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(49) and node_(97)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(2)
$ns attach-agent $node_(97) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(97) and node_(56)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(3)
$ns attach-agent $node_(56) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(76) and node_(50)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(4)
$ns attach-agent $node_(50) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(96) and node_(72)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(5)
$ns attach-agent $node_(72) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(94) and node_(27)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(6)
$ns attach-agent $node_(27) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(22) and node_(89)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(7)
$ns attach-agent $node_(89) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(87) and node_(11)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(8)
$ns attach-agent $node_(11) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(47) and node_(50)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(9)
$ns attach-agent $node_(50) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(77) and node_(6)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(10)
$ns attach-agent $node_(6) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(45) and node_(53)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(11)
$ns attach-agent $node_(53) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(15) and node_(7)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(12)
$ns attach-agent $node_(7) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(87) and node_(95)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(13)
$ns attach-agent $node_(95) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(6) and node_(95)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(14)
$ns attach-agent $node_(95) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(72) and node_(40)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(15)
$ns attach-agent $node_(40) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(29) and node_(34)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(16)
$ns attach-agent $node_(34) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(57) and node_(51)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(17)
$ns attach-agent $node_(51) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(33) and node_(36)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(18)
$ns attach-agent $node_(36) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(12) and node_(36)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(19)
$ns attach-agent $node_(36) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(18) and node_(72)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(20)
$ns attach-agent $node_(72) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(25) and node_(87)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(21)
$ns attach-agent $node_(87) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(2) and node_(21)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(22)
$ns attach-agent $node_(21) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(42) and node_(82)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(23)
$ns attach-agent $node_(82) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(19) and node_(41)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(24)
$ns attach-agent $node_(41) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(7) and node_(8)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(25)
$ns attach-agent $node_(8) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(36) and node_(53)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(26)
$ns attach-agent $node_(53) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(72) and node_(19)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(27)
$ns attach-agent $node_(19) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(94) and node_(65)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(28)
$ns attach-agent $node_(65) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(97) and node_(66)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(29)
$ns attach-agent $node_(66) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(56) and node_(14)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(30)
$ns attach-agent $node_(14) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(19) and node_(80)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(31)
$ns attach-agent $node_(80) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(21) and node_(61)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(32)
$ns attach-agent $node_(61) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(90) and node_(4)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(33)
$ns attach-agent $node_(4) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(8) and node_(19)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(34)
$ns attach-agent $node_(19) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(51) and node_(69)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(35)
$ns attach-agent $node_(69) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(53) and node_(85)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(36)
$ns attach-agent $node_(85) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(92) and node_(84)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(37)
$ns attach-agent $node_(84) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(77) and node_(59)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(38)
$ns attach-agent $node_(59) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(89) and node_(44)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(39)
$ns attach-agent $node_(44) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(61) and node_(49)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(40)
$ns attach-agent $node_(49) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(58) and node_(12)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(41)
$ns attach-agent $node_(12) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(82) and node_(75)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(42)
$ns attach-agent $node_(75) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(33) and node_(14)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(43)
$ns attach-agent $node_(14) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(88) and node_(76)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(44)
$ns attach-agent $node_(76) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(33) and node_(54)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(45)
$ns attach-agent $node_(54) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(14) and node_(35)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(46)
$ns attach-agent $node_(35) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(23) and node_(83)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(47)
$ns attach-agent $node_(83) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(44) and node_(39)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(48)
$ns attach-agent $node_(39) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(70) and node_(98)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(49)
$ns attach-agent $node_(98) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(69) and node_(62)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(50)
$ns attach-agent $node_(62) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(93) and node_(35)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(51)
$ns attach-agent $node_(35) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(73) and node_(37)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(52)
$ns attach-agent $node_(37) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(11) and node_(59)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(53)
$ns attach-agent $node_(59) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(26) and node_(42)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(54)
$ns attach-agent $node_(42) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(20) and node_(23)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(55)
$ns attach-agent $node_(23) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(55) and node_(0)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(56)
$ns attach-agent $node_(0) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(90) and node_(78)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(57)
$ns attach-agent $node_(78) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(14) and node_(8)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(58)
$ns attach-agent $node_(8) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(11) and node_(76)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(59)
$ns attach-agent $node_(76) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(16) and node_(74)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(60)
$ns attach-agent $node_(74) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(87) and node_(92)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(61)
$ns attach-agent $node_(92) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(83) and node_(57)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(62)
$ns attach-agent $node_(57) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(20) and node_(40)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(63)
$ns attach-agent $node_(40) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(44) and node_(11)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(64)
$ns attach-agent $node_(11) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(42) and node_(28)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(65)
$ns attach-agent $node_(28) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(87) and node_(68)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(66)
$ns attach-agent $node_(68) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(67) and node_(95)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(67)
$ns attach-agent $node_(95) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(50) and node_(77)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(68)
$ns attach-agent $node_(77) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(12) and node_(68)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(69)
$ns attach-agent $node_(68) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(94) and node_(97)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(70)
$ns attach-agent $node_(97) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(95) and node_(35)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(71)
$ns attach-agent $node_(35) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(9) and node_(54)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(72)
$ns attach-agent $node_(54) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(40) and node_(94)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(73)
$ns attach-agent $node_(94) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(35) and node_(94)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(74)
$ns attach-agent $node_(94) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(2) and node_(4)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(75)
$ns attach-agent $node_(4) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(69) and node_(93)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(76)
$ns attach-agent $node_(93) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(48) and node_(88)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(77)
$ns attach-agent $node_(88) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(27) and node_(55)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(78)
$ns attach-agent $node_(55) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(25) and node_(3)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(79)
$ns attach-agent $node_(3) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(33) and node_(47)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(80)
$ns attach-agent $node_(47) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(81) and node_(72)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(81)
$ns attach-agent $node_(72) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(41) and node_(3)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(82)
$ns attach-agent $node_(3) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(69) and node_(41)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(83)
$ns attach-agent $node_(41) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(31) and node_(83)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(84)
$ns attach-agent $node_(83) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(77) and node_(94)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(85)
$ns attach-agent $node_(94) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(89) and node_(65)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(86)
$ns attach-agent $node_(65) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(99) and node_(69)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(87)
$ns attach-agent $node_(69) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(37) and node_(68)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(88)
$ns attach-agent $node_(68) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(21) and node_(5)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(89)
$ns attach-agent $node_(5) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(73) and node_(95)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(90)
$ns attach-agent $node_(95) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(50) and node_(30)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(91)
$ns attach-agent $node_(30) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(16) and node_(73)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(92)
$ns attach-agent $node_(73) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(15) and node_(74)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(93)
$ns attach-agent $node_(74) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(99) and node_(45)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(94)
$ns attach-agent $node_(45) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(6) and node_(28)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(95)
$ns attach-agent $node_(28) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(89) and node_(20)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(96)
$ns attach-agent $node_(20) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(86) and node_(52)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(97)
$ns attach-agent $node_(52) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(53) and node_(87)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(98)
$ns attach-agent $node_(87) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(74) and node_(66)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(99)
$ns attach-agent $node_(66) $sink_(99)
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
