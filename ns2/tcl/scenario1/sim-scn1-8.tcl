#sim-scn1-8.tcl 
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
set tracefd       [open sim-scn1-8-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-8-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-8-$val(rp).nam w]

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
$node_(0) set X_ 1128 
$node_(0) set Y_ 171 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2802 
$node_(1) set Y_ 840 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1387 
$node_(2) set Y_ 843 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 2171 
$node_(3) set Y_ 71 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2511 
$node_(4) set Y_ 423 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 865 
$node_(5) set Y_ 297 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1380 
$node_(6) set Y_ 8 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2757 
$node_(7) set Y_ 513 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 423 
$node_(8) set Y_ 56 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 306 
$node_(9) set Y_ 47 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 2407 
$node_(10) set Y_ 857 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2146 
$node_(11) set Y_ 744 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 272 
$node_(12) set Y_ 585 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 247 
$node_(13) set Y_ 674 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1943 
$node_(14) set Y_ 841 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2550 
$node_(15) set Y_ 693 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1794 
$node_(16) set Y_ 425 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1077 
$node_(17) set Y_ 584 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 545 
$node_(18) set Y_ 289 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1509 
$node_(19) set Y_ 787 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 49 
$node_(20) set Y_ 208 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 230 
$node_(21) set Y_ 920 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 505 
$node_(22) set Y_ 754 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 794 
$node_(23) set Y_ 389 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 211 
$node_(24) set Y_ 580 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 687 
$node_(25) set Y_ 399 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 991 
$node_(26) set Y_ 829 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2186 
$node_(27) set Y_ 568 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1977 
$node_(28) set Y_ 769 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 932 
$node_(29) set Y_ 197 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1348 
$node_(30) set Y_ 350 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2734 
$node_(31) set Y_ 934 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 128 
$node_(32) set Y_ 471 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1857 
$node_(33) set Y_ 234 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1007 
$node_(34) set Y_ 173 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2874 
$node_(35) set Y_ 531 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 574 
$node_(36) set Y_ 864 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 873 
$node_(37) set Y_ 484 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 174 
$node_(38) set Y_ 932 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2525 
$node_(39) set Y_ 25 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 927 
$node_(40) set Y_ 791 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1214 
$node_(41) set Y_ 160 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 243 
$node_(42) set Y_ 479 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 41 
$node_(43) set Y_ 672 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2416 
$node_(44) set Y_ 426 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2184 
$node_(45) set Y_ 902 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 602 
$node_(46) set Y_ 904 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 623 
$node_(47) set Y_ 807 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 700 
$node_(48) set Y_ 956 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2838 
$node_(49) set Y_ 316 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1283 
$node_(50) set Y_ 338 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2584 
$node_(51) set Y_ 846 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2898 
$node_(52) set Y_ 97 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1351 
$node_(53) set Y_ 492 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 625 
$node_(54) set Y_ 941 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2573 
$node_(55) set Y_ 29 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 1870 
$node_(56) set Y_ 483 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 70 
$node_(57) set Y_ 353 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 1892 
$node_(58) set Y_ 768 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 1632 
$node_(59) set Y_ 406 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 1591 
$node_(60) set Y_ 237 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2980 
$node_(61) set Y_ 953 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1530 
$node_(62) set Y_ 429 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 711 
$node_(63) set Y_ 789 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2148 
$node_(64) set Y_ 265 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2109 
$node_(65) set Y_ 90 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1486 
$node_(66) set Y_ 724 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 2008 
$node_(67) set Y_ 673 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 683 
$node_(68) set Y_ 84 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1089 
$node_(69) set Y_ 839 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 1790 
$node_(70) set Y_ 673 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 259 
$node_(71) set Y_ 356 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 2339 
$node_(72) set Y_ 233 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 1884 
$node_(73) set Y_ 877 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 2315 
$node_(74) set Y_ 627 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2842 
$node_(75) set Y_ 743 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 13 
$node_(76) set Y_ 555 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1434 
$node_(77) set Y_ 708 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 1415 
$node_(78) set Y_ 375 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1326 
$node_(79) set Y_ 581 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2480 
$node_(80) set Y_ 923 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 698 
$node_(81) set Y_ 157 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 860 
$node_(82) set Y_ 422 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 831 
$node_(83) set Y_ 115 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 2194 
$node_(84) set Y_ 190 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2355 
$node_(85) set Y_ 733 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 266 
$node_(86) set Y_ 883 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 1313 
$node_(87) set Y_ 382 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2822 
$node_(88) set Y_ 428 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 1155 
$node_(89) set Y_ 746 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 942 
$node_(90) set Y_ 639 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2661 
$node_(91) set Y_ 665 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2326 
$node_(92) set Y_ 746 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 1655 
$node_(93) set Y_ 267 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 842 
$node_(94) set Y_ 708 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1212 
$node_(95) set Y_ 815 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 2146 
$node_(96) set Y_ 249 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2863 
$node_(97) set Y_ 313 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 2057 
$node_(98) set Y_ 989 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 69 
$node_(99) set Y_ 444 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2797 930 7.0" 
$ns at 75.49485258753037 "$node_(0) setdest 2026 813 15.0" 
$ns at 139.82571650287133 "$node_(0) setdest 930 544 16.0" 
$ns at 290.789983643427 "$node_(0) setdest 410 972 14.0" 
$ns at 523.5269550685695 "$node_(0) setdest 679 780 2.0" 
$ns at 768.7845267875515 "$node_(0) setdest 294 164 6.0" 
$ns at 0.0 "$node_(1) setdest 1842 261 14.0" 
$ns at 107.36301732326989 "$node_(1) setdest 1175 5 19.0" 
$ns at 207.93455171488768 "$node_(1) setdest 207 189 13.0" 
$ns at 374.58678516127566 "$node_(1) setdest 2894 63 20.0" 
$ns at 562.653591554388 "$node_(1) setdest 85 678 14.0" 
$ns at 841.2507981107888 "$node_(1) setdest 1468 569 5.0" 
$ns at 0.0 "$node_(2) setdest 853 74 8.0" 
$ns at 87.61375876765072 "$node_(2) setdest 488 739 10.0" 
$ns at 189.1855236929481 "$node_(2) setdest 1073 826 8.0" 
$ns at 325.64063707179184 "$node_(2) setdest 2531 881 6.0" 
$ns at 478.91556222361436 "$node_(2) setdest 1488 688 16.0" 
$ns at 840.5250988265841 "$node_(2) setdest 2758 714 5.0" 
$ns at 0.0 "$node_(3) setdest 955 319 10.0" 
$ns at 25.661470641017388 "$node_(3) setdest 1636 577 1.0" 
$ns at 56.42264017558796 "$node_(3) setdest 1133 579 20.0" 
$ns at 173.50849627394058 "$node_(3) setdest 475 440 15.0" 
$ns at 305.8310664835497 "$node_(3) setdest 469 65 14.0" 
$ns at 577.6117133429572 "$node_(3) setdest 1197 921 5.0" 
$ns at 0.0 "$node_(4) setdest 802 694 19.0" 
$ns at 77.545143416524 "$node_(4) setdest 2539 700 15.0" 
$ns at 248.66072282306544 "$node_(4) setdest 2643 383 11.0" 
$ns at 400.8506526587716 "$node_(4) setdest 606 34 15.0" 
$ns at 663.0848916133668 "$node_(4) setdest 1933 124 2.0" 
$ns at 0.0 "$node_(5) setdest 2476 283 1.0" 
$ns at 19.394670037805106 "$node_(5) setdest 1838 7 8.0" 
$ns at 99.1461830524708 "$node_(5) setdest 2275 633 19.0" 
$ns at 327.87010969499124 "$node_(5) setdest 2908 994 5.0" 
$ns at 489.4029457712992 "$node_(5) setdest 1909 428 7.0" 
$ns at 771.5174352636398 "$node_(5) setdest 1621 488 19.0" 
$ns at 0.0 "$node_(6) setdest 398 804 13.0" 
$ns at 85.85079984750675 "$node_(6) setdest 1167 4 3.0" 
$ns at 129.37244175484798 "$node_(6) setdest 2481 535 5.0" 
$ns at 204.78863297844467 "$node_(6) setdest 2988 491 10.0" 
$ns at 376.5354992886549 "$node_(6) setdest 1930 282 17.0" 
$ns at 652.2218848213884 "$node_(6) setdest 2410 104 1.0" 
$ns at 0.0 "$node_(7) setdest 759 652 12.0" 
$ns at 107.55411266799253 "$node_(7) setdest 418 483 13.0" 
$ns at 259.55957856704975 "$node_(7) setdest 269 760 11.0" 
$ns at 325.36101998496736 "$node_(7) setdest 2381 825 9.0" 
$ns at 527.5219872026078 "$node_(7) setdest 2588 218 18.0" 
$ns at 873.3725391314064 "$node_(7) setdest 2278 320 20.0" 
$ns at 0.0 "$node_(8) setdest 2171 709 20.0" 
$ns at 196.25777173592206 "$node_(8) setdest 2757 740 6.0" 
$ns at 279.67118752178067 "$node_(8) setdest 1418 595 6.0" 
$ns at 392.4167791120259 "$node_(8) setdest 2056 226 6.0" 
$ns at 520.4549097321039 "$node_(8) setdest 1362 222 1.0" 
$ns at 764.2735180547983 "$node_(8) setdest 2616 589 9.0" 
$ns at 0.0 "$node_(9) setdest 96 850 18.0" 
$ns at 16.239417247300974 "$node_(9) setdest 939 666 11.0" 
$ns at 139.99224455843017 "$node_(9) setdest 2380 382 19.0" 
$ns at 355.2010010117947 "$node_(9) setdest 2994 529 2.0" 
$ns at 482.3806268285417 "$node_(9) setdest 2617 322 17.0" 
$ns at 786.4983411296594 "$node_(9) setdest 2235 614 4.0" 
$ns at 0.0 "$node_(10) setdest 118 637 13.0" 
$ns at 87.10227914393155 "$node_(10) setdest 2040 42 16.0" 
$ns at 229.41530571621624 "$node_(10) setdest 1349 446 17.0" 
$ns at 429.17076264516055 "$node_(10) setdest 127 718 16.0" 
$ns at 652.8970864278431 "$node_(10) setdest 593 710 17.0" 
$ns at 0.0 "$node_(11) setdest 255 979 15.0" 
$ns at 115.39516802005852 "$node_(11) setdest 211 358 3.0" 
$ns at 147.36058703384077 "$node_(11) setdest 273 858 13.0" 
$ns at 274.0244224996867 "$node_(11) setdest 425 515 16.0" 
$ns at 448.8808687859138 "$node_(11) setdest 2321 258 18.0" 
$ns at 711.0695683203317 "$node_(11) setdest 328 762 9.0" 
$ns at 0.0 "$node_(12) setdest 1742 593 11.0" 
$ns at 83.34617717352583 "$node_(12) setdest 1529 603 9.0" 
$ns at 138.06756125232448 "$node_(12) setdest 2021 693 18.0" 
$ns at 322.74252546795816 "$node_(12) setdest 642 566 14.0" 
$ns at 536.1618533658793 "$node_(12) setdest 1792 15 1.0" 
$ns at 778.6579730056739 "$node_(12) setdest 2528 617 7.0" 
$ns at 0.0 "$node_(13) setdest 2748 482 19.0" 
$ns at 106.03845466678527 "$node_(13) setdest 2994 795 5.0" 
$ns at 149.40401409747687 "$node_(13) setdest 985 482 8.0" 
$ns at 260.5810236997004 "$node_(13) setdest 1372 278 15.0" 
$ns at 406.7327706760907 "$node_(13) setdest 108 832 17.0" 
$ns at 684.302928331281 "$node_(13) setdest 2164 265 16.0" 
$ns at 0.0 "$node_(14) setdest 1149 763 4.0" 
$ns at 28.18105854561301 "$node_(14) setdest 1682 383 19.0" 
$ns at 91.74390464205341 "$node_(14) setdest 107 225 12.0" 
$ns at 201.34664446341174 "$node_(14) setdest 1382 530 11.0" 
$ns at 415.8383053013098 "$node_(14) setdest 670 59 13.0" 
$ns at 745.4485560561118 "$node_(14) setdest 300 324 18.0" 
$ns at 0.0 "$node_(15) setdest 2428 838 6.0" 
$ns at 68.15348412240796 "$node_(15) setdest 802 601 6.0" 
$ns at 117.37439775186454 "$node_(15) setdest 630 433 13.0" 
$ns at 198.85553089434796 "$node_(15) setdest 2559 625 6.0" 
$ns at 364.01900464899404 "$node_(15) setdest 1305 599 12.0" 
$ns at 644.5035291556975 "$node_(15) setdest 2441 933 13.0" 
$ns at 0.0 "$node_(16) setdest 2286 130 7.0" 
$ns at 66.10047824178938 "$node_(16) setdest 765 5 17.0" 
$ns at 248.4585386869251 "$node_(16) setdest 2477 393 6.0" 
$ns at 328.09387074666915 "$node_(16) setdest 78 174 4.0" 
$ns at 452.5039026008726 "$node_(16) setdest 383 285 11.0" 
$ns at 696.952199603537 "$node_(16) setdest 1399 453 16.0" 
$ns at 0.0 "$node_(17) setdest 743 910 20.0" 
$ns at 59.86806757733288 "$node_(17) setdest 628 202 1.0" 
$ns at 95.9524447158135 "$node_(17) setdest 811 538 13.0" 
$ns at 260.2325561447645 "$node_(17) setdest 526 825 18.0" 
$ns at 467.3721108887267 "$node_(17) setdest 593 637 6.0" 
$ns at 744.1176735196013 "$node_(17) setdest 472 906 18.0" 
$ns at 0.0 "$node_(18) setdest 1103 34 9.0" 
$ns at 90.71243415000683 "$node_(18) setdest 1922 465 11.0" 
$ns at 213.69549398017455 "$node_(18) setdest 442 499 4.0" 
$ns at 299.8162885606558 "$node_(18) setdest 2253 264 11.0" 
$ns at 426.14674500833 "$node_(18) setdest 1268 319 9.0" 
$ns at 700.6178520572939 "$node_(18) setdest 1424 336 3.0" 
$ns at 0.0 "$node_(19) setdest 1948 637 11.0" 
$ns at 114.55750130683079 "$node_(19) setdest 1644 164 8.0" 
$ns at 166.93537242657936 "$node_(19) setdest 1471 634 15.0" 
$ns at 232.58671273780226 "$node_(19) setdest 1978 181 5.0" 
$ns at 395.44975441458024 "$node_(19) setdest 916 835 19.0" 
$ns at 654.7766722178152 "$node_(19) setdest 2569 520 18.0" 
$ns at 0.0 "$node_(20) setdest 43 100 2.0" 
$ns at 34.86385608691903 "$node_(20) setdest 919 195 4.0" 
$ns at 65.40126961220294 "$node_(20) setdest 302 95 1.0" 
$ns at 129.242520443145 "$node_(20) setdest 2401 133 20.0" 
$ns at 392.61400580479517 "$node_(20) setdest 2340 301 19.0" 
$ns at 806.4735415171682 "$node_(20) setdest 1953 725 17.0" 
$ns at 0.0 "$node_(21) setdest 1795 850 10.0" 
$ns at 64.22541802061241 "$node_(21) setdest 2615 843 19.0" 
$ns at 215.076254200117 "$node_(21) setdest 2940 757 15.0" 
$ns at 283.042557181226 "$node_(21) setdest 2364 478 2.0" 
$ns at 405.2877985941424 "$node_(21) setdest 1499 324 20.0" 
$ns at 727.8403932932376 "$node_(21) setdest 1413 436 17.0" 
$ns at 0.0 "$node_(22) setdest 2673 795 10.0" 
$ns at 20.547720116826802 "$node_(22) setdest 1926 763 19.0" 
$ns at 206.37122644599333 "$node_(22) setdest 199 537 3.0" 
$ns at 295.8875621916401 "$node_(22) setdest 2810 827 8.0" 
$ns at 435.0928153619774 "$node_(22) setdest 1999 316 9.0" 
$ns at 764.1403555902009 "$node_(22) setdest 2039 236 15.0" 
$ns at 0.0 "$node_(23) setdest 2718 456 6.0" 
$ns at 72.4390015785404 "$node_(23) setdest 1684 10 9.0" 
$ns at 131.52267677396014 "$node_(23) setdest 2224 948 16.0" 
$ns at 202.60717443304517 "$node_(23) setdest 2574 684 17.0" 
$ns at 485.80079264000835 "$node_(23) setdest 1865 786 4.0" 
$ns at 726.4904006405088 "$node_(23) setdest 295 280 3.0" 
$ns at 0.0 "$node_(24) setdest 1052 106 17.0" 
$ns at 115.54908485253054 "$node_(24) setdest 932 306 6.0" 
$ns at 176.6196892911649 "$node_(24) setdest 2471 910 17.0" 
$ns at 280.1796012267898 "$node_(24) setdest 765 222 10.0" 
$ns at 447.4149889356526 "$node_(24) setdest 1981 437 5.0" 
$ns at 716.2368410377021 "$node_(24) setdest 826 37 9.0" 
$ns at 0.0 "$node_(25) setdest 17 474 18.0" 
$ns at 124.49871079893668 "$node_(25) setdest 2025 974 10.0" 
$ns at 236.65066739657274 "$node_(25) setdest 38 164 3.0" 
$ns at 315.1827293668342 "$node_(25) setdest 2266 371 19.0" 
$ns at 597.1034645715116 "$node_(25) setdest 2351 109 5.0" 
$ns at 874.0547105917775 "$node_(25) setdest 2727 249 16.0" 
$ns at 0.0 "$node_(26) setdest 2350 821 19.0" 
$ns at 98.22874556808699 "$node_(26) setdest 1269 217 19.0" 
$ns at 250.94619716988615 "$node_(26) setdest 2993 810 12.0" 
$ns at 418.0344984112113 "$node_(26) setdest 2616 642 2.0" 
$ns at 554.2407672371124 "$node_(26) setdest 1063 887 20.0" 
$ns at 0.0 "$node_(27) setdest 779 268 18.0" 
$ns at 44.198609562797756 "$node_(27) setdest 534 446 14.0" 
$ns at 101.52650289824966 "$node_(27) setdest 876 692 18.0" 
$ns at 294.40013409425825 "$node_(27) setdest 2091 812 7.0" 
$ns at 431.0426588670941 "$node_(27) setdest 1303 394 5.0" 
$ns at 686.1870085548844 "$node_(27) setdest 2619 925 11.0" 
$ns at 0.0 "$node_(28) setdest 1931 224 14.0" 
$ns at 53.44478742201817 "$node_(28) setdest 212 936 20.0" 
$ns at 125.68878066480914 "$node_(28) setdest 2760 549 15.0" 
$ns at 190.93004660535837 "$node_(28) setdest 1025 498 1.0" 
$ns at 312.86224261332336 "$node_(28) setdest 220 454 5.0" 
$ns at 595.9048755097863 "$node_(28) setdest 1004 808 1.0" 
$ns at 0.0 "$node_(29) setdest 1048 703 18.0" 
$ns at 189.12482700309246 "$node_(29) setdest 329 709 9.0" 
$ns at 281.2854788069613 "$node_(29) setdest 2428 365 11.0" 
$ns at 385.1969578408482 "$node_(29) setdest 1111 390 4.0" 
$ns at 509.16029380306884 "$node_(29) setdest 1824 290 16.0" 
$ns at 870.7061834876299 "$node_(29) setdest 2659 491 6.0" 
$ns at 0.0 "$node_(30) setdest 1689 858 8.0" 
$ns at 16.200056895031423 "$node_(30) setdest 367 668 6.0" 
$ns at 60.44792377747977 "$node_(30) setdest 1996 677 4.0" 
$ns at 154.949357415733 "$node_(30) setdest 1044 905 12.0" 
$ns at 331.0276518144664 "$node_(30) setdest 1251 161 10.0" 
$ns at 611.1159502997702 "$node_(30) setdest 2237 146 2.0" 
$ns at 0.0 "$node_(31) setdest 441 152 19.0" 
$ns at 32.1955793418979 "$node_(31) setdest 848 21 8.0" 
$ns at 81.96088713011326 "$node_(31) setdest 2102 22 17.0" 
$ns at 183.2505989977353 "$node_(31) setdest 1122 743 6.0" 
$ns at 306.2829303552863 "$node_(31) setdest 420 931 12.0" 
$ns at 609.4760856072951 "$node_(31) setdest 1795 450 4.0" 
$ns at 0.0 "$node_(32) setdest 1071 158 3.0" 
$ns at 21.859987298770708 "$node_(32) setdest 2981 577 11.0" 
$ns at 97.05692512254471 "$node_(32) setdest 2223 687 12.0" 
$ns at 188.15516324371504 "$node_(32) setdest 2084 15 19.0" 
$ns at 423.11902082654314 "$node_(32) setdest 883 481 8.0" 
$ns at 674.1419475922958 "$node_(32) setdest 2812 152 18.0" 
$ns at 0.0 "$node_(33) setdest 2524 96 8.0" 
$ns at 51.034629150277446 "$node_(33) setdest 2094 65 15.0" 
$ns at 205.3559079939546 "$node_(33) setdest 684 595 6.0" 
$ns at 296.19198550096957 "$node_(33) setdest 1459 431 3.0" 
$ns at 434.02098203037195 "$node_(33) setdest 1948 902 2.0" 
$ns at 678.7719552606786 "$node_(33) setdest 181 946 9.0" 
$ns at 0.0 "$node_(34) setdest 1531 55 15.0" 
$ns at 77.88785694768306 "$node_(34) setdest 266 312 14.0" 
$ns at 174.54535020994294 "$node_(34) setdest 1356 5 8.0" 
$ns at 311.76199304052193 "$node_(34) setdest 61 95 2.0" 
$ns at 438.32833102404516 "$node_(34) setdest 1347 906 12.0" 
$ns at 770.8081470317459 "$node_(34) setdest 2072 989 1.0" 
$ns at 0.0 "$node_(35) setdest 343 65 19.0" 
$ns at 62.61054494957668 "$node_(35) setdest 1283 303 13.0" 
$ns at 95.31032305799548 "$node_(35) setdest 1837 978 6.0" 
$ns at 200.8051418351709 "$node_(35) setdest 2038 717 4.0" 
$ns at 332.24691170714533 "$node_(35) setdest 2455 127 9.0" 
$ns at 606.4634712516116 "$node_(35) setdest 1297 601 4.0" 
$ns at 0.0 "$node_(36) setdest 1876 465 12.0" 
$ns at 116.47409934394612 "$node_(36) setdest 2823 463 11.0" 
$ns at 172.55648580332428 "$node_(36) setdest 1614 766 17.0" 
$ns at 324.1498086664201 "$node_(36) setdest 1606 306 7.0" 
$ns at 487.25983750816556 "$node_(36) setdest 2853 263 5.0" 
$ns at 769.8783257906589 "$node_(36) setdest 1591 962 7.0" 
$ns at 0.0 "$node_(37) setdest 2263 251 6.0" 
$ns at 37.2210829994783 "$node_(37) setdest 1509 701 10.0" 
$ns at 118.4556487428699 "$node_(37) setdest 487 583 17.0" 
$ns at 283.6056760500031 "$node_(37) setdest 1370 654 4.0" 
$ns at 406.0393426584453 "$node_(37) setdest 2726 228 11.0" 
$ns at 686.8524483234648 "$node_(37) setdest 1938 868 3.0" 
$ns at 0.0 "$node_(38) setdest 607 329 17.0" 
$ns at 142.67779122700532 "$node_(38) setdest 235 28 1.0" 
$ns at 174.59293906509782 "$node_(38) setdest 276 422 14.0" 
$ns at 320.57223590783815 "$node_(38) setdest 2881 159 13.0" 
$ns at 545.191022296092 "$node_(38) setdest 389 753 7.0" 
$ns at 851.8528954253095 "$node_(38) setdest 1844 852 9.0" 
$ns at 0.0 "$node_(39) setdest 1432 863 2.0" 
$ns at 21.14441315247328 "$node_(39) setdest 1893 815 13.0" 
$ns at 149.60151061077246 "$node_(39) setdest 2572 870 1.0" 
$ns at 213.9087234134951 "$node_(39) setdest 811 804 7.0" 
$ns at 402.84698014269463 "$node_(39) setdest 2951 124 19.0" 
$ns at 772.2566142906448 "$node_(39) setdest 1202 229 18.0" 
$ns at 0.0 "$node_(40) setdest 1124 152 6.0" 
$ns at 68.59476788342255 "$node_(40) setdest 1411 991 17.0" 
$ns at 114.06948790160806 "$node_(40) setdest 2056 85 9.0" 
$ns at 238.0593486637696 "$node_(40) setdest 903 350 1.0" 
$ns at 366.73351384374735 "$node_(40) setdest 2885 981 5.0" 
$ns at 637.7364413983764 "$node_(40) setdest 2134 869 14.0" 
$ns at 0.0 "$node_(41) setdest 1362 715 5.0" 
$ns at 23.481780045750387 "$node_(41) setdest 738 742 11.0" 
$ns at 87.55059109390122 "$node_(41) setdest 2665 382 18.0" 
$ns at 169.3619761964066 "$node_(41) setdest 1577 53 3.0" 
$ns at 317.34256001581355 "$node_(41) setdest 1023 369 2.0" 
$ns at 567.5910370877534 "$node_(41) setdest 2972 770 9.0" 
$ns at 0.0 "$node_(42) setdest 315 523 6.0" 
$ns at 67.50790406741697 "$node_(42) setdest 171 520 5.0" 
$ns at 143.87924997693372 "$node_(42) setdest 601 112 18.0" 
$ns at 220.91539627113968 "$node_(42) setdest 2855 450 20.0" 
$ns at 413.794982669179 "$node_(42) setdest 1256 474 15.0" 
$ns at 751.2500327020812 "$node_(42) setdest 2256 717 6.0" 
$ns at 0.0 "$node_(43) setdest 136 557 4.0" 
$ns at 23.827190244336958 "$node_(43) setdest 1175 428 3.0" 
$ns at 63.87212396592854 "$node_(43) setdest 1978 754 3.0" 
$ns at 151.01078059679696 "$node_(43) setdest 1984 49 13.0" 
$ns at 360.8205736337218 "$node_(43) setdest 1941 726 4.0" 
$ns at 621.8310242503437 "$node_(43) setdest 1397 615 6.0" 
$ns at 0.0 "$node_(44) setdest 1002 129 4.0" 
$ns at 46.055274185739805 "$node_(44) setdest 2578 271 19.0" 
$ns at 236.4915745694006 "$node_(44) setdest 2609 424 12.0" 
$ns at 318.9033732123673 "$node_(44) setdest 1902 955 11.0" 
$ns at 501.942629407444 "$node_(44) setdest 806 194 18.0" 
$ns at 768.0448577079824 "$node_(44) setdest 1414 272 20.0" 
$ns at 0.0 "$node_(45) setdest 734 645 19.0" 
$ns at 104.7799661751289 "$node_(45) setdest 2804 851 2.0" 
$ns at 150.7175350347715 "$node_(45) setdest 2217 217 18.0" 
$ns at 261.6443281651523 "$node_(45) setdest 2454 755 17.0" 
$ns at 549.3564763891294 "$node_(45) setdest 847 482 15.0" 
$ns at 806.784923067409 "$node_(45) setdest 1864 722 12.0" 
$ns at 0.0 "$node_(46) setdest 1767 751 2.0" 
$ns at 26.715682686086005 "$node_(46) setdest 516 307 2.0" 
$ns at 66.21910065081832 "$node_(46) setdest 69 70 17.0" 
$ns at 130.82463759711897 "$node_(46) setdest 1991 214 8.0" 
$ns at 274.19084190208866 "$node_(46) setdest 2514 525 1.0" 
$ns at 523.0447179561394 "$node_(46) setdest 1883 371 14.0" 
$ns at 0.0 "$node_(47) setdest 976 41 1.0" 
$ns at 23.31670403651787 "$node_(47) setdest 1836 554 11.0" 
$ns at 143.71320309100614 "$node_(47) setdest 829 91 9.0" 
$ns at 279.728187761699 "$node_(47) setdest 1750 604 1.0" 
$ns at 409.15428645815507 "$node_(47) setdest 1180 999 17.0" 
$ns at 776.1294413239925 "$node_(47) setdest 970 543 2.0" 
$ns at 0.0 "$node_(48) setdest 1648 754 3.0" 
$ns at 43.030750106904996 "$node_(48) setdest 1016 135 9.0" 
$ns at 91.56004844887028 "$node_(48) setdest 123 520 20.0" 
$ns at 208.7252142241148 "$node_(48) setdest 160 700 16.0" 
$ns at 460.14872133612914 "$node_(48) setdest 683 261 9.0" 
$ns at 744.4786607383185 "$node_(48) setdest 912 220 14.0" 
$ns at 0.0 "$node_(49) setdest 594 162 14.0" 
$ns at 56.292339800366605 "$node_(49) setdest 1225 50 8.0" 
$ns at 145.1744562739267 "$node_(49) setdest 1108 766 1.0" 
$ns at 208.82613827337775 "$node_(49) setdest 968 780 10.0" 
$ns at 374.63220849799694 "$node_(49) setdest 448 6 12.0" 
$ns at 713.4968065489554 "$node_(49) setdest 1991 48 2.0" 
$ns at 0.0 "$node_(50) setdest 203 561 13.0" 
$ns at 96.8039954280557 "$node_(50) setdest 1825 350 16.0" 
$ns at 265.16941956120866 "$node_(50) setdest 47 205 17.0" 
$ns at 380.7320958149089 "$node_(50) setdest 2833 162 13.0" 
$ns at 581.1309728245764 "$node_(50) setdest 1462 79 1.0" 
$ns at 830.1117504138956 "$node_(50) setdest 2379 908 6.0" 
$ns at 0.0 "$node_(51) setdest 2919 62 13.0" 
$ns at 105.5210967548375 "$node_(51) setdest 2301 588 17.0" 
$ns at 183.3222208540074 "$node_(51) setdest 2672 665 14.0" 
$ns at 342.4639535072232 "$node_(51) setdest 1774 107 4.0" 
$ns at 463.0421420473991 "$node_(51) setdest 2127 124 14.0" 
$ns at 791.0510297528429 "$node_(51) setdest 1345 614 6.0" 
$ns at 0.0 "$node_(52) setdest 448 618 2.0" 
$ns at 24.769482329376366 "$node_(52) setdest 1725 396 5.0" 
$ns at 71.62929969416638 "$node_(52) setdest 1850 790 12.0" 
$ns at 230.22794495092302 "$node_(52) setdest 2622 131 19.0" 
$ns at 374.89078954268183 "$node_(52) setdest 744 997 5.0" 
$ns at 645.4725205211749 "$node_(52) setdest 1690 544 8.0" 
$ns at 0.0 "$node_(53) setdest 689 951 16.0" 
$ns at 95.71327162911238 "$node_(53) setdest 400 784 7.0" 
$ns at 161.01452643537834 "$node_(53) setdest 817 707 2.0" 
$ns at 221.5558491119158 "$node_(53) setdest 378 47 14.0" 
$ns at 398.6823826969588 "$node_(53) setdest 1176 137 11.0" 
$ns at 726.5799283278282 "$node_(53) setdest 1546 272 10.0" 
$ns at 0.0 "$node_(54) setdest 1165 346 9.0" 
$ns at 102.86409293350279 "$node_(54) setdest 2093 939 2.0" 
$ns at 144.98892486190078 "$node_(54) setdest 2007 689 11.0" 
$ns at 250.55256433148546 "$node_(54) setdest 1108 288 14.0" 
$ns at 412.37010882188156 "$node_(54) setdest 926 322 3.0" 
$ns at 661.0725024979558 "$node_(54) setdest 2424 493 10.0" 
$ns at 0.0 "$node_(55) setdest 1484 454 9.0" 
$ns at 30.400210635883205 "$node_(55) setdest 981 608 3.0" 
$ns at 85.12111679485977 "$node_(55) setdest 2240 744 5.0" 
$ns at 183.52047952399977 "$node_(55) setdest 2771 319 5.0" 
$ns at 348.90620237007374 "$node_(55) setdest 1677 494 2.0" 
$ns at 606.1319707997826 "$node_(55) setdest 1170 821 20.0" 
$ns at 0.0 "$node_(56) setdest 1080 582 7.0" 
$ns at 24.761747779587964 "$node_(56) setdest 1214 352 8.0" 
$ns at 112.31145224622617 "$node_(56) setdest 2795 312 13.0" 
$ns at 294.0462344582138 "$node_(56) setdest 1139 204 8.0" 
$ns at 433.9166623160817 "$node_(56) setdest 2048 588 14.0" 
$ns at 688.9367291768363 "$node_(56) setdest 220 241 7.0" 
$ns at 0.0 "$node_(57) setdest 1276 110 10.0" 
$ns at 68.02325579094995 "$node_(57) setdest 750 245 15.0" 
$ns at 213.90010423794055 "$node_(57) setdest 1628 501 14.0" 
$ns at 410.12480374126005 "$node_(57) setdest 2687 627 18.0" 
$ns at 591.0851894528662 "$node_(57) setdest 2091 553 15.0" 
$ns at 877.9441297359118 "$node_(57) setdest 2294 307 7.0" 
$ns at 0.0 "$node_(58) setdest 1415 8 6.0" 
$ns at 35.6647673912241 "$node_(58) setdest 833 819 17.0" 
$ns at 96.37850460320435 "$node_(58) setdest 1764 559 1.0" 
$ns at 163.1231857528183 "$node_(58) setdest 106 935 10.0" 
$ns at 347.24432582651025 "$node_(58) setdest 1800 983 6.0" 
$ns at 612.7304704234301 "$node_(58) setdest 1422 362 11.0" 
$ns at 0.0 "$node_(59) setdest 601 606 9.0" 
$ns at 82.31036586768117 "$node_(59) setdest 1278 313 7.0" 
$ns at 176.2274518146519 "$node_(59) setdest 1626 492 1.0" 
$ns at 240.07311267406146 "$node_(59) setdest 1830 2 18.0" 
$ns at 466.6230758917507 "$node_(59) setdest 643 66 17.0" 
$ns at 834.7993146466408 "$node_(59) setdest 955 362 9.0" 
$ns at 0.0 "$node_(60) setdest 2305 69 15.0" 
$ns at 62.236156055553295 "$node_(60) setdest 2454 543 1.0" 
$ns at 94.92550552528074 "$node_(60) setdest 2825 44 15.0" 
$ns at 182.81741203764454 "$node_(60) setdest 727 983 12.0" 
$ns at 328.44140952182914 "$node_(60) setdest 2900 758 8.0" 
$ns at 589.488696502365 "$node_(60) setdest 2953 103 4.0" 
$ns at 0.0 "$node_(61) setdest 1857 252 18.0" 
$ns at 73.14037203020811 "$node_(61) setdest 2604 942 5.0" 
$ns at 124.83162280204714 "$node_(61) setdest 2673 432 20.0" 
$ns at 354.8697701178684 "$node_(61) setdest 1838 256 2.0" 
$ns at 476.06319545107283 "$node_(61) setdest 1317 392 16.0" 
$ns at 808.2922842358536 "$node_(61) setdest 1087 907 4.0" 
$ns at 0.0 "$node_(62) setdest 599 874 13.0" 
$ns at 141.1876394267183 "$node_(62) setdest 895 578 9.0" 
$ns at 241.52729641441178 "$node_(62) setdest 2454 564 20.0" 
$ns at 335.0739977552691 "$node_(62) setdest 1822 120 19.0" 
$ns at 642.4785196269763 "$node_(62) setdest 2343 130 1.0" 
$ns at 883.2190039249558 "$node_(62) setdest 954 82 19.0" 
$ns at 0.0 "$node_(63) setdest 1216 191 4.0" 
$ns at 40.55120655169834 "$node_(63) setdest 2354 222 20.0" 
$ns at 253.88027627819923 "$node_(63) setdest 203 633 8.0" 
$ns at 356.1633426218585 "$node_(63) setdest 2491 51 14.0" 
$ns at 545.6215248890801 "$node_(63) setdest 984 962 4.0" 
$ns at 813.3820477444872 "$node_(63) setdest 2462 716 5.0" 
$ns at 0.0 "$node_(64) setdest 2513 597 7.0" 
$ns at 54.67567854703106 "$node_(64) setdest 574 761 16.0" 
$ns at 197.3367988851879 "$node_(64) setdest 526 303 7.0" 
$ns at 318.56346645949645 "$node_(64) setdest 583 579 6.0" 
$ns at 477.6665401103009 "$node_(64) setdest 23 175 12.0" 
$ns at 755.3031711770866 "$node_(64) setdest 2651 599 1.0" 
$ns at 0.0 "$node_(65) setdest 661 852 9.0" 
$ns at 65.85223352652139 "$node_(65) setdest 1836 514 6.0" 
$ns at 142.80194998769485 "$node_(65) setdest 2728 893 3.0" 
$ns at 214.6767257147838 "$node_(65) setdest 1671 85 18.0" 
$ns at 479.50189357338206 "$node_(65) setdest 1145 473 12.0" 
$ns at 819.1868386562339 "$node_(65) setdest 127 353 6.0" 
$ns at 0.0 "$node_(66) setdest 1674 853 4.0" 
$ns at 40.35428868043908 "$node_(66) setdest 2050 273 13.0" 
$ns at 110.12733714487109 "$node_(66) setdest 1263 271 12.0" 
$ns at 240.8063193922116 "$node_(66) setdest 1843 100 3.0" 
$ns at 379.8585832413531 "$node_(66) setdest 1223 201 4.0" 
$ns at 632.4909401859611 "$node_(66) setdest 980 59 8.0" 
$ns at 0.0 "$node_(67) setdest 2646 140 13.0" 
$ns at 94.45034468183464 "$node_(67) setdest 2645 116 7.0" 
$ns at 188.29722311437263 "$node_(67) setdest 286 366 18.0" 
$ns at 347.87305040433563 "$node_(67) setdest 1565 880 18.0" 
$ns at 512.8548359695247 "$node_(67) setdest 792 322 4.0" 
$ns at 787.1296278718037 "$node_(67) setdest 2837 957 20.0" 
$ns at 0.0 "$node_(68) setdest 2017 572 14.0" 
$ns at 45.64376407809301 "$node_(68) setdest 2313 301 18.0" 
$ns at 104.64789608966677 "$node_(68) setdest 2809 491 8.0" 
$ns at 215.89564885614075 "$node_(68) setdest 2843 348 11.0" 
$ns at 372.5416590857295 "$node_(68) setdest 2477 119 11.0" 
$ns at 718.9102114922298 "$node_(68) setdest 455 10 1.0" 
$ns at 0.0 "$node_(69) setdest 873 856 7.0" 
$ns at 24.103187317853674 "$node_(69) setdest 1254 806 9.0" 
$ns at 138.93436926405644 "$node_(69) setdest 1757 926 10.0" 
$ns at 282.4199774084205 "$node_(69) setdest 1615 694 15.0" 
$ns at 491.9602612247516 "$node_(69) setdest 1896 778 1.0" 
$ns at 738.7266646854961 "$node_(69) setdest 2981 405 17.0" 
$ns at 0.0 "$node_(70) setdest 70 855 16.0" 
$ns at 163.32905132492886 "$node_(70) setdest 1307 318 13.0" 
$ns at 270.7690643562153 "$node_(70) setdest 915 413 16.0" 
$ns at 407.25372782448426 "$node_(70) setdest 2986 191 1.0" 
$ns at 527.5314825588754 "$node_(70) setdest 1307 296 10.0" 
$ns at 835.6705760207096 "$node_(70) setdest 2783 293 10.0" 
$ns at 0.0 "$node_(71) setdest 1689 871 4.0" 
$ns at 17.90480783843318 "$node_(71) setdest 1114 733 20.0" 
$ns at 195.86344724903296 "$node_(71) setdest 1558 522 11.0" 
$ns at 279.72824706588864 "$node_(71) setdest 715 45 18.0" 
$ns at 521.1798397845794 "$node_(71) setdest 2017 397 5.0" 
$ns at 769.487383424886 "$node_(71) setdest 1505 326 17.0" 
$ns at 0.0 "$node_(72) setdest 95 323 9.0" 
$ns at 38.7789501945528 "$node_(72) setdest 1219 474 2.0" 
$ns at 69.98395854319638 "$node_(72) setdest 2264 71 6.0" 
$ns at 147.401204956678 "$node_(72) setdest 1099 336 2.0" 
$ns at 286.91111531760794 "$node_(72) setdest 1325 396 16.0" 
$ns at 555.2508976508639 "$node_(72) setdest 1719 806 12.0" 
$ns at 0.0 "$node_(73) setdest 2615 522 7.0" 
$ns at 70.5279339033734 "$node_(73) setdest 1736 185 18.0" 
$ns at 198.91481920445997 "$node_(73) setdest 203 11 15.0" 
$ns at 338.0080904590245 "$node_(73) setdest 1148 343 5.0" 
$ns at 501.33106519626955 "$node_(73) setdest 2524 171 14.0" 
$ns at 834.0818806738919 "$node_(73) setdest 2338 491 5.0" 
$ns at 0.0 "$node_(74) setdest 613 451 13.0" 
$ns at 116.41518565416584 "$node_(74) setdest 2993 609 12.0" 
$ns at 257.8497863885053 "$node_(74) setdest 897 485 20.0" 
$ns at 453.7299911272298 "$node_(74) setdest 2683 839 1.0" 
$ns at 575.4586852452469 "$node_(74) setdest 2211 714 15.0" 
$ns at 898.4154309856887 "$node_(74) setdest 676 383 2.0" 
$ns at 0.0 "$node_(75) setdest 1478 760 7.0" 
$ns at 43.41630826622993 "$node_(75) setdest 2277 712 7.0" 
$ns at 94.88333367145398 "$node_(75) setdest 2237 987 17.0" 
$ns at 317.3649437652423 "$node_(75) setdest 779 138 15.0" 
$ns at 441.14047011189933 "$node_(75) setdest 953 910 20.0" 
$ns at 781.8498765714323 "$node_(75) setdest 1801 50 18.0" 
$ns at 0.0 "$node_(76) setdest 1788 391 2.0" 
$ns at 25.250849328036463 "$node_(76) setdest 1604 362 16.0" 
$ns at 90.7930935599538 "$node_(76) setdest 272 789 3.0" 
$ns at 177.3067063990482 "$node_(76) setdest 2661 969 9.0" 
$ns at 324.09302846041925 "$node_(76) setdest 57 496 18.0" 
$ns at 594.0499760068468 "$node_(76) setdest 576 282 13.0" 
$ns at 0.0 "$node_(77) setdest 1681 526 1.0" 
$ns at 16.912570693552077 "$node_(77) setdest 121 112 6.0" 
$ns at 86.77255704312788 "$node_(77) setdest 2038 100 11.0" 
$ns at 241.99744829952593 "$node_(77) setdest 1986 482 1.0" 
$ns at 365.150563291532 "$node_(77) setdest 1971 377 11.0" 
$ns at 618.1744984220763 "$node_(77) setdest 1527 153 1.0" 
$ns at 0.0 "$node_(78) setdest 2193 786 9.0" 
$ns at 35.88841782613716 "$node_(78) setdest 2574 912 1.0" 
$ns at 73.48612462335029 "$node_(78) setdest 1443 605 15.0" 
$ns at 141.34467805591066 "$node_(78) setdest 2123 940 7.0" 
$ns at 284.1346626353049 "$node_(78) setdest 2589 743 17.0" 
$ns at 662.0714197153466 "$node_(78) setdest 1447 789 17.0" 
$ns at 0.0 "$node_(79) setdest 86 871 4.0" 
$ns at 37.16209648230938 "$node_(79) setdest 955 788 12.0" 
$ns at 83.96149951683026 "$node_(79) setdest 994 355 18.0" 
$ns at 216.98201615567092 "$node_(79) setdest 2844 907 3.0" 
$ns at 351.3830391533538 "$node_(79) setdest 470 647 2.0" 
$ns at 594.7589963367888 "$node_(79) setdest 1362 411 2.0" 
$ns at 0.0 "$node_(80) setdest 1440 67 18.0" 
$ns at 192.8109594947242 "$node_(80) setdest 1236 820 18.0" 
$ns at 264.93409436524223 "$node_(80) setdest 856 154 1.0" 
$ns at 325.63013096772903 "$node_(80) setdest 567 2 16.0" 
$ns at 497.3555800133023 "$node_(80) setdest 754 11 2.0" 
$ns at 751.3181488852558 "$node_(80) setdest 1269 438 9.0" 
$ns at 0.0 "$node_(81) setdest 1017 311 18.0" 
$ns at 20.763163009331237 "$node_(81) setdest 2842 957 11.0" 
$ns at 158.72528936090504 "$node_(81) setdest 548 909 3.0" 
$ns at 231.40337338005148 "$node_(81) setdest 2044 507 11.0" 
$ns at 355.1736818128874 "$node_(81) setdest 1278 210 7.0" 
$ns at 612.0573619411425 "$node_(81) setdest 777 742 9.0" 
$ns at 0.0 "$node_(82) setdest 1182 743 6.0" 
$ns at 42.222850744659574 "$node_(82) setdest 1237 490 15.0" 
$ns at 179.11149186792278 "$node_(82) setdest 2267 605 20.0" 
$ns at 325.305461588439 "$node_(82) setdest 1135 405 17.0" 
$ns at 601.1257575330611 "$node_(82) setdest 179 694 11.0" 
$ns at 0.0 "$node_(83) setdest 2563 335 15.0" 
$ns at 72.66942748690778 "$node_(83) setdest 887 927 12.0" 
$ns at 205.2634259115841 "$node_(83) setdest 790 235 18.0" 
$ns at 299.6531841833101 "$node_(83) setdest 2620 848 19.0" 
$ns at 452.9292324151336 "$node_(83) setdest 1073 646 4.0" 
$ns at 728.2742812741252 "$node_(83) setdest 1991 313 1.0" 
$ns at 0.0 "$node_(84) setdest 1264 64 2.0" 
$ns at 15.714075503055955 "$node_(84) setdest 2992 179 2.0" 
$ns at 57.228283571252305 "$node_(84) setdest 1797 741 11.0" 
$ns at 124.47439164587652 "$node_(84) setdest 2288 160 17.0" 
$ns at 358.31743051892977 "$node_(84) setdest 348 711 16.0" 
$ns at 747.8883982186732 "$node_(84) setdest 8 295 12.0" 
$ns at 0.0 "$node_(85) setdest 1226 110 20.0" 
$ns at 131.77331802519876 "$node_(85) setdest 1948 689 1.0" 
$ns at 167.32168995303334 "$node_(85) setdest 1317 73 14.0" 
$ns at 259.2891713104067 "$node_(85) setdest 887 456 9.0" 
$ns at 410.61786703474377 "$node_(85) setdest 2127 766 12.0" 
$ns at 754.8950738747781 "$node_(85) setdest 434 42 1.0" 
$ns at 0.0 "$node_(86) setdest 2232 362 19.0" 
$ns at 135.59766738581055 "$node_(86) setdest 1603 357 8.0" 
$ns at 167.18479551257374 "$node_(86) setdest 208 990 18.0" 
$ns at 374.81357074947374 "$node_(86) setdest 2042 384 2.0" 
$ns at 511.488821888752 "$node_(86) setdest 2831 984 18.0" 
$ns at 883.0401924581051 "$node_(86) setdest 1597 192 19.0" 
$ns at 0.0 "$node_(87) setdest 1117 966 3.0" 
$ns at 35.995806387461975 "$node_(87) setdest 2657 539 1.0" 
$ns at 67.26295558378476 "$node_(87) setdest 512 563 12.0" 
$ns at 233.92878732741613 "$node_(87) setdest 450 474 11.0" 
$ns at 449.3679041423221 "$node_(87) setdest 279 822 7.0" 
$ns at 740.9541364733816 "$node_(87) setdest 1228 633 1.0" 
$ns at 0.0 "$node_(88) setdest 906 610 13.0" 
$ns at 37.141601019087105 "$node_(88) setdest 2030 133 13.0" 
$ns at 186.85630193504704 "$node_(88) setdest 2080 556 17.0" 
$ns at 406.0914685186921 "$node_(88) setdest 1449 264 5.0" 
$ns at 551.805447557493 "$node_(88) setdest 2541 336 12.0" 
$ns at 873.0321441245229 "$node_(88) setdest 594 381 2.0" 
$ns at 0.0 "$node_(89) setdest 1882 354 12.0" 
$ns at 86.7243919365464 "$node_(89) setdest 2167 690 17.0" 
$ns at 157.5764994607725 "$node_(89) setdest 2088 110 10.0" 
$ns at 303.4363742601515 "$node_(89) setdest 1362 846 2.0" 
$ns at 423.7791384430988 "$node_(89) setdest 1387 818 9.0" 
$ns at 667.0274195521413 "$node_(89) setdest 1992 535 7.0" 
$ns at 0.0 "$node_(90) setdest 710 64 6.0" 
$ns at 31.726726795109144 "$node_(90) setdest 2052 476 3.0" 
$ns at 74.68439814085679 "$node_(90) setdest 1832 568 7.0" 
$ns at 135.83182952908493 "$node_(90) setdest 1632 513 13.0" 
$ns at 375.9522175996145 "$node_(90) setdest 987 335 20.0" 
$ns at 683.183473719549 "$node_(90) setdest 2880 716 13.0" 
$ns at 0.0 "$node_(91) setdest 531 756 2.0" 
$ns at 22.794460857617857 "$node_(91) setdest 2436 682 7.0" 
$ns at 52.96551629486861 "$node_(91) setdest 1944 460 5.0" 
$ns at 135.16366025947084 "$node_(91) setdest 1528 447 20.0" 
$ns at 325.96542106054983 "$node_(91) setdest 1251 962 4.0" 
$ns at 583.5214575132268 "$node_(91) setdest 2660 698 14.0" 
$ns at 0.0 "$node_(92) setdest 2654 412 3.0" 
$ns at 19.9822150011485 "$node_(92) setdest 1574 199 12.0" 
$ns at 118.9406009005129 "$node_(92) setdest 936 994 11.0" 
$ns at 226.30557170988158 "$node_(92) setdest 1934 611 14.0" 
$ns at 420.099300371714 "$node_(92) setdest 950 780 12.0" 
$ns at 757.320681038351 "$node_(92) setdest 2886 138 18.0" 
$ns at 0.0 "$node_(93) setdest 2257 77 18.0" 
$ns at 172.4087237383003 "$node_(93) setdest 461 663 4.0" 
$ns at 233.21944777468633 "$node_(93) setdest 704 592 5.0" 
$ns at 342.118449586222 "$node_(93) setdest 2483 312 8.0" 
$ns at 536.28629162997 "$node_(93) setdest 2519 936 15.0" 
$ns at 0.0 "$node_(94) setdest 418 612 18.0" 
$ns at 80.81005013870133 "$node_(94) setdest 2218 290 8.0" 
$ns at 156.60456667991687 "$node_(94) setdest 1360 676 14.0" 
$ns at 341.2707648421979 "$node_(94) setdest 2395 278 6.0" 
$ns at 513.9057207806034 "$node_(94) setdest 2074 81 3.0" 
$ns at 775.4906564806798 "$node_(94) setdest 1189 339 19.0" 
$ns at 0.0 "$node_(95) setdest 781 382 20.0" 
$ns at 19.99108669354298 "$node_(95) setdest 4 163 15.0" 
$ns at 185.25991165102698 "$node_(95) setdest 2130 417 6.0" 
$ns at 276.1728161427553 "$node_(95) setdest 771 985 3.0" 
$ns at 408.2311636048353 "$node_(95) setdest 1528 841 1.0" 
$ns at 651.1813548966454 "$node_(95) setdest 1830 777 4.0" 
$ns at 0.0 "$node_(96) setdest 1766 571 3.0" 
$ns at 29.779859682462586 "$node_(96) setdest 2225 665 7.0" 
$ns at 88.6675735316621 "$node_(96) setdest 1627 48 10.0" 
$ns at 187.90328874516106 "$node_(96) setdest 980 91 15.0" 
$ns at 437.38007613482 "$node_(96) setdest 1905 509 1.0" 
$ns at 677.9808128100682 "$node_(96) setdest 2660 547 16.0" 
$ns at 0.0 "$node_(97) setdest 27 688 9.0" 
$ns at 78.10106523123977 "$node_(97) setdest 2280 918 12.0" 
$ns at 127.7026925409833 "$node_(97) setdest 2195 625 14.0" 
$ns at 220.9915313732781 "$node_(97) setdest 1362 729 19.0" 
$ns at 440.3575488132286 "$node_(97) setdest 1754 501 9.0" 
$ns at 756.4257328642746 "$node_(97) setdest 2714 869 10.0" 
$ns at 0.0 "$node_(98) setdest 2199 687 4.0" 
$ns at 32.35920797791543 "$node_(98) setdest 1216 570 2.0" 
$ns at 74.20700136826383 "$node_(98) setdest 2021 421 7.0" 
$ns at 156.4330480255647 "$node_(98) setdest 702 698 2.0" 
$ns at 288.6721109979275 "$node_(98) setdest 310 796 4.0" 
$ns at 550.7755967395215 "$node_(98) setdest 713 674 18.0" 
$ns at 0.0 "$node_(99) setdest 1812 985 10.0" 
$ns at 84.13513990632393 "$node_(99) setdest 2714 541 18.0" 
$ns at 277.81855222540923 "$node_(99) setdest 869 869 10.0" 
$ns at 431.1236994856307 "$node_(99) setdest 2050 17 13.0" 
$ns at 609.2791875121657 "$node_(99) setdest 2420 511 8.0" 


