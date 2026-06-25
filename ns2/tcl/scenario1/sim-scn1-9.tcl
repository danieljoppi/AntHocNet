#sim-scn1-9.tcl 
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
set tracefd       [open sim-scn1-9-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-9-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-9-$val(rp).nam w]

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
$node_(0) set X_ 82 
$node_(0) set Y_ 268 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 1127 
$node_(1) set Y_ 322 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1050 
$node_(2) set Y_ 518 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 869 
$node_(3) set Y_ 169 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1114 
$node_(4) set Y_ 753 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1830 
$node_(5) set Y_ 302 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 79 
$node_(6) set Y_ 465 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2275 
$node_(7) set Y_ 308 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2253 
$node_(8) set Y_ 821 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1613 
$node_(9) set Y_ 16 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 2384 
$node_(10) set Y_ 404 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 523 
$node_(11) set Y_ 665 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 127 
$node_(12) set Y_ 907 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1355 
$node_(13) set Y_ 481 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 146 
$node_(14) set Y_ 935 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2321 
$node_(15) set Y_ 888 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2134 
$node_(16) set Y_ 201 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 873 
$node_(17) set Y_ 369 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 497 
$node_(18) set Y_ 179 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1395 
$node_(19) set Y_ 984 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 88 
$node_(20) set Y_ 700 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1673 
$node_(21) set Y_ 709 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 264 
$node_(22) set Y_ 93 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1761 
$node_(23) set Y_ 10 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2623 
$node_(24) set Y_ 197 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 659 
$node_(25) set Y_ 571 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1089 
$node_(26) set Y_ 982 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2773 
$node_(27) set Y_ 657 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 544 
$node_(28) set Y_ 570 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1397 
$node_(29) set Y_ 374 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 968 
$node_(30) set Y_ 190 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1434 
$node_(31) set Y_ 9 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 992 
$node_(32) set Y_ 921 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1274 
$node_(33) set Y_ 709 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 974 
$node_(34) set Y_ 164 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2176 
$node_(35) set Y_ 972 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 107 
$node_(36) set Y_ 424 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 634 
$node_(37) set Y_ 835 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 695 
$node_(38) set Y_ 348 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1067 
$node_(39) set Y_ 174 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1567 
$node_(40) set Y_ 951 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2743 
$node_(41) set Y_ 228 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1670 
$node_(42) set Y_ 621 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2171 
$node_(43) set Y_ 331 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 167 
$node_(44) set Y_ 805 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1158 
$node_(45) set Y_ 830 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2839 
$node_(46) set Y_ 230 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1523 
$node_(47) set Y_ 354 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 344 
$node_(48) set Y_ 157 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2855 
$node_(49) set Y_ 901 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2795 
$node_(50) set Y_ 426 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 925 
$node_(51) set Y_ 727 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2286 
$node_(52) set Y_ 996 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1196 
$node_(53) set Y_ 611 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 362 
$node_(54) set Y_ 262 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 543 
$node_(55) set Y_ 915 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 41 
$node_(56) set Y_ 700 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2574 
$node_(57) set Y_ 767 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 771 
$node_(58) set Y_ 262 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 1007 
$node_(59) set Y_ 822 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 776 
$node_(60) set Y_ 540 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1338 
$node_(61) set Y_ 324 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2469 
$node_(62) set Y_ 906 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 1484 
$node_(63) set Y_ 577 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 78 
$node_(64) set Y_ 707 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2321 
$node_(65) set Y_ 569 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 336 
$node_(66) set Y_ 158 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1939 
$node_(67) set Y_ 151 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1965 
$node_(68) set Y_ 696 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 2073 
$node_(69) set Y_ 127 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2835 
$node_(70) set Y_ 477 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 550 
$node_(71) set Y_ 601 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1996 
$node_(72) set Y_ 122 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 2634 
$node_(73) set Y_ 179 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1371 
$node_(74) set Y_ 23 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1986 
$node_(75) set Y_ 928 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 2640 
$node_(76) set Y_ 309 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 437 
$node_(77) set Y_ 545 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 1895 
$node_(78) set Y_ 23 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2022 
$node_(79) set Y_ 847 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 1805 
$node_(80) set Y_ 228 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 1685 
$node_(81) set Y_ 510 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1523 
$node_(82) set Y_ 485 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1699 
$node_(83) set Y_ 972 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1177 
$node_(84) set Y_ 616 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2286 
$node_(85) set Y_ 562 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 693 
$node_(86) set Y_ 745 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2989 
$node_(87) set Y_ 191 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 771 
$node_(88) set Y_ 358 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 186 
$node_(89) set Y_ 412 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 1152 
$node_(90) set Y_ 523 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1700 
$node_(91) set Y_ 248 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 854 
$node_(92) set Y_ 473 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 697 
$node_(93) set Y_ 955 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 785 
$node_(94) set Y_ 473 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 61 
$node_(95) set Y_ 808 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 130 
$node_(96) set Y_ 266 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 150 
$node_(97) set Y_ 65 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 74 
$node_(98) set Y_ 409 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2217 
$node_(99) set Y_ 513 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 850 506 20.0" 
$ns at 87.30708177595153 "$node_(0) setdest 2706 690 11.0" 
$ns at 206.98230802662692 "$node_(0) setdest 2242 683 14.0" 
$ns at 316.3675242842057 "$node_(0) setdest 2617 444 19.0" 
$ns at 547.4588977163025 "$node_(0) setdest 421 695 19.0" 
$ns at 899.3679875776252 "$node_(0) setdest 1491 611 13.0" 
$ns at 0.0 "$node_(1) setdest 1674 547 12.0" 
$ns at 102.51829228187268 "$node_(1) setdest 2490 997 8.0" 
$ns at 189.7487649885653 "$node_(1) setdest 2771 875 6.0" 
$ns at 289.43631235045854 "$node_(1) setdest 1758 807 20.0" 
$ns at 531.2968127556703 "$node_(1) setdest 719 407 7.0" 
$ns at 776.2673207948667 "$node_(1) setdest 2953 349 2.0" 
$ns at 0.0 "$node_(2) setdest 2092 666 9.0" 
$ns at 24.373610854855603 "$node_(2) setdest 2851 887 8.0" 
$ns at 73.82746146041609 "$node_(2) setdest 2849 508 18.0" 
$ns at 137.15971050090735 "$node_(2) setdest 1799 828 4.0" 
$ns at 273.43240426440514 "$node_(2) setdest 298 335 8.0" 
$ns at 590.7614839022156 "$node_(2) setdest 533 721 3.0" 
$ns at 0.0 "$node_(3) setdest 596 44 9.0" 
$ns at 42.585506255370724 "$node_(3) setdest 2648 754 3.0" 
$ns at 91.77328508741647 "$node_(3) setdest 944 72 12.0" 
$ns at 161.86396785928378 "$node_(3) setdest 748 724 16.0" 
$ns at 361.52819554627706 "$node_(3) setdest 1378 92 4.0" 
$ns at 624.794416977275 "$node_(3) setdest 43 680 12.0" 
$ns at 0.0 "$node_(4) setdest 2816 205 16.0" 
$ns at 27.349788040202476 "$node_(4) setdest 1936 687 15.0" 
$ns at 60.43317680036667 "$node_(4) setdest 2745 719 15.0" 
$ns at 151.7732817282701 "$node_(4) setdest 2860 438 4.0" 
$ns at 272.6895126488214 "$node_(4) setdest 721 826 1.0" 
$ns at 518.5877553716296 "$node_(4) setdest 1408 653 3.0" 
$ns at 0.0 "$node_(5) setdest 2570 772 8.0" 
$ns at 60.29616821943815 "$node_(5) setdest 1523 479 3.0" 
$ns at 101.73022012825334 "$node_(5) setdest 948 357 17.0" 
$ns at 206.85847217430444 "$node_(5) setdest 278 352 11.0" 
$ns at 429.17098876140085 "$node_(5) setdest 665 831 11.0" 
$ns at 705.1494885098637 "$node_(5) setdest 529 19 18.0" 
$ns at 0.0 "$node_(6) setdest 1918 533 3.0" 
$ns at 43.84791152905101 "$node_(6) setdest 2457 684 20.0" 
$ns at 251.87345820677263 "$node_(6) setdest 2339 849 14.0" 
$ns at 344.3649927715999 "$node_(6) setdest 785 485 5.0" 
$ns at 498.9956620529298 "$node_(6) setdest 1517 315 5.0" 
$ns at 774.1242798537825 "$node_(6) setdest 201 753 19.0" 
$ns at 0.0 "$node_(7) setdest 1380 962 8.0" 
$ns at 82.84603408726069 "$node_(7) setdest 2246 763 7.0" 
$ns at 178.6330914290531 "$node_(7) setdest 2612 222 16.0" 
$ns at 377.93383680957606 "$node_(7) setdest 1722 946 12.0" 
$ns at 590.1704590641925 "$node_(7) setdest 980 979 8.0" 
$ns at 895.4473211250656 "$node_(7) setdest 1369 740 1.0" 
$ns at 0.0 "$node_(8) setdest 252 602 9.0" 
$ns at 27.174288594174076 "$node_(8) setdest 357 574 12.0" 
$ns at 137.06447717319116 "$node_(8) setdest 2086 42 1.0" 
$ns at 197.9312932484498 "$node_(8) setdest 2869 658 4.0" 
$ns at 328.74023493189054 "$node_(8) setdest 51 314 20.0" 
$ns at 692.91711117643 "$node_(8) setdest 790 557 19.0" 
$ns at 0.0 "$node_(9) setdest 2689 965 19.0" 
$ns at 137.64378524546316 "$node_(9) setdest 2292 756 15.0" 
$ns at 302.85826407796867 "$node_(9) setdest 253 343 15.0" 
$ns at 484.75866908653893 "$node_(9) setdest 1840 655 14.0" 
$ns at 682.4606920588969 "$node_(9) setdest 546 754 15.0" 
$ns at 0.0 "$node_(10) setdest 888 726 15.0" 
$ns at 99.68153949072212 "$node_(10) setdest 1988 846 14.0" 
$ns at 227.79653169315418 "$node_(10) setdest 305 763 18.0" 
$ns at 428.6763424719518 "$node_(10) setdest 836 791 2.0" 
$ns at 558.7480823790344 "$node_(10) setdest 296 458 1.0" 
$ns at 805.8088879418171 "$node_(10) setdest 1198 110 19.0" 
$ns at 0.0 "$node_(11) setdest 2360 741 16.0" 
$ns at 42.52031119590937 "$node_(11) setdest 244 204 4.0" 
$ns at 84.49402337356256 "$node_(11) setdest 2542 595 19.0" 
$ns at 233.13750641301803 "$node_(11) setdest 2764 948 8.0" 
$ns at 399.95002017690024 "$node_(11) setdest 2025 311 12.0" 
$ns at 653.6984605110099 "$node_(11) setdest 2988 907 14.0" 
$ns at 0.0 "$node_(12) setdest 1835 380 12.0" 
$ns at 119.46261782689533 "$node_(12) setdest 1301 19 8.0" 
$ns at 207.0971617071205 "$node_(12) setdest 176 489 18.0" 
$ns at 389.4570558200643 "$node_(12) setdest 1274 822 19.0" 
$ns at 593.8721069137699 "$node_(12) setdest 2685 314 11.0" 
$ns at 0.0 "$node_(13) setdest 2147 565 6.0" 
$ns at 62.19712507562114 "$node_(13) setdest 2628 83 18.0" 
$ns at 121.42989084341684 "$node_(13) setdest 2683 768 6.0" 
$ns at 220.36244006337546 "$node_(13) setdest 2817 104 8.0" 
$ns at 345.2666339449003 "$node_(13) setdest 28 84 17.0" 
$ns at 721.5543865730831 "$node_(13) setdest 1771 725 13.0" 
$ns at 0.0 "$node_(14) setdest 995 531 11.0" 
$ns at 56.4858552100547 "$node_(14) setdest 2403 421 3.0" 
$ns at 104.9200049698247 "$node_(14) setdest 912 427 1.0" 
$ns at 166.4970937709769 "$node_(14) setdest 262 973 11.0" 
$ns at 343.03571861570947 "$node_(14) setdest 2947 615 3.0" 
$ns at 599.7293013234234 "$node_(14) setdest 2096 952 11.0" 
$ns at 0.0 "$node_(15) setdest 1549 812 1.0" 
$ns at 19.329669907931105 "$node_(15) setdest 282 945 17.0" 
$ns at 68.53366707464968 "$node_(15) setdest 1423 155 9.0" 
$ns at 141.09691736255192 "$node_(15) setdest 379 258 8.0" 
$ns at 263.51806263015817 "$node_(15) setdest 181 279 1.0" 
$ns at 507.9426266568091 "$node_(15) setdest 1848 20 2.0" 
$ns at 0.0 "$node_(16) setdest 1574 519 14.0" 
$ns at 44.66164733041692 "$node_(16) setdest 714 930 1.0" 
$ns at 82.85104821523919 "$node_(16) setdest 955 53 3.0" 
$ns at 143.64854152166117 "$node_(16) setdest 2682 74 4.0" 
$ns at 291.9104630401756 "$node_(16) setdest 2382 78 15.0" 
$ns at 544.8821545471575 "$node_(16) setdest 9 543 12.0" 
$ns at 0.0 "$node_(17) setdest 1503 350 5.0" 
$ns at 18.908890659728886 "$node_(17) setdest 1140 785 10.0" 
$ns at 52.81013635725637 "$node_(17) setdest 1143 659 2.0" 
$ns at 130.5730661117879 "$node_(17) setdest 1889 920 4.0" 
$ns at 287.0243222317921 "$node_(17) setdest 1216 95 14.0" 
$ns at 570.1142444171658 "$node_(17) setdest 703 468 8.0" 
$ns at 0.0 "$node_(18) setdest 1399 161 7.0" 
$ns at 23.754640905712627 "$node_(18) setdest 2271 185 14.0" 
$ns at 120.43439485019553 "$node_(18) setdest 1694 78 19.0" 
$ns at 227.40891580807363 "$node_(18) setdest 2520 982 10.0" 
$ns at 429.55369820720983 "$node_(18) setdest 1791 864 14.0" 
$ns at 774.4283219182116 "$node_(18) setdest 2760 125 15.0" 
$ns at 0.0 "$node_(19) setdest 887 20 11.0" 
$ns at 124.06399413839704 "$node_(19) setdest 2518 169 6.0" 
$ns at 188.64236063496986 "$node_(19) setdest 353 898 12.0" 
$ns at 273.1578421044803 "$node_(19) setdest 2338 349 1.0" 
$ns at 401.08182094068445 "$node_(19) setdest 415 85 8.0" 
$ns at 655.384993178945 "$node_(19) setdest 560 359 13.0" 
$ns at 0.0 "$node_(20) setdest 738 397 12.0" 
$ns at 130.63393763658684 "$node_(20) setdest 1876 754 2.0" 
$ns at 179.29227020751225 "$node_(20) setdest 573 296 12.0" 
$ns at 324.37819281262625 "$node_(20) setdest 2171 412 10.0" 
$ns at 471.9614170721172 "$node_(20) setdest 873 827 14.0" 
$ns at 719.5267846927325 "$node_(20) setdest 1944 778 3.0" 
$ns at 0.0 "$node_(21) setdest 2517 397 16.0" 
$ns at 127.09085561211677 "$node_(21) setdest 2319 826 11.0" 
$ns at 263.65840635867244 "$node_(21) setdest 1557 989 9.0" 
$ns at 329.9464602178435 "$node_(21) setdest 1437 972 14.0" 
$ns at 485.05640574209497 "$node_(21) setdest 1138 627 19.0" 
$ns at 760.2062281856836 "$node_(21) setdest 752 378 2.0" 
$ns at 0.0 "$node_(22) setdest 484 196 14.0" 
$ns at 39.41009445315787 "$node_(22) setdest 1504 357 16.0" 
$ns at 126.30388111456689 "$node_(22) setdest 116 923 10.0" 
$ns at 190.36499049303802 "$node_(22) setdest 2400 835 1.0" 
$ns at 314.18952021131474 "$node_(22) setdest 200 129 6.0" 
$ns at 589.5663339676785 "$node_(22) setdest 1287 90 12.0" 
$ns at 0.0 "$node_(23) setdest 2662 55 1.0" 
$ns at 21.638254507982932 "$node_(23) setdest 1329 199 14.0" 
$ns at 176.01671054379233 "$node_(23) setdest 1502 869 18.0" 
$ns at 249.47469809352162 "$node_(23) setdest 1975 930 5.0" 
$ns at 388.1601121401965 "$node_(23) setdest 435 174 10.0" 
$ns at 716.063869780304 "$node_(23) setdest 755 13 19.0" 
$ns at 0.0 "$node_(24) setdest 1763 599 6.0" 
$ns at 68.54632449349583 "$node_(24) setdest 2655 5 15.0" 
$ns at 215.49901803307847 "$node_(24) setdest 1153 303 14.0" 
$ns at 357.6396501324815 "$node_(24) setdest 1624 214 11.0" 
$ns at 502.29605661519173 "$node_(24) setdest 2690 490 16.0" 
$ns at 864.453494597208 "$node_(24) setdest 1479 373 19.0" 
$ns at 0.0 "$node_(25) setdest 383 238 6.0" 
$ns at 53.987953181083434 "$node_(25) setdest 236 37 1.0" 
$ns at 89.85712432408565 "$node_(25) setdest 2019 257 14.0" 
$ns at 193.25883304955482 "$node_(25) setdest 642 895 17.0" 
$ns at 374.71742578465677 "$node_(25) setdest 1010 381 9.0" 
$ns at 661.3673171055032 "$node_(25) setdest 2444 471 5.0" 
$ns at 0.0 "$node_(26) setdest 645 893 5.0" 
$ns at 39.33469794179818 "$node_(26) setdest 1662 902 6.0" 
$ns at 83.71001650817334 "$node_(26) setdest 897 4 14.0" 
$ns at 156.651549913163 "$node_(26) setdest 1899 767 17.0" 
$ns at 422.91272278353904 "$node_(26) setdest 2681 78 7.0" 
$ns at 697.9370028778275 "$node_(26) setdest 1470 162 1.0" 
$ns at 0.0 "$node_(27) setdest 1226 427 5.0" 
$ns at 31.176946085849774 "$node_(27) setdest 1860 488 10.0" 
$ns at 149.14766784911941 "$node_(27) setdest 953 763 1.0" 
$ns at 216.32569660732202 "$node_(27) setdest 2814 650 17.0" 
$ns at 372.48402591366084 "$node_(27) setdest 1020 635 2.0" 
$ns at 613.5610540758513 "$node_(27) setdest 1060 626 12.0" 
$ns at 0.0 "$node_(28) setdest 429 436 17.0" 
$ns at 25.54969794921844 "$node_(28) setdest 1464 621 9.0" 
$ns at 98.84250965979182 "$node_(28) setdest 353 810 2.0" 
$ns at 170.72632870498256 "$node_(28) setdest 2132 252 18.0" 
$ns at 356.54652528167003 "$node_(28) setdest 82 550 6.0" 
$ns at 620.3483686986411 "$node_(28) setdest 2734 477 7.0" 
$ns at 0.0 "$node_(29) setdest 1740 295 1.0" 
$ns at 20.4003497586719 "$node_(29) setdest 2095 229 5.0" 
$ns at 73.48807941129844 "$node_(29) setdest 683 643 15.0" 
$ns at 193.280504898074 "$node_(29) setdest 2803 945 5.0" 
$ns at 362.82463073883616 "$node_(29) setdest 2213 479 8.0" 
$ns at 628.8947219569336 "$node_(29) setdest 2392 473 9.0" 
$ns at 0.0 "$node_(30) setdest 1033 623 13.0" 
$ns at 69.47028889677313 "$node_(30) setdest 2350 42 12.0" 
$ns at 190.13088422667514 "$node_(30) setdest 1576 116 15.0" 
$ns at 252.80919159725192 "$node_(30) setdest 997 262 18.0" 
$ns at 408.8765485899064 "$node_(30) setdest 2123 733 8.0" 
$ns at 715.4857236328069 "$node_(30) setdest 2 357 15.0" 
$ns at 0.0 "$node_(31) setdest 1353 559 4.0" 
$ns at 48.78705133478468 "$node_(31) setdest 1070 97 18.0" 
$ns at 88.77680534564468 "$node_(31) setdest 2734 691 3.0" 
$ns at 160.03694366182276 "$node_(31) setdest 79 119 2.0" 
$ns at 283.5168979473917 "$node_(31) setdest 1908 428 10.0" 
$ns at 620.1969559882574 "$node_(31) setdest 1680 614 11.0" 
$ns at 0.0 "$node_(32) setdest 2964 502 4.0" 
$ns at 53.80071211310553 "$node_(32) setdest 159 573 19.0" 
$ns at 121.17297084452639 "$node_(32) setdest 2259 200 15.0" 
$ns at 328.76171823675594 "$node_(32) setdest 2075 51 14.0" 
$ns at 506.5964547780095 "$node_(32) setdest 2191 455 1.0" 
$ns at 752.0022434880825 "$node_(32) setdest 1947 161 6.0" 
$ns at 0.0 "$node_(33) setdest 1067 228 7.0" 
$ns at 62.65174436220363 "$node_(33) setdest 28 756 12.0" 
$ns at 199.5479203064609 "$node_(33) setdest 1975 786 6.0" 
$ns at 278.41331959966647 "$node_(33) setdest 1946 992 5.0" 
$ns at 427.68074124903467 "$node_(33) setdest 315 680 10.0" 
$ns at 718.7772733186918 "$node_(33) setdest 721 255 16.0" 
$ns at 0.0 "$node_(34) setdest 383 525 1.0" 
$ns at 16.131107803663074 "$node_(34) setdest 2454 125 13.0" 
$ns at 82.39465281590704 "$node_(34) setdest 1167 909 1.0" 
$ns at 145.59143596958745 "$node_(34) setdest 1705 368 14.0" 
$ns at 290.1543285044381 "$node_(34) setdest 256 8 5.0" 
$ns at 536.7203017616878 "$node_(34) setdest 2347 142 5.0" 
$ns at 0.0 "$node_(35) setdest 2512 747 1.0" 
$ns at 23.03907812741958 "$node_(35) setdest 408 874 1.0" 
$ns at 53.2083688508373 "$node_(35) setdest 2908 579 11.0" 
$ns at 190.65813125281068 "$node_(35) setdest 2192 531 11.0" 
$ns at 355.40439481667823 "$node_(35) setdest 691 226 9.0" 
$ns at 614.4413064918876 "$node_(35) setdest 1705 226 6.0" 
$ns at 0.0 "$node_(36) setdest 756 955 2.0" 
$ns at 26.24685389829736 "$node_(36) setdest 1152 367 2.0" 
$ns at 73.40224623880131 "$node_(36) setdest 908 222 13.0" 
$ns at 234.59270018253926 "$node_(36) setdest 48 822 11.0" 
$ns at 370.94148989963963 "$node_(36) setdest 386 774 12.0" 
$ns at 620.1448968547982 "$node_(36) setdest 2210 787 17.0" 
$ns at 0.0 "$node_(37) setdest 2826 528 16.0" 
$ns at 79.61207190921554 "$node_(37) setdest 654 323 19.0" 
$ns at 289.45918664363586 "$node_(37) setdest 2550 819 14.0" 
$ns at 487.99415223271785 "$node_(37) setdest 196 776 18.0" 
$ns at 747.2928261589882 "$node_(37) setdest 841 848 13.0" 
$ns at 0.0 "$node_(38) setdest 249 520 14.0" 
$ns at 19.022346809067628 "$node_(38) setdest 601 409 11.0" 
$ns at 63.91600136521808 "$node_(38) setdest 2128 749 19.0" 
$ns at 179.46062088692952 "$node_(38) setdest 548 224 13.0" 
$ns at 359.98345385497623 "$node_(38) setdest 870 257 16.0" 
$ns at 629.1328662815749 "$node_(38) setdest 1856 480 6.0" 
$ns at 0.0 "$node_(39) setdest 353 431 8.0" 
$ns at 71.25364847459622 "$node_(39) setdest 1884 384 11.0" 
$ns at 148.848172454932 "$node_(39) setdest 1236 898 1.0" 
$ns at 210.16665184852704 "$node_(39) setdest 1400 831 6.0" 
$ns at 340.07889898931376 "$node_(39) setdest 2007 544 9.0" 
$ns at 620.8632487323036 "$node_(39) setdest 1456 514 12.0" 
$ns at 0.0 "$node_(40) setdest 160 854 1.0" 
$ns at 21.192844816795333 "$node_(40) setdest 2813 48 3.0" 
$ns at 66.13814600694255 "$node_(40) setdest 2275 789 20.0" 
$ns at 156.1564638280099 "$node_(40) setdest 558 960 19.0" 
$ns at 365.87524221088654 "$node_(40) setdest 1537 650 7.0" 
$ns at 665.0068188231289 "$node_(40) setdest 342 604 18.0" 
$ns at 0.0 "$node_(41) setdest 1964 635 6.0" 
$ns at 52.43630351451494 "$node_(41) setdest 2360 355 18.0" 
$ns at 197.78125140354376 "$node_(41) setdest 1377 53 15.0" 
$ns at 373.65009537467984 "$node_(41) setdest 1999 641 16.0" 
$ns at 545.4997903492747 "$node_(41) setdest 1884 399 15.0" 
$ns at 800.698761358182 "$node_(41) setdest 2793 670 19.0" 
$ns at 0.0 "$node_(42) setdest 407 742 9.0" 
$ns at 86.93927051158342 "$node_(42) setdest 2095 914 19.0" 
$ns at 186.561983982108 "$node_(42) setdest 2536 139 19.0" 
$ns at 435.2867162360004 "$node_(42) setdest 611 691 7.0" 
$ns at 570.3460899836745 "$node_(42) setdest 1724 34 9.0" 
$ns at 836.1509902540354 "$node_(42) setdest 707 426 4.0" 
$ns at 0.0 "$node_(43) setdest 1612 838 2.0" 
$ns at 30.925848450676284 "$node_(43) setdest 1135 424 16.0" 
$ns at 192.0220800669055 "$node_(43) setdest 1010 161 18.0" 
$ns at 334.0508452016494 "$node_(43) setdest 2581 231 12.0" 
$ns at 533.7204347944976 "$node_(43) setdest 2800 394 3.0" 
$ns at 791.9171928574126 "$node_(43) setdest 189 924 15.0" 
$ns at 0.0 "$node_(44) setdest 806 597 18.0" 
$ns at 41.19240246163341 "$node_(44) setdest 2965 907 8.0" 
$ns at 124.34732646696847 "$node_(44) setdest 1396 909 8.0" 
$ns at 244.15928614666942 "$node_(44) setdest 708 47 12.0" 
$ns at 482.27548878562243 "$node_(44) setdest 2344 929 17.0" 
$ns at 881.2580874197795 "$node_(44) setdest 877 222 18.0" 
$ns at 0.0 "$node_(45) setdest 2235 777 11.0" 
$ns at 16.248172161863522 "$node_(45) setdest 539 636 6.0" 
$ns at 91.24436105932918 "$node_(45) setdest 436 793 5.0" 
$ns at 157.68007809095383 "$node_(45) setdest 2308 456 2.0" 
$ns at 286.6953025377295 "$node_(45) setdest 2414 79 18.0" 
$ns at 528.8208523862252 "$node_(45) setdest 922 623 14.0" 
$ns at 0.0 "$node_(46) setdest 924 347 9.0" 
$ns at 24.290627092741666 "$node_(46) setdest 2859 912 18.0" 
$ns at 79.60707274351904 "$node_(46) setdest 342 770 1.0" 
$ns at 141.13712262976395 "$node_(46) setdest 1154 566 4.0" 
$ns at 269.02356931150393 "$node_(46) setdest 2186 803 11.0" 
$ns at 566.2947309618814 "$node_(46) setdest 2306 101 1.0" 
$ns at 0.0 "$node_(47) setdest 2580 175 19.0" 
$ns at 149.79344061969758 "$node_(47) setdest 1937 101 15.0" 
$ns at 233.99840244633523 "$node_(47) setdest 2206 508 6.0" 
$ns at 348.1484303630764 "$node_(47) setdest 1604 94 13.0" 
$ns at 525.2410659731338 "$node_(47) setdest 8 279 17.0" 
$ns at 853.6659973007686 "$node_(47) setdest 910 832 14.0" 
$ns at 0.0 "$node_(48) setdest 2693 71 2.0" 
$ns at 16.36171620628177 "$node_(48) setdest 1826 565 18.0" 
$ns at 215.64437100819237 "$node_(48) setdest 1784 324 9.0" 
$ns at 347.2823030169753 "$node_(48) setdest 2867 137 11.0" 
$ns at 561.8892350089727 "$node_(48) setdest 2770 49 5.0" 
$ns at 848.683446295862 "$node_(48) setdest 532 991 17.0" 
$ns at 0.0 "$node_(49) setdest 2623 201 6.0" 
$ns at 47.40939029622703 "$node_(49) setdest 1153 404 11.0" 
$ns at 142.6802906946425 "$node_(49) setdest 1711 678 17.0" 
$ns at 234.68543337997588 "$node_(49) setdest 2067 548 6.0" 
$ns at 369.66760821731066 "$node_(49) setdest 1881 147 10.0" 
$ns at 617.8808257198332 "$node_(49) setdest 747 195 14.0" 
$ns at 0.0 "$node_(50) setdest 246 156 8.0" 
$ns at 38.957822834710086 "$node_(50) setdest 1307 165 4.0" 
$ns at 94.39569873557505 "$node_(50) setdest 946 240 5.0" 
$ns at 165.63055085484314 "$node_(50) setdest 530 829 2.0" 
$ns at 300.3641806060641 "$node_(50) setdest 1916 977 18.0" 
$ns at 617.2040445054274 "$node_(50) setdest 2321 266 2.0" 
$ns at 0.0 "$node_(51) setdest 1438 199 12.0" 
$ns at 75.52760033202574 "$node_(51) setdest 2235 897 16.0" 
$ns at 180.30810192319933 "$node_(51) setdest 995 818 8.0" 
$ns at 293.55449318043543 "$node_(51) setdest 1484 681 14.0" 
$ns at 442.0195691245633 "$node_(51) setdest 2721 977 17.0" 
$ns at 693.106424381722 "$node_(51) setdest 2579 202 5.0" 
$ns at 0.0 "$node_(52) setdest 460 471 9.0" 
$ns at 29.951790596909074 "$node_(52) setdest 2505 236 16.0" 
$ns at 93.97582613665216 "$node_(52) setdest 219 664 7.0" 
$ns at 199.16449489308513 "$node_(52) setdest 80 621 18.0" 
$ns at 449.3894615865399 "$node_(52) setdest 1534 334 17.0" 
$ns at 794.0667242893473 "$node_(52) setdest 1906 518 8.0" 
$ns at 0.0 "$node_(53) setdest 1043 184 3.0" 
$ns at 20.353738263184205 "$node_(53) setdest 59 395 11.0" 
$ns at 145.42752558207147 "$node_(53) setdest 2272 943 1.0" 
$ns at 211.25407384677922 "$node_(53) setdest 424 313 16.0" 
$ns at 349.31849338245746 "$node_(53) setdest 1429 296 9.0" 
$ns at 634.7845894438694 "$node_(53) setdest 1325 347 19.0" 
$ns at 0.0 "$node_(54) setdest 719 66 3.0" 
$ns at 21.712770847537 "$node_(54) setdest 2851 226 6.0" 
$ns at 82.51636498230408 "$node_(54) setdest 2476 394 5.0" 
$ns at 177.61457743570145 "$node_(54) setdest 2039 523 3.0" 
$ns at 325.5793904016876 "$node_(54) setdest 1116 837 14.0" 
$ns at 685.3649526635311 "$node_(54) setdest 1804 973 14.0" 
$ns at 0.0 "$node_(55) setdest 2705 612 2.0" 
$ns at 25.403219525480026 "$node_(55) setdest 2272 759 15.0" 
$ns at 131.8146939936191 "$node_(55) setdest 671 446 10.0" 
$ns at 280.6783181721272 "$node_(55) setdest 931 844 8.0" 
$ns at 443.21573032901546 "$node_(55) setdest 1917 720 11.0" 
$ns at 731.5704993746065 "$node_(55) setdest 1732 675 8.0" 
$ns at 0.0 "$node_(56) setdest 389 883 17.0" 
$ns at 121.19057325799487 "$node_(56) setdest 1054 854 7.0" 
$ns at 195.929829990129 "$node_(56) setdest 2860 334 17.0" 
$ns at 397.91331990328075 "$node_(56) setdest 190 594 20.0" 
$ns at 713.7659134689064 "$node_(56) setdest 2456 227 5.0" 
$ns at 0.0 "$node_(57) setdest 1738 55 8.0" 
$ns at 72.43776654434711 "$node_(57) setdest 213 916 11.0" 
$ns at 185.7079789315328 "$node_(57) setdest 2077 884 15.0" 
$ns at 345.32750021995247 "$node_(57) setdest 1682 985 1.0" 
$ns at 472.3067969885132 "$node_(57) setdest 1798 539 16.0" 
$ns at 865.7431574699978 "$node_(57) setdest 367 81 3.0" 
$ns at 0.0 "$node_(58) setdest 2773 235 13.0" 
$ns at 30.421062391435935 "$node_(58) setdest 2511 992 4.0" 
$ns at 74.79556258418347 "$node_(58) setdest 241 600 1.0" 
$ns at 142.8639159579653 "$node_(58) setdest 1527 701 8.0" 
$ns at 321.03982262586493 "$node_(58) setdest 77 350 8.0" 
$ns at 639.650865528633 "$node_(58) setdest 78 345 1.0" 
$ns at 0.0 "$node_(59) setdest 2140 592 12.0" 
$ns at 53.07210135824555 "$node_(59) setdest 1608 312 10.0" 
$ns at 168.70577904845038 "$node_(59) setdest 2356 568 13.0" 
$ns at 231.9558537653058 "$node_(59) setdest 1829 907 10.0" 
$ns at 410.6114998351577 "$node_(59) setdest 937 939 5.0" 
$ns at 675.7313081587743 "$node_(59) setdest 2455 322 3.0" 
$ns at 0.0 "$node_(60) setdest 1885 915 18.0" 
$ns at 90.68613626361866 "$node_(60) setdest 1206 844 11.0" 
$ns at 212.0319297984235 "$node_(60) setdest 1689 845 7.0" 
$ns at 283.5394687827721 "$node_(60) setdest 2860 519 6.0" 
$ns at 423.06788470558837 "$node_(60) setdest 1866 74 12.0" 
$ns at 754.8761392983588 "$node_(60) setdest 879 726 15.0" 
$ns at 0.0 "$node_(61) setdest 2741 161 5.0" 
$ns at 50.870555166438294 "$node_(61) setdest 2892 376 20.0" 
$ns at 96.38993494759725 "$node_(61) setdest 2634 787 5.0" 
$ns at 172.8683589298019 "$node_(61) setdest 48 672 5.0" 
$ns at 303.8954177514439 "$node_(61) setdest 334 936 8.0" 
$ns at 583.718780445821 "$node_(61) setdest 38 667 14.0" 
$ns at 0.0 "$node_(62) setdest 2540 179 1.0" 
$ns at 15.514266143101214 "$node_(62) setdest 1293 47 1.0" 
$ns at 48.09454357165498 "$node_(62) setdest 2644 146 19.0" 
$ns at 119.98137084229398 "$node_(62) setdest 2647 871 17.0" 
$ns at 401.4786132678494 "$node_(62) setdest 28 512 19.0" 
$ns at 786.8052972090836 "$node_(62) setdest 2491 210 6.0" 
$ns at 0.0 "$node_(63) setdest 763 91 2.0" 
$ns at 34.52409793924612 "$node_(63) setdest 2188 889 18.0" 
$ns at 83.70055846722065 "$node_(63) setdest 1382 856 12.0" 
$ns at 164.02302232775395 "$node_(63) setdest 2288 814 14.0" 
$ns at 398.30927023197216 "$node_(63) setdest 102 976 11.0" 
$ns at 702.7379245537063 "$node_(63) setdest 1812 550 6.0" 
$ns at 0.0 "$node_(64) setdest 2672 199 17.0" 
$ns at 21.151390380375446 "$node_(64) setdest 2630 155 1.0" 
$ns at 55.33009164117268 "$node_(64) setdest 2737 163 18.0" 
$ns at 166.43854379448283 "$node_(64) setdest 725 429 10.0" 
$ns at 384.64703843194206 "$node_(64) setdest 1371 469 17.0" 
$ns at 650.7538711135469 "$node_(64) setdest 851 74 17.0" 
$ns at 0.0 "$node_(65) setdest 2185 598 13.0" 
$ns at 113.95289803465005 "$node_(65) setdest 1873 454 10.0" 
$ns at 171.10366332123095 "$node_(65) setdest 161 994 7.0" 
$ns at 266.7923538898673 "$node_(65) setdest 2822 906 14.0" 
$ns at 517.4462884156621 "$node_(65) setdest 1112 917 20.0" 
$ns at 0.0 "$node_(66) setdest 2427 828 7.0" 
$ns at 29.84021227679174 "$node_(66) setdest 1423 876 18.0" 
$ns at 98.53840403836571 "$node_(66) setdest 1661 984 10.0" 
$ns at 179.6251817802135 "$node_(66) setdest 2477 730 5.0" 
$ns at 336.0727425271202 "$node_(66) setdest 1583 740 12.0" 
$ns at 652.3316878896724 "$node_(66) setdest 2911 802 20.0" 
$ns at 0.0 "$node_(67) setdest 1491 190 15.0" 
$ns at 30.119338458434605 "$node_(67) setdest 2611 569 1.0" 
$ns at 61.99859566698147 "$node_(67) setdest 172 377 6.0" 
$ns at 142.50513854338348 "$node_(67) setdest 2103 773 17.0" 
$ns at 333.47773975799214 "$node_(67) setdest 773 61 19.0" 
$ns at 592.0880254865922 "$node_(67) setdest 2724 28 4.0" 
$ns at 0.0 "$node_(68) setdest 2573 749 5.0" 
$ns at 49.549056307167106 "$node_(68) setdest 1747 261 19.0" 
$ns at 150.41229100376268 "$node_(68) setdest 2680 942 1.0" 
$ns at 216.0625012791511 "$node_(68) setdest 1350 566 7.0" 
$ns at 340.18718425664264 "$node_(68) setdest 1436 799 12.0" 
$ns at 617.2998424942416 "$node_(68) setdest 80 296 14.0" 
$ns at 0.0 "$node_(69) setdest 45 690 20.0" 
$ns at 201.4671121655153 "$node_(69) setdest 2226 493 1.0" 
$ns at 232.62219053642977 "$node_(69) setdest 720 326 12.0" 
$ns at 341.56464265439257 "$node_(69) setdest 237 969 8.0" 
$ns at 501.06810749575135 "$node_(69) setdest 2356 435 13.0" 
$ns at 839.9964024074516 "$node_(69) setdest 103 629 20.0" 
$ns at 0.0 "$node_(70) setdest 528 199 2.0" 
$ns at 19.30505718331387 "$node_(70) setdest 1341 870 6.0" 
$ns at 83.89563722825119 "$node_(70) setdest 1316 880 1.0" 
$ns at 145.5882619020005 "$node_(70) setdest 2991 136 12.0" 
$ns at 361.1221892660564 "$node_(70) setdest 2263 381 1.0" 
$ns at 601.3509972539525 "$node_(70) setdest 2777 951 8.0" 
$ns at 0.0 "$node_(71) setdest 2462 663 12.0" 
$ns at 29.681534968067606 "$node_(71) setdest 2334 34 9.0" 
$ns at 95.57720462939552 "$node_(71) setdest 2583 250 7.0" 
$ns at 179.6486348096228 "$node_(71) setdest 2149 305 3.0" 
$ns at 315.1398574149796 "$node_(71) setdest 1336 265 17.0" 
$ns at 569.6413349945583 "$node_(71) setdest 627 883 8.0" 
$ns at 0.0 "$node_(72) setdest 1670 714 1.0" 
$ns at 21.852369704952803 "$node_(72) setdest 425 388 10.0" 
$ns at 73.52574324611325 "$node_(72) setdest 1723 966 7.0" 
$ns at 171.27984142848408 "$node_(72) setdest 1960 150 8.0" 
$ns at 321.74650387387874 "$node_(72) setdest 306 641 1.0" 
$ns at 566.078634573209 "$node_(72) setdest 755 147 8.0" 
$ns at 0.0 "$node_(73) setdest 2443 361 18.0" 
$ns at 170.047737977266 "$node_(73) setdest 2996 744 1.0" 
$ns at 206.0292295594155 "$node_(73) setdest 2254 76 1.0" 
$ns at 269.5493093650451 "$node_(73) setdest 2487 590 11.0" 
$ns at 476.12720725501134 "$node_(73) setdest 2199 914 11.0" 
$ns at 723.4781954400268 "$node_(73) setdest 882 229 16.0" 
$ns at 0.0 "$node_(74) setdest 2459 768 14.0" 
$ns at 42.40372356349272 "$node_(74) setdest 854 273 4.0" 
$ns at 82.80007033518143 "$node_(74) setdest 2992 74 18.0" 
$ns at 307.6363320116211 "$node_(74) setdest 1602 217 17.0" 
$ns at 544.1807981731803 "$node_(74) setdest 1539 490 1.0" 
$ns at 793.5177806413717 "$node_(74) setdest 2853 217 12.0" 
$ns at 0.0 "$node_(75) setdest 1587 434 8.0" 
$ns at 85.57991284469233 "$node_(75) setdest 251 433 1.0" 
$ns at 122.0342854895216 "$node_(75) setdest 104 672 14.0" 
$ns at 194.47542449065867 "$node_(75) setdest 800 746 10.0" 
$ns at 383.18597960189834 "$node_(75) setdest 538 447 12.0" 
$ns at 681.6356942848065 "$node_(75) setdest 749 954 15.0" 
$ns at 0.0 "$node_(76) setdest 1373 818 19.0" 
$ns at 146.050355624724 "$node_(76) setdest 1078 756 1.0" 
$ns at 178.099952210353 "$node_(76) setdest 1277 190 17.0" 
$ns at 322.0254795241258 "$node_(76) setdest 1492 128 12.0" 
$ns at 500.3572539313027 "$node_(76) setdest 2597 238 7.0" 
$ns at 763.8367138060728 "$node_(76) setdest 1562 907 13.0" 
$ns at 0.0 "$node_(77) setdest 1756 675 13.0" 
$ns at 75.75604261162613 "$node_(77) setdest 2430 669 11.0" 
$ns at 212.23535020248136 "$node_(77) setdest 801 575 10.0" 
$ns at 359.63482248716485 "$node_(77) setdest 224 241 4.0" 
$ns at 517.2046803992266 "$node_(77) setdest 153 217 8.0" 
$ns at 773.0297211877934 "$node_(77) setdest 2081 419 18.0" 
$ns at 0.0 "$node_(78) setdest 2324 633 11.0" 
$ns at 36.359863478230025 "$node_(78) setdest 435 727 15.0" 
$ns at 103.55764310849372 "$node_(78) setdest 129 350 1.0" 
$ns at 168.40724661723664 "$node_(78) setdest 979 302 3.0" 
$ns at 300.101319645927 "$node_(78) setdest 1676 3 9.0" 
$ns at 596.825954607827 "$node_(78) setdest 2436 231 6.0" 
$ns at 0.0 "$node_(79) setdest 1152 794 19.0" 
$ns at 164.7152017057718 "$node_(79) setdest 1060 934 3.0" 
$ns at 211.78302028769494 "$node_(79) setdest 196 999 2.0" 
$ns at 281.39028882122284 "$node_(79) setdest 503 408 16.0" 
$ns at 413.7143582278174 "$node_(79) setdest 2371 973 11.0" 
$ns at 679.8579203260424 "$node_(79) setdest 2468 427 9.0" 
$ns at 0.0 "$node_(80) setdest 25 382 11.0" 
$ns at 30.16165224372658 "$node_(80) setdest 2285 28 17.0" 
$ns at 86.30912661840732 "$node_(80) setdest 560 582 15.0" 
$ns at 223.12858225405125 "$node_(80) setdest 2315 858 18.0" 
$ns at 472.865533953961 "$node_(80) setdest 1887 396 6.0" 
$ns at 733.0340719605072 "$node_(80) setdest 2842 223 8.0" 
$ns at 0.0 "$node_(81) setdest 1607 707 9.0" 
$ns at 21.80777253139973 "$node_(81) setdest 2853 917 4.0" 
$ns at 74.3971385799016 "$node_(81) setdest 2171 599 12.0" 
$ns at 135.22375035910483 "$node_(81) setdest 1848 158 8.0" 
$ns at 304.90152443145166 "$node_(81) setdest 2073 996 1.0" 
$ns at 547.7104249797251 "$node_(81) setdest 597 227 6.0" 
$ns at 0.0 "$node_(82) setdest 2831 996 7.0" 
$ns at 32.58062495658841 "$node_(82) setdest 2489 627 13.0" 
$ns at 106.07357245330176 "$node_(82) setdest 2302 379 11.0" 
$ns at 257.86237258986523 "$node_(82) setdest 2872 850 1.0" 
$ns at 386.48307837154675 "$node_(82) setdest 2591 970 16.0" 
$ns at 774.3423204992234 "$node_(82) setdest 2544 86 19.0" 
$ns at 0.0 "$node_(83) setdest 1595 839 13.0" 
$ns at 31.317996085253704 "$node_(83) setdest 1295 455 2.0" 
$ns at 74.91592070907933 "$node_(83) setdest 956 522 10.0" 
$ns at 168.21551953969617 "$node_(83) setdest 144 594 3.0" 
$ns at 302.0720827971253 "$node_(83) setdest 940 738 10.0" 
$ns at 633.8767400532477 "$node_(83) setdest 2693 675 2.0" 
$ns at 0.0 "$node_(84) setdest 1537 301 6.0" 
$ns at 47.89097978480945 "$node_(84) setdest 721 197 6.0" 
$ns at 116.00869446925628 "$node_(84) setdest 2797 184 15.0" 
$ns at 311.9025124790053 "$node_(84) setdest 1954 127 14.0" 
$ns at 509.6192888073619 "$node_(84) setdest 1180 943 5.0" 
$ns at 791.0071048862719 "$node_(84) setdest 2635 223 9.0" 
$ns at 0.0 "$node_(85) setdest 452 960 6.0" 
$ns at 52.91041228465533 "$node_(85) setdest 311 620 10.0" 
$ns at 102.76148796498879 "$node_(85) setdest 2404 208 1.0" 
$ns at 169.31360944406723 "$node_(85) setdest 1989 16 12.0" 
$ns at 403.4497592090162 "$node_(85) setdest 417 497 20.0" 
$ns at 697.2093781131958 "$node_(85) setdest 1556 31 5.0" 
$ns at 0.0 "$node_(86) setdest 2651 415 13.0" 
$ns at 130.76491762383478 "$node_(86) setdest 124 584 12.0" 
$ns at 199.9605863050936 "$node_(86) setdest 1396 401 1.0" 
$ns at 267.61697264251245 "$node_(86) setdest 2696 356 8.0" 
$ns at 440.0893534173074 "$node_(86) setdest 842 684 14.0" 
$ns at 754.8958718792201 "$node_(86) setdest 304 682 3.0" 
$ns at 0.0 "$node_(87) setdest 313 25 2.0" 
$ns at 32.10640488110247 "$node_(87) setdest 1534 446 9.0" 
$ns at 140.67202026292443 "$node_(87) setdest 1739 473 6.0" 
$ns at 237.01909761627928 "$node_(87) setdest 1072 817 2.0" 
$ns at 360.97894261602266 "$node_(87) setdest 2884 602 17.0" 
$ns at 673.5159491276976 "$node_(87) setdest 1689 905 2.0" 
$ns at 0.0 "$node_(88) setdest 1622 919 6.0" 
$ns at 52.989887941194574 "$node_(88) setdest 2806 674 19.0" 
$ns at 235.8316174687207 "$node_(88) setdest 1270 419 5.0" 
$ns at 333.80615954711976 "$node_(88) setdest 1549 678 1.0" 
$ns at 462.28994009189296 "$node_(88) setdest 1773 477 18.0" 
$ns at 748.7609659247612 "$node_(88) setdest 1944 479 16.0" 
$ns at 0.0 "$node_(89) setdest 1262 547 6.0" 
$ns at 22.36055203151255 "$node_(89) setdest 1653 802 10.0" 
$ns at 81.31652358828819 "$node_(89) setdest 258 364 9.0" 
$ns at 182.1167462517896 "$node_(89) setdest 1402 779 13.0" 
$ns at 311.7365459824379 "$node_(89) setdest 1552 619 5.0" 
$ns at 563.5350261560271 "$node_(89) setdest 2013 845 5.0" 
$ns at 0.0 "$node_(90) setdest 2538 299 16.0" 
$ns at 151.43703645230207 "$node_(90) setdest 2672 147 10.0" 
$ns at 231.08785215236162 "$node_(90) setdest 1537 163 16.0" 
$ns at 306.24563085813907 "$node_(90) setdest 2865 509 15.0" 
$ns at 548.4698892703259 "$node_(90) setdest 1367 49 10.0" 
$ns at 858.0682776289921 "$node_(90) setdest 2102 321 7.0" 
$ns at 0.0 "$node_(91) setdest 205 980 7.0" 
$ns at 61.068275911878864 "$node_(91) setdest 1357 916 13.0" 
$ns at 115.94635003426592 "$node_(91) setdest 2515 269 4.0" 
$ns at 211.36823653940314 "$node_(91) setdest 1864 262 8.0" 
$ns at 365.3167062147876 "$node_(91) setdest 2559 79 7.0" 
$ns at 668.3488773238632 "$node_(91) setdest 668 70 3.0" 
$ns at 0.0 "$node_(92) setdest 1788 152 7.0" 
$ns at 61.00875094679032 "$node_(92) setdest 1101 635 16.0" 
$ns at 167.22779029129848 "$node_(92) setdest 2114 656 17.0" 
$ns at 350.6491651894916 "$node_(92) setdest 60 992 1.0" 
$ns at 474.28207991896306 "$node_(92) setdest 1867 367 1.0" 
$ns at 717.9243689527682 "$node_(92) setdest 1762 229 19.0" 
$ns at 0.0 "$node_(93) setdest 946 629 15.0" 
$ns at 52.03507157347715 "$node_(93) setdest 367 30 7.0" 
$ns at 100.08538811455878 "$node_(93) setdest 1447 814 17.0" 
$ns at 308.6440965922642 "$node_(93) setdest 618 786 1.0" 
$ns at 438.50765909171173 "$node_(93) setdest 2801 224 14.0" 
$ns at 807.9276034517009 "$node_(93) setdest 2415 849 20.0" 
$ns at 0.0 "$node_(94) setdest 188 663 18.0" 
$ns at 29.115260001814143 "$node_(94) setdest 1958 768 3.0" 
$ns at 67.63458670863929 "$node_(94) setdest 1764 107 11.0" 
$ns at 135.7288784386931 "$node_(94) setdest 2876 590 14.0" 
$ns at 257.40777340678727 "$node_(94) setdest 2975 208 10.0" 
$ns at 499.2605173605804 "$node_(94) setdest 1479 545 20.0" 
$ns at 0.0 "$node_(95) setdest 984 571 6.0" 
$ns at 28.853569445353525 "$node_(95) setdest 1055 716 3.0" 
$ns at 84.10600297800676 "$node_(95) setdest 988 13 1.0" 
$ns at 145.3089640240935 "$node_(95) setdest 2847 510 13.0" 
$ns at 332.23793515062147 "$node_(95) setdest 2958 272 17.0" 
$ns at 722.7757452079452 "$node_(95) setdest 115 20 3.0" 
$ns at 0.0 "$node_(96) setdest 74 859 1.0" 
$ns at 15.45492539269329 "$node_(96) setdest 2452 615 9.0" 
$ns at 86.27538541564357 "$node_(96) setdest 2878 17 17.0" 
$ns at 158.79581144404307 "$node_(96) setdest 1227 320 6.0" 
$ns at 310.64486414557234 "$node_(96) setdest 1937 998 1.0" 
$ns at 557.1957818069806 "$node_(96) setdest 839 844 10.0" 
$ns at 0.0 "$node_(97) setdest 1528 103 17.0" 
$ns at 72.15207839449991 "$node_(97) setdest 1161 321 15.0" 
$ns at 126.57059294875945 "$node_(97) setdest 2630 204 18.0" 
$ns at 292.06646812394484 "$node_(97) setdest 331 100 8.0" 
$ns at 461.24058240613084 "$node_(97) setdest 249 702 8.0" 
$ns at 744.415535428258 "$node_(97) setdest 809 164 20.0" 
$ns at 0.0 "$node_(98) setdest 856 120 10.0" 
$ns at 109.15894991232041 "$node_(98) setdest 2323 22 19.0" 
$ns at 186.36253737700235 "$node_(98) setdest 457 804 1.0" 
$ns at 246.9684167336454 "$node_(98) setdest 2139 136 4.0" 
$ns at 404.5613048498104 "$node_(98) setdest 2583 417 20.0" 
$ns at 763.3996961721666 "$node_(98) setdest 2774 232 10.0" 
$ns at 0.0 "$node_(99) setdest 220 208 17.0" 
$ns at 156.5661727222145 "$node_(99) setdest 1087 69 8.0" 
$ns at 223.2580395600442 "$node_(99) setdest 2459 241 17.0" 
$ns at 385.70631362090353 "$node_(99) setdest 2372 501 14.0" 
$ns at 614.9485258246923 "$node_(99) setdest 1394 59 7.0" 


