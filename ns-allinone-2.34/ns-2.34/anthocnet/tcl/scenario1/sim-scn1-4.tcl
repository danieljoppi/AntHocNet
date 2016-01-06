#sim-scn1-4.tcl 
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
set tracefd       [open sim-scn1-4-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-4-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-4-$val(rp).nam w]

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
$node_(0) set X_ 1795 
$node_(0) set Y_ 929 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2702 
$node_(1) set Y_ 621 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 276 
$node_(2) set Y_ 643 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1310 
$node_(3) set Y_ 441 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 995 
$node_(4) set Y_ 782 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2787 
$node_(5) set Y_ 836 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2710 
$node_(6) set Y_ 810 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2790 
$node_(7) set Y_ 873 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 858 
$node_(8) set Y_ 38 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1478 
$node_(9) set Y_ 771 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 722 
$node_(10) set Y_ 921 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 490 
$node_(11) set Y_ 586 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2041 
$node_(12) set Y_ 856 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2869 
$node_(13) set Y_ 341 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1501 
$node_(14) set Y_ 441 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1636 
$node_(15) set Y_ 806 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2314 
$node_(16) set Y_ 141 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 816 
$node_(17) set Y_ 697 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2277 
$node_(18) set Y_ 683 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1822 
$node_(19) set Y_ 552 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1461 
$node_(20) set Y_ 335 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1134 
$node_(21) set Y_ 912 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 2779 
$node_(22) set Y_ 409 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1262 
$node_(23) set Y_ 721 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1353 
$node_(24) set Y_ 939 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 941 
$node_(25) set Y_ 46 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2690 
$node_(26) set Y_ 538 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1484 
$node_(27) set Y_ 342 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1252 
$node_(28) set Y_ 818 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1159 
$node_(29) set Y_ 449 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1016 
$node_(30) set Y_ 630 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 316 
$node_(31) set Y_ 467 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1174 
$node_(32) set Y_ 598 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2903 
$node_(33) set Y_ 426 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 60 
$node_(34) set Y_ 72 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 804 
$node_(35) set Y_ 440 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2839 
$node_(36) set Y_ 686 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2265 
$node_(37) set Y_ 612 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2439 
$node_(38) set Y_ 143 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2426 
$node_(39) set Y_ 539 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1540 
$node_(40) set Y_ 738 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1734 
$node_(41) set Y_ 682 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2322 
$node_(42) set Y_ 387 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 714 
$node_(43) set Y_ 219 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1985 
$node_(44) set Y_ 603 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 248 
$node_(45) set Y_ 260 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2821 
$node_(46) set Y_ 962 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1175 
$node_(47) set Y_ 458 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1913 
$node_(48) set Y_ 62 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2627 
$node_(49) set Y_ 125 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2221 
$node_(50) set Y_ 903 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 111 
$node_(51) set Y_ 925 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2046 
$node_(52) set Y_ 902 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2884 
$node_(53) set Y_ 101 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 488 
$node_(54) set Y_ 459 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2723 
$node_(55) set Y_ 984 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2693 
$node_(56) set Y_ 129 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1647 
$node_(57) set Y_ 219 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 228 
$node_(58) set Y_ 942 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 2619 
$node_(59) set Y_ 742 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2054 
$node_(60) set Y_ 371 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1715 
$node_(61) set Y_ 39 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1040 
$node_(62) set Y_ 760 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 585 
$node_(63) set Y_ 660 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 38 
$node_(64) set Y_ 773 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1462 
$node_(65) set Y_ 224 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1939 
$node_(66) set Y_ 563 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 256 
$node_(67) set Y_ 440 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 152 
$node_(68) set Y_ 931 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 611 
$node_(69) set Y_ 739 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 289 
$node_(70) set Y_ 666 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 53 
$node_(71) set Y_ 191 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 2776 
$node_(72) set Y_ 669 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 611 
$node_(73) set Y_ 297 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 427 
$node_(74) set Y_ 189 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1497 
$node_(75) set Y_ 109 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 1863 
$node_(76) set Y_ 709 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 611 
$node_(77) set Y_ 890 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 909 
$node_(78) set Y_ 585 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 785 
$node_(79) set Y_ 155 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 907 
$node_(80) set Y_ 537 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2792 
$node_(81) set Y_ 552 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 2067 
$node_(82) set Y_ 480 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 244 
$node_(83) set Y_ 472 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1696 
$node_(84) set Y_ 7 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2535 
$node_(85) set Y_ 682 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1303 
$node_(86) set Y_ 997 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2030 
$node_(87) set Y_ 539 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 1195 
$node_(88) set Y_ 498 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 2681 
$node_(89) set Y_ 573 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 1316 
$node_(90) set Y_ 998 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1200 
$node_(91) set Y_ 277 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2597 
$node_(92) set Y_ 661 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 1882 
$node_(93) set Y_ 985 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 181 
$node_(94) set Y_ 920 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 2021 
$node_(95) set Y_ 619 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 2351 
$node_(96) set Y_ 68 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 776 
$node_(97) set Y_ 888 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1973 
$node_(98) set Y_ 121 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 1142 
$node_(99) set Y_ 273 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2739 302 10.0" 
$ns at 88.86448997303984 "$node_(0) setdest 363 918 13.0" 
$ns at 204.69639655108685 "$node_(0) setdest 1299 302 5.0" 
$ns at 309.4818427286311 "$node_(0) setdest 2385 745 17.0" 
$ns at 476.3599614300595 "$node_(0) setdest 2150 4 10.0" 
$ns at 721.0341322303047 "$node_(0) setdest 1282 105 10.0" 
$ns at 0.0 "$node_(1) setdest 2045 580 20.0" 
$ns at 165.61067920562468 "$node_(1) setdest 137 238 9.0" 
$ns at 267.72437155538415 "$node_(1) setdest 683 831 8.0" 
$ns at 366.0485983910961 "$node_(1) setdest 2713 688 5.0" 
$ns at 521.2999395812051 "$node_(1) setdest 1622 533 8.0" 
$ns at 818.7783893365845 "$node_(1) setdest 2689 182 5.0" 
$ns at 0.0 "$node_(2) setdest 821 778 11.0" 
$ns at 23.899913230509217 "$node_(2) setdest 215 519 11.0" 
$ns at 75.33604585343566 "$node_(2) setdest 2636 625 17.0" 
$ns at 212.13949696330485 "$node_(2) setdest 492 367 13.0" 
$ns at 452.50219900373816 "$node_(2) setdest 1829 603 19.0" 
$ns at 804.4715860616266 "$node_(2) setdest 782 169 16.0" 
$ns at 0.0 "$node_(3) setdest 2891 868 4.0" 
$ns at 45.85722494135041 "$node_(3) setdest 60 565 6.0" 
$ns at 135.45064587765478 "$node_(3) setdest 1742 62 11.0" 
$ns at 234.63185485753857 "$node_(3) setdest 217 20 16.0" 
$ns at 452.01673550897976 "$node_(3) setdest 2615 187 19.0" 
$ns at 762.091623789589 "$node_(3) setdest 1514 572 1.0" 
$ns at 0.0 "$node_(4) setdest 2690 26 12.0" 
$ns at 72.44142757828018 "$node_(4) setdest 1715 883 5.0" 
$ns at 106.5014962325666 "$node_(4) setdest 768 930 4.0" 
$ns at 205.68410694333727 "$node_(4) setdest 82 18 15.0" 
$ns at 414.9601222926117 "$node_(4) setdest 70 6 3.0" 
$ns at 674.0524957737218 "$node_(4) setdest 2164 625 9.0" 
$ns at 0.0 "$node_(5) setdest 2942 21 17.0" 
$ns at 102.01662801675971 "$node_(5) setdest 1071 445 12.0" 
$ns at 245.07492474976564 "$node_(5) setdest 2050 561 20.0" 
$ns at 332.25336987521155 "$node_(5) setdest 1657 325 9.0" 
$ns at 467.1592943545039 "$node_(5) setdest 353 255 5.0" 
$ns at 738.7493726080329 "$node_(5) setdest 1802 160 1.0" 
$ns at 0.0 "$node_(6) setdest 2922 107 7.0" 
$ns at 61.32908193203045 "$node_(6) setdest 1724 445 13.0" 
$ns at 212.81967437921068 "$node_(6) setdest 2419 243 5.0" 
$ns at 288.10861501666403 "$node_(6) setdest 2008 352 17.0" 
$ns at 480.1241398914546 "$node_(6) setdest 1781 621 4.0" 
$ns at 729.5492206415845 "$node_(6) setdest 2777 520 5.0" 
$ns at 0.0 "$node_(7) setdest 1431 501 16.0" 
$ns at 142.98601142422802 "$node_(7) setdest 2201 978 9.0" 
$ns at 249.5460175135152 "$node_(7) setdest 2061 735 10.0" 
$ns at 397.6129287819204 "$node_(7) setdest 2266 871 10.0" 
$ns at 559.6419008215571 "$node_(7) setdest 2813 174 16.0" 
$ns at 0.0 "$node_(8) setdest 496 928 5.0" 
$ns at 56.577707379763986 "$node_(8) setdest 2397 730 10.0" 
$ns at 136.07110426144845 "$node_(8) setdest 1055 834 19.0" 
$ns at 362.9841025506478 "$node_(8) setdest 2471 920 9.0" 
$ns at 483.656630083073 "$node_(8) setdest 1412 946 11.0" 
$ns at 821.3902584038622 "$node_(8) setdest 1333 918 12.0" 
$ns at 0.0 "$node_(9) setdest 1511 10 2.0" 
$ns at 20.10975348515622 "$node_(9) setdest 2733 427 1.0" 
$ns at 51.55939549990077 "$node_(9) setdest 2123 829 7.0" 
$ns at 135.20012290966264 "$node_(9) setdest 2371 924 1.0" 
$ns at 257.9969912395814 "$node_(9) setdest 1808 34 5.0" 
$ns at 533.4130442549613 "$node_(9) setdest 2378 75 5.0" 
$ns at 0.0 "$node_(10) setdest 2687 397 9.0" 
$ns at 104.73042553070003 "$node_(10) setdest 2854 363 16.0" 
$ns at 193.8379558399181 "$node_(10) setdest 2942 365 18.0" 
$ns at 399.8599780586646 "$node_(10) setdest 1254 250 13.0" 
$ns at 620.1044688797119 "$node_(10) setdest 2734 725 1.0" 
$ns at 864.8545420665658 "$node_(10) setdest 1195 403 18.0" 
$ns at 0.0 "$node_(11) setdest 2971 594 1.0" 
$ns at 20.73650440197661 "$node_(11) setdest 2988 797 19.0" 
$ns at 175.74035492434774 "$node_(11) setdest 1116 149 19.0" 
$ns at 338.88054727290637 "$node_(11) setdest 2945 738 17.0" 
$ns at 485.7822019811748 "$node_(11) setdest 956 773 6.0" 
$ns at 773.1933418439933 "$node_(11) setdest 2286 117 4.0" 
$ns at 0.0 "$node_(12) setdest 28 546 13.0" 
$ns at 26.38481106238707 "$node_(12) setdest 193 436 16.0" 
$ns at 139.87459273789065 "$node_(12) setdest 129 260 15.0" 
$ns at 233.2762917408247 "$node_(12) setdest 319 411 1.0" 
$ns at 362.550896208832 "$node_(12) setdest 91 373 8.0" 
$ns at 614.3727747828748 "$node_(12) setdest 819 201 11.0" 
$ns at 0.0 "$node_(13) setdest 2768 589 13.0" 
$ns at 29.85383570760459 "$node_(13) setdest 1704 568 14.0" 
$ns at 150.10511472950142 "$node_(13) setdest 2899 985 2.0" 
$ns at 220.72703880325787 "$node_(13) setdest 1078 513 6.0" 
$ns at 395.5101508134368 "$node_(13) setdest 1294 856 17.0" 
$ns at 726.538196094587 "$node_(13) setdest 570 196 2.0" 
$ns at 0.0 "$node_(14) setdest 1529 716 1.0" 
$ns at 20.139080226654478 "$node_(14) setdest 2021 176 12.0" 
$ns at 143.43896470201952 "$node_(14) setdest 72 121 6.0" 
$ns at 207.17852090167943 "$node_(14) setdest 2219 299 15.0" 
$ns at 426.5155461270485 "$node_(14) setdest 2526 238 9.0" 
$ns at 677.5788465793042 "$node_(14) setdest 2268 750 14.0" 
$ns at 0.0 "$node_(15) setdest 439 343 14.0" 
$ns at 55.12392476177701 "$node_(15) setdest 871 101 11.0" 
$ns at 126.40782840561235 "$node_(15) setdest 2837 675 12.0" 
$ns at 246.2752903699044 "$node_(15) setdest 1608 384 1.0" 
$ns at 370.0080653351212 "$node_(15) setdest 1440 313 19.0" 
$ns at 735.0089171491884 "$node_(15) setdest 2003 506 16.0" 
$ns at 0.0 "$node_(16) setdest 1223 6 8.0" 
$ns at 82.38431569847042 "$node_(16) setdest 1946 541 10.0" 
$ns at 134.42691051971917 "$node_(16) setdest 2776 131 8.0" 
$ns at 207.06294358674634 "$node_(16) setdest 778 714 11.0" 
$ns at 371.3494614048079 "$node_(16) setdest 629 217 6.0" 
$ns at 637.8164653819927 "$node_(16) setdest 1091 119 7.0" 
$ns at 0.0 "$node_(17) setdest 2480 681 9.0" 
$ns at 42.61560558987357 "$node_(17) setdest 2061 473 14.0" 
$ns at 146.71768719992687 "$node_(17) setdest 22 740 9.0" 
$ns at 231.96730660395986 "$node_(17) setdest 1873 462 4.0" 
$ns at 375.4628553982916 "$node_(17) setdest 2787 639 1.0" 
$ns at 615.4758980160559 "$node_(17) setdest 2528 476 2.0" 
$ns at 0.0 "$node_(18) setdest 1194 651 10.0" 
$ns at 88.48797200977889 "$node_(18) setdest 2118 776 1.0" 
$ns at 121.37300010885251 "$node_(18) setdest 1743 497 9.0" 
$ns at 243.02722423848437 "$node_(18) setdest 2359 411 10.0" 
$ns at 450.95723793780076 "$node_(18) setdest 2026 139 16.0" 
$ns at 825.5592619253279 "$node_(18) setdest 2945 424 9.0" 
$ns at 0.0 "$node_(19) setdest 2004 101 7.0" 
$ns at 39.57626809833098 "$node_(19) setdest 32 144 10.0" 
$ns at 151.19116632606318 "$node_(19) setdest 1718 751 8.0" 
$ns at 263.6403749457859 "$node_(19) setdest 915 631 2.0" 
$ns at 384.35567541381386 "$node_(19) setdest 2374 222 12.0" 
$ns at 729.493949514391 "$node_(19) setdest 1694 555 9.0" 
$ns at 0.0 "$node_(20) setdest 1491 897 5.0" 
$ns at 24.525153859743853 "$node_(20) setdest 1510 75 8.0" 
$ns at 118.11083756493956 "$node_(20) setdest 538 629 8.0" 
$ns at 193.07614920020524 "$node_(20) setdest 1630 513 1.0" 
$ns at 316.7235274591127 "$node_(20) setdest 2245 130 8.0" 
$ns at 591.529243129687 "$node_(20) setdest 1466 871 7.0" 
$ns at 0.0 "$node_(21) setdest 2523 195 1.0" 
$ns at 22.592177798094138 "$node_(21) setdest 1320 499 6.0" 
$ns at 68.91677728208175 "$node_(21) setdest 681 697 6.0" 
$ns at 186.33697755220692 "$node_(21) setdest 1427 457 4.0" 
$ns at 337.10081045076845 "$node_(21) setdest 1363 519 11.0" 
$ns at 681.2732116639341 "$node_(21) setdest 2585 375 17.0" 
$ns at 0.0 "$node_(22) setdest 399 857 1.0" 
$ns at 20.86510486424478 "$node_(22) setdest 2456 867 3.0" 
$ns at 62.104411022813224 "$node_(22) setdest 1493 564 18.0" 
$ns at 238.46173855901264 "$node_(22) setdest 323 790 17.0" 
$ns at 458.2090608635109 "$node_(22) setdest 448 465 15.0" 
$ns at 800.5623150310196 "$node_(22) setdest 2876 905 2.0" 
$ns at 0.0 "$node_(23) setdest 342 816 13.0" 
$ns at 117.63045691766371 "$node_(23) setdest 334 741 2.0" 
$ns at 162.27829017090377 "$node_(23) setdest 1851 333 19.0" 
$ns at 313.4597620841354 "$node_(23) setdest 2953 708 12.0" 
$ns at 550.1668143428792 "$node_(23) setdest 653 469 7.0" 
$ns at 802.1223789455593 "$node_(23) setdest 740 767 14.0" 
$ns at 0.0 "$node_(24) setdest 586 858 4.0" 
$ns at 15.848237672061124 "$node_(24) setdest 923 204 3.0" 
$ns at 71.5935426922362 "$node_(24) setdest 1010 118 17.0" 
$ns at 149.66841395791351 "$node_(24) setdest 1488 302 6.0" 
$ns at 318.75802378192964 "$node_(24) setdest 1539 414 5.0" 
$ns at 567.1141024552419 "$node_(24) setdest 2848 973 9.0" 
$ns at 0.0 "$node_(25) setdest 2087 482 9.0" 
$ns at 53.14484022451091 "$node_(25) setdest 1442 654 7.0" 
$ns at 151.72033050135587 "$node_(25) setdest 916 21 2.0" 
$ns at 215.54943719903207 "$node_(25) setdest 2828 990 1.0" 
$ns at 340.1072339951738 "$node_(25) setdest 104 639 18.0" 
$ns at 631.5214537941309 "$node_(25) setdest 2578 147 5.0" 
$ns at 0.0 "$node_(26) setdest 1629 778 3.0" 
$ns at 28.71423062228572 "$node_(26) setdest 1037 768 15.0" 
$ns at 69.08291773163396 "$node_(26) setdest 2003 287 17.0" 
$ns at 187.43960708072885 "$node_(26) setdest 1750 896 8.0" 
$ns at 358.8111356312156 "$node_(26) setdest 133 574 2.0" 
$ns at 612.3001223592273 "$node_(26) setdest 1110 402 1.0" 
$ns at 0.0 "$node_(27) setdest 841 517 11.0" 
$ns at 94.66728589159901 "$node_(27) setdest 1559 730 11.0" 
$ns at 132.10316879908157 "$node_(27) setdest 240 553 11.0" 
$ns at 218.63830896368336 "$node_(27) setdest 363 996 12.0" 
$ns at 406.86710915306776 "$node_(27) setdest 2887 616 2.0" 
$ns at 653.8823190861026 "$node_(27) setdest 2810 758 4.0" 
$ns at 0.0 "$node_(28) setdest 1395 867 1.0" 
$ns at 16.651760997480945 "$node_(28) setdest 1357 992 16.0" 
$ns at 134.49533634860416 "$node_(28) setdest 2951 375 11.0" 
$ns at 204.45192494367686 "$node_(28) setdest 1054 83 2.0" 
$ns at 342.3189411725156 "$node_(28) setdest 1910 184 10.0" 
$ns at 589.1331071694992 "$node_(28) setdest 1298 890 1.0" 
$ns at 0.0 "$node_(29) setdest 2408 433 16.0" 
$ns at 53.32443751285753 "$node_(29) setdest 723 158 10.0" 
$ns at 115.4148114019413 "$node_(29) setdest 672 473 5.0" 
$ns at 214.03787557938182 "$node_(29) setdest 2784 868 8.0" 
$ns at 337.4351365700467 "$node_(29) setdest 2457 128 6.0" 
$ns at 627.6541495410122 "$node_(29) setdest 355 285 7.0" 
$ns at 0.0 "$node_(30) setdest 1810 558 1.0" 
$ns at 24.693229733413418 "$node_(30) setdest 2382 788 6.0" 
$ns at 97.13443591376365 "$node_(30) setdest 1075 372 13.0" 
$ns at 197.7089144586854 "$node_(30) setdest 1411 762 11.0" 
$ns at 347.9391897801772 "$node_(30) setdest 2831 938 19.0" 
$ns at 677.0802164302954 "$node_(30) setdest 552 106 10.0" 
$ns at 0.0 "$node_(31) setdest 1203 47 12.0" 
$ns at 130.57192751576594 "$node_(31) setdest 174 173 19.0" 
$ns at 257.59597871338525 "$node_(31) setdest 716 377 5.0" 
$ns at 344.30075219040725 "$node_(31) setdest 1408 167 4.0" 
$ns at 474.62066331288133 "$node_(31) setdest 1637 416 13.0" 
$ns at 814.4656214975637 "$node_(31) setdest 248 322 10.0" 
$ns at 0.0 "$node_(32) setdest 2485 773 15.0" 
$ns at 133.85528338479835 "$node_(32) setdest 822 401 8.0" 
$ns at 235.6509810439308 "$node_(32) setdest 2137 62 11.0" 
$ns at 298.7194630745366 "$node_(32) setdest 2138 313 16.0" 
$ns at 442.8280238909395 "$node_(32) setdest 2725 778 12.0" 
$ns at 711.0109702326374 "$node_(32) setdest 361 914 2.0" 
$ns at 0.0 "$node_(33) setdest 248 835 2.0" 
$ns at 21.83043654090808 "$node_(33) setdest 1428 272 13.0" 
$ns at 143.56450490244592 "$node_(33) setdest 1584 706 19.0" 
$ns at 354.34601096730694 "$node_(33) setdest 571 968 7.0" 
$ns at 504.9926764960252 "$node_(33) setdest 2340 328 16.0" 
$ns at 811.0229644398071 "$node_(33) setdest 41 215 1.0" 
$ns at 0.0 "$node_(34) setdest 1725 202 10.0" 
$ns at 15.227992713165293 "$node_(34) setdest 2100 860 12.0" 
$ns at 155.4063052558891 "$node_(34) setdest 2362 370 2.0" 
$ns at 219.18947658904452 "$node_(34) setdest 2094 562 12.0" 
$ns at 340.94253876249184 "$node_(34) setdest 754 179 7.0" 
$ns at 597.668811074519 "$node_(34) setdest 1154 697 3.0" 
$ns at 0.0 "$node_(35) setdest 1806 32 6.0" 
$ns at 65.02676992945752 "$node_(35) setdest 1843 794 11.0" 
$ns at 127.96803040334797 "$node_(35) setdest 1606 526 1.0" 
$ns at 188.47300741211944 "$node_(35) setdest 1802 557 19.0" 
$ns at 358.91924923066665 "$node_(35) setdest 394 667 17.0" 
$ns at 603.6150171076455 "$node_(35) setdest 1210 754 19.0" 
$ns at 0.0 "$node_(36) setdest 397 90 3.0" 
$ns at 16.781720072195423 "$node_(36) setdest 1612 556 2.0" 
$ns at 55.607873635954874 "$node_(36) setdest 973 452 15.0" 
$ns at 131.37875539666638 "$node_(36) setdest 1416 93 12.0" 
$ns at 267.47227174666733 "$node_(36) setdest 1239 423 5.0" 
$ns at 555.087717955804 "$node_(36) setdest 138 303 8.0" 
$ns at 0.0 "$node_(37) setdest 125 963 3.0" 
$ns at 30.640782648177755 "$node_(37) setdest 184 361 18.0" 
$ns at 189.0388937051408 "$node_(37) setdest 2527 797 1.0" 
$ns at 249.5475981149132 "$node_(37) setdest 1735 246 19.0" 
$ns at 451.3059466234133 "$node_(37) setdest 2001 266 15.0" 
$ns at 713.9728278105629 "$node_(37) setdest 2048 242 15.0" 
$ns at 0.0 "$node_(38) setdest 1182 993 6.0" 
$ns at 72.862098498032 "$node_(38) setdest 2221 424 1.0" 
$ns at 111.51180546341863 "$node_(38) setdest 2855 20 15.0" 
$ns at 309.55461433339747 "$node_(38) setdest 1243 436 8.0" 
$ns at 499.19820858675325 "$node_(38) setdest 1366 358 17.0" 
$ns at 879.3704313145615 "$node_(38) setdest 2876 102 6.0" 
$ns at 0.0 "$node_(39) setdest 1807 114 1.0" 
$ns at 17.691093567126774 "$node_(39) setdest 1688 679 1.0" 
$ns at 50.438012007170244 "$node_(39) setdest 2157 630 18.0" 
$ns at 218.8669133048894 "$node_(39) setdest 2284 804 14.0" 
$ns at 422.51277384093663 "$node_(39) setdest 311 308 10.0" 
$ns at 757.2606538925963 "$node_(39) setdest 557 417 7.0" 
$ns at 0.0 "$node_(40) setdest 1688 35 20.0" 
$ns at 16.392627813539306 "$node_(40) setdest 509 246 5.0" 
$ns at 51.01499537525083 "$node_(40) setdest 842 406 19.0" 
$ns at 233.0521796451294 "$node_(40) setdest 2945 614 6.0" 
$ns at 363.5482275242926 "$node_(40) setdest 1260 149 10.0" 
$ns at 650.1789235008158 "$node_(40) setdest 2118 656 4.0" 
$ns at 0.0 "$node_(41) setdest 298 441 5.0" 
$ns at 61.84385984461911 "$node_(41) setdest 114 214 7.0" 
$ns at 145.8644758027588 "$node_(41) setdest 1908 35 12.0" 
$ns at 288.69855657488176 "$node_(41) setdest 1541 992 3.0" 
$ns at 417.8337541552963 "$node_(41) setdest 619 381 7.0" 
$ns at 664.9958131719786 "$node_(41) setdest 2840 743 1.0" 
$ns at 0.0 "$node_(42) setdest 938 150 18.0" 
$ns at 71.79689144140679 "$node_(42) setdest 265 558 15.0" 
$ns at 212.36086847780967 "$node_(42) setdest 2111 860 8.0" 
$ns at 290.03866428848266 "$node_(42) setdest 2342 553 2.0" 
$ns at 425.230308605012 "$node_(42) setdest 1928 513 12.0" 
$ns at 681.1239788519887 "$node_(42) setdest 377 502 18.0" 
$ns at 0.0 "$node_(43) setdest 1999 419 8.0" 
$ns at 26.35452420370802 "$node_(43) setdest 1304 216 1.0" 
$ns at 58.188886733798455 "$node_(43) setdest 696 650 3.0" 
$ns at 130.0122588937274 "$node_(43) setdest 2944 727 17.0" 
$ns at 298.1507226058946 "$node_(43) setdest 2684 773 11.0" 
$ns at 622.6863713090994 "$node_(43) setdest 2485 562 19.0" 
$ns at 0.0 "$node_(44) setdest 2728 811 6.0" 
$ns at 57.442853585496955 "$node_(44) setdest 728 681 20.0" 
$ns at 138.02251665781037 "$node_(44) setdest 1218 597 18.0" 
$ns at 230.02239934096676 "$node_(44) setdest 1424 854 17.0" 
$ns at 425.7482914601708 "$node_(44) setdest 1575 947 7.0" 
$ns at 666.1611902854611 "$node_(44) setdest 2747 549 1.0" 
$ns at 0.0 "$node_(45) setdest 497 331 3.0" 
$ns at 17.164913689408003 "$node_(45) setdest 2725 618 12.0" 
$ns at 57.44842537124698 "$node_(45) setdest 710 965 19.0" 
$ns at 137.43531341636032 "$node_(45) setdest 2173 338 7.0" 
$ns at 306.94062459484775 "$node_(45) setdest 1665 502 17.0" 
$ns at 557.6542291974534 "$node_(45) setdest 1445 610 19.0" 
$ns at 0.0 "$node_(46) setdest 2361 747 7.0" 
$ns at 38.78563451492026 "$node_(46) setdest 69 357 7.0" 
$ns at 103.14537643830731 "$node_(46) setdest 234 70 18.0" 
$ns at 214.67442881081558 "$node_(46) setdest 59 433 4.0" 
$ns at 342.0865081885033 "$node_(46) setdest 790 444 13.0" 
$ns at 683.794958668329 "$node_(46) setdest 2471 588 3.0" 
$ns at 0.0 "$node_(47) setdest 2418 289 4.0" 
$ns at 49.002841998322154 "$node_(47) setdest 2521 291 9.0" 
$ns at 99.96997767019184 "$node_(47) setdest 2559 534 19.0" 
$ns at 263.50539318926957 "$node_(47) setdest 1300 459 11.0" 
$ns at 478.7647089139809 "$node_(47) setdest 184 591 20.0" 
$ns at 841.6634998713353 "$node_(47) setdest 1918 398 14.0" 
$ns at 0.0 "$node_(48) setdest 241 151 13.0" 
$ns at 101.05662849385241 "$node_(48) setdest 624 503 16.0" 
$ns at 160.03214889470706 "$node_(48) setdest 2519 988 16.0" 
$ns at 348.5548692711775 "$node_(48) setdest 2207 519 3.0" 
$ns at 476.43545956992585 "$node_(48) setdest 109 190 18.0" 
$ns at 726.4840732639211 "$node_(48) setdest 2754 416 1.0" 
$ns at 0.0 "$node_(49) setdest 1402 496 13.0" 
$ns at 138.1776997943394 "$node_(49) setdest 547 170 4.0" 
$ns at 200.81203747685487 "$node_(49) setdest 285 669 17.0" 
$ns at 275.06192764063326 "$node_(49) setdest 685 14 8.0" 
$ns at 456.16016356918675 "$node_(49) setdest 7 71 12.0" 
$ns at 775.5495084480833 "$node_(49) setdest 717 949 10.0" 
$ns at 0.0 "$node_(50) setdest 1853 872 2.0" 
$ns at 18.353166975612346 "$node_(50) setdest 2366 572 14.0" 
$ns at 166.07128472299203 "$node_(50) setdest 2606 574 5.0" 
$ns at 263.6098705933868 "$node_(50) setdest 2127 518 18.0" 
$ns at 413.6022637811608 "$node_(50) setdest 438 758 6.0" 
$ns at 653.8846373019966 "$node_(50) setdest 1323 70 4.0" 
$ns at 0.0 "$node_(51) setdest 697 252 6.0" 
$ns at 24.077774562934785 "$node_(51) setdest 1915 733 4.0" 
$ns at 89.85499912574664 "$node_(51) setdest 1752 132 11.0" 
$ns at 244.60767550653503 "$node_(51) setdest 117 829 7.0" 
$ns at 374.73491295837835 "$node_(51) setdest 1841 234 6.0" 
$ns at 626.8601330930798 "$node_(51) setdest 2644 410 2.0" 
$ns at 0.0 "$node_(52) setdest 2600 102 4.0" 
$ns at 32.94275623077038 "$node_(52) setdest 1135 38 15.0" 
$ns at 154.15687850450922 "$node_(52) setdest 714 554 1.0" 
$ns at 221.644215637442 "$node_(52) setdest 70 240 14.0" 
$ns at 431.5431346686241 "$node_(52) setdest 1856 287 5.0" 
$ns at 715.4924518830983 "$node_(52) setdest 2230 680 16.0" 
$ns at 0.0 "$node_(53) setdest 1878 189 16.0" 
$ns at 107.70776750161026 "$node_(53) setdest 520 353 8.0" 
$ns at 178.29235137870694 "$node_(53) setdest 900 307 6.0" 
$ns at 250.69487685173493 "$node_(53) setdest 1701 353 13.0" 
$ns at 428.4153004776999 "$node_(53) setdest 2765 616 7.0" 
$ns at 716.9194427088084 "$node_(53) setdest 350 17 4.0" 
$ns at 0.0 "$node_(54) setdest 1021 41 19.0" 
$ns at 24.238972261737125 "$node_(54) setdest 2102 483 1.0" 
$ns at 59.250231345336694 "$node_(54) setdest 1373 393 18.0" 
$ns at 280.98928808636975 "$node_(54) setdest 986 988 8.0" 
$ns at 434.3108440814143 "$node_(54) setdest 2286 148 20.0" 
$ns at 831.9052514661958 "$node_(54) setdest 2404 430 1.0" 
$ns at 0.0 "$node_(55) setdest 179 252 10.0" 
$ns at 39.82797843484179 "$node_(55) setdest 1075 7 16.0" 
$ns at 222.87622268878258 "$node_(55) setdest 2375 364 20.0" 
$ns at 454.8514429728263 "$node_(55) setdest 990 992 19.0" 
$ns at 606.10187651645 "$node_(55) setdest 1769 222 17.0" 
$ns at 0.0 "$node_(56) setdest 201 929 7.0" 
$ns at 36.49433128106352 "$node_(56) setdest 2873 64 6.0" 
$ns at 103.63125283935877 "$node_(56) setdest 1988 806 6.0" 
$ns at 199.8571930210876 "$node_(56) setdest 680 261 20.0" 
$ns at 363.33016748811843 "$node_(56) setdest 715 15 19.0" 
$ns at 622.6017351487635 "$node_(56) setdest 538 602 19.0" 
$ns at 0.0 "$node_(57) setdest 2449 134 9.0" 
$ns at 54.57610688454983 "$node_(57) setdest 2956 913 1.0" 
$ns at 91.48093060506915 "$node_(57) setdest 132 851 4.0" 
$ns at 182.21411232760613 "$node_(57) setdest 1028 908 13.0" 
$ns at 366.4559004442248 "$node_(57) setdest 865 554 15.0" 
$ns at 633.292280208778 "$node_(57) setdest 2921 485 4.0" 
$ns at 0.0 "$node_(58) setdest 2637 423 19.0" 
$ns at 65.45076198869236 "$node_(58) setdest 2590 862 20.0" 
$ns at 270.177350545139 "$node_(58) setdest 1520 38 6.0" 
$ns at 370.7639137252471 "$node_(58) setdest 2670 243 6.0" 
$ns at 498.1525318336248 "$node_(58) setdest 172 834 19.0" 
$ns at 884.5889427496343 "$node_(58) setdest 2221 941 5.0" 
$ns at 0.0 "$node_(59) setdest 1187 930 16.0" 
$ns at 133.8730395149641 "$node_(59) setdest 764 124 9.0" 
$ns at 174.99341427202737 "$node_(59) setdest 2608 158 2.0" 
$ns at 251.5805112405327 "$node_(59) setdest 1787 624 15.0" 
$ns at 377.4327798949682 "$node_(59) setdest 1663 313 9.0" 
$ns at 658.6900119181453 "$node_(59) setdest 2654 471 18.0" 
$ns at 0.0 "$node_(60) setdest 1521 953 2.0" 
$ns at 24.19136982649107 "$node_(60) setdest 611 81 4.0" 
$ns at 88.04396054371092 "$node_(60) setdest 1646 278 5.0" 
$ns at 182.69514442048455 "$node_(60) setdest 308 288 8.0" 
$ns at 340.33784914712794 "$node_(60) setdest 1040 904 13.0" 
$ns at 673.1671595372874 "$node_(60) setdest 28 619 9.0" 
$ns at 0.0 "$node_(61) setdest 2446 577 6.0" 
$ns at 35.110673838028674 "$node_(61) setdest 560 514 18.0" 
$ns at 185.60324383865196 "$node_(61) setdest 304 120 12.0" 
$ns at 269.4968819100285 "$node_(61) setdest 395 402 10.0" 
$ns at 419.8722437644416 "$node_(61) setdest 2043 182 2.0" 
$ns at 674.4005808181596 "$node_(61) setdest 1672 813 6.0" 
$ns at 0.0 "$node_(62) setdest 991 571 6.0" 
$ns at 18.02779456974462 "$node_(62) setdest 1077 947 3.0" 
$ns at 76.45314853359548 "$node_(62) setdest 2980 232 14.0" 
$ns at 248.9331263614427 "$node_(62) setdest 607 388 15.0" 
$ns at 464.55858979111036 "$node_(62) setdest 2449 172 13.0" 
$ns at 817.1934962269456 "$node_(62) setdest 1894 876 18.0" 
$ns at 0.0 "$node_(63) setdest 2598 873 2.0" 
$ns at 23.94154824157578 "$node_(63) setdest 2524 316 20.0" 
$ns at 78.84157968293258 "$node_(63) setdest 912 9 19.0" 
$ns at 157.43713527709178 "$node_(63) setdest 1527 453 4.0" 
$ns at 293.52318235361895 "$node_(63) setdest 108 498 13.0" 
$ns at 603.5238038346492 "$node_(63) setdest 981 892 6.0" 
$ns at 0.0 "$node_(64) setdest 308 213 3.0" 
$ns at 26.86036077852318 "$node_(64) setdest 401 375 1.0" 
$ns at 60.08783415975491 "$node_(64) setdest 1009 879 20.0" 
$ns at 164.49330667622786 "$node_(64) setdest 2360 507 13.0" 
$ns at 305.65214158002624 "$node_(64) setdest 151 975 9.0" 
$ns at 582.8349252706051 "$node_(64) setdest 519 346 8.0" 
$ns at 0.0 "$node_(65) setdest 2339 689 16.0" 
$ns at 155.1033376091908 "$node_(65) setdest 2997 537 16.0" 
$ns at 310.05511051178473 "$node_(65) setdest 1033 208 4.0" 
$ns at 392.8735284972913 "$node_(65) setdest 772 914 19.0" 
$ns at 603.6403732130252 "$node_(65) setdest 2268 928 19.0" 
$ns at 898.3251495879766 "$node_(65) setdest 1538 750 6.0" 
$ns at 0.0 "$node_(66) setdest 2196 350 16.0" 
$ns at 58.13138608754002 "$node_(66) setdest 1208 74 14.0" 
$ns at 89.7351316094051 "$node_(66) setdest 2535 736 12.0" 
$ns at 214.75351693858357 "$node_(66) setdest 2999 738 7.0" 
$ns at 365.1305149327769 "$node_(66) setdest 1701 818 19.0" 
$ns at 618.6238992715556 "$node_(66) setdest 2769 151 13.0" 
$ns at 0.0 "$node_(67) setdest 2217 104 19.0" 
$ns at 35.32206930877044 "$node_(67) setdest 1053 868 4.0" 
$ns at 97.25216747669978 "$node_(67) setdest 679 600 13.0" 
$ns at 199.6126148685149 "$node_(67) setdest 986 443 14.0" 
$ns at 351.7860409002989 "$node_(67) setdest 2348 976 9.0" 
$ns at 649.0967026566332 "$node_(67) setdest 19 245 9.0" 
$ns at 0.0 "$node_(68) setdest 1184 495 8.0" 
$ns at 76.19082864485884 "$node_(68) setdest 2151 135 5.0" 
$ns at 126.5241574792908 "$node_(68) setdest 1865 249 18.0" 
$ns at 361.91507776780986 "$node_(68) setdest 74 206 10.0" 
$ns at 574.5822278936537 "$node_(68) setdest 2120 497 17.0" 
$ns at 0.0 "$node_(69) setdest 442 989 5.0" 
$ns at 47.76060086779289 "$node_(69) setdest 1408 169 3.0" 
$ns at 103.7024258088807 "$node_(69) setdest 1179 825 2.0" 
$ns at 176.22040276515796 "$node_(69) setdest 776 823 20.0" 
$ns at 346.719206532175 "$node_(69) setdest 1520 298 1.0" 
$ns at 594.1240172694363 "$node_(69) setdest 1446 615 9.0" 
$ns at 0.0 "$node_(70) setdest 217 940 9.0" 
$ns at 71.96674774909619 "$node_(70) setdest 1432 84 10.0" 
$ns at 138.3032552768541 "$node_(70) setdest 1087 605 3.0" 
$ns at 213.76754777148057 "$node_(70) setdest 2256 785 12.0" 
$ns at 335.6476407308451 "$node_(70) setdest 848 202 11.0" 
$ns at 630.0065549780913 "$node_(70) setdest 2569 105 20.0" 
$ns at 0.0 "$node_(71) setdest 912 706 16.0" 
$ns at 29.9504811338584 "$node_(71) setdest 1231 771 12.0" 
$ns at 130.10714474813312 "$node_(71) setdest 1580 637 11.0" 
$ns at 297.5459014752938 "$node_(71) setdest 164 886 1.0" 
$ns at 418.6405709488431 "$node_(71) setdest 818 407 6.0" 
$ns at 664.7700927461283 "$node_(71) setdest 1034 529 20.0" 
$ns at 0.0 "$node_(72) setdest 2549 237 2.0" 
$ns at 31.029895558458787 "$node_(72) setdest 2572 208 5.0" 
$ns at 95.38715966998303 "$node_(72) setdest 1139 558 17.0" 
$ns at 243.83703049510638 "$node_(72) setdest 90 749 2.0" 
$ns at 364.5852259873761 "$node_(72) setdest 2523 63 1.0" 
$ns at 606.66485733175 "$node_(72) setdest 1504 384 8.0" 
$ns at 0.0 "$node_(73) setdest 2137 858 1.0" 
$ns at 20.957493703027826 "$node_(73) setdest 2919 116 14.0" 
$ns at 94.98274342010819 "$node_(73) setdest 2610 367 6.0" 
$ns at 206.04350583291736 "$node_(73) setdest 2588 653 5.0" 
$ns at 370.71213889995363 "$node_(73) setdest 1884 926 13.0" 
$ns at 655.7013530010827 "$node_(73) setdest 804 458 8.0" 
$ns at 0.0 "$node_(74) setdest 195 243 12.0" 
$ns at 78.58615321627389 "$node_(74) setdest 27 722 5.0" 
$ns at 129.78241950526592 "$node_(74) setdest 115 143 10.0" 
$ns at 203.8693443748003 "$node_(74) setdest 2310 305 19.0" 
$ns at 381.7330705279428 "$node_(74) setdest 1573 285 8.0" 
$ns at 641.6620958652579 "$node_(74) setdest 1839 952 10.0" 
$ns at 0.0 "$node_(75) setdest 540 761 3.0" 
$ns at 40.988470191390405 "$node_(75) setdest 1127 328 15.0" 
$ns at 151.98375408922806 "$node_(75) setdest 818 773 10.0" 
$ns at 223.13366807166784 "$node_(75) setdest 2194 681 7.0" 
$ns at 369.80649657889103 "$node_(75) setdest 1118 788 16.0" 
$ns at 637.2408809456829 "$node_(75) setdest 2768 177 11.0" 
$ns at 0.0 "$node_(76) setdest 1348 876 15.0" 
$ns at 96.46788686190267 "$node_(76) setdest 1337 204 1.0" 
$ns at 135.75045465591808 "$node_(76) setdest 808 133 4.0" 
$ns at 207.634870498414 "$node_(76) setdest 595 217 10.0" 
$ns at 419.4589543963324 "$node_(76) setdest 717 375 16.0" 
$ns at 715.5165712547137 "$node_(76) setdest 2601 888 1.0" 
$ns at 0.0 "$node_(77) setdest 267 531 15.0" 
$ns at 162.9005897457806 "$node_(77) setdest 1696 656 18.0" 
$ns at 271.4831587955873 "$node_(77) setdest 118 404 18.0" 
$ns at 351.10108697936437 "$node_(77) setdest 10 935 19.0" 
$ns at 537.2210534228519 "$node_(77) setdest 1035 730 5.0" 
$ns at 826.0013754376143 "$node_(77) setdest 2090 565 15.0" 
$ns at 0.0 "$node_(78) setdest 1097 712 17.0" 
$ns at 80.49265398941444 "$node_(78) setdest 2977 287 9.0" 
$ns at 200.36778284694464 "$node_(78) setdest 1659 449 8.0" 
$ns at 306.1814033811083 "$node_(78) setdest 2782 297 19.0" 
$ns at 461.2868524648924 "$node_(78) setdest 2993 943 12.0" 
$ns at 735.9674138433493 "$node_(78) setdest 578 183 17.0" 
$ns at 0.0 "$node_(79) setdest 1309 607 7.0" 
$ns at 71.69200454914765 "$node_(79) setdest 2150 796 2.0" 
$ns at 102.62835035505344 "$node_(79) setdest 2577 442 19.0" 
$ns at 325.8156062720998 "$node_(79) setdest 1934 851 5.0" 
$ns at 493.952484201664 "$node_(79) setdest 335 324 10.0" 
$ns at 802.4084296543724 "$node_(79) setdest 2180 308 20.0" 
$ns at 0.0 "$node_(80) setdest 420 66 6.0" 
$ns at 61.76849913853535 "$node_(80) setdest 1170 848 17.0" 
$ns at 147.9088234321179 "$node_(80) setdest 2303 182 4.0" 
$ns at 247.08174532492723 "$node_(80) setdest 32 973 18.0" 
$ns at 530.9076957123635 "$node_(80) setdest 467 532 9.0" 
$ns at 854.6596823337488 "$node_(80) setdest 468 549 15.0" 
$ns at 0.0 "$node_(81) setdest 995 270 8.0" 
$ns at 28.189926886739364 "$node_(81) setdest 2452 830 6.0" 
$ns at 111.20731419979887 "$node_(81) setdest 1331 773 13.0" 
$ns at 206.10253979604238 "$node_(81) setdest 2708 274 4.0" 
$ns at 360.37194105517756 "$node_(81) setdest 1866 482 13.0" 
$ns at 715.3891263753874 "$node_(81) setdest 1522 698 10.0" 
$ns at 0.0 "$node_(82) setdest 1801 816 1.0" 
$ns at 20.389882181268444 "$node_(82) setdest 2204 564 12.0" 
$ns at 67.64331531679721 "$node_(82) setdest 1472 602 18.0" 
$ns at 221.62473201257345 "$node_(82) setdest 250 466 18.0" 
$ns at 363.32962419523346 "$node_(82) setdest 1057 683 10.0" 
$ns at 635.6589460224034 "$node_(82) setdest 2022 98 2.0" 
$ns at 0.0 "$node_(83) setdest 1363 642 10.0" 
$ns at 49.86385048205191 "$node_(83) setdest 2498 269 18.0" 
$ns at 162.53542027493188 "$node_(83) setdest 1116 805 5.0" 
$ns at 268.27385360779743 "$node_(83) setdest 2397 757 13.0" 
$ns at 436.4112404551406 "$node_(83) setdest 941 960 20.0" 
$ns at 827.470543524036 "$node_(83) setdest 1754 60 4.0" 
$ns at 0.0 "$node_(84) setdest 974 462 17.0" 
$ns at 104.86678631744667 "$node_(84) setdest 730 334 12.0" 
$ns at 193.630870264799 "$node_(84) setdest 775 648 7.0" 
$ns at 258.2032927839946 "$node_(84) setdest 239 81 9.0" 
$ns at 441.9843620273915 "$node_(84) setdest 1982 743 1.0" 
$ns at 685.4171832777955 "$node_(84) setdest 1683 382 9.0" 
$ns at 0.0 "$node_(85) setdest 2895 680 18.0" 
$ns at 92.23837118886908 "$node_(85) setdest 2859 722 19.0" 
$ns at 167.8948300958329 "$node_(85) setdest 1917 514 9.0" 
$ns at 306.5351883212832 "$node_(85) setdest 2858 716 3.0" 
$ns at 440.7583333206827 "$node_(85) setdest 536 341 14.0" 
$ns at 722.92045304967 "$node_(85) setdest 2491 280 5.0" 
$ns at 0.0 "$node_(86) setdest 284 923 1.0" 
$ns at 16.77293614234534 "$node_(86) setdest 2573 51 1.0" 
$ns at 54.057712238990334 "$node_(86) setdest 858 417 8.0" 
$ns at 193.98723912517147 "$node_(86) setdest 113 109 8.0" 
$ns at 354.4201469993431 "$node_(86) setdest 1327 909 6.0" 
$ns at 617.856495648876 "$node_(86) setdest 1218 291 17.0" 
$ns at 0.0 "$node_(87) setdest 1126 658 13.0" 
$ns at 124.8178203542588 "$node_(87) setdest 1273 667 2.0" 
$ns at 165.37621990071398 "$node_(87) setdest 1250 241 11.0" 
$ns at 236.33941225414327 "$node_(87) setdest 708 956 6.0" 
$ns at 408.34094329050566 "$node_(87) setdest 854 13 9.0" 
$ns at 683.1722630628067 "$node_(87) setdest 2399 954 2.0" 
$ns at 0.0 "$node_(88) setdest 164 571 11.0" 
$ns at 19.526155168557665 "$node_(88) setdest 527 258 7.0" 
$ns at 97.58598453973607 "$node_(88) setdest 416 131 6.0" 
$ns at 170.01412873332185 "$node_(88) setdest 1444 850 10.0" 
$ns at 317.80567596746477 "$node_(88) setdest 1233 9 8.0" 
$ns at 608.6898489088971 "$node_(88) setdest 854 325 6.0" 
$ns at 0.0 "$node_(89) setdest 2624 628 16.0" 
$ns at 143.91755220440018 "$node_(89) setdest 1376 841 1.0" 
$ns at 181.5631626981031 "$node_(89) setdest 1556 715 13.0" 
$ns at 352.7575793837242 "$node_(89) setdest 2287 59 19.0" 
$ns at 614.7851904448556 "$node_(89) setdest 762 634 18.0" 
$ns at 867.739137447216 "$node_(89) setdest 2009 648 5.0" 
$ns at 0.0 "$node_(90) setdest 240 14 5.0" 
$ns at 60.87982768397969 "$node_(90) setdest 652 148 16.0" 
$ns at 248.9880980062044 "$node_(90) setdest 2597 102 10.0" 
$ns at 392.4580218372323 "$node_(90) setdest 2664 239 6.0" 
$ns at 521.6400206011458 "$node_(90) setdest 1208 527 15.0" 
$ns at 809.4468879722955 "$node_(90) setdest 2403 719 16.0" 
$ns at 0.0 "$node_(91) setdest 1844 383 19.0" 
$ns at 204.1877052610803 "$node_(91) setdest 2185 746 11.0" 
$ns at 318.4383427376389 "$node_(91) setdest 212 824 1.0" 
$ns at 385.3745850532016 "$node_(91) setdest 2116 135 10.0" 
$ns at 581.9682257736487 "$node_(91) setdest 603 583 13.0" 
$ns at 0.0 "$node_(92) setdest 779 773 13.0" 
$ns at 97.9006469911453 "$node_(92) setdest 2558 99 5.0" 
$ns at 128.40375779258602 "$node_(92) setdest 1563 438 11.0" 
$ns at 195.30982873039744 "$node_(92) setdest 259 177 13.0" 
$ns at 361.83791641519736 "$node_(92) setdest 2211 594 10.0" 
$ns at 698.502924736626 "$node_(92) setdest 1057 354 18.0" 
$ns at 0.0 "$node_(93) setdest 2886 936 17.0" 
$ns at 173.26955400748403 "$node_(93) setdest 1344 398 10.0" 
$ns at 210.72801729583526 "$node_(93) setdest 2823 757 12.0" 
$ns at 316.19515199801765 "$node_(93) setdest 2678 617 14.0" 
$ns at 504.67896640409487 "$node_(93) setdest 1357 432 18.0" 
$ns at 860.950899985397 "$node_(93) setdest 1867 899 13.0" 
$ns at 0.0 "$node_(94) setdest 1909 566 11.0" 
$ns at 48.09482255071929 "$node_(94) setdest 427 669 18.0" 
$ns at 193.9284059858088 "$node_(94) setdest 223 605 14.0" 
$ns at 299.91380421269395 "$node_(94) setdest 1610 176 15.0" 
$ns at 487.93492221721556 "$node_(94) setdest 1916 973 10.0" 
$ns at 731.8158936348424 "$node_(94) setdest 2932 794 1.0" 
$ns at 0.0 "$node_(95) setdest 1152 23 19.0" 
$ns at 169.90618367660866 "$node_(95) setdest 1883 266 19.0" 
$ns at 291.4479224394879 "$node_(95) setdest 2996 357 7.0" 
$ns at 356.0212104873945 "$node_(95) setdest 250 49 13.0" 
$ns at 478.7788734951686 "$node_(95) setdest 1758 316 17.0" 
$ns at 886.5178304836505 "$node_(95) setdest 2250 215 3.0" 
$ns at 0.0 "$node_(96) setdest 2387 696 5.0" 
$ns at 15.64667114822472 "$node_(96) setdest 2383 553 15.0" 
$ns at 50.271034954004655 "$node_(96) setdest 1720 979 4.0" 
$ns at 112.31147230088209 "$node_(96) setdest 1716 817 19.0" 
$ns at 264.48677064213757 "$node_(96) setdest 145 641 2.0" 
$ns at 521.979013591069 "$node_(96) setdest 2011 295 6.0" 
$ns at 0.0 "$node_(97) setdest 993 331 19.0" 
$ns at 69.38585209568737 "$node_(97) setdest 2884 112 7.0" 
$ns at 102.23421836446701 "$node_(97) setdest 707 975 14.0" 
$ns at 289.84282358182475 "$node_(97) setdest 943 962 17.0" 
$ns at 513.0458793689074 "$node_(97) setdest 606 108 5.0" 
$ns at 789.9819986319914 "$node_(97) setdest 2568 170 4.0" 
$ns at 0.0 "$node_(98) setdest 2798 975 10.0" 
$ns at 91.74638743356624 "$node_(98) setdest 2779 289 20.0" 
$ns at 239.71456037983071 "$node_(98) setdest 1550 213 16.0" 
$ns at 360.3185782969976 "$node_(98) setdest 378 629 18.0" 
$ns at 641.6175275456092 "$node_(98) setdest 177 161 19.0" 
$ns at 0.0 "$node_(99) setdest 286 421 9.0" 
$ns at 62.14797633377339 "$node_(99) setdest 257 96 12.0" 
$ns at 117.75735121911376 "$node_(99) setdest 2770 514 18.0" 
$ns at 333.1737368912703 "$node_(99) setdest 725 947 13.0" 
$ns at 526.40404483767 "$node_(99) setdest 992 805 2.0" 
$ns at 772.1335090175858 "$node_(99) setdest 168 292 10.0" 


