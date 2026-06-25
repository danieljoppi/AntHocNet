#sim-scn1-1.tcl 
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
set tracefd       [open sim-scn1-1-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-1-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-1-$val(rp).nam w]

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
$node_(0) set X_ 299 
$node_(0) set Y_ 529 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 1839 
$node_(1) set Y_ 173 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 14 
$node_(2) set Y_ 169 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 45 
$node_(3) set Y_ 844 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2084 
$node_(4) set Y_ 783 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2130 
$node_(5) set Y_ 881 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2050 
$node_(6) set Y_ 68 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 114 
$node_(7) set Y_ 26 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2373 
$node_(8) set Y_ 928 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2866 
$node_(9) set Y_ 743 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1164 
$node_(10) set Y_ 359 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 864 
$node_(11) set Y_ 13 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 582 
$node_(12) set Y_ 568 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1256 
$node_(13) set Y_ 278 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2666 
$node_(14) set Y_ 911 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1085 
$node_(15) set Y_ 886 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2758 
$node_(16) set Y_ 30 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1226 
$node_(17) set Y_ 336 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1354 
$node_(18) set Y_ 4 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1951 
$node_(19) set Y_ 802 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1087 
$node_(20) set Y_ 397 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2164 
$node_(21) set Y_ 680 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1631 
$node_(22) set Y_ 867 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 161 
$node_(23) set Y_ 367 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1652 
$node_(24) set Y_ 378 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 2336 
$node_(25) set Y_ 77 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2419 
$node_(26) set Y_ 121 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 492 
$node_(27) set Y_ 271 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 487 
$node_(28) set Y_ 978 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 423 
$node_(29) set Y_ 189 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1788 
$node_(30) set Y_ 720 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 126 
$node_(31) set Y_ 59 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 686 
$node_(32) set Y_ 166 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 411 
$node_(33) set Y_ 769 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1936 
$node_(34) set Y_ 213 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2840 
$node_(35) set Y_ 199 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2111 
$node_(36) set Y_ 994 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1776 
$node_(37) set Y_ 939 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1932 
$node_(38) set Y_ 403 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1877 
$node_(39) set Y_ 823 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 955 
$node_(40) set Y_ 892 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2709 
$node_(41) set Y_ 566 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2377 
$node_(42) set Y_ 757 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 124 
$node_(43) set Y_ 805 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1220 
$node_(44) set Y_ 78 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2816 
$node_(45) set Y_ 10 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1867 
$node_(46) set Y_ 126 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1899 
$node_(47) set Y_ 58 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1846 
$node_(48) set Y_ 299 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1527 
$node_(49) set Y_ 754 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1941 
$node_(50) set Y_ 616 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1471 
$node_(51) set Y_ 196 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2059 
$node_(52) set Y_ 355 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1173 
$node_(53) set Y_ 703 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 1887 
$node_(54) set Y_ 697 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 121 
$node_(55) set Y_ 961 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2183 
$node_(56) set Y_ 122 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 440 
$node_(57) set Y_ 148 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 1571 
$node_(58) set Y_ 873 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 359 
$node_(59) set Y_ 58 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 1964 
$node_(60) set Y_ 19 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 683 
$node_(61) set Y_ 686 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1200 
$node_(62) set Y_ 504 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 1629 
$node_(63) set Y_ 279 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2176 
$node_(64) set Y_ 135 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 285 
$node_(65) set Y_ 604 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 2651 
$node_(66) set Y_ 598 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1581 
$node_(67) set Y_ 89 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1032 
$node_(68) set Y_ 471 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1061 
$node_(69) set Y_ 497 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2785 
$node_(70) set Y_ 678 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1767 
$node_(71) set Y_ 38 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1686 
$node_(72) set Y_ 999 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 392 
$node_(73) set Y_ 143 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 2893 
$node_(74) set Y_ 32 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2339 
$node_(75) set Y_ 664 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 2846 
$node_(76) set Y_ 506 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 570 
$node_(77) set Y_ 908 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2175 
$node_(78) set Y_ 938 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1093 
$node_(79) set Y_ 773 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2284 
$node_(80) set Y_ 412 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 1566 
$node_(81) set Y_ 186 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 902 
$node_(82) set Y_ 704 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 951 
$node_(83) set Y_ 241 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1759 
$node_(84) set Y_ 46 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 1182 
$node_(85) set Y_ 663 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 678 
$node_(86) set Y_ 595 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 715 
$node_(87) set Y_ 738 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2637 
$node_(88) set Y_ 56 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 307 
$node_(89) set Y_ 406 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 1927 
$node_(90) set Y_ 974 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1688 
$node_(91) set Y_ 7 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 240 
$node_(92) set Y_ 932 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2737 
$node_(93) set Y_ 66 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2537 
$node_(94) set Y_ 255 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 499 
$node_(95) set Y_ 608 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 687 
$node_(96) set Y_ 847 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2781 
$node_(97) set Y_ 691 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 2295 
$node_(98) set Y_ 491 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2225 
$node_(99) set Y_ 257 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 773 257 17.0" 
$ns at 175.15750646577285 "$node_(0) setdest 517 676 11.0" 
$ns at 223.4694860012637 "$node_(0) setdest 1146 989 1.0" 
$ns at 290.6505637941957 "$node_(0) setdest 2032 94 8.0" 
$ns at 412.1860424381983 "$node_(0) setdest 821 758 15.0" 
$ns at 720.9022287105802 "$node_(0) setdest 2422 313 1.0" 
$ns at 0.0 "$node_(1) setdest 2802 324 13.0" 
$ns at 99.4694872199059 "$node_(1) setdest 2159 624 3.0" 
$ns at 141.76006519460682 "$node_(1) setdest 1343 753 12.0" 
$ns at 238.46874617367104 "$node_(1) setdest 1057 39 17.0" 
$ns at 373.0301311758229 "$node_(1) setdest 125 481 17.0" 
$ns at 686.3934943425031 "$node_(1) setdest 181 166 2.0" 
$ns at 0.0 "$node_(2) setdest 371 137 2.0" 
$ns at 30.010468608789658 "$node_(2) setdest 116 535 18.0" 
$ns at 167.9260668663817 "$node_(2) setdest 689 338 4.0" 
$ns at 236.37367117069078 "$node_(2) setdest 256 224 10.0" 
$ns at 387.9935803542113 "$node_(2) setdest 150 915 1.0" 
$ns at 628.4017516108444 "$node_(2) setdest 1503 859 12.0" 
$ns at 0.0 "$node_(3) setdest 2902 266 3.0" 
$ns at 26.04379273380819 "$node_(3) setdest 544 311 2.0" 
$ns at 57.70643024787795 "$node_(3) setdest 2329 801 19.0" 
$ns at 247.58090315134075 "$node_(3) setdest 589 695 10.0" 
$ns at 443.5543965675598 "$node_(3) setdest 1541 690 9.0" 
$ns at 742.659500232163 "$node_(3) setdest 1246 472 14.0" 
$ns at 0.0 "$node_(4) setdest 1718 357 2.0" 
$ns at 16.615031017465768 "$node_(4) setdest 2905 770 5.0" 
$ns at 92.61808305409205 "$node_(4) setdest 1595 443 20.0" 
$ns at 345.1727260257422 "$node_(4) setdest 1821 228 8.0" 
$ns at 501.84621546999205 "$node_(4) setdest 1097 187 9.0" 
$ns at 744.5785870681149 "$node_(4) setdest 761 956 15.0" 
$ns at 0.0 "$node_(5) setdest 2924 424 1.0" 
$ns at 16.732767227363954 "$node_(5) setdest 893 451 3.0" 
$ns at 58.702372418534736 "$node_(5) setdest 591 682 7.0" 
$ns at 160.01228134306172 "$node_(5) setdest 1308 535 16.0" 
$ns at 328.43088193855357 "$node_(5) setdest 2219 52 17.0" 
$ns at 680.5469096142069 "$node_(5) setdest 333 660 16.0" 
$ns at 0.0 "$node_(6) setdest 2094 816 1.0" 
$ns at 23.048975781784463 "$node_(6) setdest 2526 155 6.0" 
$ns at 109.00222588591788 "$node_(6) setdest 1772 26 4.0" 
$ns at 203.93616758074876 "$node_(6) setdest 30 248 13.0" 
$ns at 340.49617314676794 "$node_(6) setdest 262 490 13.0" 
$ns at 684.0991428042713 "$node_(6) setdest 2649 950 8.0" 
$ns at 0.0 "$node_(7) setdest 2559 883 1.0" 
$ns at 20.56932114810346 "$node_(7) setdest 2848 126 9.0" 
$ns at 110.90032200136363 "$node_(7) setdest 557 928 2.0" 
$ns at 185.29808829772816 "$node_(7) setdest 2525 340 5.0" 
$ns at 312.3136633242761 "$node_(7) setdest 1124 860 11.0" 
$ns at 559.52214826104 "$node_(7) setdest 1260 303 13.0" 
$ns at 0.0 "$node_(8) setdest 2853 628 1.0" 
$ns at 15.756573280634855 "$node_(8) setdest 2404 9 9.0" 
$ns at 83.53477866381492 "$node_(8) setdest 782 549 6.0" 
$ns at 161.76019563081996 "$node_(8) setdest 1173 886 10.0" 
$ns at 283.81611749490605 "$node_(8) setdest 99 356 18.0" 
$ns at 684.888137911789 "$node_(8) setdest 667 554 5.0" 
$ns at 0.0 "$node_(9) setdest 2618 864 8.0" 
$ns at 77.00170701900667 "$node_(9) setdest 428 6 5.0" 
$ns at 142.73478696310212 "$node_(9) setdest 2543 698 4.0" 
$ns at 213.94719942053706 "$node_(9) setdest 1983 314 7.0" 
$ns at 353.4741330031522 "$node_(9) setdest 1807 799 14.0" 
$ns at 627.675058223542 "$node_(9) setdest 1489 172 2.0" 
$ns at 0.0 "$node_(10) setdest 2010 659 14.0" 
$ns at 128.97043913794624 "$node_(10) setdest 403 873 15.0" 
$ns at 177.21768177606313 "$node_(10) setdest 2731 492 2.0" 
$ns at 247.50013878129715 "$node_(10) setdest 2819 548 4.0" 
$ns at 396.2593012465212 "$node_(10) setdest 744 811 12.0" 
$ns at 675.5579729209663 "$node_(10) setdest 1884 738 11.0" 
$ns at 0.0 "$node_(11) setdest 416 89 8.0" 
$ns at 80.11712872940377 "$node_(11) setdest 431 657 13.0" 
$ns at 126.20430761108692 "$node_(11) setdest 1308 500 4.0" 
$ns at 207.5919149407967 "$node_(11) setdest 749 694 12.0" 
$ns at 338.2083102847183 "$node_(11) setdest 1769 907 19.0" 
$ns at 635.7326163876162 "$node_(11) setdest 1128 15 10.0" 
$ns at 0.0 "$node_(12) setdest 1036 591 2.0" 
$ns at 15.586694187572492 "$node_(12) setdest 1583 333 11.0" 
$ns at 64.4445758502615 "$node_(12) setdest 1127 398 8.0" 
$ns at 139.23017244774442 "$node_(12) setdest 926 181 8.0" 
$ns at 280.18474948138794 "$node_(12) setdest 1551 278 1.0" 
$ns at 521.630894940368 "$node_(12) setdest 1057 265 16.0" 
$ns at 0.0 "$node_(13) setdest 1612 419 18.0" 
$ns at 184.0164633993113 "$node_(13) setdest 2161 742 12.0" 
$ns at 302.91054944702194 "$node_(13) setdest 1838 432 8.0" 
$ns at 377.0348963772092 "$node_(13) setdest 188 493 6.0" 
$ns at 529.6298134789841 "$node_(13) setdest 2803 295 15.0" 
$ns at 793.7854020156271 "$node_(13) setdest 1778 722 16.0" 
$ns at 0.0 "$node_(14) setdest 380 9 18.0" 
$ns at 99.70617623231674 "$node_(14) setdest 537 477 12.0" 
$ns at 188.33794306092875 "$node_(14) setdest 1202 185 18.0" 
$ns at 341.8421829390659 "$node_(14) setdest 304 910 15.0" 
$ns at 601.142028698458 "$node_(14) setdest 1844 2 10.0" 
$ns at 0.0 "$node_(15) setdest 831 365 3.0" 
$ns at 32.97206183690902 "$node_(15) setdest 2024 255 11.0" 
$ns at 98.65945359246375 "$node_(15) setdest 4 624 20.0" 
$ns at 327.53486181023 "$node_(15) setdest 2833 450 8.0" 
$ns at 450.42969064294175 "$node_(15) setdest 1530 899 15.0" 
$ns at 753.4128324672108 "$node_(15) setdest 1784 144 7.0" 
$ns at 0.0 "$node_(16) setdest 2725 392 12.0" 
$ns at 95.17900000258273 "$node_(16) setdest 196 995 13.0" 
$ns at 139.584941723947 "$node_(16) setdest 818 509 8.0" 
$ns at 249.90113068035924 "$node_(16) setdest 200 232 3.0" 
$ns at 382.79995528024943 "$node_(16) setdest 2916 66 13.0" 
$ns at 717.3261247218711 "$node_(16) setdest 2391 486 14.0" 
$ns at 0.0 "$node_(17) setdest 1533 62 1.0" 
$ns at 24.32979951530381 "$node_(17) setdest 899 214 12.0" 
$ns at 86.2724760540082 "$node_(17) setdest 1339 854 1.0" 
$ns at 151.66886852208455 "$node_(17) setdest 415 142 1.0" 
$ns at 277.86052566617116 "$node_(17) setdest 527 811 14.0" 
$ns at 651.1316459661527 "$node_(17) setdest 2438 468 4.0" 
$ns at 0.0 "$node_(18) setdest 1958 788 13.0" 
$ns at 32.08025997457764 "$node_(18) setdest 1785 755 19.0" 
$ns at 244.9923288078464 "$node_(18) setdest 967 997 19.0" 
$ns at 417.4246241879565 "$node_(18) setdest 2126 732 6.0" 
$ns at 555.6361683770975 "$node_(18) setdest 2515 104 6.0" 
$ns at 801.0194711931098 "$node_(18) setdest 82 459 6.0" 
$ns at 0.0 "$node_(19) setdest 1056 643 8.0" 
$ns at 47.42371908420878 "$node_(19) setdest 2160 569 6.0" 
$ns at 105.9863547560702 "$node_(19) setdest 1290 65 14.0" 
$ns at 285.86895467457236 "$node_(19) setdest 1550 530 7.0" 
$ns at 474.25564372187023 "$node_(19) setdest 2703 19 4.0" 
$ns at 731.9230571336005 "$node_(19) setdest 1569 148 3.0" 
$ns at 0.0 "$node_(20) setdest 540 690 7.0" 
$ns at 68.06090637233791 "$node_(20) setdest 2261 757 19.0" 
$ns at 236.10436758340566 "$node_(20) setdest 2616 275 5.0" 
$ns at 300.2945190709769 "$node_(20) setdest 2464 815 1.0" 
$ns at 428.8126600704186 "$node_(20) setdest 2125 929 10.0" 
$ns at 696.4267332559918 "$node_(20) setdest 1329 848 4.0" 
$ns at 0.0 "$node_(21) setdest 333 766 6.0" 
$ns at 37.44928905473722 "$node_(21) setdest 2102 967 14.0" 
$ns at 201.58817275012476 "$node_(21) setdest 2822 747 12.0" 
$ns at 268.05280054646653 "$node_(21) setdest 686 396 2.0" 
$ns at 396.24249325468014 "$node_(21) setdest 685 535 6.0" 
$ns at 655.9813498398073 "$node_(21) setdest 2249 732 16.0" 
$ns at 0.0 "$node_(22) setdest 2812 645 13.0" 
$ns at 33.46519414010571 "$node_(22) setdest 1923 891 4.0" 
$ns at 94.27544914250657 "$node_(22) setdest 193 484 15.0" 
$ns at 265.37377938691236 "$node_(22) setdest 1361 941 16.0" 
$ns at 472.09747279274256 "$node_(22) setdest 1859 99 8.0" 
$ns at 790.7508374181646 "$node_(22) setdest 1679 286 11.0" 
$ns at 0.0 "$node_(23) setdest 899 719 20.0" 
$ns at 208.67327604969665 "$node_(23) setdest 1070 908 4.0" 
$ns at 277.3699427213304 "$node_(23) setdest 2671 431 9.0" 
$ns at 394.4105437767137 "$node_(23) setdest 2099 614 6.0" 
$ns at 544.3996464597292 "$node_(23) setdest 2133 563 10.0" 
$ns at 806.1072595019401 "$node_(23) setdest 1480 510 17.0" 
$ns at 0.0 "$node_(24) setdest 1941 604 12.0" 
$ns at 102.00411933668758 "$node_(24) setdest 1840 148 1.0" 
$ns at 141.4169578571787 "$node_(24) setdest 1706 756 15.0" 
$ns at 322.1316798029692 "$node_(24) setdest 1765 61 15.0" 
$ns at 458.6390013521588 "$node_(24) setdest 577 437 12.0" 
$ns at 778.025352223302 "$node_(24) setdest 2144 627 9.0" 
$ns at 0.0 "$node_(25) setdest 2045 322 1.0" 
$ns at 24.179534174667253 "$node_(25) setdest 1588 497 11.0" 
$ns at 114.69675549058726 "$node_(25) setdest 1613 755 12.0" 
$ns at 241.73292517730283 "$node_(25) setdest 2466 14 14.0" 
$ns at 499.04463077640173 "$node_(25) setdest 1757 616 9.0" 
$ns at 771.0404323441403 "$node_(25) setdest 1815 354 10.0" 
$ns at 0.0 "$node_(26) setdest 300 961 17.0" 
$ns at 86.00529722787208 "$node_(26) setdest 2163 324 13.0" 
$ns at 208.3901657742129 "$node_(26) setdest 1128 46 13.0" 
$ns at 367.285104772595 "$node_(26) setdest 47 49 16.0" 
$ns at 592.192412676108 "$node_(26) setdest 887 530 1.0" 
$ns at 832.5915362996649 "$node_(26) setdest 737 984 18.0" 
$ns at 0.0 "$node_(27) setdest 2058 971 12.0" 
$ns at 116.00594423090469 "$node_(27) setdest 459 965 6.0" 
$ns at 155.99368715513816 "$node_(27) setdest 1582 932 14.0" 
$ns at 240.97039017815658 "$node_(27) setdest 1140 262 11.0" 
$ns at 463.6833694766681 "$node_(27) setdest 919 274 3.0" 
$ns at 706.0837731990649 "$node_(27) setdest 444 830 4.0" 
$ns at 0.0 "$node_(28) setdest 198 485 14.0" 
$ns at 74.96928322041637 "$node_(28) setdest 2640 230 5.0" 
$ns at 112.41955348776986 "$node_(28) setdest 2866 110 4.0" 
$ns at 189.5214358253676 "$node_(28) setdest 568 905 17.0" 
$ns at 448.8818064915017 "$node_(28) setdest 980 625 11.0" 
$ns at 728.0030639462257 "$node_(28) setdest 2737 792 20.0" 
$ns at 0.0 "$node_(29) setdest 2058 332 9.0" 
$ns at 59.26481984532418 "$node_(29) setdest 333 463 18.0" 
$ns at 250.33634508808825 "$node_(29) setdest 118 109 11.0" 
$ns at 350.34743223810653 "$node_(29) setdest 650 252 14.0" 
$ns at 585.0406483141082 "$node_(29) setdest 1335 94 6.0" 
$ns at 867.608389738537 "$node_(29) setdest 2251 81 14.0" 
$ns at 0.0 "$node_(30) setdest 2445 640 10.0" 
$ns at 94.87484401221757 "$node_(30) setdest 850 939 17.0" 
$ns at 164.76958392715514 "$node_(30) setdest 813 122 15.0" 
$ns at 225.95333897257396 "$node_(30) setdest 1723 221 1.0" 
$ns at 351.38895213153614 "$node_(30) setdest 1813 419 4.0" 
$ns at 623.1052590730408 "$node_(30) setdest 159 382 5.0" 
$ns at 0.0 "$node_(31) setdest 1918 171 16.0" 
$ns at 87.87701521977787 "$node_(31) setdest 229 619 12.0" 
$ns at 204.13217147025028 "$node_(31) setdest 1660 124 9.0" 
$ns at 295.293255425758 "$node_(31) setdest 1908 532 3.0" 
$ns at 440.4865610350747 "$node_(31) setdest 1355 154 16.0" 
$ns at 744.4609251457109 "$node_(31) setdest 1324 972 1.0" 
$ns at 0.0 "$node_(32) setdest 2254 810 7.0" 
$ns at 25.25623961266657 "$node_(32) setdest 1651 540 15.0" 
$ns at 204.32507963400607 "$node_(32) setdest 509 439 4.0" 
$ns at 288.10266074906025 "$node_(32) setdest 2947 428 1.0" 
$ns at 417.20167661134184 "$node_(32) setdest 1124 243 4.0" 
$ns at 682.3047039220309 "$node_(32) setdest 2936 582 13.0" 
$ns at 0.0 "$node_(33) setdest 1777 837 7.0" 
$ns at 71.94610497422477 "$node_(33) setdest 2535 371 5.0" 
$ns at 121.71741492325265 "$node_(33) setdest 2176 152 16.0" 
$ns at 304.24435856552526 "$node_(33) setdest 1638 236 13.0" 
$ns at 441.7524891165562 "$node_(33) setdest 2342 752 14.0" 
$ns at 745.4869789043498 "$node_(33) setdest 1444 16 2.0" 
$ns at 0.0 "$node_(34) setdest 1987 910 1.0" 
$ns at 16.149440590265797 "$node_(34) setdest 349 913 4.0" 
$ns at 85.04636371281039 "$node_(34) setdest 1868 14 1.0" 
$ns at 151.37849226060774 "$node_(34) setdest 1186 298 2.0" 
$ns at 282.7098586375955 "$node_(34) setdest 2790 142 7.0" 
$ns at 563.2602147013555 "$node_(34) setdest 330 829 10.0" 
$ns at 0.0 "$node_(35) setdest 1641 885 20.0" 
$ns at 66.22862460786557 "$node_(35) setdest 1964 563 9.0" 
$ns at 132.77917440417616 "$node_(35) setdest 2635 754 5.0" 
$ns at 214.0276529918475 "$node_(35) setdest 2512 43 18.0" 
$ns at 389.2596976370096 "$node_(35) setdest 2635 744 11.0" 
$ns at 694.8125359523008 "$node_(35) setdest 2029 559 2.0" 
$ns at 0.0 "$node_(36) setdest 241 897 10.0" 
$ns at 17.965363344822048 "$node_(36) setdest 1070 29 7.0" 
$ns at 85.81692970946214 "$node_(36) setdest 1016 943 8.0" 
$ns at 213.33378995116942 "$node_(36) setdest 2328 231 18.0" 
$ns at 375.0246487162168 "$node_(36) setdest 1026 346 10.0" 
$ns at 702.07454401512 "$node_(36) setdest 1041 314 1.0" 
$ns at 0.0 "$node_(37) setdest 577 344 12.0" 
$ns at 33.678516914261095 "$node_(37) setdest 2980 818 9.0" 
$ns at 107.70574465397586 "$node_(37) setdest 1821 811 14.0" 
$ns at 202.75769926643505 "$node_(37) setdest 1511 653 12.0" 
$ns at 416.55413797285433 "$node_(37) setdest 1609 25 4.0" 
$ns at 683.8892419420174 "$node_(37) setdest 2044 739 13.0" 
$ns at 0.0 "$node_(38) setdest 772 672 13.0" 
$ns at 49.10593299099078 "$node_(38) setdest 2857 268 10.0" 
$ns at 132.02652090674886 "$node_(38) setdest 704 670 14.0" 
$ns at 205.68629728409343 "$node_(38) setdest 1109 798 11.0" 
$ns at 411.568138155949 "$node_(38) setdest 923 643 9.0" 
$ns at 695.8963537820271 "$node_(38) setdest 544 628 19.0" 
$ns at 0.0 "$node_(39) setdest 2993 130 14.0" 
$ns at 28.464817407357693 "$node_(39) setdest 1179 174 8.0" 
$ns at 78.83596727774035 "$node_(39) setdest 2979 857 10.0" 
$ns at 234.94456863630307 "$node_(39) setdest 2990 283 11.0" 
$ns at 409.6979273063507 "$node_(39) setdest 314 658 20.0" 
$ns at 730.1708156554208 "$node_(39) setdest 2382 720 3.0" 
$ns at 0.0 "$node_(40) setdest 758 877 4.0" 
$ns at 47.06404466034465 "$node_(40) setdest 2977 250 12.0" 
$ns at 160.68463988130287 "$node_(40) setdest 819 325 12.0" 
$ns at 310.7454179478874 "$node_(40) setdest 2973 61 4.0" 
$ns at 447.4134592063805 "$node_(40) setdest 1825 138 8.0" 
$ns at 701.7126899199591 "$node_(40) setdest 132 448 12.0" 
$ns at 0.0 "$node_(41) setdest 511 106 2.0" 
$ns at 22.209259823053905 "$node_(41) setdest 2154 993 10.0" 
$ns at 90.29563891381582 "$node_(41) setdest 2809 310 19.0" 
$ns at 329.68220719805004 "$node_(41) setdest 962 684 19.0" 
$ns at 531.4148622584687 "$node_(41) setdest 215 149 11.0" 
$ns at 815.4294677591106 "$node_(41) setdest 2202 682 1.0" 
$ns at 0.0 "$node_(42) setdest 1903 88 6.0" 
$ns at 46.8364596003548 "$node_(42) setdest 944 694 8.0" 
$ns at 119.35155535316349 "$node_(42) setdest 482 712 13.0" 
$ns at 301.0692795478178 "$node_(42) setdest 2404 162 14.0" 
$ns at 479.969816002563 "$node_(42) setdest 2047 909 13.0" 
$ns at 795.9679659012727 "$node_(42) setdest 1180 723 2.0" 
$ns at 0.0 "$node_(43) setdest 2929 280 7.0" 
$ns at 76.15916890678858 "$node_(43) setdest 1300 640 2.0" 
$ns at 124.02831826288586 "$node_(43) setdest 298 91 17.0" 
$ns at 326.31571086394166 "$node_(43) setdest 1105 174 5.0" 
$ns at 468.56849462332315 "$node_(43) setdest 1513 360 12.0" 
$ns at 754.4718909513792 "$node_(43) setdest 2736 95 8.0" 
$ns at 0.0 "$node_(44) setdest 883 905 4.0" 
$ns at 43.48275662417333 "$node_(44) setdest 1761 790 4.0" 
$ns at 108.75886739932113 "$node_(44) setdest 1233 443 19.0" 
$ns at 228.41851697162255 "$node_(44) setdest 222 680 18.0" 
$ns at 525.8939965188855 "$node_(44) setdest 2429 63 3.0" 
$ns at 771.1419462624284 "$node_(44) setdest 118 897 1.0" 
$ns at 0.0 "$node_(45) setdest 2770 656 2.0" 
$ns at 17.087500788059003 "$node_(45) setdest 1109 428 1.0" 
$ns at 47.347627558288835 "$node_(45) setdest 2887 142 8.0" 
$ns at 132.70917485501616 "$node_(45) setdest 2968 194 6.0" 
$ns at 311.91589607995184 "$node_(45) setdest 2564 572 16.0" 
$ns at 658.6674311314437 "$node_(45) setdest 2060 753 20.0" 
$ns at 0.0 "$node_(46) setdest 2630 427 4.0" 
$ns at 22.201210155447512 "$node_(46) setdest 1864 599 12.0" 
$ns at 162.90625483791752 "$node_(46) setdest 815 714 14.0" 
$ns at 331.2384387560249 "$node_(46) setdest 1339 257 10.0" 
$ns at 514.5480608541617 "$node_(46) setdest 1241 679 9.0" 
$ns at 783.1751535112172 "$node_(46) setdest 627 635 6.0" 
$ns at 0.0 "$node_(47) setdest 927 220 14.0" 
$ns at 74.09797947692832 "$node_(47) setdest 1408 335 17.0" 
$ns at 131.8014842475352 "$node_(47) setdest 1483 337 1.0" 
$ns at 197.7828950843533 "$node_(47) setdest 905 881 7.0" 
$ns at 324.5669971634857 "$node_(47) setdest 1880 194 8.0" 
$ns at 620.0717233989069 "$node_(47) setdest 331 80 4.0" 
$ns at 0.0 "$node_(48) setdest 952 634 10.0" 
$ns at 88.87816870198421 "$node_(48) setdest 1300 960 6.0" 
$ns at 175.84457481728688 "$node_(48) setdest 38 223 12.0" 
$ns at 307.78833077036165 "$node_(48) setdest 484 994 14.0" 
$ns at 526.8635844302858 "$node_(48) setdest 2910 151 16.0" 
$ns at 780.8094555228993 "$node_(48) setdest 2539 586 6.0" 
$ns at 0.0 "$node_(49) setdest 1890 583 7.0" 
$ns at 43.888240734301995 "$node_(49) setdest 78 992 6.0" 
$ns at 95.75517938783005 "$node_(49) setdest 2811 286 11.0" 
$ns at 170.5312739270086 "$node_(49) setdest 2219 164 1.0" 
$ns at 293.1841819029477 "$node_(49) setdest 1224 607 15.0" 
$ns at 681.8810788443404 "$node_(49) setdest 1989 210 4.0" 
$ns at 0.0 "$node_(50) setdest 1 155 11.0" 
$ns at 44.56627960733251 "$node_(50) setdest 1601 429 1.0" 
$ns at 79.65467996014897 "$node_(50) setdest 236 738 11.0" 
$ns at 204.3653692365939 "$node_(50) setdest 2395 121 16.0" 
$ns at 397.9426896799199 "$node_(50) setdest 104 420 8.0" 
$ns at 659.4100468172682 "$node_(50) setdest 1963 649 14.0" 
$ns at 0.0 "$node_(51) setdest 1070 754 5.0" 
$ns at 47.4902467088356 "$node_(51) setdest 2727 437 13.0" 
$ns at 204.0105869706184 "$node_(51) setdest 600 537 13.0" 
$ns at 267.94358633713125 "$node_(51) setdest 1019 874 2.0" 
$ns at 400.20462341856717 "$node_(51) setdest 2296 667 1.0" 
$ns at 641.2268285254011 "$node_(51) setdest 1417 328 18.0" 
$ns at 0.0 "$node_(52) setdest 72 932 5.0" 
$ns at 16.98141950675121 "$node_(52) setdest 2885 729 17.0" 
$ns at 107.76714915099245 "$node_(52) setdest 1816 807 11.0" 
$ns at 236.7397878076875 "$node_(52) setdest 2971 426 1.0" 
$ns at 358.798627589187 "$node_(52) setdest 2647 608 17.0" 
$ns at 611.7399152382382 "$node_(52) setdest 1117 270 16.0" 
$ns at 0.0 "$node_(53) setdest 1708 567 19.0" 
$ns at 95.60141650431798 "$node_(53) setdest 836 144 3.0" 
$ns at 149.71011956023614 "$node_(53) setdest 1119 670 2.0" 
$ns at 222.88875698180092 "$node_(53) setdest 2294 381 16.0" 
$ns at 488.1331028743771 "$node_(53) setdest 1504 338 9.0" 
$ns at 814.8865246335824 "$node_(53) setdest 1580 787 2.0" 
$ns at 0.0 "$node_(54) setdest 252 281 14.0" 
$ns at 117.20305305172 "$node_(54) setdest 1671 226 1.0" 
$ns at 154.75764109514336 "$node_(54) setdest 2395 110 7.0" 
$ns at 230.59833918908635 "$node_(54) setdest 1891 965 9.0" 
$ns at 357.0564495059377 "$node_(54) setdest 773 539 15.0" 
$ns at 608.4105353013327 "$node_(54) setdest 2381 252 1.0" 
$ns at 0.0 "$node_(55) setdest 2878 254 7.0" 
$ns at 80.07687911950538 "$node_(55) setdest 863 811 11.0" 
$ns at 155.445540310502 "$node_(55) setdest 2539 788 14.0" 
$ns at 353.5405316544617 "$node_(55) setdest 1707 241 5.0" 
$ns at 519.0711672405421 "$node_(55) setdest 2332 979 16.0" 
$ns at 798.600108734687 "$node_(55) setdest 1113 494 17.0" 
$ns at 0.0 "$node_(56) setdest 1397 845 15.0" 
$ns at 113.22162669656646 "$node_(56) setdest 2899 915 2.0" 
$ns at 155.01934480029578 "$node_(56) setdest 2029 961 10.0" 
$ns at 266.1058714224014 "$node_(56) setdest 194 536 15.0" 
$ns at 508.9369841463367 "$node_(56) setdest 2225 660 8.0" 
$ns at 813.9186747702022 "$node_(56) setdest 61 588 1.0" 
$ns at 0.0 "$node_(57) setdest 2075 654 9.0" 
$ns at 51.534287660385566 "$node_(57) setdest 817 432 15.0" 
$ns at 224.33806522907955 "$node_(57) setdest 1649 897 19.0" 
$ns at 303.98249951852154 "$node_(57) setdest 590 373 7.0" 
$ns at 462.8633578748054 "$node_(57) setdest 1791 773 16.0" 
$ns at 726.9979319699539 "$node_(57) setdest 2385 63 11.0" 
$ns at 0.0 "$node_(58) setdest 1959 945 1.0" 
$ns at 21.990314164967174 "$node_(58) setdest 2678 439 13.0" 
$ns at 160.17956068202366 "$node_(58) setdest 2026 450 8.0" 
$ns at 233.57709171388652 "$node_(58) setdest 2336 421 5.0" 
$ns at 366.16287609439826 "$node_(58) setdest 690 853 18.0" 
$ns at 722.7157925878844 "$node_(58) setdest 1367 814 13.0" 
$ns at 0.0 "$node_(59) setdest 1894 574 14.0" 
$ns at 118.4455965135219 "$node_(59) setdest 2794 125 3.0" 
$ns at 151.60299250952528 "$node_(59) setdest 2405 687 20.0" 
$ns at 304.43251511387246 "$node_(59) setdest 669 248 1.0" 
$ns at 429.03331795872043 "$node_(59) setdest 463 799 3.0" 
$ns at 673.6994133624241 "$node_(59) setdest 22 239 4.0" 
$ns at 0.0 "$node_(60) setdest 146 821 18.0" 
$ns at 97.61855882544334 "$node_(60) setdest 240 615 8.0" 
$ns at 193.73233312697158 "$node_(60) setdest 1856 731 7.0" 
$ns at 313.2017835281757 "$node_(60) setdest 196 902 15.0" 
$ns at 539.3357088846399 "$node_(60) setdest 78 645 4.0" 
$ns at 791.4537456198595 "$node_(60) setdest 114 379 17.0" 
$ns at 0.0 "$node_(61) setdest 1307 790 12.0" 
$ns at 17.115682975802073 "$node_(61) setdest 2978 239 14.0" 
$ns at 131.47691043717526 "$node_(61) setdest 815 205 1.0" 
$ns at 194.79804136017282 "$node_(61) setdest 995 598 13.0" 
$ns at 349.8352939888159 "$node_(61) setdest 1633 251 18.0" 
$ns at 631.5698614577078 "$node_(61) setdest 2399 92 17.0" 
$ns at 0.0 "$node_(62) setdest 927 268 18.0" 
$ns at 31.26974227812753 "$node_(62) setdest 1612 988 17.0" 
$ns at 215.895631025419 "$node_(62) setdest 1649 955 15.0" 
$ns at 356.76222565832023 "$node_(62) setdest 556 41 13.0" 
$ns at 493.4319061458215 "$node_(62) setdest 131 308 8.0" 
$ns at 782.2652963230613 "$node_(62) setdest 624 534 17.0" 
$ns at 0.0 "$node_(63) setdest 15 198 9.0" 
$ns at 64.36919829932259 "$node_(63) setdest 2608 227 6.0" 
$ns at 143.6405738348154 "$node_(63) setdest 1671 921 13.0" 
$ns at 324.9014925756504 "$node_(63) setdest 1591 151 9.0" 
$ns at 474.70663741313183 "$node_(63) setdest 1016 301 7.0" 
$ns at 715.2288468117288 "$node_(63) setdest 594 478 1.0" 
$ns at 0.0 "$node_(64) setdest 2372 173 19.0" 
$ns at 84.05445164866117 "$node_(64) setdest 1502 899 10.0" 
$ns at 200.50283733749933 "$node_(64) setdest 2776 347 14.0" 
$ns at 311.65817366441104 "$node_(64) setdest 1544 237 3.0" 
$ns at 438.0742094941907 "$node_(64) setdest 1887 357 7.0" 
$ns at 745.9439076205681 "$node_(64) setdest 358 244 1.0" 
$ns at 0.0 "$node_(65) setdest 2401 601 4.0" 
$ns at 48.061821911605115 "$node_(65) setdest 2412 786 13.0" 
$ns at 203.64827203792365 "$node_(65) setdest 2619 691 2.0" 
$ns at 279.91814335915376 "$node_(65) setdest 318 877 2.0" 
$ns at 403.9616055973595 "$node_(65) setdest 1568 101 4.0" 
$ns at 659.5789602040813 "$node_(65) setdest 308 273 2.0" 
$ns at 0.0 "$node_(66) setdest 1838 437 1.0" 
$ns at 19.250980071276953 "$node_(66) setdest 1902 574 7.0" 
$ns at 98.5589050575982 "$node_(66) setdest 2031 927 19.0" 
$ns at 230.92489456401213 "$node_(66) setdest 546 45 1.0" 
$ns at 352.5124562363046 "$node_(66) setdest 1468 943 1.0" 
$ns at 592.6362679563128 "$node_(66) setdest 1751 617 11.0" 
$ns at 0.0 "$node_(67) setdest 1573 649 18.0" 
$ns at 188.3780086888302 "$node_(67) setdest 2996 771 4.0" 
$ns at 231.70199855001283 "$node_(67) setdest 1067 111 7.0" 
$ns at 355.4267372718553 "$node_(67) setdest 2449 258 13.0" 
$ns at 538.9604061553295 "$node_(67) setdest 888 440 8.0" 
$ns at 790.9483584125763 "$node_(67) setdest 1246 876 15.0" 
$ns at 0.0 "$node_(68) setdest 2487 800 20.0" 
$ns at 168.63980392414538 "$node_(68) setdest 2900 738 11.0" 
$ns at 230.49353715001573 "$node_(68) setdest 1895 379 12.0" 
$ns at 385.77988560476206 "$node_(68) setdest 2071 769 6.0" 
$ns at 533.9285307976899 "$node_(68) setdest 722 637 16.0" 
$ns at 0.0 "$node_(69) setdest 766 354 18.0" 
$ns at 65.97664629751308 "$node_(69) setdest 1987 419 10.0" 
$ns at 103.18003677362745 "$node_(69) setdest 714 377 15.0" 
$ns at 186.34428243152013 "$node_(69) setdest 1431 773 17.0" 
$ns at 446.0964906655163 "$node_(69) setdest 2463 81 8.0" 
$ns at 727.4888139590312 "$node_(69) setdest 713 538 1.0" 
$ns at 0.0 "$node_(70) setdest 472 476 12.0" 
$ns at 93.54707417970793 "$node_(70) setdest 651 53 13.0" 
$ns at 241.55503402377798 "$node_(70) setdest 216 239 15.0" 
$ns at 342.96226551561574 "$node_(70) setdest 2394 556 19.0" 
$ns at 493.24865042618745 "$node_(70) setdest 95 322 1.0" 
$ns at 736.8799221471929 "$node_(70) setdest 194 112 1.0" 
$ns at 0.0 "$node_(71) setdest 1668 717 20.0" 
$ns at 23.90895736951012 "$node_(71) setdest 1173 143 1.0" 
$ns at 55.015612176256276 "$node_(71) setdest 1486 89 12.0" 
$ns at 178.07418579377486 "$node_(71) setdest 227 905 12.0" 
$ns at 392.98443247733314 "$node_(71) setdest 2557 240 12.0" 
$ns at 673.6175721535626 "$node_(71) setdest 998 485 4.0" 
$ns at 0.0 "$node_(72) setdest 219 599 16.0" 
$ns at 84.86678079767826 "$node_(72) setdest 529 152 10.0" 
$ns at 141.2860666842466 "$node_(72) setdest 2944 199 2.0" 
$ns at 219.21231160775557 "$node_(72) setdest 39 142 15.0" 
$ns at 342.85639065430286 "$node_(72) setdest 2359 860 16.0" 
$ns at 623.2641906012591 "$node_(72) setdest 2943 218 12.0" 
$ns at 0.0 "$node_(73) setdest 2502 515 6.0" 
$ns at 59.004328110888416 "$node_(73) setdest 1038 571 5.0" 
$ns at 123.0145647757748 "$node_(73) setdest 93 902 10.0" 
$ns at 274.44888981525935 "$node_(73) setdest 1500 913 6.0" 
$ns at 447.8894373146477 "$node_(73) setdest 360 71 20.0" 
$ns at 800.2761911136076 "$node_(73) setdest 1091 827 11.0" 
$ns at 0.0 "$node_(74) setdest 669 414 13.0" 
$ns at 104.22410382340915 "$node_(74) setdest 738 720 12.0" 
$ns at 224.66512447867888 "$node_(74) setdest 1016 180 7.0" 
$ns at 289.71385929004634 "$node_(74) setdest 1371 946 1.0" 
$ns at 415.04364569663926 "$node_(74) setdest 2142 678 3.0" 
$ns at 679.2516723064991 "$node_(74) setdest 694 950 19.0" 
$ns at 0.0 "$node_(75) setdest 795 618 19.0" 
$ns at 124.73665204101606 "$node_(75) setdest 2271 494 19.0" 
$ns at 208.22446031490912 "$node_(75) setdest 1434 314 9.0" 
$ns at 335.9897010669426 "$node_(75) setdest 1087 318 20.0" 
$ns at 640.3147993065468 "$node_(75) setdest 1376 693 4.0" 
$ns at 0.0 "$node_(76) setdest 496 797 1.0" 
$ns at 18.681304741554136 "$node_(76) setdest 196 314 8.0" 
$ns at 98.05832150907759 "$node_(76) setdest 2183 450 10.0" 
$ns at 216.60014111271443 "$node_(76) setdest 873 875 10.0" 
$ns at 372.52806947579677 "$node_(76) setdest 1578 352 10.0" 
$ns at 661.2869296186373 "$node_(76) setdest 985 884 13.0" 
$ns at 0.0 "$node_(77) setdest 837 815 19.0" 
$ns at 28.289153683648596 "$node_(77) setdest 2972 478 18.0" 
$ns at 107.24710056985188 "$node_(77) setdest 1327 899 19.0" 
$ns at 267.67568697034835 "$node_(77) setdest 1240 583 2.0" 
$ns at 399.8847250360396 "$node_(77) setdest 1232 581 9.0" 
$ns at 686.0161351433471 "$node_(77) setdest 636 880 10.0" 
$ns at 0.0 "$node_(78) setdest 720 686 11.0" 
$ns at 114.37656660795257 "$node_(78) setdest 1579 269 14.0" 
$ns at 282.90050978599186 "$node_(78) setdest 2788 893 4.0" 
$ns at 373.54304169781653 "$node_(78) setdest 1858 811 3.0" 
$ns at 500.27606738433354 "$node_(78) setdest 1716 400 16.0" 
$ns at 798.8638715882909 "$node_(78) setdest 2895 335 15.0" 
$ns at 0.0 "$node_(79) setdest 2761 90 6.0" 
$ns at 38.893924954261905 "$node_(79) setdest 2978 177 18.0" 
$ns at 74.83981489509938 "$node_(79) setdest 510 271 14.0" 
$ns at 249.47784083889255 "$node_(79) setdest 2765 758 10.0" 
$ns at 414.33273577864566 "$node_(79) setdest 29 329 3.0" 
$ns at 682.2294058581551 "$node_(79) setdest 1060 947 4.0" 
$ns at 0.0 "$node_(80) setdest 722 863 4.0" 
$ns at 39.24111579040383 "$node_(80) setdest 1667 438 18.0" 
$ns at 139.8831402965871 "$node_(80) setdest 1551 153 1.0" 
$ns at 207.99384674321018 "$node_(80) setdest 1822 576 6.0" 
$ns at 337.2320032814346 "$node_(80) setdest 12 28 15.0" 
$ns at 696.8973910686854 "$node_(80) setdest 2503 348 17.0" 
$ns at 0.0 "$node_(81) setdest 24 472 15.0" 
$ns at 110.33202788603286 "$node_(81) setdest 630 499 9.0" 
$ns at 228.9467758296421 "$node_(81) setdest 2638 547 1.0" 
$ns at 298.5537835256843 "$node_(81) setdest 1936 974 14.0" 
$ns at 482.7914914979053 "$node_(81) setdest 2209 474 19.0" 
$ns at 740.5774039331434 "$node_(81) setdest 1046 153 18.0" 
$ns at 0.0 "$node_(82) setdest 2440 938 1.0" 
$ns at 24.17478772291393 "$node_(82) setdest 2027 566 8.0" 
$ns at 102.93676919676582 "$node_(82) setdest 1449 966 9.0" 
$ns at 177.6198952646203 "$node_(82) setdest 443 70 18.0" 
$ns at 314.6970387616742 "$node_(82) setdest 761 945 1.0" 
$ns at 564.6419737413288 "$node_(82) setdest 1694 679 3.0" 
$ns at 0.0 "$node_(83) setdest 873 631 17.0" 
$ns at 21.627392433134453 "$node_(83) setdest 1165 506 20.0" 
$ns at 126.91346679790814 "$node_(83) setdest 803 202 9.0" 
$ns at 210.12099503356 "$node_(83) setdest 2462 529 11.0" 
$ns at 438.1678350442312 "$node_(83) setdest 1773 723 11.0" 
$ns at 711.2266850490219 "$node_(83) setdest 760 132 4.0" 
$ns at 0.0 "$node_(84) setdest 914 570 19.0" 
$ns at 60.16283272301604 "$node_(84) setdest 41 634 19.0" 
$ns at 197.4476300639 "$node_(84) setdest 676 676 7.0" 
$ns at 314.6864648879897 "$node_(84) setdest 1759 263 7.0" 
$ns at 485.62275730288815 "$node_(84) setdest 308 654 13.0" 
$ns at 808.9108900288575 "$node_(84) setdest 2192 269 2.0" 
$ns at 0.0 "$node_(85) setdest 2593 149 8.0" 
$ns at 86.60489325383567 "$node_(85) setdest 524 154 13.0" 
$ns at 134.06086023366967 "$node_(85) setdest 721 991 17.0" 
$ns at 287.70714387060787 "$node_(85) setdest 2423 211 4.0" 
$ns at 408.1240953710859 "$node_(85) setdest 954 986 11.0" 
$ns at 665.1057771954295 "$node_(85) setdest 1649 832 1.0" 
$ns at 0.0 "$node_(86) setdest 2500 420 10.0" 
$ns at 76.8817765220069 "$node_(86) setdest 974 295 6.0" 
$ns at 127.95980996965153 "$node_(86) setdest 724 614 10.0" 
$ns at 253.49249749803317 "$node_(86) setdest 2420 986 15.0" 
$ns at 384.19161367114395 "$node_(86) setdest 2625 119 12.0" 
$ns at 712.874983249498 "$node_(86) setdest 2625 262 1.0" 
$ns at 0.0 "$node_(87) setdest 2207 358 16.0" 
$ns at 135.72688931603523 "$node_(87) setdest 2832 409 4.0" 
$ns at 175.41815145390638 "$node_(87) setdest 2165 829 12.0" 
$ns at 321.28496756559866 "$node_(87) setdest 1804 413 8.0" 
$ns at 502.82571336666695 "$node_(87) setdest 1029 180 1.0" 
$ns at 744.8551939367537 "$node_(87) setdest 672 486 12.0" 
$ns at 0.0 "$node_(88) setdest 667 743 14.0" 
$ns at 73.24248057468743 "$node_(88) setdest 1510 564 10.0" 
$ns at 187.55944820934388 "$node_(88) setdest 2807 358 16.0" 
$ns at 404.5749488114103 "$node_(88) setdest 152 234 16.0" 
$ns at 671.826665069626 "$node_(88) setdest 2977 577 9.0" 
$ns at 0.0 "$node_(89) setdest 1537 794 18.0" 
$ns at 194.01470829909948 "$node_(89) setdest 4 570 13.0" 
$ns at 272.67526265173694 "$node_(89) setdest 2604 399 2.0" 
$ns at 341.8204792645152 "$node_(89) setdest 1000 316 6.0" 
$ns at 468.9405901519888 "$node_(89) setdest 2514 508 18.0" 
$ns at 868.1219206117023 "$node_(89) setdest 2460 922 2.0" 
$ns at 0.0 "$node_(90) setdest 1734 92 11.0" 
$ns at 117.66298761353796 "$node_(90) setdest 890 135 3.0" 
$ns at 159.52545724471565 "$node_(90) setdest 249 288 12.0" 
$ns at 265.9754913907631 "$node_(90) setdest 117 394 8.0" 
$ns at 447.76228217306465 "$node_(90) setdest 2937 489 16.0" 
$ns at 785.9337313619344 "$node_(90) setdest 1171 994 13.0" 
$ns at 0.0 "$node_(91) setdest 1883 48 1.0" 
$ns at 24.604648642556487 "$node_(91) setdest 415 205 11.0" 
$ns at 149.8932286658661 "$node_(91) setdest 2162 70 4.0" 
$ns at 244.0959477462724 "$node_(91) setdest 1295 412 10.0" 
$ns at 417.12996181961626 "$node_(91) setdest 2355 994 14.0" 
$ns at 745.1195471171233 "$node_(91) setdest 888 623 19.0" 
$ns at 0.0 "$node_(92) setdest 847 919 8.0" 
$ns at 41.707649584554474 "$node_(92) setdest 136 917 6.0" 
$ns at 119.64602137502864 "$node_(92) setdest 668 884 4.0" 
$ns at 182.75959163379392 "$node_(92) setdest 425 676 5.0" 
$ns at 309.24533248476257 "$node_(92) setdest 1404 564 5.0" 
$ns at 581.0208350646025 "$node_(92) setdest 909 666 1.0" 
$ns at 0.0 "$node_(93) setdest 474 79 17.0" 
$ns at 77.46181263277259 "$node_(93) setdest 2729 312 1.0" 
$ns at 112.99396647795402 "$node_(93) setdest 2768 879 9.0" 
$ns at 236.80230990985635 "$node_(93) setdest 34 749 6.0" 
$ns at 416.4267719492815 "$node_(93) setdest 2460 911 16.0" 
$ns at 776.6436771851727 "$node_(93) setdest 1454 469 11.0" 
$ns at 0.0 "$node_(94) setdest 497 529 3.0" 
$ns at 35.50627987458655 "$node_(94) setdest 425 662 8.0" 
$ns at 134.8212767076234 "$node_(94) setdest 2047 840 3.0" 
$ns at 198.2747004084474 "$node_(94) setdest 2525 575 6.0" 
$ns at 344.69697986595156 "$node_(94) setdest 1943 468 4.0" 
$ns at 606.6636175973686 "$node_(94) setdest 2714 462 18.0" 
$ns at 0.0 "$node_(95) setdest 2892 913 16.0" 
$ns at 99.00128421490471 "$node_(95) setdest 1142 980 12.0" 
$ns at 132.82951519205452 "$node_(95) setdest 970 988 2.0" 
$ns at 196.831997909754 "$node_(95) setdest 2912 90 2.0" 
$ns at 319.86589642179604 "$node_(95) setdest 2703 27 10.0" 
$ns at 598.9591736480284 "$node_(95) setdest 1970 805 4.0" 
$ns at 0.0 "$node_(96) setdest 734 821 12.0" 
$ns at 56.02569453024606 "$node_(96) setdest 1001 375 2.0" 
$ns at 92.3120468197158 "$node_(96) setdest 867 496 2.0" 
$ns at 167.1600581379469 "$node_(96) setdest 9 721 14.0" 
$ns at 391.3613622941066 "$node_(96) setdest 2025 787 11.0" 
$ns at 715.1002264029931 "$node_(96) setdest 959 217 9.0" 
$ns at 0.0 "$node_(97) setdest 2374 408 2.0" 
$ns at 17.357060625847357 "$node_(97) setdest 1652 152 3.0" 
$ns at 75.64484768324222 "$node_(97) setdest 666 494 18.0" 
$ns at 218.42897270248727 "$node_(97) setdest 722 437 19.0" 
$ns at 439.1937519281079 "$node_(97) setdest 1562 293 2.0" 
$ns at 690.5388593265693 "$node_(97) setdest 420 409 8.0" 
$ns at 0.0 "$node_(98) setdest 1467 595 10.0" 
$ns at 30.102276222285116 "$node_(98) setdest 575 808 12.0" 
$ns at 92.72864165006568 "$node_(98) setdest 1162 585 11.0" 
$ns at 182.20549994574543 "$node_(98) setdest 1890 243 7.0" 
$ns at 358.85363001097915 "$node_(98) setdest 2242 87 5.0" 
$ns at 629.8214252511486 "$node_(98) setdest 1479 763 14.0" 
$ns at 0.0 "$node_(99) setdest 2159 394 19.0" 
$ns at 63.24486145884229 "$node_(99) setdest 294 326 9.0" 
$ns at 178.5467725900438 "$node_(99) setdest 381 165 6.0" 
$ns at 265.21891935999554 "$node_(99) setdest 834 277 3.0" 
$ns at 393.6136885958139 "$node_(99) setdest 1954 65 8.0" 
$ns at 694.2548198072327 "$node_(99) setdest 1315 159 19.0" 