#Set a TCP connection between node_(57) and node_(55)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(0)
$ns attach-agent $node_(55) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(88) and node_(66)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(1)
$ns attach-agent $node_(66) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(33) and node_(13)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(2)
$ns attach-agent $node_(13) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(11) and node_(62)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(3)
$ns attach-agent $node_(62) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(27) and node_(71)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(4)
$ns attach-agent $node_(71) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(50) and node_(49)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(5)
$ns attach-agent $node_(49) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(48) and node_(54)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(6)
$ns attach-agent $node_(54) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(29) and node_(18)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(7)
$ns attach-agent $node_(18) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(34) and node_(44)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(8)
$ns attach-agent $node_(44) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(78) and node_(89)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(9)
$ns attach-agent $node_(89) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(23) and node_(15)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(10)
$ns attach-agent $node_(15) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(4) and node_(47)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(11)
$ns attach-agent $node_(47) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(26) and node_(93)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(12)
$ns attach-agent $node_(93) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(81) and node_(94)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(13)
$ns attach-agent $node_(94) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(28) and node_(7)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(14)
$ns attach-agent $node_(7) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(84) and node_(89)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(15)
$ns attach-agent $node_(89) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(29) and node_(38)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(16)
$ns attach-agent $node_(38) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(24) and node_(9)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(17)
$ns attach-agent $node_(9) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(51) and node_(86)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(18)
$ns attach-agent $node_(86) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(28) and node_(60)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(19)
$ns attach-agent $node_(60) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(43) and node_(48)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(20)
$ns attach-agent $node_(48) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(19) and node_(68)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(21)
$ns attach-agent $node_(68) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(40) and node_(2)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(22)
$ns attach-agent $node_(2) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(80) and node_(20)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(23)
$ns attach-agent $node_(20) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(12) and node_(84)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(24)
$ns attach-agent $node_(84) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(12) and node_(20)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(25)
$ns attach-agent $node_(20) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(56) and node_(13)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(26)
$ns attach-agent $node_(13) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(11) and node_(62)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(27)
$ns attach-agent $node_(62) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(21) and node_(46)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(28)
$ns attach-agent $node_(46) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(57) and node_(67)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(29)
$ns attach-agent $node_(67) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(78) and node_(48)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(30)
$ns attach-agent $node_(48) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(68) and node_(62)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(31)
$ns attach-agent $node_(62) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(46) and node_(81)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(32)
$ns attach-agent $node_(81) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(29) and node_(30)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(33)
$ns attach-agent $node_(30) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(22) and node_(33)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(34)
$ns attach-agent $node_(33) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(59) and node_(28)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(35)
$ns attach-agent $node_(28) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(72) and node_(63)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(36)
$ns attach-agent $node_(63) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(22) and node_(32)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(37)
$ns attach-agent $node_(32) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(67) and node_(28)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(38)
$ns attach-agent $node_(28) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(69) and node_(25)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(39)
$ns attach-agent $node_(25) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(25) and node_(88)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(40)
$ns attach-agent $node_(88) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(22) and node_(42)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(41)
$ns attach-agent $node_(42) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(4) and node_(45)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(42)
$ns attach-agent $node_(45) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(61) and node_(84)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(43)
$ns attach-agent $node_(84) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(16) and node_(94)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(44)
$ns attach-agent $node_(94) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(65) and node_(45)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(45)
$ns attach-agent $node_(45) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(29) and node_(25)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(46)
$ns attach-agent $node_(25) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(45) and node_(2)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(47)
$ns attach-agent $node_(2) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(70) and node_(77)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(48)
$ns attach-agent $node_(77) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(3) and node_(16)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(49)
$ns attach-agent $node_(16) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(84) and node_(19)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(50)
$ns attach-agent $node_(19) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(87) and node_(91)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(51)
$ns attach-agent $node_(91) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(1) and node_(63)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(52)
$ns attach-agent $node_(63) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(42) and node_(14)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(53)
$ns attach-agent $node_(14) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(88) and node_(77)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(54)
$ns attach-agent $node_(77) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(2) and node_(59)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(55)
$ns attach-agent $node_(59) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(44) and node_(70)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(56)
$ns attach-agent $node_(70) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(48) and node_(41)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(57)
$ns attach-agent $node_(41) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(7) and node_(60)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(58)
$ns attach-agent $node_(60) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(55) and node_(99)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(59)
$ns attach-agent $node_(99) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(68) and node_(51)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(60)
$ns attach-agent $node_(51) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(97) and node_(3)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(61)
$ns attach-agent $node_(3) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(84) and node_(15)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(62)
$ns attach-agent $node_(15) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(68) and node_(32)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(63)
$ns attach-agent $node_(32) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(24) and node_(21)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(64)
$ns attach-agent $node_(21) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(43) and node_(89)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(65)
$ns attach-agent $node_(89) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(15) and node_(79)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(66)
$ns attach-agent $node_(79) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(95) and node_(42)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(67)
$ns attach-agent $node_(42) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(96) and node_(91)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(68)
$ns attach-agent $node_(91) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(22) and node_(61)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(69)
$ns attach-agent $node_(61) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(25) and node_(19)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(70)
$ns attach-agent $node_(19) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(15) and node_(75)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(71)
$ns attach-agent $node_(75) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(82) and node_(13)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(72)
$ns attach-agent $node_(13) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(85) and node_(92)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(73)
$ns attach-agent $node_(92) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(3) and node_(72)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(74)
$ns attach-agent $node_(72) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(13) and node_(86)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(75)
$ns attach-agent $node_(86) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(74) and node_(29)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(76)
$ns attach-agent $node_(29) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(95) and node_(47)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(77)
$ns attach-agent $node_(47) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(58) and node_(42)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(78)
$ns attach-agent $node_(42) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(25) and node_(35)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(79)
$ns attach-agent $node_(35) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(16) and node_(1)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(80)
$ns attach-agent $node_(1) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(40) and node_(3)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(81)
$ns attach-agent $node_(3) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(95) and node_(12)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(82)
$ns attach-agent $node_(12) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(74) and node_(29)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(83)
$ns attach-agent $node_(29) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(19) and node_(92)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(84)
$ns attach-agent $node_(92) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(43) and node_(21)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(85)
$ns attach-agent $node_(21) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(54) and node_(3)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(86)
$ns attach-agent $node_(3) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(20) and node_(96)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(87)
$ns attach-agent $node_(96) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(86) and node_(37)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(88)
$ns attach-agent $node_(37) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(18) and node_(17)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(89)
$ns attach-agent $node_(17) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(35) and node_(78)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(90)
$ns attach-agent $node_(78) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(49) and node_(13)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(91)
$ns attach-agent $node_(13) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(61) and node_(10)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(92)
$ns attach-agent $node_(10) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(80) and node_(50)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(93)
$ns attach-agent $node_(50) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(21) and node_(6)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(94)
$ns attach-agent $node_(6) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(27) and node_(97)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(95)
$ns attach-agent $node_(97) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(1) and node_(51)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(96)
$ns attach-agent $node_(51) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(64) and node_(59)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(97)
$ns attach-agent $node_(59) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(80) and node_(68)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(98)
$ns attach-agent $node_(68) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(47) and node_(15)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(99)
$ns attach-agent $node_(15) $sink_(99)
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