#Set a TCP connection between node_(2) and node_(81)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(0)
$ns attach-agent $node_(81) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(55) and node_(49)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(1)
$ns attach-agent $node_(49) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(78) and node_(67)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(2)
$ns attach-agent $node_(67) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(27) and node_(63)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(3)
$ns attach-agent $node_(63) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(82) and node_(9)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(4)
$ns attach-agent $node_(9) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(86) and node_(31)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(5)
$ns attach-agent $node_(31) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(62) and node_(59)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(6)
$ns attach-agent $node_(59) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(61) and node_(5)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(7)
$ns attach-agent $node_(5) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(62) and node_(35)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(8)
$ns attach-agent $node_(35) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(75) and node_(63)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(9)
$ns attach-agent $node_(63) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(77) and node_(58)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(10)
$ns attach-agent $node_(58) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(80) and node_(46)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(11)
$ns attach-agent $node_(46) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(98) and node_(56)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(12)
$ns attach-agent $node_(56) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(14) and node_(59)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(13)
$ns attach-agent $node_(59) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(15) and node_(38)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(14)
$ns attach-agent $node_(38) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(48) and node_(66)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(15)
$ns attach-agent $node_(66) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(22) and node_(38)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(16)
$ns attach-agent $node_(38) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(88) and node_(6)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(17)
$ns attach-agent $node_(6) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(76) and node_(8)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(18)
$ns attach-agent $node_(8) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(85) and node_(58)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(19)
$ns attach-agent $node_(58) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(16) and node_(59)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(20)
$ns attach-agent $node_(59) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(30) and node_(6)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(21)
$ns attach-agent $node_(6) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(4) and node_(57)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(22)
$ns attach-agent $node_(57) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(76) and node_(62)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(23)
$ns attach-agent $node_(62) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(83) and node_(51)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(24)
$ns attach-agent $node_(51) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(42) and node_(86)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(25)
$ns attach-agent $node_(86) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(58) and node_(0)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(26)
$ns attach-agent $node_(0) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(42) and node_(92)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(27)
$ns attach-agent $node_(92) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(9) and node_(56)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(28)
$ns attach-agent $node_(56) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(77) and node_(67)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(29)
$ns attach-agent $node_(67) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(13) and node_(74)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(30)
$ns attach-agent $node_(74) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(2) and node_(29)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(31)
$ns attach-agent $node_(29) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(37) and node_(33)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(32)
$ns attach-agent $node_(33) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(13) and node_(9)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(33)
$ns attach-agent $node_(9) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(78) and node_(26)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(34)
$ns attach-agent $node_(26) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(36) and node_(43)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(35)
$ns attach-agent $node_(43) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(69) and node_(91)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(36)
$ns attach-agent $node_(91) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(20) and node_(4)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(37)
$ns attach-agent $node_(4) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(78) and node_(89)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(38)
$ns attach-agent $node_(89) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(28) and node_(86)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(39)
$ns attach-agent $node_(86) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(33) and node_(38)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(40)
$ns attach-agent $node_(38) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(71) and node_(72)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(41)
$ns attach-agent $node_(72) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(20) and node_(32)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(42)
$ns attach-agent $node_(32) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(60) and node_(75)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(43)
$ns attach-agent $node_(75) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(51) and node_(60)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(44)
$ns attach-agent $node_(60) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(2) and node_(65)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(45)
$ns attach-agent $node_(65) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(51) and node_(32)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(46)
$ns attach-agent $node_(32) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(67) and node_(16)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(47)
$ns attach-agent $node_(16) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(63) and node_(81)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(48)
$ns attach-agent $node_(81) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(17) and node_(97)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(49)
$ns attach-agent $node_(97) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(3) and node_(9)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(50)
$ns attach-agent $node_(9) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(92) and node_(81)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(51)
$ns attach-agent $node_(81) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(37) and node_(63)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(52)
$ns attach-agent $node_(63) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(26) and node_(63)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(53)
$ns attach-agent $node_(63) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(29) and node_(18)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(54)
$ns attach-agent $node_(18) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(87) and node_(37)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(55)
$ns attach-agent $node_(37) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(85) and node_(40)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(56)
$ns attach-agent $node_(40) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(43) and node_(1)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(57)
$ns attach-agent $node_(1) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(19) and node_(78)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(58)
$ns attach-agent $node_(78) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(60) and node_(44)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(59)
$ns attach-agent $node_(44) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(84) and node_(11)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(60)
$ns attach-agent $node_(11) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(75) and node_(17)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(61)
$ns attach-agent $node_(17) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(38) and node_(17)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(62)
$ns attach-agent $node_(17) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(59) and node_(31)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(63)
$ns attach-agent $node_(31) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(45) and node_(25)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(64)
$ns attach-agent $node_(25) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(91) and node_(79)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(65)
$ns attach-agent $node_(79) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(15) and node_(9)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(66)
$ns attach-agent $node_(9) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(43) and node_(76)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(67)
$ns attach-agent $node_(76) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(93) and node_(31)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(68)
$ns attach-agent $node_(31) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(50) and node_(41)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(69)
$ns attach-agent $node_(41) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(90) and node_(85)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(70)
$ns attach-agent $node_(85) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(81) and node_(60)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(71)
$ns attach-agent $node_(60) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(54) and node_(82)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(72)
$ns attach-agent $node_(82) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(24) and node_(58)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(73)
$ns attach-agent $node_(58) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(92) and node_(23)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(74)
$ns attach-agent $node_(23) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(76) and node_(82)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(75)
$ns attach-agent $node_(82) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(49) and node_(22)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(76)
$ns attach-agent $node_(22) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(50) and node_(10)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(77)
$ns attach-agent $node_(10) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(90) and node_(18)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(78)
$ns attach-agent $node_(18) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(19) and node_(32)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(79)
$ns attach-agent $node_(32) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(55) and node_(72)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(80)
$ns attach-agent $node_(72) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(86) and node_(38)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(81)
$ns attach-agent $node_(38) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(70) and node_(50)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(82)
$ns attach-agent $node_(50) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(92) and node_(86)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(83)
$ns attach-agent $node_(86) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(81) and node_(20)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(84)
$ns attach-agent $node_(20) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(68) and node_(57)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(85)
$ns attach-agent $node_(57) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(13) and node_(54)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(86)
$ns attach-agent $node_(54) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(13) and node_(54)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(87)
$ns attach-agent $node_(54) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(50) and node_(71)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(88)
$ns attach-agent $node_(71) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(90) and node_(9)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(89)
$ns attach-agent $node_(9) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(57) and node_(64)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(90)
$ns attach-agent $node_(64) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(55) and node_(87)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(91)
$ns attach-agent $node_(87) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(12) and node_(5)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(92)
$ns attach-agent $node_(5) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(41) and node_(60)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(93)
$ns attach-agent $node_(60) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(25) and node_(9)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(94)
$ns attach-agent $node_(9) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(4) and node_(46)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(95)
$ns attach-agent $node_(46) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(15) and node_(58)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(96)
$ns attach-agent $node_(58) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(88) and node_(66)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(97)
$ns attach-agent $node_(66) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(82) and node_(59)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(98)
$ns attach-agent $node_(59) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(38) and node_(77)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(99)
$ns attach-agent $node_(77) $sink_(99)
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