#Set a TCP connection between node_(62) and node_(90)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(0)
$ns attach-agent $node_(90) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(17) and node_(93)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(1)
$ns attach-agent $node_(93) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(18) and node_(47)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(2)
$ns attach-agent $node_(47) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(77) and node_(24)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(3)
$ns attach-agent $node_(24) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(95) and node_(34)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(4)
$ns attach-agent $node_(34) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(69) and node_(10)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(5)
$ns attach-agent $node_(10) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(60) and node_(44)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(6)
$ns attach-agent $node_(44) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(50) and node_(97)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(7)
$ns attach-agent $node_(97) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(9) and node_(95)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(8)
$ns attach-agent $node_(95) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(27) and node_(46)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(9)
$ns attach-agent $node_(46) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(61) and node_(27)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(10)
$ns attach-agent $node_(27) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(61) and node_(14)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(11)
$ns attach-agent $node_(14) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(7) and node_(54)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(12)
$ns attach-agent $node_(54) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(93) and node_(52)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(13)
$ns attach-agent $node_(52) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(36) and node_(53)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(14)
$ns attach-agent $node_(53) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(64) and node_(52)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(15)
$ns attach-agent $node_(52) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(10) and node_(30)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(16)
$ns attach-agent $node_(30) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(81) and node_(59)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(17)
$ns attach-agent $node_(59) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(5) and node_(46)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(18)
$ns attach-agent $node_(46) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(84) and node_(6)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(19)
$ns attach-agent $node_(6) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(84) and node_(9)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(20)
$ns attach-agent $node_(9) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(25) and node_(14)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(21)
$ns attach-agent $node_(14) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(10) and node_(77)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(22)
$ns attach-agent $node_(77) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(50) and node_(79)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(23)
$ns attach-agent $node_(79) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(92) and node_(88)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(24)
$ns attach-agent $node_(88) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(24) and node_(97)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(25)
$ns attach-agent $node_(97) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(57) and node_(14)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(26)
$ns attach-agent $node_(14) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(98) and node_(73)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(27)
$ns attach-agent $node_(73) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(13) and node_(7)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(28)
$ns attach-agent $node_(7) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(36) and node_(27)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(29)
$ns attach-agent $node_(27) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(17) and node_(64)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(30)
$ns attach-agent $node_(64) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(55) and node_(44)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(31)
$ns attach-agent $node_(44) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(19) and node_(83)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(32)
$ns attach-agent $node_(83) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(88) and node_(94)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(33)
$ns attach-agent $node_(94) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(7) and node_(16)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(34)
$ns attach-agent $node_(16) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(3) and node_(35)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(35)
$ns attach-agent $node_(35) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(17) and node_(93)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(36)
$ns attach-agent $node_(93) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(7) and node_(99)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(37)
$ns attach-agent $node_(99) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(38) and node_(41)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(38)
$ns attach-agent $node_(41) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(2) and node_(8)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(39)
$ns attach-agent $node_(8) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(75) and node_(35)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(40)
$ns attach-agent $node_(35) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(42) and node_(61)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(41)
$ns attach-agent $node_(61) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(15) and node_(92)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(42)
$ns attach-agent $node_(92) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(33) and node_(20)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(43)
$ns attach-agent $node_(20) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(93) and node_(75)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(44)
$ns attach-agent $node_(75) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(68) and node_(42)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(45)
$ns attach-agent $node_(42) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(96) and node_(52)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(46)
$ns attach-agent $node_(52) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(48) and node_(39)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(47)
$ns attach-agent $node_(39) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(99) and node_(84)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(48)
$ns attach-agent $node_(84) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(80) and node_(92)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(49)
$ns attach-agent $node_(92) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(83) and node_(86)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(50)
$ns attach-agent $node_(86) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(74) and node_(81)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(51)
$ns attach-agent $node_(81) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(74) and node_(84)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(52)
$ns attach-agent $node_(84) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(6) and node_(18)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(53)
$ns attach-agent $node_(18) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(65) and node_(1)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(54)
$ns attach-agent $node_(1) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(97) and node_(8)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(55)
$ns attach-agent $node_(8) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(46) and node_(77)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(56)
$ns attach-agent $node_(77) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(15) and node_(22)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(57)
$ns attach-agent $node_(22) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(56) and node_(37)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(58)
$ns attach-agent $node_(37) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(23) and node_(34)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(59)
$ns attach-agent $node_(34) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(80) and node_(37)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(60)
$ns attach-agent $node_(37) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(92) and node_(68)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(61)
$ns attach-agent $node_(68) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(13) and node_(35)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(62)
$ns attach-agent $node_(35) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(84) and node_(17)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(63)
$ns attach-agent $node_(17) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(88) and node_(59)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(64)
$ns attach-agent $node_(59) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(9) and node_(80)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(65)
$ns attach-agent $node_(80) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(84) and node_(41)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(66)
$ns attach-agent $node_(41) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(56) and node_(44)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(67)
$ns attach-agent $node_(44) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(16) and node_(30)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(68)
$ns attach-agent $node_(30) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(91) and node_(58)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(69)
$ns attach-agent $node_(58) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(64) and node_(57)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(70)
$ns attach-agent $node_(57) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(91) and node_(21)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(71)
$ns attach-agent $node_(21) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(74) and node_(38)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(72)
$ns attach-agent $node_(38) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(6) and node_(94)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(73)
$ns attach-agent $node_(94) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(33) and node_(52)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(74)
$ns attach-agent $node_(52) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(68) and node_(39)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(75)
$ns attach-agent $node_(39) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(53) and node_(39)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(76)
$ns attach-agent $node_(39) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(73) and node_(1)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(77)
$ns attach-agent $node_(1) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(9) and node_(75)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(78)
$ns attach-agent $node_(75) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(57) and node_(79)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(79)
$ns attach-agent $node_(79) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(95) and node_(70)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(80)
$ns attach-agent $node_(70) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(5) and node_(93)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(81)
$ns attach-agent $node_(93) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(56) and node_(55)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(82)
$ns attach-agent $node_(55) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(4) and node_(68)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(83)
$ns attach-agent $node_(68) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(53) and node_(48)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(84)
$ns attach-agent $node_(48) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(12) and node_(99)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(85)
$ns attach-agent $node_(99) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(7) and node_(61)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(86)
$ns attach-agent $node_(61) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(10) and node_(99)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(87)
$ns attach-agent $node_(99) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(27) and node_(11)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(88)
$ns attach-agent $node_(11) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(35) and node_(60)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(89)
$ns attach-agent $node_(60) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(1) and node_(71)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(90)
$ns attach-agent $node_(71) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(57) and node_(85)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(91)
$ns attach-agent $node_(85) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(80) and node_(83)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(92)
$ns attach-agent $node_(83) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(96) and node_(72)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(93)
$ns attach-agent $node_(72) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(50) and node_(67)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(94)
$ns attach-agent $node_(67) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(89) and node_(10)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(95)
$ns attach-agent $node_(10) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(75) and node_(81)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(96)
$ns attach-agent $node_(81) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(67) and node_(78)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(97)
$ns attach-agent $node_(78) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(85) and node_(48)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(98)
$ns attach-agent $node_(48) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(77) and node_(82)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(99)
$ns attach-agent $node_(82) $sink_(99)
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
