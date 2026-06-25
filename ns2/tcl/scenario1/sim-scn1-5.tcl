#sim-scn1-5.tcl 
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
set tracefd       [open sim-scn1-5-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-5-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-5-$val(rp).nam w]

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
$node_(0) set X_ 317 
$node_(0) set Y_ 192 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2798 
$node_(1) set Y_ 554 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 40 
$node_(2) set Y_ 625 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 728 
$node_(3) set Y_ 378 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2085 
$node_(4) set Y_ 179 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2074 
$node_(5) set Y_ 910 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1273 
$node_(6) set Y_ 168 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2786 
$node_(7) set Y_ 866 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 1054 
$node_(8) set Y_ 288 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1573 
$node_(9) set Y_ 375 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1765 
$node_(10) set Y_ 649 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 239 
$node_(11) set Y_ 149 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1361 
$node_(12) set Y_ 315 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1012 
$node_(13) set Y_ 273 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 173 
$node_(14) set Y_ 136 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1930 
$node_(15) set Y_ 952 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2742 
$node_(16) set Y_ 962 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1734 
$node_(17) set Y_ 929 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2815 
$node_(18) set Y_ 81 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2085 
$node_(19) set Y_ 633 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 59 
$node_(20) set Y_ 867 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 267 
$node_(21) set Y_ 334 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 990 
$node_(22) set Y_ 174 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2819 
$node_(23) set Y_ 691 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2012 
$node_(24) set Y_ 973 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 843 
$node_(25) set Y_ 150 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1385 
$node_(26) set Y_ 92 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2941 
$node_(27) set Y_ 570 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1236 
$node_(28) set Y_ 681 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 983 
$node_(29) set Y_ 286 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1596 
$node_(30) set Y_ 217 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2042 
$node_(31) set Y_ 634 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2706 
$node_(32) set Y_ 442 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1028 
$node_(33) set Y_ 538 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1588 
$node_(34) set Y_ 595 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 621 
$node_(35) set Y_ 412 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2140 
$node_(36) set Y_ 735 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2234 
$node_(37) set Y_ 36 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1647 
$node_(38) set Y_ 712 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1745 
$node_(39) set Y_ 487 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1832 
$node_(40) set Y_ 587 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 806 
$node_(41) set Y_ 475 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1138 
$node_(42) set Y_ 878 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2483 
$node_(43) set Y_ 631 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2093 
$node_(44) set Y_ 76 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 984 
$node_(45) set Y_ 380 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1120 
$node_(46) set Y_ 259 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 117 
$node_(47) set Y_ 69 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 245 
$node_(48) set Y_ 484 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2063 
$node_(49) set Y_ 884 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2629 
$node_(50) set Y_ 885 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2871 
$node_(51) set Y_ 961 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2836 
$node_(52) set Y_ 27 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1957 
$node_(53) set Y_ 763 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 2196 
$node_(54) set Y_ 149 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2657 
$node_(55) set Y_ 484 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 530 
$node_(56) set Y_ 343 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 687 
$node_(57) set Y_ 716 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 1894 
$node_(58) set Y_ 636 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 82 
$node_(59) set Y_ 117 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2835 
$node_(60) set Y_ 157 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2908 
$node_(61) set Y_ 119 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 985 
$node_(62) set Y_ 297 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 1715 
$node_(63) set Y_ 996 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2612 
$node_(64) set Y_ 803 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1350 
$node_(65) set Y_ 765 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 2969 
$node_(66) set Y_ 296 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 357 
$node_(67) set Y_ 457 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2058 
$node_(68) set Y_ 529 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1792 
$node_(69) set Y_ 291 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 590 
$node_(70) set Y_ 68 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 812 
$node_(71) set Y_ 115 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1573 
$node_(72) set Y_ 752 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 943 
$node_(73) set Y_ 323 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1129 
$node_(74) set Y_ 388 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1404 
$node_(75) set Y_ 111 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 717 
$node_(76) set Y_ 710 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 342 
$node_(77) set Y_ 538 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2004 
$node_(78) set Y_ 504 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1237 
$node_(79) set Y_ 381 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 1183 
$node_(80) set Y_ 158 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2165 
$node_(81) set Y_ 161 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1529 
$node_(82) set Y_ 644 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1945 
$node_(83) set Y_ 57 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 2464 
$node_(84) set Y_ 59 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2543 
$node_(85) set Y_ 620 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1355 
$node_(86) set Y_ 431 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 423 
$node_(87) set Y_ 369 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2656 
$node_(88) set Y_ 430 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 1768 
$node_(89) set Y_ 345 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 2925 
$node_(90) set Y_ 14 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2793 
$node_(91) set Y_ 663 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2570 
$node_(92) set Y_ 776 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 515 
$node_(93) set Y_ 966 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 990 
$node_(94) set Y_ 976 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 595 
$node_(95) set Y_ 390 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 107 
$node_(96) set Y_ 787 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2943 
$node_(97) set Y_ 378 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1992 
$node_(98) set Y_ 303 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 954 
$node_(99) set Y_ 184 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 1550 224 2.0" 
$ns at 23.51763095615665 "$node_(0) setdest 2893 972 15.0" 
$ns at 113.72406058641293 "$node_(0) setdest 2235 159 16.0" 
$ns at 203.70467903150552 "$node_(0) setdest 1724 967 15.0" 
$ns at 430.37488322445245 "$node_(0) setdest 766 22 13.0" 
$ns at 683.6841149677609 "$node_(0) setdest 949 755 11.0" 
$ns at 0.0 "$node_(1) setdest 715 94 9.0" 
$ns at 53.546598072603395 "$node_(1) setdest 1429 546 1.0" 
$ns at 84.35934910310034 "$node_(1) setdest 2490 407 13.0" 
$ns at 243.69848350519277 "$node_(1) setdest 547 861 5.0" 
$ns at 383.0586853353343 "$node_(1) setdest 806 197 6.0" 
$ns at 660.888253710621 "$node_(1) setdest 2817 240 15.0" 
$ns at 0.0 "$node_(2) setdest 934 363 1.0" 
$ns at 18.43621199573978 "$node_(2) setdest 1017 111 15.0" 
$ns at 141.29515490058344 "$node_(2) setdest 1676 580 17.0" 
$ns at 315.5812416457807 "$node_(2) setdest 668 138 5.0" 
$ns at 465.37024479161374 "$node_(2) setdest 1738 21 18.0" 
$ns at 708.0998068926772 "$node_(2) setdest 2414 599 1.0" 
$ns at 0.0 "$node_(3) setdest 2937 836 11.0" 
$ns at 24.63960169833365 "$node_(3) setdest 1602 582 6.0" 
$ns at 98.79223735186392 "$node_(3) setdest 2432 833 16.0" 
$ns at 215.69176478570773 "$node_(3) setdest 2141 66 17.0" 
$ns at 426.4546216121429 "$node_(3) setdest 2901 31 19.0" 
$ns at 800.4712137910174 "$node_(3) setdest 425 178 19.0" 
$ns at 0.0 "$node_(4) setdest 1359 5 19.0" 
$ns at 31.51231179382788 "$node_(4) setdest 904 175 12.0" 
$ns at 171.18556582237275 "$node_(4) setdest 2045 213 4.0" 
$ns at 235.98826401872861 "$node_(4) setdest 2580 960 19.0" 
$ns at 505.86859838366036 "$node_(4) setdest 560 711 14.0" 
$ns at 871.9544215317784 "$node_(4) setdest 1520 176 14.0" 
$ns at 0.0 "$node_(5) setdest 1196 949 4.0" 
$ns at 34.81712765698428 "$node_(5) setdest 1173 184 10.0" 
$ns at 107.76952426657463 "$node_(5) setdest 1130 568 13.0" 
$ns at 280.17576154475483 "$node_(5) setdest 2052 469 17.0" 
$ns at 420.2584089182586 "$node_(5) setdest 1928 369 5.0" 
$ns at 670.2204607499997 "$node_(5) setdest 101 281 16.0" 
$ns at 0.0 "$node_(6) setdest 1532 887 8.0" 
$ns at 87.95900401765618 "$node_(6) setdest 2792 559 12.0" 
$ns at 143.03561196813064 "$node_(6) setdest 1672 241 13.0" 
$ns at 303.2229336774291 "$node_(6) setdest 766 440 3.0" 
$ns at 427.2610303994634 "$node_(6) setdest 381 188 14.0" 
$ns at 794.833389855269 "$node_(6) setdest 1581 905 16.0" 
$ns at 0.0 "$node_(7) setdest 47 558 17.0" 
$ns at 137.30959248385201 "$node_(7) setdest 1870 353 13.0" 
$ns at 232.8195715225704 "$node_(7) setdest 2191 489 5.0" 
$ns at 333.7943735327211 "$node_(7) setdest 2967 170 17.0" 
$ns at 563.0485089491356 "$node_(7) setdest 2897 149 17.0" 
$ns at 0.0 "$node_(8) setdest 1816 584 4.0" 
$ns at 37.67808331225649 "$node_(8) setdest 586 860 2.0" 
$ns at 76.02033015700187 "$node_(8) setdest 710 354 8.0" 
$ns at 186.55910960834342 "$node_(8) setdest 1553 807 12.0" 
$ns at 337.8346604130726 "$node_(8) setdest 2186 103 1.0" 
$ns at 584.0534527880391 "$node_(8) setdest 477 753 8.0" 
$ns at 0.0 "$node_(9) setdest 1117 334 18.0" 
$ns at 115.85663924525163 "$node_(9) setdest 802 438 11.0" 
$ns at 208.21155476640996 "$node_(9) setdest 1816 448 6.0" 
$ns at 284.8474819536036 "$node_(9) setdest 2706 593 19.0" 
$ns at 480.98219544267295 "$node_(9) setdest 1722 289 12.0" 
$ns at 733.4389572583216 "$node_(9) setdest 1072 728 2.0" 
$ns at 0.0 "$node_(10) setdest 953 42 14.0" 
$ns at 57.423791796146276 "$node_(10) setdest 648 146 1.0" 
$ns at 89.67252371079952 "$node_(10) setdest 1808 522 10.0" 
$ns at 159.88135250125202 "$node_(10) setdest 2335 830 1.0" 
$ns at 283.22903485286355 "$node_(10) setdest 2012 151 20.0" 
$ns at 610.9189682175212 "$node_(10) setdest 2284 153 5.0" 
$ns at 0.0 "$node_(11) setdest 1267 184 16.0" 
$ns at 140.36829655787102 "$node_(11) setdest 1227 572 11.0" 
$ns at 278.0890339210333 "$node_(11) setdest 2418 983 4.0" 
$ns at 364.3783559424036 "$node_(11) setdest 1241 735 3.0" 
$ns at 499.10191426429435 "$node_(11) setdest 1294 379 2.0" 
$ns at 753.0251538792248 "$node_(11) setdest 871 684 6.0" 
$ns at 0.0 "$node_(12) setdest 2031 438 5.0" 
$ns at 34.47839303078126 "$node_(12) setdest 287 66 4.0" 
$ns at 103.09153730000887 "$node_(12) setdest 2431 174 4.0" 
$ns at 196.91351216697382 "$node_(12) setdest 1929 544 20.0" 
$ns at 338.6368706293438 "$node_(12) setdest 2676 1 18.0" 
$ns at 614.8606371172767 "$node_(12) setdest 1799 816 19.0" 
$ns at 0.0 "$node_(13) setdest 1445 1 13.0" 
$ns at 85.21737273029078 "$node_(13) setdest 360 939 18.0" 
$ns at 201.42953369102133 "$node_(13) setdest 1250 273 2.0" 
$ns at 270.0252385804829 "$node_(13) setdest 2696 863 12.0" 
$ns at 392.9548112371966 "$node_(13) setdest 545 951 1.0" 
$ns at 637.3875908518339 "$node_(13) setdest 2397 359 7.0" 
$ns at 0.0 "$node_(14) setdest 1921 657 20.0" 
$ns at 70.5256113138206 "$node_(14) setdest 1330 777 8.0" 
$ns at 105.31830536740244 "$node_(14) setdest 440 467 14.0" 
$ns at 211.86477400035565 "$node_(14) setdest 1238 292 11.0" 
$ns at 373.8416907762743 "$node_(14) setdest 923 677 3.0" 
$ns at 639.7111224363309 "$node_(14) setdest 2852 573 10.0" 
$ns at 0.0 "$node_(15) setdest 2743 924 7.0" 
$ns at 19.589403995284425 "$node_(15) setdest 948 55 20.0" 
$ns at 82.68931631753163 "$node_(15) setdest 2437 456 2.0" 
$ns at 157.16388862631723 "$node_(15) setdest 530 229 5.0" 
$ns at 284.14282067002637 "$node_(15) setdest 2201 615 6.0" 
$ns at 539.3813681543932 "$node_(15) setdest 2081 634 11.0" 
$ns at 0.0 "$node_(16) setdest 1057 822 15.0" 
$ns at 58.25409505888223 "$node_(16) setdest 548 477 4.0" 
$ns at 120.49814796099494 "$node_(16) setdest 279 618 9.0" 
$ns at 193.37004075108445 "$node_(16) setdest 1517 49 12.0" 
$ns at 373.49760281104665 "$node_(16) setdest 1355 570 15.0" 
$ns at 732.0877487822252 "$node_(16) setdest 1750 369 13.0" 
$ns at 0.0 "$node_(17) setdest 2577 71 14.0" 
$ns at 42.88677138968453 "$node_(17) setdest 2009 736 18.0" 
$ns at 210.3092819582952 "$node_(17) setdest 1031 367 9.0" 
$ns at 283.9053372106614 "$node_(17) setdest 870 100 9.0" 
$ns at 460.5549092900426 "$node_(17) setdest 1585 329 9.0" 
$ns at 781.9604472723333 "$node_(17) setdest 2947 449 1.0" 
$ns at 0.0 "$node_(18) setdest 2149 797 8.0" 
$ns at 39.956954623906576 "$node_(18) setdest 711 612 20.0" 
$ns at 122.540933596331 "$node_(18) setdest 285 526 4.0" 
$ns at 192.85634027153992 "$node_(18) setdest 842 182 3.0" 
$ns at 321.1649161558471 "$node_(18) setdest 973 54 4.0" 
$ns at 582.3433558794388 "$node_(18) setdest 1794 460 18.0" 
$ns at 0.0 "$node_(19) setdest 85 25 8.0" 
$ns at 53.68428430068193 "$node_(19) setdest 1013 611 15.0" 
$ns at 116.78698558441891 "$node_(19) setdest 2883 781 12.0" 
$ns at 191.5631028981163 "$node_(19) setdest 2976 453 1.0" 
$ns at 313.5129098375036 "$node_(19) setdest 2597 266 14.0" 
$ns at 616.0196183624744 "$node_(19) setdest 4 554 2.0" 
$ns at 0.0 "$node_(20) setdest 886 548 8.0" 
$ns at 29.591763226859733 "$node_(20) setdest 524 563 13.0" 
$ns at 116.42151117090194 "$node_(20) setdest 2754 505 18.0" 
$ns at 225.890383900926 "$node_(20) setdest 204 953 19.0" 
$ns at 430.90505902732593 "$node_(20) setdest 214 479 6.0" 
$ns at 714.7045926122811 "$node_(20) setdest 2164 598 2.0" 
$ns at 0.0 "$node_(21) setdest 1769 950 8.0" 
$ns at 70.15873988643442 "$node_(21) setdest 1183 869 3.0" 
$ns at 110.88289099684644 "$node_(21) setdest 516 524 15.0" 
$ns at 297.25860145607976 "$node_(21) setdest 586 155 7.0" 
$ns at 487.1500328408406 "$node_(21) setdest 2430 794 18.0" 
$ns at 824.4512978027215 "$node_(21) setdest 2253 9 18.0" 
$ns at 0.0 "$node_(22) setdest 137 871 13.0" 
$ns at 44.627831081419544 "$node_(22) setdest 921 331 15.0" 
$ns at 115.18618481880796 "$node_(22) setdest 237 636 19.0" 
$ns at 184.87103138046285 "$node_(22) setdest 2729 259 7.0" 
$ns at 318.53749877058306 "$node_(22) setdest 2983 11 16.0" 
$ns at 680.1587053444491 "$node_(22) setdest 1674 713 9.0" 
$ns at 0.0 "$node_(23) setdest 1878 804 20.0" 
$ns at 68.40285477478075 "$node_(23) setdest 1418 744 7.0" 
$ns at 103.05609951284333 "$node_(23) setdest 2487 933 16.0" 
$ns at 238.36641790823984 "$node_(23) setdest 2634 134 11.0" 
$ns at 360.29939964147934 "$node_(23) setdest 547 65 7.0" 
$ns at 615.4192294378754 "$node_(23) setdest 2815 909 8.0" 
$ns at 0.0 "$node_(24) setdest 1151 983 4.0" 
$ns at 34.891743863552236 "$node_(24) setdest 2238 697 9.0" 
$ns at 148.30720906340161 "$node_(24) setdest 2598 234 10.0" 
$ns at 235.3971814124348 "$node_(24) setdest 1515 110 4.0" 
$ns at 363.9830359601276 "$node_(24) setdest 1189 848 3.0" 
$ns at 618.6692771617663 "$node_(24) setdest 905 567 2.0" 
$ns at 0.0 "$node_(25) setdest 2044 181 14.0" 
$ns at 46.086947815543795 "$node_(25) setdest 341 239 4.0" 
$ns at 98.62350320828322 "$node_(25) setdest 752 199 12.0" 
$ns at 275.21681063800276 "$node_(25) setdest 2831 43 12.0" 
$ns at 479.28381811002475 "$node_(25) setdest 390 723 6.0" 
$ns at 752.6345317797172 "$node_(25) setdest 689 856 16.0" 
$ns at 0.0 "$node_(26) setdest 251 471 13.0" 
$ns at 36.05928285849397 "$node_(26) setdest 2759 383 9.0" 
$ns at 145.4316754694279 "$node_(26) setdest 1310 918 15.0" 
$ns at 271.5069296059865 "$node_(26) setdest 2586 343 7.0" 
$ns at 449.5737273172656 "$node_(26) setdest 2261 292 14.0" 
$ns at 794.6104955071455 "$node_(26) setdest 1199 913 2.0" 
$ns at 0.0 "$node_(27) setdest 2663 253 9.0" 
$ns at 97.69479942018197 "$node_(27) setdest 957 588 17.0" 
$ns at 159.74921371408328 "$node_(27) setdest 521 51 12.0" 
$ns at 235.45230846441265 "$node_(27) setdest 1623 901 11.0" 
$ns at 401.8583293910501 "$node_(27) setdest 2347 222 2.0" 
$ns at 658.0193920351305 "$node_(27) setdest 618 669 1.0" 
$ns at 0.0 "$node_(28) setdest 1520 114 12.0" 
$ns at 86.2713039822283 "$node_(28) setdest 124 692 19.0" 
$ns at 175.47852772493127 "$node_(28) setdest 1496 804 13.0" 
$ns at 340.341345996054 "$node_(28) setdest 477 79 5.0" 
$ns at 493.43695197990223 "$node_(28) setdest 2179 189 8.0" 
$ns at 811.2904557656632 "$node_(28) setdest 2035 631 4.0" 
$ns at 0.0 "$node_(29) setdest 515 331 2.0" 
$ns at 21.16350525643523 "$node_(29) setdest 2448 955 3.0" 
$ns at 58.932841370828754 "$node_(29) setdest 113 324 3.0" 
$ns at 126.45474618770707 "$node_(29) setdest 1018 234 14.0" 
$ns at 279.8871801916586 "$node_(29) setdest 1453 256 1.0" 
$ns at 524.1100549462788 "$node_(29) setdest 1585 830 8.0" 
$ns at 0.0 "$node_(30) setdest 1991 60 19.0" 
$ns at 132.6338281785679 "$node_(30) setdest 115 145 1.0" 
$ns at 165.46059574833453 "$node_(30) setdest 220 306 13.0" 
$ns at 316.7929761153491 "$node_(30) setdest 931 413 17.0" 
$ns at 496.5460688973409 "$node_(30) setdest 1486 227 18.0" 
$ns at 826.5795862311843 "$node_(30) setdest 1266 357 18.0" 
$ns at 0.0 "$node_(31) setdest 140 543 8.0" 
$ns at 21.519726844093352 "$node_(31) setdest 1574 875 16.0" 
$ns at 126.97845993041935 "$node_(31) setdest 307 877 14.0" 
$ns at 189.92472933453323 "$node_(31) setdest 786 198 16.0" 
$ns at 381.73255905919314 "$node_(31) setdest 348 807 12.0" 
$ns at 683.2384318995776 "$node_(31) setdest 2428 167 17.0" 
$ns at 0.0 "$node_(32) setdest 1828 870 3.0" 
$ns at 28.414435330047677 "$node_(32) setdest 1316 594 3.0" 
$ns at 65.71948898514081 "$node_(32) setdest 2522 58 11.0" 
$ns at 215.8220338202372 "$node_(32) setdest 2223 846 15.0" 
$ns at 459.6944451779042 "$node_(32) setdest 2806 603 14.0" 
$ns at 709.8166920641263 "$node_(32) setdest 2734 99 1.0" 
$ns at 0.0 "$node_(33) setdest 1456 118 2.0" 
$ns at 20.01222021258023 "$node_(33) setdest 2208 933 14.0" 
$ns at 100.00523080885513 "$node_(33) setdest 2686 379 1.0" 
$ns at 160.6627204785205 "$node_(33) setdest 527 190 8.0" 
$ns at 316.4705095384244 "$node_(33) setdest 2978 301 12.0" 
$ns at 585.9389103928968 "$node_(33) setdest 2076 278 4.0" 
$ns at 0.0 "$node_(34) setdest 2000 923 6.0" 
$ns at 61.57653836976729 "$node_(34) setdest 2134 338 17.0" 
$ns at 145.27776365762696 "$node_(34) setdest 1701 434 9.0" 
$ns at 286.4357560275987 "$node_(34) setdest 2600 956 11.0" 
$ns at 474.78383354455843 "$node_(34) setdest 349 549 7.0" 
$ns at 784.3183754368738 "$node_(34) setdest 2754 345 2.0" 
$ns at 0.0 "$node_(35) setdest 1117 787 8.0" 
$ns at 67.26565045730288 "$node_(35) setdest 1478 171 7.0" 
$ns at 117.16789548103685 "$node_(35) setdest 1483 457 4.0" 
$ns at 203.77971456039893 "$node_(35) setdest 113 451 17.0" 
$ns at 389.76132740189695 "$node_(35) setdest 2533 381 17.0" 
$ns at 741.1102002007713 "$node_(35) setdest 1904 193 17.0" 
$ns at 0.0 "$node_(36) setdest 2964 689 1.0" 
$ns at 20.74486131819615 "$node_(36) setdest 1700 714 4.0" 
$ns at 86.2459416266544 "$node_(36) setdest 341 200 1.0" 
$ns at 149.97887356339385 "$node_(36) setdest 2347 801 16.0" 
$ns at 390.8138388310649 "$node_(36) setdest 1925 223 5.0" 
$ns at 654.2931059931648 "$node_(36) setdest 1968 150 15.0" 
$ns at 0.0 "$node_(37) setdest 131 798 18.0" 
$ns at 174.2603317128941 "$node_(37) setdest 2044 752 11.0" 
$ns at 261.00775613752944 "$node_(37) setdest 414 709 9.0" 
$ns at 334.94035735842016 "$node_(37) setdest 1 154 19.0" 
$ns at 481.5774589647118 "$node_(37) setdest 1150 793 13.0" 
$ns at 771.1505667670363 "$node_(37) setdest 2713 774 10.0" 
$ns at 0.0 "$node_(38) setdest 2827 357 13.0" 
$ns at 19.707261304099966 "$node_(38) setdest 2136 686 11.0" 
$ns at 50.2870182747228 "$node_(38) setdest 1586 764 17.0" 
$ns at 175.30494153092252 "$node_(38) setdest 1973 569 13.0" 
$ns at 379.52375229967777 "$node_(38) setdest 939 463 12.0" 
$ns at 694.5269150979402 "$node_(38) setdest 2071 722 1.0" 
$ns at 0.0 "$node_(39) setdest 1210 41 11.0" 
$ns at 32.010566931908414 "$node_(39) setdest 990 343 15.0" 
$ns at 184.1470329249994 "$node_(39) setdest 2015 80 3.0" 
$ns at 259.0875929271523 "$node_(39) setdest 2911 481 16.0" 
$ns at 387.24030041690247 "$node_(39) setdest 2840 880 9.0" 
$ns at 702.63404225605 "$node_(39) setdest 827 350 10.0" 
$ns at 0.0 "$node_(40) setdest 2516 338 11.0" 
$ns at 38.6354378362453 "$node_(40) setdest 1700 918 2.0" 
$ns at 70.01958116416351 "$node_(40) setdest 2161 548 12.0" 
$ns at 223.40788213658516 "$node_(40) setdest 1014 961 7.0" 
$ns at 385.14383152720495 "$node_(40) setdest 1893 906 4.0" 
$ns at 652.8475652094965 "$node_(40) setdest 909 991 6.0" 
$ns at 0.0 "$node_(41) setdest 372 791 18.0" 
$ns at 117.5977775667204 "$node_(41) setdest 1833 750 1.0" 
$ns at 148.58418630905064 "$node_(41) setdest 975 97 6.0" 
$ns at 240.80457994201117 "$node_(41) setdest 388 187 11.0" 
$ns at 361.4812745933118 "$node_(41) setdest 2180 199 19.0" 
$ns at 658.7434569315251 "$node_(41) setdest 2816 96 4.0" 
$ns at 0.0 "$node_(42) setdest 1440 118 5.0" 
$ns at 56.55955877776984 "$node_(42) setdest 1289 834 11.0" 
$ns at 122.58426109896726 "$node_(42) setdest 634 969 1.0" 
$ns at 187.68406285707343 "$node_(42) setdest 1961 812 11.0" 
$ns at 340.48376698210245 "$node_(42) setdest 1881 968 19.0" 
$ns at 747.8772323241328 "$node_(42) setdest 2445 664 5.0" 
$ns at 0.0 "$node_(43) setdest 1292 561 10.0" 
$ns at 49.40368341322463 "$node_(43) setdest 158 286 1.0" 
$ns at 85.93235643092402 "$node_(43) setdest 959 475 8.0" 
$ns at 179.34764917770843 "$node_(43) setdest 2721 160 8.0" 
$ns at 322.7203665008098 "$node_(43) setdest 238 742 18.0" 
$ns at 640.3075381924449 "$node_(43) setdest 334 648 9.0" 
$ns at 0.0 "$node_(44) setdest 150 985 15.0" 
$ns at 128.59830085429417 "$node_(44) setdest 1829 168 16.0" 
$ns at 266.11802190222295 "$node_(44) setdest 1431 538 9.0" 
$ns at 411.91617844422126 "$node_(44) setdest 2811 451 8.0" 
$ns at 606.0890930608372 "$node_(44) setdest 1576 185 10.0" 
$ns at 887.843019139167 "$node_(44) setdest 1101 274 15.0" 
$ns at 0.0 "$node_(45) setdest 2895 568 4.0" 
$ns at 32.225456532238894 "$node_(45) setdest 1379 376 11.0" 
$ns at 104.43933466409116 "$node_(45) setdest 2430 580 15.0" 
$ns at 268.10834409242693 "$node_(45) setdest 2741 457 4.0" 
$ns at 418.4596847423403 "$node_(45) setdest 1254 277 7.0" 
$ns at 708.1528650656479 "$node_(45) setdest 2585 453 20.0" 
$ns at 0.0 "$node_(46) setdest 2490 113 2.0" 
$ns at 28.5338732605573 "$node_(46) setdest 22 506 12.0" 
$ns at 86.69420677581388 "$node_(46) setdest 1097 566 14.0" 
$ns at 239.34630339380735 "$node_(46) setdest 733 303 4.0" 
$ns at 369.66749307823727 "$node_(46) setdest 2222 424 13.0" 
$ns at 644.2964025958465 "$node_(46) setdest 1968 715 3.0" 
$ns at 0.0 "$node_(47) setdest 697 314 14.0" 
$ns at 26.834811893591663 "$node_(47) setdest 108 903 19.0" 
$ns at 176.63253021340904 "$node_(47) setdest 1972 256 18.0" 
$ns at 342.9351506292932 "$node_(47) setdest 988 335 11.0" 
$ns at 549.0498781882659 "$node_(47) setdest 555 295 1.0" 
$ns at 792.1955770213729 "$node_(47) setdest 1901 362 3.0" 
$ns at 0.0 "$node_(48) setdest 753 514 13.0" 
$ns at 69.56028441519325 "$node_(48) setdest 1976 307 7.0" 
$ns at 119.4933853330044 "$node_(48) setdest 293 987 1.0" 
$ns at 179.93754143994008 "$node_(48) setdest 2361 225 19.0" 
$ns at 365.2037957173661 "$node_(48) setdest 2113 452 12.0" 
$ns at 607.9622598673632 "$node_(48) setdest 385 760 2.0" 
$ns at 0.0 "$node_(49) setdest 387 780 11.0" 
$ns at 108.21761944229766 "$node_(49) setdest 656 792 6.0" 
$ns at 139.70170412413162 "$node_(49) setdest 1602 520 1.0" 
$ns at 209.5450147879826 "$node_(49) setdest 751 774 10.0" 
$ns at 382.8079983218318 "$node_(49) setdest 1231 80 17.0" 
$ns at 777.4532683452959 "$node_(49) setdest 2952 959 17.0" 
$ns at 0.0 "$node_(50) setdest 2323 347 11.0" 
$ns at 67.26228686440885 "$node_(50) setdest 2198 923 14.0" 
$ns at 227.00999177673404 "$node_(50) setdest 1054 795 14.0" 
$ns at 352.6385823353384 "$node_(50) setdest 201 76 19.0" 
$ns at 518.5134207546623 "$node_(50) setdest 73 371 8.0" 
$ns at 797.2419238646115 "$node_(50) setdest 393 77 15.0" 
$ns at 0.0 "$node_(51) setdest 166 733 17.0" 
$ns at 93.16992266625962 "$node_(51) setdest 2151 328 4.0" 
$ns at 159.22266702992636 "$node_(51) setdest 2580 613 1.0" 
$ns at 224.26670579148686 "$node_(51) setdest 1478 981 15.0" 
$ns at 349.1993885248788 "$node_(51) setdest 1047 383 5.0" 
$ns at 632.6157052993888 "$node_(51) setdest 68 128 19.0" 
$ns at 0.0 "$node_(52) setdest 320 98 10.0" 
$ns at 32.735666148836486 "$node_(52) setdest 1458 98 9.0" 
$ns at 71.66455376829872 "$node_(52) setdest 2781 592 16.0" 
$ns at 178.0912816922068 "$node_(52) setdest 670 41 13.0" 
$ns at 336.16588908347825 "$node_(52) setdest 1431 413 14.0" 
$ns at 631.264681826857 "$node_(52) setdest 1560 226 15.0" 
$ns at 0.0 "$node_(53) setdest 320 643 6.0" 
$ns at 26.91604786053545 "$node_(53) setdest 779 720 15.0" 
$ns at 170.92844117389413 "$node_(53) setdest 218 923 11.0" 
$ns at 269.5252596042427 "$node_(53) setdest 1052 384 3.0" 
$ns at 405.4526714464206 "$node_(53) setdest 2100 215 5.0" 
$ns at 666.3670020280944 "$node_(53) setdest 190 359 14.0" 
$ns at 0.0 "$node_(54) setdest 740 115 5.0" 
$ns at 18.473582622074794 "$node_(54) setdest 2032 462 4.0" 
$ns at 63.438507899291196 "$node_(54) setdest 1482 753 1.0" 
$ns at 126.50198608226577 "$node_(54) setdest 246 174 12.0" 
$ns at 300.60380606028593 "$node_(54) setdest 993 602 4.0" 
$ns at 575.1590658660255 "$node_(54) setdest 674 148 11.0" 
$ns at 0.0 "$node_(55) setdest 2549 721 10.0" 
$ns at 29.046402359264967 "$node_(55) setdest 1643 398 14.0" 
$ns at 97.99247233415622 "$node_(55) setdest 2184 259 3.0" 
$ns at 166.156762907727 "$node_(55) setdest 2450 620 3.0" 
$ns at 306.053265793405 "$node_(55) setdest 2730 252 3.0" 
$ns at 552.473099340916 "$node_(55) setdest 2930 294 11.0" 
$ns at 0.0 "$node_(56) setdest 2589 15 3.0" 
$ns at 43.25752363598629 "$node_(56) setdest 2806 510 5.0" 
$ns at 76.12742314335665 "$node_(56) setdest 2769 697 3.0" 
$ns at 140.27139672200818 "$node_(56) setdest 1244 693 4.0" 
$ns at 266.67125667530473 "$node_(56) setdest 1506 776 3.0" 
$ns at 535.8811834979858 "$node_(56) setdest 809 636 4.0" 
$ns at 0.0 "$node_(57) setdest 535 563 1.0" 
$ns at 23.51091292283101 "$node_(57) setdest 2743 547 1.0" 
$ns at 57.2442460462439 "$node_(57) setdest 2797 7 1.0" 
$ns at 119.45266869792279 "$node_(57) setdest 2258 2 5.0" 
$ns at 285.6028050075124 "$node_(57) setdest 171 350 15.0" 
$ns at 650.7509892901219 "$node_(57) setdest 2268 5 6.0" 
$ns at 0.0 "$node_(58) setdest 1514 447 5.0" 
$ns at 17.357134911710993 "$node_(58) setdest 1759 571 5.0" 
$ns at 51.850222856509035 "$node_(58) setdest 2081 778 18.0" 
$ns at 118.28662600713471 "$node_(58) setdest 2708 505 19.0" 
$ns at 292.8122550928358 "$node_(58) setdest 127 477 8.0" 
$ns at 536.0724792314115 "$node_(58) setdest 2262 307 18.0" 
$ns at 0.0 "$node_(59) setdest 2257 912 5.0" 
$ns at 15.005064970449759 "$node_(59) setdest 585 385 11.0" 
$ns at 134.95818131548168 "$node_(59) setdest 1827 625 15.0" 
$ns at 222.80585448107485 "$node_(59) setdest 1572 983 10.0" 
$ns at 435.6529017801112 "$node_(59) setdest 2451 680 5.0" 
$ns at 710.9592854524865 "$node_(59) setdest 2359 522 9.0" 
$ns at 0.0 "$node_(60) setdest 433 721 18.0" 
$ns at 193.18812677229064 "$node_(60) setdest 1312 262 4.0" 
$ns at 233.15428817115708 "$node_(60) setdest 2676 289 13.0" 
$ns at 372.5882450357075 "$node_(60) setdest 935 477 15.0" 
$ns at 582.8303605819945 "$node_(60) setdest 1376 197 1.0" 
$ns at 823.5420912446149 "$node_(60) setdest 863 548 15.0" 
$ns at 0.0 "$node_(61) setdest 1561 27 14.0" 
$ns at 71.25117268273826 "$node_(61) setdest 900 673 1.0" 
$ns at 110.28094111976839 "$node_(61) setdest 285 24 2.0" 
$ns at 184.25702470452654 "$node_(61) setdest 1759 102 2.0" 
$ns at 324.0944217621096 "$node_(61) setdest 33 969 18.0" 
$ns at 735.7421586248413 "$node_(61) setdest 960 82 12.0" 
$ns at 0.0 "$node_(62) setdest 1652 803 10.0" 
$ns at 94.35477874304136 "$node_(62) setdest 54 934 4.0" 
$ns at 130.4500478893563 "$node_(62) setdest 850 74 15.0" 
$ns at 339.738301197562 "$node_(62) setdest 1108 939 18.0" 
$ns at 515.3324846469013 "$node_(62) setdest 1095 496 17.0" 
$ns at 0.0 "$node_(63) setdest 1150 958 8.0" 
$ns at 60.48126538426855 "$node_(63) setdest 2459 174 15.0" 
$ns at 237.7322172821161 "$node_(63) setdest 2988 968 13.0" 
$ns at 382.92883763254196 "$node_(63) setdest 1707 300 8.0" 
$ns at 544.4821230370017 "$node_(63) setdest 1593 922 15.0" 
$ns at 857.8837715705112 "$node_(63) setdest 714 360 6.0" 
$ns at 0.0 "$node_(64) setdest 1991 637 14.0" 
$ns at 67.6158298398726 "$node_(64) setdest 2993 168 15.0" 
$ns at 193.859250591782 "$node_(64) setdest 2328 604 8.0" 
$ns at 298.62367136106536 "$node_(64) setdest 2913 262 9.0" 
$ns at 501.6886317994609 "$node_(64) setdest 2556 925 11.0" 
$ns at 756.1548367571326 "$node_(64) setdest 2902 475 3.0" 
$ns at 0.0 "$node_(65) setdest 924 779 16.0" 
$ns at 99.3008641341727 "$node_(65) setdest 1694 726 18.0" 
$ns at 159.67557037586852 "$node_(65) setdest 1190 111 3.0" 
$ns at 222.748384202546 "$node_(65) setdest 2444 328 2.0" 
$ns at 362.60002967083597 "$node_(65) setdest 265 455 7.0" 
$ns at 639.8088518338504 "$node_(65) setdest 251 380 1.0" 
$ns at 0.0 "$node_(66) setdest 1699 81 17.0" 
$ns at 15.907452187085548 "$node_(66) setdest 2403 18 8.0" 
$ns at 109.5774150125989 "$node_(66) setdest 2201 879 16.0" 
$ns at 246.02640236266552 "$node_(66) setdest 411 601 9.0" 
$ns at 387.7441814227225 "$node_(66) setdest 1137 661 13.0" 
$ns at 685.4324556577426 "$node_(66) setdest 2631 119 13.0" 
$ns at 0.0 "$node_(67) setdest 2665 812 16.0" 
$ns at 172.9805876248351 "$node_(67) setdest 33 371 7.0" 
$ns at 217.93413317619894 "$node_(67) setdest 1971 457 3.0" 
$ns at 280.63357682996724 "$node_(67) setdest 2437 731 3.0" 
$ns at 418.1613899250384 "$node_(67) setdest 1759 574 10.0" 
$ns at 701.6697754265771 "$node_(67) setdest 1256 529 7.0" 
$ns at 0.0 "$node_(68) setdest 957 730 1.0" 
$ns at 16.991712001566547 "$node_(68) setdest 570 370 6.0" 
$ns at 58.36593183660546 "$node_(68) setdest 299 360 4.0" 
$ns at 141.02136845622786 "$node_(68) setdest 1086 922 2.0" 
$ns at 267.9319940961425 "$node_(68) setdest 1234 777 16.0" 
$ns at 660.8021042375133 "$node_(68) setdest 2283 996 4.0" 
$ns at 0.0 "$node_(69) setdest 2330 321 2.0" 
$ns at 18.940339784137006 "$node_(69) setdest 1820 944 13.0" 
$ns at 170.14631878992094 "$node_(69) setdest 1128 339 17.0" 
$ns at 255.6434057395162 "$node_(69) setdest 1993 695 2.0" 
$ns at 377.4820725406086 "$node_(69) setdest 1102 917 1.0" 
$ns at 622.4283107279339 "$node_(69) setdest 815 972 6.0" 
$ns at 0.0 "$node_(70) setdest 181 529 12.0" 
$ns at 97.95063706991122 "$node_(70) setdest 27 493 15.0" 
$ns at 157.46855831337984 "$node_(70) setdest 1012 46 2.0" 
$ns at 224.31747415742745 "$node_(70) setdest 89 201 8.0" 
$ns at 347.5029630513083 "$node_(70) setdest 2882 771 11.0" 
$ns at 636.6893523420881 "$node_(70) setdest 964 830 14.0" 
$ns at 0.0 "$node_(71) setdest 2012 428 16.0" 
$ns at 60.60386377801309 "$node_(71) setdest 1267 363 11.0" 
$ns at 131.9756797217505 "$node_(71) setdest 623 274 15.0" 
$ns at 329.8595111429298 "$node_(71) setdest 1059 164 8.0" 
$ns at 452.343744143432 "$node_(71) setdest 1984 774 15.0" 
$ns at 775.7351112149704 "$node_(71) setdest 2371 854 13.0" 
$ns at 0.0 "$node_(72) setdest 2363 505 7.0" 
$ns at 32.427961799092174 "$node_(72) setdest 2260 227 11.0" 
$ns at 70.94682879801303 "$node_(72) setdest 569 214 14.0" 
$ns at 227.2105919126489 "$node_(72) setdest 940 744 9.0" 
$ns at 376.3918868918536 "$node_(72) setdest 1513 205 1.0" 
$ns at 616.9527128021529 "$node_(72) setdest 320 427 3.0" 
$ns at 0.0 "$node_(73) setdest 2978 497 9.0" 
$ns at 33.27057619326543 "$node_(73) setdest 1993 185 1.0" 
$ns at 72.53638505574503 "$node_(73) setdest 530 402 19.0" 
$ns at 248.20619407493723 "$node_(73) setdest 2489 888 4.0" 
$ns at 396.09681840259 "$node_(73) setdest 1251 467 2.0" 
$ns at 653.8894714725477 "$node_(73) setdest 2342 722 18.0" 
$ns at 0.0 "$node_(74) setdest 1729 959 12.0" 
$ns at 114.14356835441579 "$node_(74) setdest 1304 644 20.0" 
$ns at 263.770049167185 "$node_(74) setdest 493 297 17.0" 
$ns at 350.1641989079448 "$node_(74) setdest 729 981 9.0" 
$ns at 524.8235729926524 "$node_(74) setdest 1813 136 14.0" 
$ns at 850.598151179619 "$node_(74) setdest 1967 465 15.0" 
$ns at 0.0 "$node_(75) setdest 1570 2 11.0" 
$ns at 121.24720837841512 "$node_(75) setdest 2311 270 9.0" 
$ns at 179.79652352028668 "$node_(75) setdest 607 672 9.0" 
$ns at 241.9806923901341 "$node_(75) setdest 2807 839 10.0" 
$ns at 402.4225904725013 "$node_(75) setdest 1766 717 9.0" 
$ns at 720.3303968440443 "$node_(75) setdest 988 561 2.0" 
$ns at 0.0 "$node_(76) setdest 1521 884 19.0" 
$ns at 160.75569097747317 "$node_(76) setdest 2342 593 13.0" 
$ns at 233.48723616441436 "$node_(76) setdest 2915 247 20.0" 
$ns at 409.24197048717576 "$node_(76) setdest 1066 376 16.0" 
$ns at 664.3621973487845 "$node_(76) setdest 2217 292 9.0" 
$ns at 0.0 "$node_(77) setdest 1423 659 15.0" 
$ns at 18.396973505408834 "$node_(77) setdest 1487 384 11.0" 
$ns at 124.69377609494117 "$node_(77) setdest 1757 59 10.0" 
$ns at 192.712085901791 "$node_(77) setdest 994 257 17.0" 
$ns at 420.9672428636629 "$node_(77) setdest 1969 485 18.0" 
$ns at 732.6701666192594 "$node_(77) setdest 1146 495 6.0" 
$ns at 0.0 "$node_(78) setdest 27 950 15.0" 
$ns at 133.51626363114724 "$node_(78) setdest 2393 141 16.0" 
$ns at 253.264035883162 "$node_(78) setdest 797 592 8.0" 
$ns at 322.43688400612274 "$node_(78) setdest 1269 882 4.0" 
$ns at 461.64954144546493 "$node_(78) setdest 1278 947 8.0" 
$ns at 709.8276253797176 "$node_(78) setdest 2508 485 19.0" 
$ns at 0.0 "$node_(79) setdest 1032 772 20.0" 
$ns at 115.47430755565338 "$node_(79) setdest 1932 402 15.0" 
$ns at 288.52306723879366 "$node_(79) setdest 372 972 5.0" 
$ns at 394.4814180442515 "$node_(79) setdest 519 715 7.0" 
$ns at 528.819184592998 "$node_(79) setdest 620 435 5.0" 
$ns at 816.1417825629766 "$node_(79) setdest 2862 872 9.0" 
$ns at 0.0 "$node_(80) setdest 492 818 17.0" 
$ns at 94.30378196647582 "$node_(80) setdest 1934 853 12.0" 
$ns at 201.9462084058155 "$node_(80) setdest 1417 594 17.0" 
$ns at 300.249385617657 "$node_(80) setdest 848 728 4.0" 
$ns at 451.4727081831428 "$node_(80) setdest 2349 902 13.0" 
$ns at 697.7094829985374 "$node_(80) setdest 52 757 9.0" 
$ns at 0.0 "$node_(81) setdest 1381 5 15.0" 
$ns at 61.065248003295636 "$node_(81) setdest 2126 466 3.0" 
$ns at 118.19509800311948 "$node_(81) setdest 1221 409 19.0" 
$ns at 274.69736116684004 "$node_(81) setdest 137 382 1.0" 
$ns at 399.1645740341255 "$node_(81) setdest 1340 939 4.0" 
$ns at 643.2857375512658 "$node_(81) setdest 218 341 2.0" 
$ns at 0.0 "$node_(82) setdest 2340 328 12.0" 
$ns at 123.05312818530804 "$node_(82) setdest 808 554 18.0" 
$ns at 291.9009644622897 "$node_(82) setdest 865 110 1.0" 
$ns at 358.6782284214678 "$node_(82) setdest 1746 848 10.0" 
$ns at 509.6037171905647 "$node_(82) setdest 2108 885 6.0" 
$ns at 801.5622319371868 "$node_(82) setdest 140 768 9.0" 
$ns at 0.0 "$node_(83) setdest 2718 237 3.0" 
$ns at 27.49903380869418 "$node_(83) setdest 2704 460 19.0" 
$ns at 197.86718636998748 "$node_(83) setdest 2669 872 10.0" 
$ns at 279.3208520386824 "$node_(83) setdest 989 505 3.0" 
$ns at 407.2441066288271 "$node_(83) setdest 402 762 19.0" 
$ns at 770.8246498799116 "$node_(83) setdest 699 146 6.0" 
$ns at 0.0 "$node_(84) setdest 1301 364 3.0" 
$ns at 21.487083498298613 "$node_(84) setdest 2021 565 7.0" 
$ns at 79.02439973991443 "$node_(84) setdest 1294 199 15.0" 
$ns at 174.4913887635928 "$node_(84) setdest 2653 152 4.0" 
$ns at 319.1413258777417 "$node_(84) setdest 1166 342 20.0" 
$ns at 578.8865970655572 "$node_(84) setdest 2964 926 19.0" 
$ns at 0.0 "$node_(85) setdest 2867 641 14.0" 
$ns at 98.61054969879407 "$node_(85) setdest 2473 554 5.0" 
$ns at 175.1050068506239 "$node_(85) setdest 2889 696 11.0" 
$ns at 262.7922262571803 "$node_(85) setdest 1572 618 1.0" 
$ns at 382.9523713597059 "$node_(85) setdest 1510 905 6.0" 
$ns at 665.9083016097558 "$node_(85) setdest 2187 81 18.0" 
$ns at 0.0 "$node_(86) setdest 2479 136 17.0" 
$ns at 123.5329434064466 "$node_(86) setdest 1801 114 1.0" 
$ns at 159.96929415512355 "$node_(86) setdest 2427 817 5.0" 
$ns at 249.41953923026983 "$node_(86) setdest 36 706 9.0" 
$ns at 421.95661007384336 "$node_(86) setdest 92 490 17.0" 
$ns at 817.3886179467088 "$node_(86) setdest 1705 749 19.0" 
$ns at 0.0 "$node_(87) setdest 2134 151 10.0" 
$ns at 78.56521096073058 "$node_(87) setdest 1046 506 2.0" 
$ns at 124.08262501875454 "$node_(87) setdest 132 897 4.0" 
$ns at 214.1808305860137 "$node_(87) setdest 1544 650 3.0" 
$ns at 344.4945358754201 "$node_(87) setdest 2041 708 6.0" 
$ns at 618.3643288307328 "$node_(87) setdest 550 295 3.0" 
$ns at 0.0 "$node_(88) setdest 1193 397 7.0" 
$ns at 76.34427833081423 "$node_(88) setdest 606 691 3.0" 
$ns at 116.31563958940114 "$node_(88) setdest 629 36 20.0" 
$ns at 215.75702038644187 "$node_(88) setdest 2183 523 3.0" 
$ns at 345.92712154183874 "$node_(88) setdest 1340 412 12.0" 
$ns at 621.8615147647894 "$node_(88) setdest 2246 965 4.0" 
$ns at 0.0 "$node_(89) setdest 1710 302 13.0" 
$ns at 112.39183473808907 "$node_(89) setdest 2842 947 1.0" 
$ns at 149.85864733600664 "$node_(89) setdest 2229 630 9.0" 
$ns at 234.33276364919547 "$node_(89) setdest 1639 275 7.0" 
$ns at 357.60956101277213 "$node_(89) setdest 1282 803 2.0" 
$ns at 598.9532007438495 "$node_(89) setdest 105 568 12.0" 
$ns at 0.0 "$node_(90) setdest 1570 770 20.0" 
$ns at 101.87118920636046 "$node_(90) setdest 2748 147 17.0" 
$ns at 218.3802100139764 "$node_(90) setdest 2474 621 5.0" 
$ns at 294.5902830217165 "$node_(90) setdest 2622 342 9.0" 
$ns at 501.70576766949756 "$node_(90) setdest 2424 753 14.0" 
$ns at 836.6867502807262 "$node_(90) setdest 5 860 18.0" 
$ns at 0.0 "$node_(91) setdest 76 929 20.0" 
$ns at 149.21858592972887 "$node_(91) setdest 2965 160 18.0" 
$ns at 202.83577735205358 "$node_(91) setdest 1850 762 4.0" 
$ns at 271.42876221620486 "$node_(91) setdest 1211 999 6.0" 
$ns at 421.9664921999455 "$node_(91) setdest 2163 433 5.0" 
$ns at 679.2381042009017 "$node_(91) setdest 1448 589 16.0" 
$ns at 0.0 "$node_(92) setdest 2379 698 6.0" 
$ns at 35.87506474101899 "$node_(92) setdest 144 21 5.0" 
$ns at 69.44752734671977 "$node_(92) setdest 312 468 18.0" 
$ns at 262.1670846549928 "$node_(92) setdest 1406 899 13.0" 
$ns at 451.00914372530934 "$node_(92) setdest 2836 534 5.0" 
$ns at 713.8939021823825 "$node_(92) setdest 2392 351 6.0" 
$ns at 0.0 "$node_(93) setdest 897 226 12.0" 
$ns at 124.47524280580762 "$node_(93) setdest 1446 843 12.0" 
$ns at 212.70273216912415 "$node_(93) setdest 2 54 19.0" 
$ns at 403.53598821915926 "$node_(93) setdest 890 483 15.0" 
$ns at 549.9208562229458 "$node_(93) setdest 1987 642 12.0" 
$ns at 800.853791839055 "$node_(93) setdest 1154 716 6.0" 
$ns at 0.0 "$node_(94) setdest 2615 496 13.0" 
$ns at 124.9049970978977 "$node_(94) setdest 1680 618 6.0" 
$ns at 210.6054227074622 "$node_(94) setdest 1329 415 7.0" 
$ns at 311.6788108949107 "$node_(94) setdest 778 182 8.0" 
$ns at 501.35754920123486 "$node_(94) setdest 2205 586 12.0" 
$ns at 860.9108992189948 "$node_(94) setdest 2380 304 2.0" 
$ns at 0.0 "$node_(95) setdest 916 678 5.0" 
$ns at 49.92008773372372 "$node_(95) setdest 2361 366 8.0" 
$ns at 110.33418174041464 "$node_(95) setdest 1276 468 1.0" 
$ns at 173.15946940421 "$node_(95) setdest 2872 611 1.0" 
$ns at 298.9904407439299 "$node_(95) setdest 652 813 2.0" 
$ns at 540.2365382319041 "$node_(95) setdest 1857 725 3.0" 
$ns at 0.0 "$node_(96) setdest 1328 21 20.0" 
$ns at 102.16164417808479 "$node_(96) setdest 1704 312 19.0" 
$ns at 171.93937629574833 "$node_(96) setdest 605 905 11.0" 
$ns at 337.52863344055686 "$node_(96) setdest 696 176 19.0" 
$ns at 598.8014507396227 "$node_(96) setdest 214 86 17.0" 
$ns at 0.0 "$node_(97) setdest 705 595 3.0" 
$ns at 24.165169506806926 "$node_(97) setdest 1344 347 11.0" 
$ns at 63.27537287610375 "$node_(97) setdest 2320 7 18.0" 
$ns at 294.75251086316456 "$node_(97) setdest 338 71 15.0" 
$ns at 455.62973788886296 "$node_(97) setdest 1317 788 19.0" 
$ns at 778.2182184998007 "$node_(97) setdest 876 87 14.0" 
$ns at 0.0 "$node_(98) setdest 1188 44 6.0" 
$ns at 46.45140142816559 "$node_(98) setdest 2196 459 16.0" 
$ns at 223.96375429521558 "$node_(98) setdest 137 601 11.0" 
$ns at 287.0753316158031 "$node_(98) setdest 1665 20 10.0" 
$ns at 468.234068045083 "$node_(98) setdest 1738 601 4.0" 
$ns at 737.0091910082992 "$node_(98) setdest 2755 713 8.0" 
$ns at 0.0 "$node_(99) setdest 186 400 11.0" 
$ns at 89.09055570804277 "$node_(99) setdest 2242 22 7.0" 
$ns at 170.57630691874587 "$node_(99) setdest 2821 685 15.0" 
$ns at 343.7876462058641 "$node_(99) setdest 171 66 15.0" 
$ns at 576.5341803750869 "$node_(99) setdest 375 983 5.0" 
$ns at 828.1846632103332 "$node_(99) setdest 1910 132 19.0" 