#Set a TCP connection between node_(82) and node_(13)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(0)
$ns attach-agent $node_(13) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(33) and node_(58)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(1)
$ns attach-agent $node_(58) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(72) and node_(42)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(2)
$ns attach-agent $node_(42) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(34) and node_(17)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(3)
$ns attach-agent $node_(17) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(77) and node_(5)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(4)
$ns attach-agent $node_(5) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(42) and node_(66)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(5)
$ns attach-agent $node_(66) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(84) and node_(90)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(6)
$ns attach-agent $node_(90) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(19) and node_(41)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(7)
$ns attach-agent $node_(41) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(84) and node_(83)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(8)
$ns attach-agent $node_(83) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(67) and node_(34)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(9)
$ns attach-agent $node_(34) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(42) and node_(11)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(10)
$ns attach-agent $node_(11) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(63) and node_(39)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(11)
$ns attach-agent $node_(39) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(59) and node_(57)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(12)
$ns attach-agent $node_(57) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(13) and node_(59)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(13)
$ns attach-agent $node_(59) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(73) and node_(65)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(14)
$ns attach-agent $node_(65) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(62) and node_(41)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(15)
$ns attach-agent $node_(41) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(74) and node_(20)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(16)
$ns attach-agent $node_(20) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(90) and node_(14)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(17)
$ns attach-agent $node_(14) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(42) and node_(47)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(18)
$ns attach-agent $node_(47) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(43) and node_(86)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(19)
$ns attach-agent $node_(86) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(18) and node_(60)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(20)
$ns attach-agent $node_(60) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(62) and node_(6)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(21)
$ns attach-agent $node_(6) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(45) and node_(59)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(22)
$ns attach-agent $node_(59) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(22) and node_(93)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(23)
$ns attach-agent $node_(93) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(89) and node_(28)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(24)
$ns attach-agent $node_(28) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(17) and node_(74)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(25)
$ns attach-agent $node_(74) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(35) and node_(51)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(26)
$ns attach-agent $node_(51) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(52) and node_(11)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(27)
$ns attach-agent $node_(11) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(65) and node_(61)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(28)
$ns attach-agent $node_(61) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(6) and node_(27)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(29)
$ns attach-agent $node_(27) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(52) and node_(63)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(30)
$ns attach-agent $node_(63) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(38) and node_(33)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(31)
$ns attach-agent $node_(33) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(76) and node_(34)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(32)
$ns attach-agent $node_(34) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(87) and node_(27)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(33)
$ns attach-agent $node_(27) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(27) and node_(26)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(34)
$ns attach-agent $node_(26) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(27) and node_(61)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(35)
$ns attach-agent $node_(61) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(96) and node_(68)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(36)
$ns attach-agent $node_(68) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(51) and node_(7)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(37)
$ns attach-agent $node_(7) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(68) and node_(93)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(38)
$ns attach-agent $node_(93) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(17) and node_(30)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(39)
$ns attach-agent $node_(30) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(74) and node_(54)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(40)
$ns attach-agent $node_(54) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(24) and node_(60)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(41)
$ns attach-agent $node_(60) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(60) and node_(32)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(42)
$ns attach-agent $node_(32) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(42) and node_(25)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(43)
$ns attach-agent $node_(25) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(32) and node_(33)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(44)
$ns attach-agent $node_(33) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(79) and node_(41)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(45)
$ns attach-agent $node_(41) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(34) and node_(87)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(46)
$ns attach-agent $node_(87) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(22) and node_(79)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(47)
$ns attach-agent $node_(79) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(0) and node_(63)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(48)
$ns attach-agent $node_(63) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(7) and node_(65)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(49)
$ns attach-agent $node_(65) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(74) and node_(92)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(50)
$ns attach-agent $node_(92) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(81) and node_(14)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(51)
$ns attach-agent $node_(14) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(2) and node_(67)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(52)
$ns attach-agent $node_(67) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(95) and node_(3)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(53)
$ns attach-agent $node_(3) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(95) and node_(93)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(54)
$ns attach-agent $node_(93) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(85) and node_(52)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(55)
$ns attach-agent $node_(52) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(75) and node_(23)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(56)
$ns attach-agent $node_(23) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(53) and node_(98)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(57)
$ns attach-agent $node_(98) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(79) and node_(20)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(58)
$ns attach-agent $node_(20) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(46) and node_(48)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(59)
$ns attach-agent $node_(48) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(97) and node_(48)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(60)
$ns attach-agent $node_(48) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(76) and node_(66)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(61)
$ns attach-agent $node_(66) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(76) and node_(2)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(62)
$ns attach-agent $node_(2) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(86) and node_(76)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(63)
$ns attach-agent $node_(76) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(69) and node_(11)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(64)
$ns attach-agent $node_(11) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(10) and node_(34)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(65)
$ns attach-agent $node_(34) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(94) and node_(21)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(66)
$ns attach-agent $node_(21) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(74) and node_(96)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(67)
$ns attach-agent $node_(96) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(54) and node_(36)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(68)
$ns attach-agent $node_(36) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(87) and node_(44)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(69)
$ns attach-agent $node_(44) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(45) and node_(65)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(70)
$ns attach-agent $node_(65) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(62) and node_(87)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(71)
$ns attach-agent $node_(87) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(87) and node_(8)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(72)
$ns attach-agent $node_(8) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(40) and node_(43)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(73)
$ns attach-agent $node_(43) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(4) and node_(99)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(74)
$ns attach-agent $node_(99) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(93) and node_(4)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(75)
$ns attach-agent $node_(4) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(7) and node_(87)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(76)
$ns attach-agent $node_(87) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(1) and node_(84)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(77)
$ns attach-agent $node_(84) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(19) and node_(73)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(78)
$ns attach-agent $node_(73) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(70) and node_(8)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(79)
$ns attach-agent $node_(8) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(58) and node_(88)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(80)
$ns attach-agent $node_(88) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(47) and node_(72)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(81)
$ns attach-agent $node_(72) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(70) and node_(49)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(82)
$ns attach-agent $node_(49) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(73) and node_(77)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(83)
$ns attach-agent $node_(77) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(79) and node_(90)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(84)
$ns attach-agent $node_(90) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(72) and node_(79)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(85)
$ns attach-agent $node_(79) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(56) and node_(4)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(86)
$ns attach-agent $node_(4) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(94) and node_(96)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(87)
$ns attach-agent $node_(96) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(78) and node_(68)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(88)
$ns attach-agent $node_(68) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(65) and node_(48)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(89)
$ns attach-agent $node_(48) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(70) and node_(43)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(90)
$ns attach-agent $node_(43) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(26) and node_(69)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(91)
$ns attach-agent $node_(69) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(44) and node_(83)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(92)
$ns attach-agent $node_(83) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(31) and node_(36)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(93)
$ns attach-agent $node_(36) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(89) and node_(28)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(94)
$ns attach-agent $node_(28) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(3) and node_(26)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(95)
$ns attach-agent $node_(26) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(59) and node_(53)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(96)
$ns attach-agent $node_(53) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(3) and node_(73)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(97)
$ns attach-agent $node_(73) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(89) and node_(7)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(98)
$ns attach-agent $node_(7) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(98) and node_(4)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(99)
$ns attach-agent $node_(4) $sink_(99)
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
