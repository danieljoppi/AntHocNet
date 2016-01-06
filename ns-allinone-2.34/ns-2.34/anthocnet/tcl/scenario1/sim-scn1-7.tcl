#sim-scn1-7.tcl 
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
set tracefd       [open sim-scn1-7-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-7-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-7-$val(rp).nam w]

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
$node_(0) set X_ 2045 
$node_(0) set Y_ 263 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 707 
$node_(1) set Y_ 33 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1006 
$node_(2) set Y_ 868 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1906 
$node_(3) set Y_ 339 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2925 
$node_(4) set Y_ 905 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1740 
$node_(5) set Y_ 190 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 797 
$node_(6) set Y_ 331 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2735 
$node_(7) set Y_ 184 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 713 
$node_(8) set Y_ 24 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 64 
$node_(9) set Y_ 595 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 44 
$node_(10) set Y_ 932 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2909 
$node_(11) set Y_ 324 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 423 
$node_(12) set Y_ 398 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 365 
$node_(13) set Y_ 525 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2376 
$node_(14) set Y_ 291 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2721 
$node_(15) set Y_ 508 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1409 
$node_(16) set Y_ 223 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1791 
$node_(17) set Y_ 229 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 819 
$node_(18) set Y_ 197 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2759 
$node_(19) set Y_ 327 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1407 
$node_(20) set Y_ 463 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2794 
$node_(21) set Y_ 185 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 2648 
$node_(22) set Y_ 257 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2421 
$node_(23) set Y_ 945 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1726 
$node_(24) set Y_ 323 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 327 
$node_(25) set Y_ 767 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1161 
$node_(26) set Y_ 855 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2011 
$node_(27) set Y_ 834 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 545 
$node_(28) set Y_ 511 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1265 
$node_(29) set Y_ 832 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 159 
$node_(30) set Y_ 703 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1148 
$node_(31) set Y_ 634 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 973 
$node_(32) set Y_ 217 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1673 
$node_(33) set Y_ 943 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2707 
$node_(34) set Y_ 544 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 1980 
$node_(35) set Y_ 496 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1332 
$node_(36) set Y_ 997 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1295 
$node_(37) set Y_ 231 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2473 
$node_(38) set Y_ 812 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2474 
$node_(39) set Y_ 517 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1824 
$node_(40) set Y_ 960 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1374 
$node_(41) set Y_ 125 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1713 
$node_(42) set Y_ 285 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1741 
$node_(43) set Y_ 144 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2531 
$node_(44) set Y_ 974 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 684 
$node_(45) set Y_ 449 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2706 
$node_(46) set Y_ 50 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1181 
$node_(47) set Y_ 641 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1425 
$node_(48) set Y_ 771 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2400 
$node_(49) set Y_ 612 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1198 
$node_(50) set Y_ 316 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 912 
$node_(51) set Y_ 4 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 1824 
$node_(52) set Y_ 168 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 156 
$node_(53) set Y_ 889 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 2162 
$node_(54) set Y_ 885 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 746 
$node_(55) set Y_ 915 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 473 
$node_(56) set Y_ 803 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2436 
$node_(57) set Y_ 26 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 935 
$node_(58) set Y_ 324 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 711 
$node_(59) set Y_ 620 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 188 
$node_(60) set Y_ 71 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2158 
$node_(61) set Y_ 658 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2547 
$node_(62) set Y_ 150 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2846 
$node_(63) set Y_ 824 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 1751 
$node_(64) set Y_ 187 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 65 
$node_(65) set Y_ 281 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 2780 
$node_(66) set Y_ 566 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1793 
$node_(67) set Y_ 984 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2474 
$node_(68) set Y_ 552 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 2315 
$node_(69) set Y_ 762 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2289 
$node_(70) set Y_ 556 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 399 
$node_(71) set Y_ 600 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 2637 
$node_(72) set Y_ 841 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 363 
$node_(73) set Y_ 632 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 2835 
$node_(74) set Y_ 391 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 360 
$node_(75) set Y_ 375 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 711 
$node_(76) set Y_ 495 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 2034 
$node_(77) set Y_ 638 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 1429 
$node_(78) set Y_ 840 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2623 
$node_(79) set Y_ 352 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 1072 
$node_(80) set Y_ 547 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 387 
$node_(81) set Y_ 309 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1962 
$node_(82) set Y_ 649 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 2056 
$node_(83) set Y_ 400 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1618 
$node_(84) set Y_ 945 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 1756 
$node_(85) set Y_ 511 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1617 
$node_(86) set Y_ 67 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 633 
$node_(87) set Y_ 648 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 1495 
$node_(88) set Y_ 808 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 1074 
$node_(89) set Y_ 233 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 128 
$node_(90) set Y_ 502 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1128 
$node_(91) set Y_ 748 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 838 
$node_(92) set Y_ 286 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 368 
$node_(93) set Y_ 94 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2692 
$node_(94) set Y_ 570 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1056 
$node_(95) set Y_ 61 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 1242 
$node_(96) set Y_ 957 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2035 
$node_(97) set Y_ 312 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 92 
$node_(98) set Y_ 124 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 1375 
$node_(99) set Y_ 148 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 1373 925 15.0" 
$ns at 31.67225874265989 "$node_(0) setdest 346 37 1.0" 
$ns at 63.33396217349651 "$node_(0) setdest 911 54 12.0" 
$ns at 222.06259055312194 "$node_(0) setdest 930 800 16.0" 
$ns at 347.7458118203224 "$node_(0) setdest 2755 10 4.0" 
$ns at 593.8967243990627 "$node_(0) setdest 1391 243 14.0" 
$ns at 0.0 "$node_(1) setdest 1189 41 11.0" 
$ns at 55.59721718732747 "$node_(1) setdest 909 913 3.0" 
$ns at 98.22928037360816 "$node_(1) setdest 1412 658 6.0" 
$ns at 180.58443596460302 "$node_(1) setdest 1107 925 10.0" 
$ns at 397.0146388184965 "$node_(1) setdest 2649 668 5.0" 
$ns at 683.3576665752578 "$node_(1) setdest 2186 332 1.0" 
$ns at 0.0 "$node_(2) setdest 756 202 5.0" 
$ns at 39.9329485034184 "$node_(2) setdest 2176 305 9.0" 
$ns at 89.31794559158703 "$node_(2) setdest 1006 693 20.0" 
$ns at 243.16625710534007 "$node_(2) setdest 862 694 4.0" 
$ns at 375.45377703053816 "$node_(2) setdest 2495 963 17.0" 
$ns at 734.0205431344173 "$node_(2) setdest 1717 751 6.0" 
$ns at 0.0 "$node_(3) setdest 344 848 17.0" 
$ns at 129.56862515891208 "$node_(3) setdest 2864 76 1.0" 
$ns at 164.27276539350385 "$node_(3) setdest 1641 40 6.0" 
$ns at 269.55808657388616 "$node_(3) setdest 1905 88 10.0" 
$ns at 420.9446446233751 "$node_(3) setdest 798 73 12.0" 
$ns at 686.4716679464575 "$node_(3) setdest 1170 564 6.0" 
$ns at 0.0 "$node_(4) setdest 1752 617 8.0" 
$ns at 22.57350344726276 "$node_(4) setdest 677 55 20.0" 
$ns at 235.01082275242555 "$node_(4) setdest 1215 525 12.0" 
$ns at 309.7664827240857 "$node_(4) setdest 2884 221 18.0" 
$ns at 444.8489937839319 "$node_(4) setdest 876 290 13.0" 
$ns at 701.6974312673528 "$node_(4) setdest 31 398 17.0" 
$ns at 0.0 "$node_(5) setdest 268 851 19.0" 
$ns at 159.60382209786363 "$node_(5) setdest 2630 938 18.0" 
$ns at 218.50822704656713 "$node_(5) setdest 713 916 19.0" 
$ns at 362.54918023085764 "$node_(5) setdest 417 119 3.0" 
$ns at 503.8752223122231 "$node_(5) setdest 539 234 12.0" 
$ns at 844.4479886516547 "$node_(5) setdest 2811 694 13.0" 
$ns at 0.0 "$node_(6) setdest 1497 482 12.0" 
$ns at 51.00021523956163 "$node_(6) setdest 714 359 5.0" 
$ns at 121.8607821968084 "$node_(6) setdest 2068 707 6.0" 
$ns at 184.10082784926027 "$node_(6) setdest 1183 701 10.0" 
$ns at 379.9996028182845 "$node_(6) setdest 2085 487 11.0" 
$ns at 620.0376359975319 "$node_(6) setdest 2299 431 14.0" 
$ns at 0.0 "$node_(7) setdest 1864 238 2.0" 
$ns at 29.277113884999103 "$node_(7) setdest 1289 942 14.0" 
$ns at 101.03742218805013 "$node_(7) setdest 766 351 17.0" 
$ns at 254.4867716248107 "$node_(7) setdest 704 500 6.0" 
$ns at 408.3596268745106 "$node_(7) setdest 884 79 7.0" 
$ns at 660.6969945435832 "$node_(7) setdest 2221 614 17.0" 
$ns at 0.0 "$node_(8) setdest 1284 343 11.0" 
$ns at 34.0555442373292 "$node_(8) setdest 2366 398 14.0" 
$ns at 121.24300378881478 "$node_(8) setdest 1977 896 3.0" 
$ns at 182.7503058657605 "$node_(8) setdest 2227 954 2.0" 
$ns at 304.990693956399 "$node_(8) setdest 1574 519 15.0" 
$ns at 568.5562357178189 "$node_(8) setdest 1961 98 12.0" 
$ns at 0.0 "$node_(9) setdest 286 156 12.0" 
$ns at 41.93255761934185 "$node_(9) setdest 2654 968 16.0" 
$ns at 216.24073575128662 "$node_(9) setdest 2717 195 4.0" 
$ns at 297.14930732696706 "$node_(9) setdest 2837 317 2.0" 
$ns at 426.72278684377784 "$node_(9) setdest 626 291 6.0" 
$ns at 719.4047706249653 "$node_(9) setdest 1735 546 6.0" 
$ns at 0.0 "$node_(10) setdest 600 427 16.0" 
$ns at 20.271863277126165 "$node_(10) setdest 1029 772 11.0" 
$ns at 108.17870077531677 "$node_(10) setdest 315 129 15.0" 
$ns at 181.76967367545868 "$node_(10) setdest 716 483 16.0" 
$ns at 316.89796071133026 "$node_(10) setdest 809 14 1.0" 
$ns at 557.2026320618788 "$node_(10) setdest 363 583 20.0" 
$ns at 0.0 "$node_(11) setdest 1981 96 16.0" 
$ns at 100.42649101946658 "$node_(11) setdest 2815 883 7.0" 
$ns at 151.21500513275612 "$node_(11) setdest 1214 525 16.0" 
$ns at 308.4982023635022 "$node_(11) setdest 160 316 17.0" 
$ns at 481.83978931515037 "$node_(11) setdest 827 686 7.0" 
$ns at 774.0409878412067 "$node_(11) setdest 531 465 7.0" 
$ns at 0.0 "$node_(12) setdest 787 836 10.0" 
$ns at 76.08020601039627 "$node_(12) setdest 2019 166 1.0" 
$ns at 116.02719433204899 "$node_(12) setdest 1859 700 16.0" 
$ns at 253.7398886937983 "$node_(12) setdest 789 262 16.0" 
$ns at 380.6659113450328 "$node_(12) setdest 129 700 14.0" 
$ns at 756.5823048892761 "$node_(12) setdest 1191 797 15.0" 
$ns at 0.0 "$node_(13) setdest 2589 758 16.0" 
$ns at 122.72171161531345 "$node_(13) setdest 2422 210 1.0" 
$ns at 154.0940678211069 "$node_(13) setdest 1208 824 11.0" 
$ns at 310.1638926425347 "$node_(13) setdest 55 315 3.0" 
$ns at 442.91803916733926 "$node_(13) setdest 2687 578 19.0" 
$ns at 760.3488814574309 "$node_(13) setdest 2495 139 9.0" 
$ns at 0.0 "$node_(14) setdest 1815 969 4.0" 
$ns at 25.213111451622147 "$node_(14) setdest 164 893 4.0" 
$ns at 91.88450631457434 "$node_(14) setdest 118 521 10.0" 
$ns at 208.8152973781393 "$node_(14) setdest 2973 653 9.0" 
$ns at 402.46810717492815 "$node_(14) setdest 1238 577 15.0" 
$ns at 662.840640509868 "$node_(14) setdest 1399 533 4.0" 
$ns at 0.0 "$node_(15) setdest 2221 914 6.0" 
$ns at 45.30235982645089 "$node_(15) setdest 1218 407 16.0" 
$ns at 211.5875945932769 "$node_(15) setdest 645 405 5.0" 
$ns at 285.5165056010832 "$node_(15) setdest 701 483 9.0" 
$ns at 457.41126447897784 "$node_(15) setdest 2276 637 7.0" 
$ns at 717.9105864330096 "$node_(15) setdest 1840 277 13.0" 
$ns at 0.0 "$node_(16) setdest 2686 690 8.0" 
$ns at 69.924690019545 "$node_(16) setdest 901 787 10.0" 
$ns at 114.76246759822806 "$node_(16) setdest 1015 476 3.0" 
$ns at 177.47996312887028 "$node_(16) setdest 376 925 6.0" 
$ns at 319.53197337357574 "$node_(16) setdest 2807 326 1.0" 
$ns at 563.81668858792 "$node_(16) setdest 1131 490 16.0" 
$ns at 0.0 "$node_(17) setdest 2612 755 6.0" 
$ns at 18.95459685280964 "$node_(17) setdest 314 260 13.0" 
$ns at 51.265331036725485 "$node_(17) setdest 781 564 6.0" 
$ns at 129.10913805198456 "$node_(17) setdest 334 977 19.0" 
$ns at 254.83708392790328 "$node_(17) setdest 1634 730 15.0" 
$ns at 556.099973787751 "$node_(17) setdest 1959 293 7.0" 
$ns at 0.0 "$node_(18) setdest 953 731 20.0" 
$ns at 175.28235266076388 "$node_(18) setdest 359 969 16.0" 
$ns at 276.569413230188 "$node_(18) setdest 1454 256 11.0" 
$ns at 438.18493221016973 "$node_(18) setdest 632 884 10.0" 
$ns at 579.7967790753189 "$node_(18) setdest 2702 465 4.0" 
$ns at 859.2469283667041 "$node_(18) setdest 1144 651 17.0" 
$ns at 0.0 "$node_(19) setdest 2631 221 8.0" 
$ns at 71.79228826999122 "$node_(19) setdest 1717 887 1.0" 
$ns at 103.38217830400724 "$node_(19) setdest 612 979 4.0" 
$ns at 186.9827148894595 "$node_(19) setdest 1495 452 4.0" 
$ns at 319.43021584900305 "$node_(19) setdest 1755 252 9.0" 
$ns at 596.796313196591 "$node_(19) setdest 39 186 1.0" 
$ns at 0.0 "$node_(20) setdest 1864 833 19.0" 
$ns at 20.673389243675853 "$node_(20) setdest 948 969 14.0" 
$ns at 161.08681949415643 "$node_(20) setdest 2255 190 14.0" 
$ns at 302.1029680504465 "$node_(20) setdest 91 130 10.0" 
$ns at 460.37871827770556 "$node_(20) setdest 2339 731 4.0" 
$ns at 729.210590939355 "$node_(20) setdest 1226 533 16.0" 
$ns at 0.0 "$node_(21) setdest 2679 832 2.0" 
$ns at 26.04970403986657 "$node_(21) setdest 595 860 12.0" 
$ns at 112.46876959683773 "$node_(21) setdest 940 841 16.0" 
$ns at 208.70066827609278 "$node_(21) setdest 2782 921 10.0" 
$ns at 343.6772248841164 "$node_(21) setdest 2925 447 4.0" 
$ns at 603.9135891028136 "$node_(21) setdest 1904 26 3.0" 
$ns at 0.0 "$node_(22) setdest 2622 127 11.0" 
$ns at 96.60716846809586 "$node_(22) setdest 937 714 2.0" 
$ns at 134.25062947255333 "$node_(22) setdest 2952 558 2.0" 
$ns at 194.48872815970853 "$node_(22) setdest 1744 411 6.0" 
$ns at 327.7442243175918 "$node_(22) setdest 2646 207 16.0" 
$ns at 633.0969768802829 "$node_(22) setdest 1102 795 1.0" 
$ns at 0.0 "$node_(23) setdest 1445 494 3.0" 
$ns at 36.46187990429602 "$node_(23) setdest 1797 935 19.0" 
$ns at 250.20918449990262 "$node_(23) setdest 1539 227 4.0" 
$ns at 348.6368176600305 "$node_(23) setdest 591 495 7.0" 
$ns at 475.4570826057128 "$node_(23) setdest 1950 214 6.0" 
$ns at 750.4778381113035 "$node_(23) setdest 2621 562 2.0" 
$ns at 0.0 "$node_(24) setdest 1273 253 14.0" 
$ns at 43.72838610870904 "$node_(24) setdest 1531 886 11.0" 
$ns at 165.03230273625235 "$node_(24) setdest 972 896 15.0" 
$ns at 260.8602910056234 "$node_(24) setdest 414 602 12.0" 
$ns at 463.2084578343006 "$node_(24) setdest 2160 690 18.0" 
$ns at 852.9016494229221 "$node_(24) setdest 2349 712 17.0" 
$ns at 0.0 "$node_(25) setdest 1541 802 5.0" 
$ns at 58.61386983536372 "$node_(25) setdest 2113 901 16.0" 
$ns at 178.6238234840781 "$node_(25) setdest 1961 212 15.0" 
$ns at 246.96526780210115 "$node_(25) setdest 2361 469 15.0" 
$ns at 414.95752717992184 "$node_(25) setdest 2736 904 2.0" 
$ns at 659.7787754836552 "$node_(25) setdest 339 436 12.0" 
$ns at 0.0 "$node_(26) setdest 1706 715 11.0" 
$ns at 80.3173370318503 "$node_(26) setdest 2944 129 8.0" 
$ns at 189.28261546483225 "$node_(26) setdest 2682 788 7.0" 
$ns at 266.54405721983187 "$node_(26) setdest 2674 790 9.0" 
$ns at 434.201333391503 "$node_(26) setdest 1736 791 3.0" 
$ns at 688.3276203718943 "$node_(26) setdest 799 9 17.0" 
$ns at 0.0 "$node_(27) setdest 1505 325 3.0" 
$ns at 32.85228034580901 "$node_(27) setdest 2785 38 19.0" 
$ns at 170.7717836262969 "$node_(27) setdest 1452 218 9.0" 
$ns at 245.05164691713662 "$node_(27) setdest 1806 281 6.0" 
$ns at 368.99718866955004 "$node_(27) setdest 2757 604 16.0" 
$ns at 615.4186968501632 "$node_(27) setdest 2883 514 19.0" 
$ns at 0.0 "$node_(28) setdest 1286 977 8.0" 
$ns at 58.7746742711128 "$node_(28) setdest 2967 632 3.0" 
$ns at 118.35410004246759 "$node_(28) setdest 2803 648 4.0" 
$ns at 206.6506189278161 "$node_(28) setdest 2025 980 11.0" 
$ns at 427.3804213349555 "$node_(28) setdest 2382 274 1.0" 
$ns at 669.8584114767757 "$node_(28) setdest 937 563 3.0" 
$ns at 0.0 "$node_(29) setdest 2674 387 6.0" 
$ns at 15.073792190723452 "$node_(29) setdest 2756 688 16.0" 
$ns at 64.42258922303257 "$node_(29) setdest 2493 100 3.0" 
$ns at 146.27421117756887 "$node_(29) setdest 1651 837 8.0" 
$ns at 291.09428224404115 "$node_(29) setdest 1881 411 8.0" 
$ns at 578.5545856275304 "$node_(29) setdest 1585 832 12.0" 
$ns at 0.0 "$node_(30) setdest 1595 795 14.0" 
$ns at 124.27352476969638 "$node_(30) setdest 2533 570 5.0" 
$ns at 201.2861742399267 "$node_(30) setdest 2703 984 11.0" 
$ns at 370.53960892474834 "$node_(30) setdest 810 906 5.0" 
$ns at 538.9646942920258 "$node_(30) setdest 713 140 4.0" 
$ns at 811.7132932914444 "$node_(30) setdest 2802 464 2.0" 
$ns at 0.0 "$node_(31) setdest 2430 829 8.0" 
$ns at 31.13088200880088 "$node_(31) setdest 1175 440 7.0" 
$ns at 63.80785450670857 "$node_(31) setdest 1463 469 19.0" 
$ns at 221.01974126944913 "$node_(31) setdest 1360 689 4.0" 
$ns at 344.0513328481084 "$node_(31) setdest 2075 192 9.0" 
$ns at 669.0674111706246 "$node_(31) setdest 872 649 14.0" 
$ns at 0.0 "$node_(32) setdest 1807 291 15.0" 
$ns at 51.8188408427566 "$node_(32) setdest 1781 907 7.0" 
$ns at 139.4108304453692 "$node_(32) setdest 53 661 15.0" 
$ns at 348.00824316244825 "$node_(32) setdest 2380 457 19.0" 
$ns at 608.7386789454031 "$node_(32) setdest 1529 944 15.0" 
$ns at 0.0 "$node_(33) setdest 1876 941 10.0" 
$ns at 30.032377640773355 "$node_(33) setdest 2319 264 15.0" 
$ns at 67.44226210476506 "$node_(33) setdest 1643 436 6.0" 
$ns at 163.15358983986255 "$node_(33) setdest 918 761 18.0" 
$ns at 386.0547908064717 "$node_(33) setdest 2362 585 7.0" 
$ns at 690.9825825953809 "$node_(33) setdest 2479 333 16.0" 
$ns at 0.0 "$node_(34) setdest 93 119 18.0" 
$ns at 73.46223149329796 "$node_(34) setdest 171 260 6.0" 
$ns at 123.96720670937594 "$node_(34) setdest 107 68 14.0" 
$ns at 186.78272965149063 "$node_(34) setdest 2357 644 4.0" 
$ns at 315.465765010313 "$node_(34) setdest 2006 226 15.0" 
$ns at 572.0389913642589 "$node_(34) setdest 1007 844 6.0" 
$ns at 0.0 "$node_(35) setdest 477 652 2.0" 
$ns at 16.11029488066591 "$node_(35) setdest 2535 314 15.0" 
$ns at 149.51461465316444 "$node_(35) setdest 1704 272 8.0" 
$ns at 267.9304336052518 "$node_(35) setdest 1 537 10.0" 
$ns at 424.6240730055674 "$node_(35) setdest 2268 879 16.0" 
$ns at 687.834294202175 "$node_(35) setdest 349 977 15.0" 
$ns at 0.0 "$node_(36) setdest 1091 75 7.0" 
$ns at 28.779027538185126 "$node_(36) setdest 2127 220 7.0" 
$ns at 106.35857084477382 "$node_(36) setdest 1722 966 7.0" 
$ns at 170.7694754110124 "$node_(36) setdest 2860 731 19.0" 
$ns at 430.84891588585367 "$node_(36) setdest 2035 656 19.0" 
$ns at 690.5104493823869 "$node_(36) setdest 2021 906 15.0" 
$ns at 0.0 "$node_(37) setdest 2142 837 11.0" 
$ns at 57.096731197997315 "$node_(37) setdest 2281 346 13.0" 
$ns at 140.19085808189462 "$node_(37) setdest 2083 36 8.0" 
$ns at 214.227471815336 "$node_(37) setdest 457 518 6.0" 
$ns at 357.06947089394765 "$node_(37) setdest 595 305 13.0" 
$ns at 606.1310876463357 "$node_(37) setdest 2374 248 9.0" 
$ns at 0.0 "$node_(38) setdest 1026 426 13.0" 
$ns at 83.8464863812703 "$node_(38) setdest 534 698 11.0" 
$ns at 212.11958166957947 "$node_(38) setdest 1200 900 8.0" 
$ns at 274.68551180408394 "$node_(38) setdest 1311 773 11.0" 
$ns at 436.58264893018367 "$node_(38) setdest 1789 312 19.0" 
$ns at 703.2551080062024 "$node_(38) setdest 84 127 17.0" 
$ns at 0.0 "$node_(39) setdest 2507 832 17.0" 
$ns at 36.68020897629832 "$node_(39) setdest 1498 186 18.0" 
$ns at 118.26734672091341 "$node_(39) setdest 1175 935 2.0" 
$ns at 178.53299711246066 "$node_(39) setdest 2791 874 19.0" 
$ns at 450.80632906426115 "$node_(39) setdest 2474 614 9.0" 
$ns at 702.3036937580094 "$node_(39) setdest 2864 969 5.0" 
$ns at 0.0 "$node_(40) setdest 1942 663 6.0" 
$ns at 48.89734266317926 "$node_(40) setdest 1527 253 17.0" 
$ns at 79.67777818069375 "$node_(40) setdest 1522 811 14.0" 
$ns at 159.2282653990334 "$node_(40) setdest 2118 891 9.0" 
$ns at 347.70188312705716 "$node_(40) setdest 2720 762 19.0" 
$ns at 722.7146312637118 "$node_(40) setdest 1402 712 14.0" 
$ns at 0.0 "$node_(41) setdest 2187 452 17.0" 
$ns at 182.23131444242716 "$node_(41) setdest 2468 325 17.0" 
$ns at 237.5523576015728 "$node_(41) setdest 270 57 10.0" 
$ns at 313.37825648583237 "$node_(41) setdest 25 230 6.0" 
$ns at 478.6184129055167 "$node_(41) setdest 861 571 15.0" 
$ns at 723.0236573045742 "$node_(41) setdest 2305 361 8.0" 
$ns at 0.0 "$node_(42) setdest 2580 989 16.0" 
$ns at 80.64155694213008 "$node_(42) setdest 1488 742 16.0" 
$ns at 244.6558344357637 "$node_(42) setdest 120 405 3.0" 
$ns at 334.27620624338624 "$node_(42) setdest 352 164 6.0" 
$ns at 489.8077616816494 "$node_(42) setdest 302 571 7.0" 
$ns at 797.8163747940721 "$node_(42) setdest 2559 79 12.0" 
$ns at 0.0 "$node_(43) setdest 1148 726 12.0" 
$ns at 34.09426973755822 "$node_(43) setdest 782 118 5.0" 
$ns at 80.00385589697837 "$node_(43) setdest 35 730 19.0" 
$ns at 190.38709932213004 "$node_(43) setdest 590 928 15.0" 
$ns at 397.6226186706592 "$node_(43) setdest 1741 825 7.0" 
$ns at 682.6571026525748 "$node_(43) setdest 1790 234 2.0" 
$ns at 0.0 "$node_(44) setdest 933 550 5.0" 
$ns at 52.736075894872876 "$node_(44) setdest 641 317 5.0" 
$ns at 131.97169567940568 "$node_(44) setdest 1412 637 5.0" 
$ns at 241.940291552101 "$node_(44) setdest 2144 327 3.0" 
$ns at 386.3072309040483 "$node_(44) setdest 171 909 15.0" 
$ns at 742.382141733116 "$node_(44) setdest 2321 107 6.0" 
$ns at 0.0 "$node_(45) setdest 77 512 13.0" 
$ns at 127.80159479537046 "$node_(45) setdest 188 460 1.0" 
$ns at 164.48313720258852 "$node_(45) setdest 1734 5 18.0" 
$ns at 325.7744192052415 "$node_(45) setdest 837 19 4.0" 
$ns at 472.90962712625003 "$node_(45) setdest 834 129 15.0" 
$ns at 720.0492745790726 "$node_(45) setdest 1821 168 5.0" 
$ns at 0.0 "$node_(46) setdest 60 287 2.0" 
$ns at 15.235442718416419 "$node_(46) setdest 770 669 1.0" 
$ns at 53.46197624541796 "$node_(46) setdest 337 57 17.0" 
$ns at 203.8353851360641 "$node_(46) setdest 2931 937 15.0" 
$ns at 323.967221179943 "$node_(46) setdest 12 268 9.0" 
$ns at 619.0520747353257 "$node_(46) setdest 2051 126 4.0" 
$ns at 0.0 "$node_(47) setdest 1247 458 4.0" 
$ns at 54.88833489291886 "$node_(47) setdest 1801 463 16.0" 
$ns at 161.36590729759797 "$node_(47) setdest 2698 744 1.0" 
$ns at 222.49613684079387 "$node_(47) setdest 1664 493 18.0" 
$ns at 409.68062882930724 "$node_(47) setdest 288 434 2.0" 
$ns at 654.7891014178637 "$node_(47) setdest 976 177 15.0" 
$ns at 0.0 "$node_(48) setdest 625 898 18.0" 
$ns at 84.68473040591712 "$node_(48) setdest 555 2 1.0" 
$ns at 115.48054211009298 "$node_(48) setdest 1383 525 15.0" 
$ns at 198.95607878816443 "$node_(48) setdest 96 541 19.0" 
$ns at 433.3751646275565 "$node_(48) setdest 1695 805 17.0" 
$ns at 673.638850828776 "$node_(48) setdest 2265 133 5.0" 
$ns at 0.0 "$node_(49) setdest 1379 839 5.0" 
$ns at 37.63115913990036 "$node_(49) setdest 2193 611 9.0" 
$ns at 120.47523970511241 "$node_(49) setdest 2542 829 12.0" 
$ns at 300.0949235799063 "$node_(49) setdest 1769 249 14.0" 
$ns at 471.03481983065416 "$node_(49) setdest 874 343 3.0" 
$ns at 714.5632795413547 "$node_(49) setdest 1956 368 4.0" 
$ns at 0.0 "$node_(50) setdest 2706 416 3.0" 
$ns at 26.181114708698694 "$node_(50) setdest 2032 253 13.0" 
$ns at 115.075048804451 "$node_(50) setdest 2615 781 6.0" 
$ns at 212.4991368051459 "$node_(50) setdest 2457 329 18.0" 
$ns at 412.8860195218211 "$node_(50) setdest 1152 779 3.0" 
$ns at 676.3111823469405 "$node_(50) setdest 2788 762 13.0" 
$ns at 0.0 "$node_(51) setdest 2002 752 8.0" 
$ns at 69.03627840578018 "$node_(51) setdest 1842 911 1.0" 
$ns at 102.54872959754235 "$node_(51) setdest 622 978 11.0" 
$ns at 264.26079123533555 "$node_(51) setdest 2021 307 15.0" 
$ns at 414.5369512118292 "$node_(51) setdest 1177 423 9.0" 
$ns at 735.5627599812415 "$node_(51) setdest 2493 82 1.0" 
$ns at 0.0 "$node_(52) setdest 331 898 9.0" 
$ns at 29.954929908120313 "$node_(52) setdest 2669 40 8.0" 
$ns at 122.24061311662462 "$node_(52) setdest 196 387 10.0" 
$ns at 281.9057291679305 "$node_(52) setdest 2144 767 11.0" 
$ns at 410.0132272706003 "$node_(52) setdest 2504 619 3.0" 
$ns at 675.2087531502245 "$node_(52) setdest 2044 478 7.0" 
$ns at 0.0 "$node_(53) setdest 2803 173 14.0" 
$ns at 132.42546139125545 "$node_(53) setdest 1470 529 6.0" 
$ns at 216.33492963359038 "$node_(53) setdest 1248 677 4.0" 
$ns at 307.2773703466796 "$node_(53) setdest 1457 748 20.0" 
$ns at 493.00545102019765 "$node_(53) setdest 2281 890 17.0" 
$ns at 739.5521446027587 "$node_(53) setdest 2642 28 14.0" 
$ns at 0.0 "$node_(54) setdest 269 727 16.0" 
$ns at 97.63270470967014 "$node_(54) setdest 1572 863 16.0" 
$ns at 167.51460102126705 "$node_(54) setdest 2906 525 12.0" 
$ns at 283.2545603379758 "$node_(54) setdest 338 732 19.0" 
$ns at 470.93776499238487 "$node_(54) setdest 929 96 6.0" 
$ns at 757.3755514393381 "$node_(54) setdest 2963 520 8.0" 
$ns at 0.0 "$node_(55) setdest 478 379 11.0" 
$ns at 38.97397314688233 "$node_(55) setdest 2731 412 10.0" 
$ns at 87.68814046082018 "$node_(55) setdest 1132 728 19.0" 
$ns at 252.14854755919464 "$node_(55) setdest 1393 905 13.0" 
$ns at 393.2266318336344 "$node_(55) setdest 1451 150 8.0" 
$ns at 678.4848431687825 "$node_(55) setdest 2928 901 8.0" 
$ns at 0.0 "$node_(56) setdest 569 31 16.0" 
$ns at 94.19141116671206 "$node_(56) setdest 301 28 6.0" 
$ns at 135.34433781209455 "$node_(56) setdest 1152 162 1.0" 
$ns at 198.64865195816526 "$node_(56) setdest 1387 626 14.0" 
$ns at 448.0660389705614 "$node_(56) setdest 1784 110 11.0" 
$ns at 794.083636513752 "$node_(56) setdest 13 76 10.0" 
$ns at 0.0 "$node_(57) setdest 580 235 5.0" 
$ns at 26.871037734615825 "$node_(57) setdest 2789 399 2.0" 
$ns at 64.14252798573165 "$node_(57) setdest 2593 904 1.0" 
$ns at 126.91418297025758 "$node_(57) setdest 1161 283 3.0" 
$ns at 268.93682075367957 "$node_(57) setdest 313 704 19.0" 
$ns at 645.5368383073071 "$node_(57) setdest 881 994 9.0" 
$ns at 0.0 "$node_(58) setdest 2335 707 8.0" 
$ns at 70.39645539867315 "$node_(58) setdest 2816 818 4.0" 
$ns at 134.71432323898608 "$node_(58) setdest 2983 78 14.0" 
$ns at 289.25487488898625 "$node_(58) setdest 783 979 5.0" 
$ns at 453.823327829258 "$node_(58) setdest 2467 591 18.0" 
$ns at 798.3675676943508 "$node_(58) setdest 2844 199 8.0" 
$ns at 0.0 "$node_(59) setdest 1863 844 10.0" 
$ns at 84.29220307628266 "$node_(59) setdest 2253 328 10.0" 
$ns at 206.4125070073684 "$node_(59) setdest 2998 222 8.0" 
$ns at 291.3129305540748 "$node_(59) setdest 1966 721 3.0" 
$ns at 422.66209958174534 "$node_(59) setdest 2024 922 10.0" 
$ns at 684.6338297601355 "$node_(59) setdest 2428 291 5.0" 
$ns at 0.0 "$node_(60) setdest 2260 570 9.0" 
$ns at 45.78052010597813 "$node_(60) setdest 1042 403 19.0" 
$ns at 238.3258337040652 "$node_(60) setdest 596 256 11.0" 
$ns at 320.0155018573819 "$node_(60) setdest 1523 47 9.0" 
$ns at 474.1420328893869 "$node_(60) setdest 1525 11 9.0" 
$ns at 715.8182578312965 "$node_(60) setdest 2064 960 20.0" 
$ns at 0.0 "$node_(61) setdest 2613 53 15.0" 
$ns at 112.45566472480945 "$node_(61) setdest 993 619 16.0" 
$ns at 168.0816846889996 "$node_(61) setdest 956 329 16.0" 
$ns at 320.777251733007 "$node_(61) setdest 2366 290 19.0" 
$ns at 625.0130589517806 "$node_(61) setdest 1946 170 14.0" 
$ns at 0.0 "$node_(62) setdest 1665 554 8.0" 
$ns at 61.504736132234456 "$node_(62) setdest 397 107 8.0" 
$ns at 160.89535239704827 "$node_(62) setdest 1550 981 6.0" 
$ns at 251.59741157031215 "$node_(62) setdest 833 138 1.0" 
$ns at 378.86555946207733 "$node_(62) setdest 334 886 20.0" 
$ns at 688.0192282349644 "$node_(62) setdest 513 16 4.0" 
$ns at 0.0 "$node_(63) setdest 1627 339 16.0" 
$ns at 161.14295723108634 "$node_(63) setdest 489 337 15.0" 
$ns at 268.61508691331875 "$node_(63) setdest 1321 854 13.0" 
$ns at 386.82623132126434 "$node_(63) setdest 2756 498 5.0" 
$ns at 519.135353079834 "$node_(63) setdest 1865 435 4.0" 
$ns at 767.6890693642895 "$node_(63) setdest 314 813 3.0" 
$ns at 0.0 "$node_(64) setdest 2496 900 18.0" 
$ns at 77.08940725920783 "$node_(64) setdest 680 343 8.0" 
$ns at 135.6870051307982 "$node_(64) setdest 1867 669 9.0" 
$ns at 274.5418505508984 "$node_(64) setdest 1187 241 4.0" 
$ns at 431.28811577934346 "$node_(64) setdest 2269 428 16.0" 
$ns at 705.2926491806155 "$node_(64) setdest 94 659 12.0" 
$ns at 0.0 "$node_(65) setdest 2349 359 1.0" 
$ns at 20.203063205828126 "$node_(65) setdest 2352 528 12.0" 
$ns at 145.62070654259185 "$node_(65) setdest 2046 845 2.0" 
$ns at 221.21695316786054 "$node_(65) setdest 552 741 3.0" 
$ns at 350.3813102384628 "$node_(65) setdest 2141 846 15.0" 
$ns at 663.5655036883638 "$node_(65) setdest 2391 568 11.0" 
$ns at 0.0 "$node_(66) setdest 2642 354 4.0" 
$ns at 24.93733434975774 "$node_(66) setdest 2688 328 8.0" 
$ns at 92.24650200787752 "$node_(66) setdest 1901 616 13.0" 
$ns at 248.33202505044412 "$node_(66) setdest 2789 636 17.0" 
$ns at 473.3613062142381 "$node_(66) setdest 2173 35 14.0" 
$ns at 824.3527359584793 "$node_(66) setdest 886 762 5.0" 
$ns at 0.0 "$node_(67) setdest 1043 948 8.0" 
$ns at 61.53156702279934 "$node_(67) setdest 589 924 16.0" 
$ns at 92.53764652135894 "$node_(67) setdest 2897 681 7.0" 
$ns at 162.512421678363 "$node_(67) setdest 1790 535 19.0" 
$ns at 395.98684155949354 "$node_(67) setdest 1381 576 16.0" 
$ns at 753.0351677143603 "$node_(67) setdest 1634 733 14.0" 
$ns at 0.0 "$node_(68) setdest 1530 910 11.0" 
$ns at 97.14624886405495 "$node_(68) setdest 1159 733 8.0" 
$ns at 146.2881873010995 "$node_(68) setdest 989 873 17.0" 
$ns at 241.36197353632656 "$node_(68) setdest 1905 795 14.0" 
$ns at 417.7494674640576 "$node_(68) setdest 527 48 14.0" 
$ns at 660.6961859294894 "$node_(68) setdest 1558 877 2.0" 
$ns at 0.0 "$node_(69) setdest 769 52 14.0" 
$ns at 91.97356598029205 "$node_(69) setdest 1439 251 9.0" 
$ns at 148.11551517000777 "$node_(69) setdest 2822 277 12.0" 
$ns at 229.1565862403689 "$node_(69) setdest 386 656 15.0" 
$ns at 461.77829317737553 "$node_(69) setdest 1246 894 11.0" 
$ns at 799.606378769524 "$node_(69) setdest 1348 768 12.0" 
$ns at 0.0 "$node_(70) setdest 537 558 17.0" 
$ns at 36.239349245855806 "$node_(70) setdest 749 53 12.0" 
$ns at 109.94282333233349 "$node_(70) setdest 67 484 20.0" 
$ns at 234.89005423882094 "$node_(70) setdest 420 298 3.0" 
$ns at 379.00383143474784 "$node_(70) setdest 1155 816 13.0" 
$ns at 746.7814272939881 "$node_(70) setdest 1672 368 8.0" 
$ns at 0.0 "$node_(71) setdest 716 476 10.0" 
$ns at 29.940032707631055 "$node_(71) setdest 1811 993 1.0" 
$ns at 61.792932693363284 "$node_(71) setdest 2656 902 19.0" 
$ns at 242.39194345757954 "$node_(71) setdest 2149 637 3.0" 
$ns at 379.0061085169079 "$node_(71) setdest 955 373 14.0" 
$ns at 675.4952569071315 "$node_(71) setdest 1332 748 5.0" 
$ns at 0.0 "$node_(72) setdest 123 821 7.0" 
$ns at 77.64784695749131 "$node_(72) setdest 2532 939 6.0" 
$ns at 128.61031182536124 "$node_(72) setdest 1461 329 1.0" 
$ns at 191.2010142336945 "$node_(72) setdest 819 902 5.0" 
$ns at 346.0643108633983 "$node_(72) setdest 1306 728 17.0" 
$ns at 712.8688809442679 "$node_(72) setdest 1764 107 19.0" 
$ns at 0.0 "$node_(73) setdest 198 968 17.0" 
$ns at 140.3366489282976 "$node_(73) setdest 96 580 1.0" 
$ns at 171.11929903403114 "$node_(73) setdest 1655 198 7.0" 
$ns at 242.19985764775873 "$node_(73) setdest 948 325 7.0" 
$ns at 379.46806398295365 "$node_(73) setdest 986 722 13.0" 
$ns at 652.9519216519137 "$node_(73) setdest 2029 173 7.0" 
$ns at 0.0 "$node_(74) setdest 1320 262 9.0" 
$ns at 104.46499697600063 "$node_(74) setdest 2756 125 7.0" 
$ns at 143.3232186763687 "$node_(74) setdest 1799 196 17.0" 
$ns at 291.5508165477704 "$node_(74) setdest 2169 474 8.0" 
$ns at 441.60522358552197 "$node_(74) setdest 2607 713 11.0" 
$ns at 735.6251251898815 "$node_(74) setdest 2182 275 11.0" 
$ns at 0.0 "$node_(75) setdest 269 41 10.0" 
$ns at 36.3422157344141 "$node_(75) setdest 482 946 3.0" 
$ns at 91.40495670096524 "$node_(75) setdest 1411 184 8.0" 
$ns at 217.80960434286465 "$node_(75) setdest 128 65 18.0" 
$ns at 381.59280233227 "$node_(75) setdest 2907 853 12.0" 
$ns at 630.1068256783881 "$node_(75) setdest 671 648 1.0" 
$ns at 0.0 "$node_(76) setdest 1103 491 4.0" 
$ns at 26.328809558098012 "$node_(76) setdest 2337 482 1.0" 
$ns at 62.12838833630161 "$node_(76) setdest 542 596 14.0" 
$ns at 225.33242518715477 "$node_(76) setdest 1594 290 16.0" 
$ns at 472.2869995351207 "$node_(76) setdest 2388 749 11.0" 
$ns at 761.2702409650819 "$node_(76) setdest 2160 789 10.0" 
$ns at 0.0 "$node_(77) setdest 1469 33 11.0" 
$ns at 123.08578762081679 "$node_(77) setdest 257 949 3.0" 
$ns at 156.25810093647934 "$node_(77) setdest 628 758 9.0" 
$ns at 220.4333447221674 "$node_(77) setdest 2669 988 8.0" 
$ns at 402.57375314757496 "$node_(77) setdest 819 686 5.0" 
$ns at 679.7768883687465 "$node_(77) setdest 1914 916 9.0" 
$ns at 0.0 "$node_(78) setdest 1125 157 9.0" 
$ns at 91.21793759982764 "$node_(78) setdest 1599 681 19.0" 
$ns at 216.4407998668908 "$node_(78) setdest 1637 814 17.0" 
$ns at 361.1287735716124 "$node_(78) setdest 2743 196 5.0" 
$ns at 505.55848895131777 "$node_(78) setdest 2874 844 14.0" 
$ns at 761.5677589281624 "$node_(78) setdest 647 833 5.0" 
$ns at 0.0 "$node_(79) setdest 2179 905 18.0" 
$ns at 99.01374894001518 "$node_(79) setdest 618 147 19.0" 
$ns at 281.2668455039941 "$node_(79) setdest 277 175 5.0" 
$ns at 350.4026323490972 "$node_(79) setdest 1592 917 11.0" 
$ns at 577.3267006926275 "$node_(79) setdest 1923 194 8.0" 
$ns at 829.6774318321175 "$node_(79) setdest 2476 768 20.0" 
$ns at 0.0 "$node_(80) setdest 1328 424 4.0" 
$ns at 38.723397235245784 "$node_(80) setdest 2768 963 5.0" 
$ns at 92.20611579796322 "$node_(80) setdest 795 700 8.0" 
$ns at 209.64273627021734 "$node_(80) setdest 2759 130 7.0" 
$ns at 377.2396489518742 "$node_(80) setdest 751 13 17.0" 
$ns at 671.1128807374123 "$node_(80) setdest 373 999 6.0" 
$ns at 0.0 "$node_(81) setdest 2106 276 8.0" 
$ns at 68.45490034584753 "$node_(81) setdest 463 447 15.0" 
$ns at 136.46641337040728 "$node_(81) setdest 2618 20 7.0" 
$ns at 235.7367951392801 "$node_(81) setdest 2115 384 17.0" 
$ns at 499.0753853431089 "$node_(81) setdest 2713 186 5.0" 
$ns at 759.2376062527342 "$node_(81) setdest 2266 303 19.0" 
$ns at 0.0 "$node_(82) setdest 920 442 17.0" 
$ns at 126.30776562422542 "$node_(82) setdest 702 536 17.0" 
$ns at 183.36011780235373 "$node_(82) setdest 1883 698 12.0" 
$ns at 252.2869724197896 "$node_(82) setdest 1244 508 15.0" 
$ns at 378.3658264803506 "$node_(82) setdest 607 746 2.0" 
$ns at 628.7489239989561 "$node_(82) setdest 1670 559 2.0" 
$ns at 0.0 "$node_(83) setdest 384 200 3.0" 
$ns at 23.508852030234607 "$node_(83) setdest 1692 113 4.0" 
$ns at 75.27146494350762 "$node_(83) setdest 2593 168 13.0" 
$ns at 163.62046069529515 "$node_(83) setdest 2049 262 3.0" 
$ns at 305.1323912291392 "$node_(83) setdest 280 325 13.0" 
$ns at 559.8746164145226 "$node_(83) setdest 1513 58 8.0" 
$ns at 0.0 "$node_(84) setdest 2229 305 15.0" 
$ns at 28.70945338100612 "$node_(84) setdest 2375 68 16.0" 
$ns at 149.86897376621505 "$node_(84) setdest 946 613 1.0" 
$ns at 219.75215585229964 "$node_(84) setdest 2717 977 11.0" 
$ns at 410.84585492657266 "$node_(84) setdest 2733 454 15.0" 
$ns at 796.394842760864 "$node_(84) setdest 2532 325 4.0" 
$ns at 0.0 "$node_(85) setdest 1801 176 16.0" 
$ns at 154.02495510126903 "$node_(85) setdest 494 632 14.0" 
$ns at 255.9555904178601 "$node_(85) setdest 92 238 14.0" 
$ns at 452.40102129386617 "$node_(85) setdest 944 507 15.0" 
$ns at 659.8223632515359 "$node_(85) setdest 1250 891 14.0" 
$ns at 0.0 "$node_(86) setdest 391 505 12.0" 
$ns at 63.33659709963962 "$node_(86) setdest 924 990 3.0" 
$ns at 105.09242130852067 "$node_(86) setdest 1601 810 16.0" 
$ns at 274.85010471274677 "$node_(86) setdest 2340 613 14.0" 
$ns at 486.6292161347245 "$node_(86) setdest 2066 27 5.0" 
$ns at 756.6818959449517 "$node_(86) setdest 2811 416 18.0" 
$ns at 0.0 "$node_(87) setdest 425 644 10.0" 
$ns at 55.62160837990546 "$node_(87) setdest 2641 902 14.0" 
$ns at 163.25679174418607 "$node_(87) setdest 2139 958 11.0" 
$ns at 327.1849578843704 "$node_(87) setdest 1589 18 13.0" 
$ns at 486.84393568703405 "$node_(87) setdest 479 519 1.0" 
$ns at 735.5116273305516 "$node_(87) setdest 2830 775 11.0" 
$ns at 0.0 "$node_(88) setdest 2635 399 19.0" 
$ns at 145.98415597690234 "$node_(88) setdest 108 794 20.0" 
$ns at 231.53090149868353 "$node_(88) setdest 511 823 1.0" 
$ns at 292.13473333145765 "$node_(88) setdest 2494 976 12.0" 
$ns at 487.69351857155493 "$node_(88) setdest 2506 968 16.0" 
$ns at 861.5787815902186 "$node_(88) setdest 1956 704 4.0" 
$ns at 0.0 "$node_(89) setdest 344 998 14.0" 
$ns at 132.9958141914958 "$node_(89) setdest 2652 263 10.0" 
$ns at 244.2006184039497 "$node_(89) setdest 759 600 13.0" 
$ns at 358.8188250005532 "$node_(89) setdest 648 403 6.0" 
$ns at 509.31366607707054 "$node_(89) setdest 600 611 18.0" 
$ns at 773.3424288196236 "$node_(89) setdest 1486 217 18.0" 
$ns at 0.0 "$node_(90) setdest 657 506 16.0" 
$ns at 54.26847472715929 "$node_(90) setdest 1779 755 18.0" 
$ns at 139.6308520221353 "$node_(90) setdest 1268 816 16.0" 
$ns at 331.3138402623669 "$node_(90) setdest 2789 71 5.0" 
$ns at 474.08054537424897 "$node_(90) setdest 1523 769 6.0" 
$ns at 749.4839785699226 "$node_(90) setdest 1641 599 9.0" 
$ns at 0.0 "$node_(91) setdest 610 710 15.0" 
$ns at 148.1913354552512 "$node_(91) setdest 2631 58 20.0" 
$ns at 332.40774868153346 "$node_(91) setdest 626 91 8.0" 
$ns at 421.09197794109076 "$node_(91) setdest 1805 300 1.0" 
$ns at 547.8791063664123 "$node_(91) setdest 1904 93 15.0" 
$ns at 819.737379038284 "$node_(91) setdest 733 777 19.0" 
$ns at 0.0 "$node_(92) setdest 662 176 4.0" 
$ns at 22.810239096405063 "$node_(92) setdest 1174 560 19.0" 
$ns at 201.36805259024172 "$node_(92) setdest 2536 106 12.0" 
$ns at 335.3823116272389 "$node_(92) setdest 2061 77 1.0" 
$ns at 463.9108200648759 "$node_(92) setdest 317 263 3.0" 
$ns at 705.532506230453 "$node_(92) setdest 2989 3 9.0" 
$ns at 0.0 "$node_(93) setdest 2921 280 12.0" 
$ns at 86.23355994661766 "$node_(93) setdest 1137 970 6.0" 
$ns at 151.4708477098595 "$node_(93) setdest 2433 307 13.0" 
$ns at 305.7410943240717 "$node_(93) setdest 2313 31 6.0" 
$ns at 484.48023301989065 "$node_(93) setdest 767 470 1.0" 
$ns at 726.9820526975551 "$node_(93) setdest 1554 49 9.0" 
$ns at 0.0 "$node_(94) setdest 2249 295 1.0" 
$ns at 23.188645083490254 "$node_(94) setdest 466 441 18.0" 
$ns at 133.99749551656453 "$node_(94) setdest 2189 185 7.0" 
$ns at 261.0886667808948 "$node_(94) setdest 223 941 2.0" 
$ns at 400.14963382635426 "$node_(94) setdest 2244 213 6.0" 
$ns at 682.5352224150845 "$node_(94) setdest 2939 325 17.0" 
$ns at 0.0 "$node_(95) setdest 143 815 1.0" 
$ns at 17.118400253990774 "$node_(95) setdest 815 263 2.0" 
$ns at 54.33823859994348 "$node_(95) setdest 1060 158 2.0" 
$ns at 132.6957876853374 "$node_(95) setdest 2263 724 3.0" 
$ns at 274.0709629009965 "$node_(95) setdest 2720 252 18.0" 
$ns at 548.1198416862073 "$node_(95) setdest 936 614 10.0" 
$ns at 0.0 "$node_(96) setdest 23 93 18.0" 
$ns at 104.44810726114615 "$node_(96) setdest 1346 567 13.0" 
$ns at 200.91699695915275 "$node_(96) setdest 1767 400 9.0" 
$ns at 308.20864417329017 "$node_(96) setdest 2505 75 8.0" 
$ns at 434.86583324933986 "$node_(96) setdest 1751 741 1.0" 
$ns at 682.9949655106857 "$node_(96) setdest 774 367 15.0" 
$ns at 0.0 "$node_(97) setdest 351 91 14.0" 
$ns at 125.60011070782912 "$node_(97) setdest 1851 732 7.0" 
$ns at 163.06544459123654 "$node_(97) setdest 2346 138 17.0" 
$ns at 279.11189335339316 "$node_(97) setdest 2580 193 17.0" 
$ns at 517.6668678564388 "$node_(97) setdest 1569 880 13.0" 
$ns at 779.9219770614683 "$node_(97) setdest 25 722 19.0" 
$ns at 0.0 "$node_(98) setdest 2688 312 8.0" 
$ns at 81.53230387974094 "$node_(98) setdest 1973 412 15.0" 
$ns at 176.5092732784363 "$node_(98) setdest 2183 253 7.0" 
$ns at 297.3127685744066 "$node_(98) setdest 1825 291 18.0" 
$ns at 525.9832023359791 "$node_(98) setdest 1307 623 8.0" 
$ns at 814.5250485540628 "$node_(98) setdest 1535 695 14.0" 
$ns at 0.0 "$node_(99) setdest 1615 711 3.0" 
$ns at 35.76178631199082 "$node_(99) setdest 2041 380 3.0" 
$ns at 73.95392175084552 "$node_(99) setdest 352 237 2.0" 
$ns at 135.68572695122282 "$node_(99) setdest 1382 800 15.0" 
$ns at 321.82405728596916 "$node_(99) setdest 764 262 16.0" 
$ns at 620.6296724901051 "$node_(99) setdest 2407 224 11.0" 