#Set a TCP connection between node_(3) and node_(98)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(0)
$ns attach-agent $node_(98) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(79) and node_(77)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(1)
$ns attach-agent $node_(77) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(11) and node_(71)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(2)
$ns attach-agent $node_(71) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(28) and node_(83)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(3)
$ns attach-agent $node_(83) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(23) and node_(39)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(4)
$ns attach-agent $node_(39) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(77) and node_(29)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(5)
$ns attach-agent $node_(29) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(67) and node_(37)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(6)
$ns attach-agent $node_(37) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(6) and node_(37)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(7)
$ns attach-agent $node_(37) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(62) and node_(13)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(8)
$ns attach-agent $node_(13) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(29) and node_(40)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(9)
$ns attach-agent $node_(40) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(93) and node_(91)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(10)
$ns attach-agent $node_(91) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(67) and node_(34)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(11)
$ns attach-agent $node_(34) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(22) and node_(4)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(12)
$ns attach-agent $node_(4) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(46) and node_(79)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(13)
$ns attach-agent $node_(79) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(73) and node_(58)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(14)
$ns attach-agent $node_(58) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(90) and node_(99)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(15)
$ns attach-agent $node_(99) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(67) and node_(33)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(16)
$ns attach-agent $node_(33) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(40) and node_(18)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(17)
$ns attach-agent $node_(18) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(43) and node_(64)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(18)
$ns attach-agent $node_(64) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(18) and node_(44)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(19)
$ns attach-agent $node_(44) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(1) and node_(44)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(20)
$ns attach-agent $node_(44) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(95) and node_(8)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(21)
$ns attach-agent $node_(8) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(77) and node_(43)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(22)
$ns attach-agent $node_(43) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(24) and node_(67)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(23)
$ns attach-agent $node_(67) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(45) and node_(35)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(24)
$ns attach-agent $node_(35) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(84) and node_(30)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(25)
$ns attach-agent $node_(30) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(93) and node_(32)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(26)
$ns attach-agent $node_(32) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(82) and node_(26)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(27)
$ns attach-agent $node_(26) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(1) and node_(34)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(28)
$ns attach-agent $node_(34) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(8) and node_(75)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(29)
$ns attach-agent $node_(75) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(38) and node_(34)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(30)
$ns attach-agent $node_(34) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(71) and node_(20)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(31)
$ns attach-agent $node_(20) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(58) and node_(31)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(32)
$ns attach-agent $node_(31) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(47) and node_(23)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(33)
$ns attach-agent $node_(23) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(78) and node_(28)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(34)
$ns attach-agent $node_(28) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(37) and node_(67)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(35)
$ns attach-agent $node_(67) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(19) and node_(50)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(36)
$ns attach-agent $node_(50) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(98) and node_(8)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(37)
$ns attach-agent $node_(8) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(16) and node_(50)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(38)
$ns attach-agent $node_(50) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(7) and node_(38)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(39)
$ns attach-agent $node_(38) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(82) and node_(12)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(40)
$ns attach-agent $node_(12) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(54) and node_(10)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(41)
$ns attach-agent $node_(10) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(66) and node_(38)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(42)
$ns attach-agent $node_(38) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(89) and node_(79)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(43)
$ns attach-agent $node_(79) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(52) and node_(9)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(44)
$ns attach-agent $node_(9) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(30) and node_(62)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(45)
$ns attach-agent $node_(62) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(3) and node_(38)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(46)
$ns attach-agent $node_(38) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(21) and node_(49)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(47)
$ns attach-agent $node_(49) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(66) and node_(78)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(48)
$ns attach-agent $node_(78) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(77) and node_(63)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(49)
$ns attach-agent $node_(63) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(62) and node_(14)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(50)
$ns attach-agent $node_(14) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(39) and node_(46)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(51)
$ns attach-agent $node_(46) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(50) and node_(68)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(52)
$ns attach-agent $node_(68) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(4) and node_(33)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(53)
$ns attach-agent $node_(33) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(35) and node_(14)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(54)
$ns attach-agent $node_(14) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(5) and node_(1)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(55)
$ns attach-agent $node_(1) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(68) and node_(0)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(56)
$ns attach-agent $node_(0) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(96) and node_(59)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(57)
$ns attach-agent $node_(59) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(9) and node_(84)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(58)
$ns attach-agent $node_(84) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(2) and node_(65)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(59)
$ns attach-agent $node_(65) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(1) and node_(97)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(60)
$ns attach-agent $node_(97) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(42) and node_(5)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(61)
$ns attach-agent $node_(5) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(32) and node_(26)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(62)
$ns attach-agent $node_(26) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(73) and node_(29)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(63)
$ns attach-agent $node_(29) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(73) and node_(40)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(64)
$ns attach-agent $node_(40) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(56) and node_(91)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(65)
$ns attach-agent $node_(91) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(16) and node_(35)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(66)
$ns attach-agent $node_(35) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(97) and node_(17)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(67)
$ns attach-agent $node_(17) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(32) and node_(33)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(68)
$ns attach-agent $node_(33) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(94) and node_(78)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(69)
$ns attach-agent $node_(78) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(90) and node_(89)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(70)
$ns attach-agent $node_(89) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(85) and node_(82)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(71)
$ns attach-agent $node_(82) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(29) and node_(24)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(72)
$ns attach-agent $node_(24) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(88) and node_(87)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(73)
$ns attach-agent $node_(87) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(85) and node_(55)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(74)
$ns attach-agent $node_(55) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(68) and node_(90)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(75)
$ns attach-agent $node_(90) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(57) and node_(5)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(76)
$ns attach-agent $node_(5) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(36) and node_(50)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(77)
$ns attach-agent $node_(50) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(1) and node_(30)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(78)
$ns attach-agent $node_(30) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(12) and node_(36)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(79)
$ns attach-agent $node_(36) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(66) and node_(75)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(80)
$ns attach-agent $node_(75) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(43) and node_(92)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(81)
$ns attach-agent $node_(92) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(79) and node_(46)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(82)
$ns attach-agent $node_(46) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(56) and node_(58)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(83)
$ns attach-agent $node_(58) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(27) and node_(59)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(84)
$ns attach-agent $node_(59) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(89) and node_(61)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(85)
$ns attach-agent $node_(61) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(21) and node_(4)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(86)
$ns attach-agent $node_(4) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(94) and node_(57)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(87)
$ns attach-agent $node_(57) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(44) and node_(92)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(88)
$ns attach-agent $node_(92) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(72) and node_(63)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(89)
$ns attach-agent $node_(63) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(67) and node_(9)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(90)
$ns attach-agent $node_(9) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(10) and node_(99)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(91)
$ns attach-agent $node_(99) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(28) and node_(40)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(92)
$ns attach-agent $node_(40) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(40) and node_(91)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(93)
$ns attach-agent $node_(91) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(69) and node_(27)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(94)
$ns attach-agent $node_(27) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(58) and node_(76)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(95)
$ns attach-agent $node_(76) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(70) and node_(95)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(96)
$ns attach-agent $node_(95) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(32) and node_(22)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(97)
$ns attach-agent $node_(22) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(19) and node_(85)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(98)
$ns attach-agent $node_(85) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(56) and node_(67)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(99)
$ns attach-agent $node_(67) $sink_(99)
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