#Set a TCP connection between node_(71) and node_(24)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(0)
$ns attach-agent $node_(24) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(80) and node_(44)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(1)
$ns attach-agent $node_(44) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(92) and node_(61)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(2)
$ns attach-agent $node_(61) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(82) and node_(5)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(3)
$ns attach-agent $node_(5) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(39) and node_(79)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(4)
$ns attach-agent $node_(79) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(97) and node_(5)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(5)
$ns attach-agent $node_(5) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(25) and node_(47)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(6)
$ns attach-agent $node_(47) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(41) and node_(29)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(7)
$ns attach-agent $node_(29) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(28) and node_(93)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(8)
$ns attach-agent $node_(93) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(58) and node_(64)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(9)
$ns attach-agent $node_(64) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(92) and node_(99)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(10)
$ns attach-agent $node_(99) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(21) and node_(27)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(11)
$ns attach-agent $node_(27) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(1) and node_(88)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(12)
$ns attach-agent $node_(88) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(11) and node_(54)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(13)
$ns attach-agent $node_(54) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(66) and node_(33)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(14)
$ns attach-agent $node_(33) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(15) and node_(31)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(15)
$ns attach-agent $node_(31) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(20) and node_(72)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(16)
$ns attach-agent $node_(72) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(91) and node_(46)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(17)
$ns attach-agent $node_(46) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(73) and node_(81)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(18)
$ns attach-agent $node_(81) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(67) and node_(61)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(19)
$ns attach-agent $node_(61) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(17) and node_(42)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(20)
$ns attach-agent $node_(42) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(89) and node_(73)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(21)
$ns attach-agent $node_(73) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(33) and node_(24)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(22)
$ns attach-agent $node_(24) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(18) and node_(10)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(23)
$ns attach-agent $node_(10) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(69) and node_(14)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(24)
$ns attach-agent $node_(14) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(90) and node_(93)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(25)
$ns attach-agent $node_(93) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(57) and node_(85)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(26)
$ns attach-agent $node_(85) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(20) and node_(47)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(27)
$ns attach-agent $node_(47) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(99) and node_(68)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(28)
$ns attach-agent $node_(68) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(59) and node_(70)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(29)
$ns attach-agent $node_(70) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(89) and node_(49)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(30)
$ns attach-agent $node_(49) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(15) and node_(79)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(31)
$ns attach-agent $node_(79) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(4) and node_(61)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(32)
$ns attach-agent $node_(61) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(2) and node_(83)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(33)
$ns attach-agent $node_(83) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(75) and node_(91)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(34)
$ns attach-agent $node_(91) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(8) and node_(53)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(35)
$ns attach-agent $node_(53) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(82) and node_(35)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(36)
$ns attach-agent $node_(35) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(96) and node_(11)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(37)
$ns attach-agent $node_(11) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(63) and node_(52)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(38)
$ns attach-agent $node_(52) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(57) and node_(80)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(39)
$ns attach-agent $node_(80) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(31) and node_(28)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(40)
$ns attach-agent $node_(28) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(6) and node_(46)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(41)
$ns attach-agent $node_(46) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(87) and node_(74)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(42)
$ns attach-agent $node_(74) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(82) and node_(33)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(43)
$ns attach-agent $node_(33) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(5) and node_(76)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(44)
$ns attach-agent $node_(76) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(85) and node_(19)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(45)
$ns attach-agent $node_(19) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(4) and node_(5)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(46)
$ns attach-agent $node_(5) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(57) and node_(32)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(47)
$ns attach-agent $node_(32) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(85) and node_(44)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(48)
$ns attach-agent $node_(44) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(78) and node_(57)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(49)
$ns attach-agent $node_(57) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(40) and node_(14)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(50)
$ns attach-agent $node_(14) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(31) and node_(30)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(51)
$ns attach-agent $node_(30) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(93) and node_(28)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(52)
$ns attach-agent $node_(28) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(47) and node_(5)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(53)
$ns attach-agent $node_(5) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(17) and node_(85)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(54)
$ns attach-agent $node_(85) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(12) and node_(59)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(55)
$ns attach-agent $node_(59) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(26) and node_(27)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(56)
$ns attach-agent $node_(27) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(71) and node_(64)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(57)
$ns attach-agent $node_(64) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(32) and node_(93)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(58)
$ns attach-agent $node_(93) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(80) and node_(96)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(59)
$ns attach-agent $node_(96) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(24) and node_(81)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(60)
$ns attach-agent $node_(81) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(34) and node_(59)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(61)
$ns attach-agent $node_(59) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(19) and node_(53)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(62)
$ns attach-agent $node_(53) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(42) and node_(64)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(63)
$ns attach-agent $node_(64) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(2) and node_(1)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(64)
$ns attach-agent $node_(1) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(61) and node_(10)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(65)
$ns attach-agent $node_(10) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(26) and node_(20)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(66)
$ns attach-agent $node_(20) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(24) and node_(71)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(67)
$ns attach-agent $node_(71) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(73) and node_(46)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(68)
$ns attach-agent $node_(46) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(96) and node_(74)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(69)
$ns attach-agent $node_(74) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(66) and node_(74)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(70)
$ns attach-agent $node_(74) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(74) and node_(70)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(71)
$ns attach-agent $node_(70) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(72) and node_(45)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(72)
$ns attach-agent $node_(45) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(13) and node_(6)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(73)
$ns attach-agent $node_(6) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(57) and node_(19)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(74)
$ns attach-agent $node_(19) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(28) and node_(63)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(75)
$ns attach-agent $node_(63) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(52) and node_(38)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(76)
$ns attach-agent $node_(38) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(6) and node_(25)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(77)
$ns attach-agent $node_(25) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(12) and node_(57)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(78)
$ns attach-agent $node_(57) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(35) and node_(7)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(79)
$ns attach-agent $node_(7) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(3) and node_(98)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(80)
$ns attach-agent $node_(98) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(15) and node_(99)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(81)
$ns attach-agent $node_(99) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(95) and node_(62)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(82)
$ns attach-agent $node_(62) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(76) and node_(89)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(83)
$ns attach-agent $node_(89) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(35) and node_(64)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(84)
$ns attach-agent $node_(64) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(64) and node_(84)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(85)
$ns attach-agent $node_(84) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(28) and node_(27)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(86)
$ns attach-agent $node_(27) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(3) and node_(72)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(87)
$ns attach-agent $node_(72) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(0) and node_(80)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(88)
$ns attach-agent $node_(80) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(28) and node_(83)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(89)
$ns attach-agent $node_(83) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(1) and node_(66)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(90)
$ns attach-agent $node_(66) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(84) and node_(31)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(91)
$ns attach-agent $node_(31) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(60) and node_(43)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(92)
$ns attach-agent $node_(43) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(55) and node_(97)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(93)
$ns attach-agent $node_(97) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(58) and node_(13)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(94)
$ns attach-agent $node_(13) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(52) and node_(33)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(95)
$ns attach-agent $node_(33) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(31) and node_(77)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(96)
$ns attach-agent $node_(77) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(6) and node_(7)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(97)
$ns attach-agent $node_(7) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(31) and node_(22)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(98)
$ns attach-agent $node_(22) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(52) and node_(38)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(99)
$ns attach-agent $node_(38) $sink_(99)
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
