#sim-scn1-0.tcl 
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
set tracefd       [open sim-scn1-0-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-0-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-0-$val(rp).nam w]

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
$node_(0) set X_ 2974 
$node_(0) set Y_ 586 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 586 
$node_(1) set Y_ 720 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1213 
$node_(2) set Y_ 79 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 132 
$node_(3) set Y_ 714 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1172 
$node_(4) set Y_ 667 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 953 
$node_(5) set Y_ 311 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1661 
$node_(6) set Y_ 567 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1852 
$node_(7) set Y_ 44 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2660 
$node_(8) set Y_ 982 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1783 
$node_(9) set Y_ 253 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 666 
$node_(10) set Y_ 948 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 649 
$node_(11) set Y_ 7 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2751 
$node_(12) set Y_ 951 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1131 
$node_(13) set Y_ 35 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1541 
$node_(14) set Y_ 625 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2969 
$node_(15) set Y_ 517 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2770 
$node_(16) set Y_ 498 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 345 
$node_(17) set Y_ 988 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2660 
$node_(18) set Y_ 89 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2794 
$node_(19) set Y_ 141 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 222 
$node_(20) set Y_ 686 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1718 
$node_(21) set Y_ 35 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 650 
$node_(22) set Y_ 749 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2818 
$node_(23) set Y_ 39 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 250 
$node_(24) set Y_ 221 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1806 
$node_(25) set Y_ 893 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2841 
$node_(26) set Y_ 998 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2486 
$node_(27) set Y_ 401 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1288 
$node_(28) set Y_ 388 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1738 
$node_(29) set Y_ 623 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 776 
$node_(30) set Y_ 739 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 111 
$node_(31) set Y_ 897 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1552 
$node_(32) set Y_ 273 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2632 
$node_(33) set Y_ 669 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1290 
$node_(34) set Y_ 819 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 32 
$node_(35) set Y_ 904 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1774 
$node_(36) set Y_ 341 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2928 
$node_(37) set Y_ 785 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2441 
$node_(38) set Y_ 82 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1535 
$node_(39) set Y_ 545 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1341 
$node_(40) set Y_ 701 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 256 
$node_(41) set Y_ 498 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 324 
$node_(42) set Y_ 994 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 987 
$node_(43) set Y_ 796 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 729 
$node_(44) set Y_ 650 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1151 
$node_(45) set Y_ 986 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2541 
$node_(46) set Y_ 57 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 422 
$node_(47) set Y_ 179 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2886 
$node_(48) set Y_ 310 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 734 
$node_(49) set Y_ 537 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 852 
$node_(50) set Y_ 454 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1513 
$node_(51) set Y_ 826 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 975 
$node_(52) set Y_ 466 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 171 
$node_(53) set Y_ 968 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 292 
$node_(54) set Y_ 648 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 673 
$node_(55) set Y_ 918 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 624 
$node_(56) set Y_ 909 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1523 
$node_(57) set Y_ 651 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 1781 
$node_(58) set Y_ 874 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 1734 
$node_(59) set Y_ 773 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2577 
$node_(60) set Y_ 887 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1308 
$node_(61) set Y_ 44 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 987 
$node_(62) set Y_ 753 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 419 
$node_(63) set Y_ 109 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 1420 
$node_(64) set Y_ 489 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1880 
$node_(65) set Y_ 875 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 997 
$node_(66) set Y_ 465 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 586 
$node_(67) set Y_ 241 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2755 
$node_(68) set Y_ 36 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 456 
$node_(69) set Y_ 364 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 1056 
$node_(70) set Y_ 198 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 2935 
$node_(71) set Y_ 238 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 2003 
$node_(72) set Y_ 829 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 382 
$node_(73) set Y_ 129 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 2394 
$node_(74) set Y_ 830 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 666 
$node_(75) set Y_ 313 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 722 
$node_(76) set Y_ 814 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 2979 
$node_(77) set Y_ 683 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 945 
$node_(78) set Y_ 47 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2294 
$node_(79) set Y_ 954 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2090 
$node_(80) set Y_ 20 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2064 
$node_(81) set Y_ 653 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 458 
$node_(82) set Y_ 361 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 574 
$node_(83) set Y_ 576 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 2968 
$node_(84) set Y_ 827 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 972 
$node_(85) set Y_ 115 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 2293 
$node_(86) set Y_ 720 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2276 
$node_(87) set Y_ 711 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 687 
$node_(88) set Y_ 421 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 685 
$node_(89) set Y_ 702 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 922 
$node_(90) set Y_ 691 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 250 
$node_(91) set Y_ 0 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 461 
$node_(92) set Y_ 994 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 1398 
$node_(93) set Y_ 367 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2922 
$node_(94) set Y_ 400 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1012 
$node_(95) set Y_ 518 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 1081 
$node_(96) set Y_ 542 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 610 
$node_(97) set Y_ 955 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 971 
$node_(98) set Y_ 698 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2811 
$node_(99) set Y_ 186 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 295 325 11.0" 
$ns at 121.69579073218172 "$node_(0) setdest 140 256 19.0" 
$ns at 210.11667638328373 "$node_(0) setdest 2015 343 12.0" 
$ns at 292.4151252244586 "$node_(0) setdest 2504 554 16.0" 
$ns at 489.00330637230127 "$node_(0) setdest 2269 379 4.0" 
$ns at 768.9111821682012 "$node_(0) setdest 842 953 14.0" 
$ns at 0.0 "$node_(1) setdest 539 473 3.0" 
$ns at 34.62923770585098 "$node_(1) setdest 2962 331 10.0" 
$ns at 108.13479769320719 "$node_(1) setdest 2891 891 1.0" 
$ns at 175.81276838288528 "$node_(1) setdest 929 970 19.0" 
$ns at 421.86486378300367 "$node_(1) setdest 2052 922 6.0" 
$ns at 706.5812684116331 "$node_(1) setdest 1209 659 14.0" 
$ns at 0.0 "$node_(2) setdest 1328 89 12.0" 
$ns at 19.388780038388372 "$node_(2) setdest 1532 221 10.0" 
$ns at 107.85371436151496 "$node_(2) setdest 27 608 3.0" 
$ns at 178.13699064845417 "$node_(2) setdest 1972 922 19.0" 
$ns at 303.6999780601133 "$node_(2) setdest 2779 169 2.0" 
$ns at 547.3001018160267 "$node_(2) setdest 546 465 19.0" 
$ns at 0.0 "$node_(3) setdest 1914 381 10.0" 
$ns at 59.30524344411133 "$node_(3) setdest 2343 525 19.0" 
$ns at 127.85874012193239 "$node_(3) setdest 2791 457 5.0" 
$ns at 231.02541623940348 "$node_(3) setdest 2970 35 11.0" 
$ns at 359.3087073770082 "$node_(3) setdest 737 965 17.0" 
$ns at 685.2853699042084 "$node_(3) setdest 835 691 9.0" 
$ns at 0.0 "$node_(4) setdest 2000 747 18.0" 
$ns at 140.80493847933383 "$node_(4) setdest 555 350 1.0" 
$ns at 177.15324601358526 "$node_(4) setdest 1861 311 1.0" 
$ns at 237.5873338240817 "$node_(4) setdest 501 325 19.0" 
$ns at 485.3152265522972 "$node_(4) setdest 1811 307 12.0" 
$ns at 772.4018066179904 "$node_(4) setdest 270 738 9.0" 
$ns at 0.0 "$node_(5) setdest 1453 889 3.0" 
$ns at 43.47902186915812 "$node_(5) setdest 1608 421 16.0" 
$ns at 160.5415080016316 "$node_(5) setdest 511 71 13.0" 
$ns at 334.5625655531268 "$node_(5) setdest 1060 57 10.0" 
$ns at 494.3078231744968 "$node_(5) setdest 2125 395 8.0" 
$ns at 739.3839003810169 "$node_(5) setdest 372 520 19.0" 
$ns at 0.0 "$node_(6) setdest 311 496 16.0" 
$ns at 164.88103639488227 "$node_(6) setdest 1430 620 16.0" 
$ns at 205.36271124846667 "$node_(6) setdest 1255 395 18.0" 
$ns at 351.2252556389544 "$node_(6) setdest 1251 719 3.0" 
$ns at 473.91782683784743 "$node_(6) setdest 2830 604 1.0" 
$ns at 722.0834066826451 "$node_(6) setdest 322 911 8.0" 
$ns at 0.0 "$node_(7) setdest 1500 381 1.0" 
$ns at 15.74902547182697 "$node_(7) setdest 2293 734 19.0" 
$ns at 217.37740635054945 "$node_(7) setdest 505 696 12.0" 
$ns at 316.0563782429989 "$node_(7) setdest 1815 616 4.0" 
$ns at 459.63012924473367 "$node_(7) setdest 2984 769 10.0" 
$ns at 781.3001794606596 "$node_(7) setdest 51 512 4.0" 
$ns at 0.0 "$node_(8) setdest 1437 238 1.0" 
$ns at 24.081265936393116 "$node_(8) setdest 1124 443 8.0" 
$ns at 121.4255544298602 "$node_(8) setdest 2676 306 15.0" 
$ns at 219.80453440787915 "$node_(8) setdest 549 890 18.0" 
$ns at 497.71925206989454 "$node_(8) setdest 2172 433 14.0" 
$ns at 773.0138277491938 "$node_(8) setdest 1408 249 13.0" 
$ns at 0.0 "$node_(9) setdest 2448 418 11.0" 
$ns at 102.68944876982341 "$node_(9) setdest 1808 810 2.0" 
$ns at 140.32278865275248 "$node_(9) setdest 2917 954 9.0" 
$ns at 274.17553764896974 "$node_(9) setdest 2891 963 18.0" 
$ns at 408.521297270653 "$node_(9) setdest 321 972 10.0" 
$ns at 667.7762913779817 "$node_(9) setdest 432 583 18.0" 
$ns at 0.0 "$node_(10) setdest 681 371 7.0" 
$ns at 79.43417694708035 "$node_(10) setdest 1791 817 9.0" 
$ns at 151.5158559454539 "$node_(10) setdest 2387 968 10.0" 
$ns at 289.0178109853475 "$node_(10) setdest 2756 704 9.0" 
$ns at 413.6161229916197 "$node_(10) setdest 861 734 12.0" 
$ns at 742.4152985503817 "$node_(10) setdest 552 370 6.0" 
$ns at 0.0 "$node_(11) setdest 2921 664 7.0" 
$ns at 80.17617767093843 "$node_(11) setdest 42 716 2.0" 
$ns at 120.61207667808436 "$node_(11) setdest 757 850 1.0" 
$ns at 189.3871897423084 "$node_(11) setdest 893 840 20.0" 
$ns at 409.8490695015979 "$node_(11) setdest 176 610 19.0" 
$ns at 709.0003694180152 "$node_(11) setdest 2247 627 12.0" 
$ns at 0.0 "$node_(12) setdest 514 722 6.0" 
$ns at 66.53542525533436 "$node_(12) setdest 2158 229 11.0" 
$ns at 123.88014936013246 "$node_(12) setdest 1360 129 14.0" 
$ns at 222.9732641732338 "$node_(12) setdest 2839 377 8.0" 
$ns at 413.95638682143056 "$node_(12) setdest 1010 672 14.0" 
$ns at 673.9911731981671 "$node_(12) setdest 480 753 1.0" 
$ns at 0.0 "$node_(13) setdest 293 702 17.0" 
$ns at 31.737370721413498 "$node_(13) setdest 2178 854 20.0" 
$ns at 246.5887122573586 "$node_(13) setdest 2168 636 16.0" 
$ns at 325.105682791341 "$node_(13) setdest 2250 77 2.0" 
$ns at 455.38325327111454 "$node_(13) setdest 1257 798 16.0" 
$ns at 752.688953215845 "$node_(13) setdest 952 967 10.0" 
$ns at 0.0 "$node_(14) setdest 205 135 15.0" 
$ns at 100.70393286219768 "$node_(14) setdest 2395 843 3.0" 
$ns at 134.83489355181712 "$node_(14) setdest 521 616 5.0" 
$ns at 201.6758459737856 "$node_(14) setdest 1171 260 3.0" 
$ns at 339.478085369615 "$node_(14) setdest 314 425 10.0" 
$ns at 597.8584012057115 "$node_(14) setdest 970 2 14.0" 
$ns at 0.0 "$node_(15) setdest 2053 259 7.0" 
$ns at 43.29317722950303 "$node_(15) setdest 1225 585 14.0" 
$ns at 100.77630844459466 "$node_(15) setdest 1282 320 1.0" 
$ns at 165.42406206844595 "$node_(15) setdest 2549 448 6.0" 
$ns at 297.0575068149758 "$node_(15) setdest 2915 836 1.0" 
$ns at 538.6735794353389 "$node_(15) setdest 1497 322 10.0" 
$ns at 0.0 "$node_(16) setdest 1537 189 6.0" 
$ns at 57.6492524571807 "$node_(16) setdest 2933 452 3.0" 
$ns at 107.51103823351426 "$node_(16) setdest 842 981 16.0" 
$ns at 298.80172965743634 "$node_(16) setdest 1030 653 1.0" 
$ns at 421.9186591743699 "$node_(16) setdest 1132 630 1.0" 
$ns at 666.3039284835943 "$node_(16) setdest 664 395 1.0" 
$ns at 0.0 "$node_(17) setdest 1506 309 1.0" 
$ns at 18.195612409697443 "$node_(17) setdest 1761 378 17.0" 
$ns at 172.74210181740042 "$node_(17) setdest 1164 328 18.0" 
$ns at 378.18491243241874 "$node_(17) setdest 1842 304 10.0" 
$ns at 550.836517408391 "$node_(17) setdest 2960 287 1.0" 
$ns at 795.6287306170789 "$node_(17) setdest 811 798 11.0" 
$ns at 0.0 "$node_(18) setdest 2120 573 12.0" 
$ns at 79.16611416777204 "$node_(18) setdest 1762 691 8.0" 
$ns at 143.75604723769203 "$node_(18) setdest 767 41 13.0" 
$ns at 216.20079788828522 "$node_(18) setdest 2328 128 14.0" 
$ns at 469.83586500529753 "$node_(18) setdest 2663 966 11.0" 
$ns at 796.6728501007914 "$node_(18) setdest 1849 186 20.0" 
$ns at 0.0 "$node_(19) setdest 315 579 12.0" 
$ns at 47.70144124411649 "$node_(19) setdest 2396 982 2.0" 
$ns at 94.26289840074261 "$node_(19) setdest 351 797 13.0" 
$ns at 230.52584820215904 "$node_(19) setdest 409 473 14.0" 
$ns at 415.5620046136921 "$node_(19) setdest 1815 948 1.0" 
$ns at 660.4642270594973 "$node_(19) setdest 2499 391 19.0" 
$ns at 0.0 "$node_(20) setdest 1787 600 19.0" 
$ns at 45.62067544030857 "$node_(20) setdest 680 37 4.0" 
$ns at 104.98758248330276 "$node_(20) setdest 1478 811 12.0" 
$ns at 274.78665928843986 "$node_(20) setdest 2046 883 2.0" 
$ns at 402.22522851920513 "$node_(20) setdest 1702 381 1.0" 
$ns at 650.5554691723044 "$node_(20) setdest 1702 192 18.0" 
$ns at 0.0 "$node_(21) setdest 1381 952 3.0" 
$ns at 28.349268372495185 "$node_(21) setdest 1446 109 6.0" 
$ns at 95.6984449362226 "$node_(21) setdest 1476 22 6.0" 
$ns at 207.3373546565277 "$node_(21) setdest 491 931 8.0" 
$ns at 333.3652948199252 "$node_(21) setdest 2513 210 9.0" 
$ns at 662.9302921508746 "$node_(21) setdest 2259 521 18.0" 
$ns at 0.0 "$node_(22) setdest 2587 366 6.0" 
$ns at 61.93885435821309 "$node_(22) setdest 1016 60 16.0" 
$ns at 204.1182773499842 "$node_(22) setdest 510 332 20.0" 
$ns at 368.21887169386963 "$node_(22) setdest 2884 602 1.0" 
$ns at 491.72827338356626 "$node_(22) setdest 500 471 17.0" 
$ns at 858.5312900201374 "$node_(22) setdest 1495 142 18.0" 
$ns at 0.0 "$node_(23) setdest 565 257 10.0" 
$ns at 42.724815271713986 "$node_(23) setdest 326 142 14.0" 
$ns at 125.57593992680188 "$node_(23) setdest 1483 544 13.0" 
$ns at 228.07397533643376 "$node_(23) setdest 490 739 1.0" 
$ns at 350.76286121442587 "$node_(23) setdest 2029 322 15.0" 
$ns at 714.1612724674005 "$node_(23) setdest 2504 73 18.0" 
$ns at 0.0 "$node_(24) setdest 860 50 12.0" 
$ns at 55.172120462966575 "$node_(24) setdest 2319 458 1.0" 
$ns at 90.875753794568 "$node_(24) setdest 2193 901 1.0" 
$ns at 153.4049194602414 "$node_(24) setdest 1633 346 17.0" 
$ns at 434.4346735731222 "$node_(24) setdest 2199 495 5.0" 
$ns at 679.8058335603366 "$node_(24) setdest 2270 289 15.0" 
$ns at 0.0 "$node_(25) setdest 2751 958 12.0" 
$ns at 36.52585559290969 "$node_(25) setdest 150 364 11.0" 
$ns at 130.924072209163 "$node_(25) setdest 932 386 3.0" 
$ns at 214.7500750050787 "$node_(25) setdest 1126 755 9.0" 
$ns at 389.4456635329899 "$node_(25) setdest 2455 40 7.0" 
$ns at 695.4609861917011 "$node_(25) setdest 714 466 1.0" 
$ns at 0.0 "$node_(26) setdest 2904 869 17.0" 
$ns at 36.58221294012671 "$node_(26) setdest 2501 355 3.0" 
$ns at 82.17891803057675 "$node_(26) setdest 1439 180 6.0" 
$ns at 176.22781653547003 "$node_(26) setdest 749 958 19.0" 
$ns at 419.463300085941 "$node_(26) setdest 1368 539 16.0" 
$ns at 688.1835406749451 "$node_(26) setdest 479 809 18.0" 
$ns at 0.0 "$node_(27) setdest 745 241 13.0" 
$ns at 138.4496806488476 "$node_(27) setdest 2058 200 1.0" 
$ns at 172.55091616058988 "$node_(27) setdest 896 927 10.0" 
$ns at 294.083854617493 "$node_(27) setdest 1068 610 9.0" 
$ns at 477.00338667245035 "$node_(27) setdest 1515 176 11.0" 
$ns at 803.8336752311606 "$node_(27) setdest 988 238 5.0" 
$ns at 0.0 "$node_(28) setdest 2742 165 1.0" 
$ns at 24.235890629591196 "$node_(28) setdest 957 366 6.0" 
$ns at 89.51260195810882 "$node_(28) setdest 2377 716 5.0" 
$ns at 187.37027987577505 "$node_(28) setdest 2658 491 14.0" 
$ns at 429.2502502093509 "$node_(28) setdest 1123 323 13.0" 
$ns at 687.888243674798 "$node_(28) setdest 86 451 3.0" 
$ns at 0.0 "$node_(29) setdest 2516 985 6.0" 
$ns at 38.988991341753135 "$node_(29) setdest 743 987 9.0" 
$ns at 155.37774008375374 "$node_(29) setdest 946 927 8.0" 
$ns at 261.47780755398054 "$node_(29) setdest 1521 457 8.0" 
$ns at 434.99910149341827 "$node_(29) setdest 2919 542 19.0" 
$ns at 729.1153160457902 "$node_(29) setdest 2318 653 15.0" 
$ns at 0.0 "$node_(30) setdest 1459 144 7.0" 
$ns at 84.1000632762733 "$node_(30) setdest 142 939 9.0" 
$ns at 129.80125391985683 "$node_(30) setdest 1312 344 4.0" 
$ns at 225.1108435955267 "$node_(30) setdest 260 148 8.0" 
$ns at 367.82685323003955 "$node_(30) setdest 1341 155 18.0" 
$ns at 750.6395095196697 "$node_(30) setdest 634 969 15.0" 
$ns at 0.0 "$node_(31) setdest 278 140 2.0" 
$ns at 28.759972601032914 "$node_(31) setdest 2707 756 11.0" 
$ns at 156.92604213567057 "$node_(31) setdest 2724 192 19.0" 
$ns at 357.949918092772 "$node_(31) setdest 288 989 17.0" 
$ns at 515.0672882008901 "$node_(31) setdest 57 786 13.0" 
$ns at 765.1978965357682 "$node_(31) setdest 1080 824 6.0" 
$ns at 0.0 "$node_(32) setdest 649 760 15.0" 
$ns at 101.45260765384738 "$node_(32) setdest 1119 459 3.0" 
$ns at 150.1878639213719 "$node_(32) setdest 1535 992 2.0" 
$ns at 218.38938766340283 "$node_(32) setdest 1160 252 10.0" 
$ns at 385.8418929518996 "$node_(32) setdest 1457 525 14.0" 
$ns at 652.1582373696402 "$node_(32) setdest 1778 816 7.0" 
$ns at 0.0 "$node_(33) setdest 2908 988 16.0" 
$ns at 152.25036665919123 "$node_(33) setdest 1722 537 9.0" 
$ns at 258.9193243321748 "$node_(33) setdest 2607 390 8.0" 
$ns at 379.80249632825377 "$node_(33) setdest 785 224 4.0" 
$ns at 530.2417995482217 "$node_(33) setdest 534 621 3.0" 
$ns at 784.768383134544 "$node_(33) setdest 234 859 1.0" 
$ns at 0.0 "$node_(34) setdest 1439 237 20.0" 
$ns at 95.34781449071684 "$node_(34) setdest 564 629 9.0" 
$ns at 160.79224320448432 "$node_(34) setdest 1475 373 17.0" 
$ns at 230.01223334184886 "$node_(34) setdest 108 729 11.0" 
$ns at 397.82919605762396 "$node_(34) setdest 1359 848 9.0" 
$ns at 705.9880107558035 "$node_(34) setdest 1787 616 3.0" 
$ns at 0.0 "$node_(35) setdest 1210 811 5.0" 
$ns at 19.256103781102976 "$node_(35) setdest 12 684 16.0" 
$ns at 87.30110070492327 "$node_(35) setdest 1966 501 10.0" 
$ns at 159.6184933832447 "$node_(35) setdest 1532 566 10.0" 
$ns at 294.02684246054827 "$node_(35) setdest 40 955 17.0" 
$ns at 642.007691571705 "$node_(35) setdest 2743 523 8.0" 
$ns at 0.0 "$node_(36) setdest 1607 746 7.0" 
$ns at 52.67413367143907 "$node_(36) setdest 2743 611 16.0" 
$ns at 130.08514021572796 "$node_(36) setdest 2678 81 8.0" 
$ns at 216.54630762653449 "$node_(36) setdest 154 610 17.0" 
$ns at 402.3704198673546 "$node_(36) setdest 1870 849 16.0" 
$ns at 701.324781654409 "$node_(36) setdest 500 894 15.0" 
$ns at 0.0 "$node_(37) setdest 2513 439 7.0" 
$ns at 24.209314772280266 "$node_(37) setdest 1645 719 20.0" 
$ns at 215.4320377429414 "$node_(37) setdest 506 420 14.0" 
$ns at 398.5077587713346 "$node_(37) setdest 601 626 4.0" 
$ns at 536.5160372242462 "$node_(37) setdest 68 409 1.0" 
$ns at 779.8577602691213 "$node_(37) setdest 2704 924 9.0" 
$ns at 0.0 "$node_(38) setdest 1291 712 3.0" 
$ns at 23.837837491245295 "$node_(38) setdest 2951 447 1.0" 
$ns at 57.17409204471453 "$node_(38) setdest 139 571 14.0" 
$ns at 161.12815739516282 "$node_(38) setdest 20 57 18.0" 
$ns at 360.47378085689377 "$node_(38) setdest 313 94 13.0" 
$ns at 710.603845057724 "$node_(38) setdest 2256 586 15.0" 
$ns at 0.0 "$node_(39) setdest 1110 207 17.0" 
$ns at 100.87940560512753 "$node_(39) setdest 640 194 18.0" 
$ns at 239.308640192143 "$node_(39) setdest 1202 205 11.0" 
$ns at 333.8047271345799 "$node_(39) setdest 1531 321 19.0" 
$ns at 526.3089757444607 "$node_(39) setdest 1965 733 4.0" 
$ns at 771.0842774796529 "$node_(39) setdest 2696 717 10.0" 
$ns at 0.0 "$node_(40) setdest 784 283 12.0" 
$ns at 79.84372718485972 "$node_(40) setdest 915 242 8.0" 
$ns at 158.3809175858284 "$node_(40) setdest 1468 543 16.0" 
$ns at 234.72567096938258 "$node_(40) setdest 183 402 16.0" 
$ns at 447.22526662423246 "$node_(40) setdest 679 163 20.0" 
$ns at 778.5918968635096 "$node_(40) setdest 2289 814 10.0" 
$ns at 0.0 "$node_(41) setdest 43 795 18.0" 
$ns at 164.0470098156441 "$node_(41) setdest 1298 77 1.0" 
$ns at 201.31438829040616 "$node_(41) setdest 1322 462 1.0" 
$ns at 262.08408817973896 "$node_(41) setdest 1213 738 12.0" 
$ns at 469.2610390049464 "$node_(41) setdest 2824 613 3.0" 
$ns at 710.2757529979475 "$node_(41) setdest 1844 321 4.0" 
$ns at 0.0 "$node_(42) setdest 926 427 20.0" 
$ns at 212.8422947463849 "$node_(42) setdest 664 619 12.0" 
$ns at 339.982673301866 "$node_(42) setdest 1395 214 5.0" 
$ns at 424.48648809877017 "$node_(42) setdest 2178 715 8.0" 
$ns at 582.5144233361431 "$node_(42) setdest 874 973 16.0" 
$ns at 0.0 "$node_(43) setdest 81 428 12.0" 
$ns at 42.42352054216393 "$node_(43) setdest 1715 468 3.0" 
$ns at 99.7523935723322 "$node_(43) setdest 234 148 10.0" 
$ns at 202.86115908870528 "$node_(43) setdest 1044 381 10.0" 
$ns at 350.2095124702312 "$node_(43) setdest 230 268 3.0" 
$ns at 602.4286267388716 "$node_(43) setdest 720 379 9.0" 
$ns at 0.0 "$node_(44) setdest 1092 667 11.0" 
$ns at 60.54886505315497 "$node_(44) setdest 1576 187 8.0" 
$ns at 165.73134028748032 "$node_(44) setdest 1361 944 19.0" 
$ns at 378.5877969484807 "$node_(44) setdest 117 988 14.0" 
$ns at 547.3339253994843 "$node_(44) setdest 2614 383 20.0" 
$ns at 0.0 "$node_(45) setdest 557 736 16.0" 
$ns at 156.51724517462438 "$node_(45) setdest 2188 824 5.0" 
$ns at 204.99081938142905 "$node_(45) setdest 1855 213 12.0" 
$ns at 269.2117132014706 "$node_(45) setdest 632 927 18.0" 
$ns at 397.9035488799922 "$node_(45) setdest 1156 917 15.0" 
$ns at 638.9111994550763 "$node_(45) setdest 1170 514 11.0" 
$ns at 0.0 "$node_(46) setdest 1782 102 6.0" 
$ns at 45.94223682030476 "$node_(46) setdest 200 956 9.0" 
$ns at 163.59961303000455 "$node_(46) setdest 2682 569 18.0" 
$ns at 398.80913002402997 "$node_(46) setdest 1604 821 11.0" 
$ns at 604.6675782484505 "$node_(46) setdest 986 21 9.0" 
$ns at 863.485603251823 "$node_(46) setdest 1402 209 5.0" 
$ns at 0.0 "$node_(47) setdest 1077 74 1.0" 
$ns at 16.270283674872076 "$node_(47) setdest 1022 527 10.0" 
$ns at 112.86471598435044 "$node_(47) setdest 319 263 7.0" 
$ns at 238.73971192574817 "$node_(47) setdest 216 613 3.0" 
$ns at 366.33967881692826 "$node_(47) setdest 351 608 2.0" 
$ns at 623.9791225940736 "$node_(47) setdest 2402 457 19.0" 
$ns at 0.0 "$node_(48) setdest 605 586 3.0" 
$ns at 30.648300652345817 "$node_(48) setdest 2946 945 12.0" 
$ns at 80.80425662197092 "$node_(48) setdest 436 585 1.0" 
$ns at 141.89189380161542 "$node_(48) setdest 686 353 11.0" 
$ns at 316.0535185209585 "$node_(48) setdest 1031 173 12.0" 
$ns at 623.3678850141664 "$node_(48) setdest 1699 539 13.0" 
$ns at 0.0 "$node_(49) setdest 1988 766 11.0" 
$ns at 15.756604300650185 "$node_(49) setdest 105 42 13.0" 
$ns at 103.43530206024751 "$node_(49) setdest 223 522 7.0" 
$ns at 165.11450715795223 "$node_(49) setdest 2432 545 11.0" 
$ns at 302.338802718999 "$node_(49) setdest 2611 549 5.0" 
$ns at 590.6244289716627 "$node_(49) setdest 812 410 14.0" 
$ns at 0.0 "$node_(50) setdest 1502 756 14.0" 
$ns at 18.202952578719366 "$node_(50) setdest 2050 242 14.0" 
$ns at 62.380151942585584 "$node_(50) setdest 1025 931 14.0" 
$ns at 250.32038318059853 "$node_(50) setdest 1327 680 7.0" 
$ns at 376.10244960302657 "$node_(50) setdest 2829 868 14.0" 
$ns at 664.8183765355476 "$node_(50) setdest 72 897 14.0" 
$ns at 0.0 "$node_(51) setdest 1659 650 19.0" 
$ns at 139.76529221147175 "$node_(51) setdest 288 480 16.0" 
$ns at 283.09529189507384 "$node_(51) setdest 2928 382 12.0" 
$ns at 371.5351614618701 "$node_(51) setdest 1342 681 6.0" 
$ns at 535.2776846426473 "$node_(51) setdest 180 998 4.0" 
$ns at 803.3594123497455 "$node_(51) setdest 2012 222 11.0" 
$ns at 0.0 "$node_(52) setdest 1098 943 6.0" 
$ns at 67.95326661573418 "$node_(52) setdest 2311 127 12.0" 
$ns at 185.91538043810658 "$node_(52) setdest 2462 817 14.0" 
$ns at 256.3653686360385 "$node_(52) setdest 363 277 1.0" 
$ns at 386.2181407862242 "$node_(52) setdest 1205 338 8.0" 
$ns at 640.4459626800046 "$node_(52) setdest 1369 649 4.0" 
$ns at 0.0 "$node_(53) setdest 476 161 14.0" 
$ns at 101.54706095930199 "$node_(53) setdest 2428 451 8.0" 
$ns at 137.6652035611134 "$node_(53) setdest 356 435 13.0" 
$ns at 223.76224202529957 "$node_(53) setdest 1745 601 11.0" 
$ns at 350.321418353485 "$node_(53) setdest 2627 140 17.0" 
$ns at 638.9775266119603 "$node_(53) setdest 508 264 16.0" 
$ns at 0.0 "$node_(54) setdest 2762 555 20.0" 
$ns at 202.21919291924925 "$node_(54) setdest 2454 398 7.0" 
$ns at 260.9862386064195 "$node_(54) setdest 15 441 11.0" 
$ns at 422.29198974675387 "$node_(54) setdest 1907 527 12.0" 
$ns at 591.7104903611844 "$node_(54) setdest 283 760 14.0" 
$ns at 0.0 "$node_(55) setdest 2810 179 1.0" 
$ns at 15.65908522463552 "$node_(55) setdest 2133 22 15.0" 
$ns at 48.76221153706989 "$node_(55) setdest 1037 722 12.0" 
$ns at 203.44035654122627 "$node_(55) setdest 2149 581 14.0" 
$ns at 326.2838798869982 "$node_(55) setdest 999 524 1.0" 
$ns at 575.7290887075217 "$node_(55) setdest 2500 479 15.0" 
$ns at 0.0 "$node_(56) setdest 333 680 12.0" 
$ns at 38.561817875888636 "$node_(56) setdest 1378 654 5.0" 
$ns at 104.09077797526739 "$node_(56) setdest 203 723 1.0" 
$ns at 166.47155761305868 "$node_(56) setdest 1725 598 10.0" 
$ns at 327.4129963666391 "$node_(56) setdest 470 65 13.0" 
$ns at 686.8597818963465 "$node_(56) setdest 2367 802 9.0" 
$ns at 0.0 "$node_(57) setdest 2791 93 17.0" 
$ns at 20.907003354599894 "$node_(57) setdest 2506 570 10.0" 
$ns at 122.50295659458895 "$node_(57) setdest 391 152 1.0" 
$ns at 185.56292933445636 "$node_(57) setdest 170 24 12.0" 
$ns at 342.65521736228584 "$node_(57) setdest 63 849 1.0" 
$ns at 585.7402360704705 "$node_(57) setdest 2065 394 17.0" 
$ns at 0.0 "$node_(58) setdest 2649 410 4.0" 
$ns at 30.208710039583618 "$node_(58) setdest 2959 921 15.0" 
$ns at 187.8495273826493 "$node_(58) setdest 1055 23 2.0" 
$ns at 263.2760416200278 "$node_(58) setdest 1507 948 10.0" 
$ns at 389.60269672329014 "$node_(58) setdest 1550 388 10.0" 
$ns at 685.3943398454521 "$node_(58) setdest 171 45 4.0" 
$ns at 0.0 "$node_(59) setdest 2902 934 17.0" 
$ns at 30.078351997832687 "$node_(59) setdest 629 237 10.0" 
$ns at 147.1474694054266 "$node_(59) setdest 608 393 13.0" 
$ns at 335.09918872549594 "$node_(59) setdest 838 674 9.0" 
$ns at 537.8801307962453 "$node_(59) setdest 258 711 8.0" 
$ns at 854.5482243343943 "$node_(59) setdest 644 322 17.0" 
$ns at 0.0 "$node_(60) setdest 809 481 6.0" 
$ns at 73.85848297641945 "$node_(60) setdest 2595 511 20.0" 
$ns at 254.5060311986934 "$node_(60) setdest 2281 367 1.0" 
$ns at 320.02938866029075 "$node_(60) setdest 1354 416 4.0" 
$ns at 454.8049739612359 "$node_(60) setdest 183 235 3.0" 
$ns at 698.0357981785795 "$node_(60) setdest 879 810 3.0" 
$ns at 0.0 "$node_(61) setdest 1664 919 14.0" 
$ns at 130.12629882657853 "$node_(61) setdest 248 664 1.0" 
$ns at 165.28344446968265 "$node_(61) setdest 186 860 19.0" 
$ns at 289.1743981906768 "$node_(61) setdest 809 431 13.0" 
$ns at 523.866978036998 "$node_(61) setdest 2240 62 4.0" 
$ns at 770.5974638097723 "$node_(61) setdest 1036 95 15.0" 
$ns at 0.0 "$node_(62) setdest 2385 62 10.0" 
$ns at 98.85933249890887 "$node_(62) setdest 249 313 10.0" 
$ns at 219.35624072256414 "$node_(62) setdest 1633 896 9.0" 
$ns at 366.67354649532535 "$node_(62) setdest 115 246 6.0" 
$ns at 494.6077005940356 "$node_(62) setdest 2961 240 8.0" 
$ns at 805.6179464564366 "$node_(62) setdest 2552 882 6.0" 
$ns at 0.0 "$node_(63) setdest 2476 202 19.0" 
$ns at 106.86341152980083 "$node_(63) setdest 474 972 15.0" 
$ns at 219.71280010088483 "$node_(63) setdest 1511 471 5.0" 
$ns at 298.29808834931373 "$node_(63) setdest 495 875 4.0" 
$ns at 420.2411085185461 "$node_(63) setdest 2680 765 12.0" 
$ns at 731.9161892861756 "$node_(63) setdest 525 921 4.0" 
$ns at 0.0 "$node_(64) setdest 1666 804 14.0" 
$ns at 74.09799236176744 "$node_(64) setdest 1887 101 3.0" 
$ns at 117.06964708550132 "$node_(64) setdest 2272 254 18.0" 
$ns at 349.18975632171157 "$node_(64) setdest 1373 192 16.0" 
$ns at 514.7645905555763 "$node_(64) setdest 2013 347 19.0" 
$ns at 879.0326728688187 "$node_(64) setdest 2375 618 12.0" 
$ns at 0.0 "$node_(65) setdest 1278 148 17.0" 
$ns at 175.72201595955497 "$node_(65) setdest 1017 664 5.0" 
$ns at 241.5045468673402 "$node_(65) setdest 2827 656 5.0" 
$ns at 327.5342709767417 "$node_(65) setdest 2916 840 15.0" 
$ns at 589.295232476337 "$node_(65) setdest 2176 216 14.0" 
$ns at 834.733468766796 "$node_(65) setdest 988 507 19.0" 
$ns at 0.0 "$node_(66) setdest 114 931 13.0" 
$ns at 51.44801795440711 "$node_(66) setdest 1449 71 7.0" 
$ns at 106.28950711972055 "$node_(66) setdest 406 47 19.0" 
$ns at 168.34588001253223 "$node_(66) setdest 2913 358 2.0" 
$ns at 301.4832479066459 "$node_(66) setdest 1455 505 14.0" 
$ns at 552.4185696627108 "$node_(66) setdest 2238 962 10.0" 
$ns at 0.0 "$node_(67) setdest 430 128 19.0" 
$ns at 112.07930184423304 "$node_(67) setdest 2523 687 5.0" 
$ns at 191.82877557973947 "$node_(67) setdest 2171 139 18.0" 
$ns at 366.79738330892667 "$node_(67) setdest 2408 392 10.0" 
$ns at 519.9302972431442 "$node_(67) setdest 1862 977 4.0" 
$ns at 780.0174696850395 "$node_(67) setdest 585 826 17.0" 
$ns at 0.0 "$node_(68) setdest 1284 613 9.0" 
$ns at 21.707095875936794 "$node_(68) setdest 2158 286 17.0" 
$ns at 59.585448773730796 "$node_(68) setdest 2148 823 10.0" 
$ns at 125.81674092725859 "$node_(68) setdest 2275 183 19.0" 
$ns at 283.75202967958245 "$node_(68) setdest 1796 125 16.0" 
$ns at 572.6922529060332 "$node_(68) setdest 1163 841 14.0" 
$ns at 0.0 "$node_(69) setdest 2309 340 16.0" 
$ns at 22.782578110871512 "$node_(69) setdest 482 123 9.0" 
$ns at 53.79624462302685 "$node_(69) setdest 2770 983 9.0" 
$ns at 167.3426550603387 "$node_(69) setdest 651 694 12.0" 
$ns at 403.2972051083143 "$node_(69) setdest 2243 932 17.0" 
$ns at 664.7101734934417 "$node_(69) setdest 1539 35 6.0" 
$ns at 0.0 "$node_(70) setdest 2721 103 3.0" 
$ns at 35.78795199965855 "$node_(70) setdest 677 505 9.0" 
$ns at 102.11518801174105 "$node_(70) setdest 2082 62 6.0" 
$ns at 201.58465716604735 "$node_(70) setdest 1901 65 14.0" 
$ns at 345.1534856669249 "$node_(70) setdest 823 805 3.0" 
$ns at 588.163266690087 "$node_(70) setdest 66 472 14.0" 
$ns at 0.0 "$node_(71) setdest 2110 142 4.0" 
$ns at 53.444346911875996 "$node_(71) setdest 1245 35 4.0" 
$ns at 117.50181496341641 "$node_(71) setdest 411 412 4.0" 
$ns at 215.1315358645906 "$node_(71) setdest 553 269 4.0" 
$ns at 338.38617938292447 "$node_(71) setdest 2741 466 13.0" 
$ns at 633.482899863368 "$node_(71) setdest 2510 24 1.0" 
$ns at 0.0 "$node_(72) setdest 1305 146 11.0" 
$ns at 119.25986600149153 "$node_(72) setdest 1592 912 14.0" 
$ns at 180.34206294429458 "$node_(72) setdest 52 698 2.0" 
$ns at 260.0664650138393 "$node_(72) setdest 365 139 17.0" 
$ns at 509.4340241622308 "$node_(72) setdest 433 833 9.0" 
$ns at 755.3260128083938 "$node_(72) setdest 2366 45 3.0" 
$ns at 0.0 "$node_(73) setdest 2376 407 7.0" 
$ns at 48.96435933638691 "$node_(73) setdest 1620 955 3.0" 
$ns at 104.76430576691575 "$node_(73) setdest 2268 896 17.0" 
$ns at 192.20680399953923 "$node_(73) setdest 463 161 8.0" 
$ns at 317.05464072356466 "$node_(73) setdest 457 157 1.0" 
$ns at 560.6745121132885 "$node_(73) setdest 1056 127 12.0" 
$ns at 0.0 "$node_(74) setdest 1571 159 14.0" 
$ns at 64.56841385157531 "$node_(74) setdest 750 239 8.0" 
$ns at 116.77936893555628 "$node_(74) setdest 658 648 14.0" 
$ns at 209.4053572485529 "$node_(74) setdest 1206 688 2.0" 
$ns at 343.69927982588575 "$node_(74) setdest 2946 953 1.0" 
$ns at 588.2238156392373 "$node_(74) setdest 2921 317 13.0" 
$ns at 0.0 "$node_(75) setdest 2732 398 11.0" 
$ns at 105.67837670426441 "$node_(75) setdest 2556 513 3.0" 
$ns at 162.30222246638488 "$node_(75) setdest 696 10 5.0" 
$ns at 222.79176664840534 "$node_(75) setdest 2233 479 11.0" 
$ns at 433.85110108969525 "$node_(75) setdest 1647 493 12.0" 
$ns at 766.1188994474231 "$node_(75) setdest 1685 463 12.0" 
$ns at 0.0 "$node_(76) setdest 1497 674 15.0" 
$ns at 88.50158249537341 "$node_(76) setdest 1925 780 11.0" 
$ns at 186.37925023114695 "$node_(76) setdest 2976 871 12.0" 
$ns at 338.4789064234147 "$node_(76) setdest 1836 708 2.0" 
$ns at 465.65641981460425 "$node_(76) setdest 1375 900 15.0" 
$ns at 712.8179034219673 "$node_(76) setdest 2820 588 8.0" 
$ns at 0.0 "$node_(77) setdest 2339 667 7.0" 
$ns at 57.89900089536386 "$node_(77) setdest 1429 716 13.0" 
$ns at 152.36639079849866 "$node_(77) setdest 2492 562 15.0" 
$ns at 275.5960053971849 "$node_(77) setdest 1611 852 12.0" 
$ns at 448.4966986003941 "$node_(77) setdest 2411 105 17.0" 
$ns at 786.5670215941711 "$node_(77) setdest 993 431 6.0" 
$ns at 0.0 "$node_(78) setdest 2243 556 17.0" 
$ns at 89.85549494897195 "$node_(78) setdest 2330 806 1.0" 
$ns at 125.39400578395279 "$node_(78) setdest 2978 442 15.0" 
$ns at 284.61330441516134 "$node_(78) setdest 46 114 1.0" 
$ns at 410.8674259695285 "$node_(78) setdest 1159 209 1.0" 
$ns at 657.3001906398006 "$node_(78) setdest 502 582 11.0" 
$ns at 0.0 "$node_(79) setdest 1563 462 12.0" 
$ns at 40.467711395078005 "$node_(79) setdest 400 369 1.0" 
$ns at 76.68299725612356 "$node_(79) setdest 1119 485 3.0" 
$ns at 152.06647684019367 "$node_(79) setdest 1480 265 15.0" 
$ns at 330.9790331182754 "$node_(79) setdest 102 21 11.0" 
$ns at 614.524011764413 "$node_(79) setdest 2401 841 19.0" 
$ns at 0.0 "$node_(80) setdest 1372 492 15.0" 
$ns at 138.12698578334306 "$node_(80) setdest 2468 865 2.0" 
$ns at 185.56834509447157 "$node_(80) setdest 1186 142 15.0" 
$ns at 251.6484439292014 "$node_(80) setdest 1604 89 5.0" 
$ns at 397.4454829578278 "$node_(80) setdest 2868 791 17.0" 
$ns at 737.5235652634052 "$node_(80) setdest 2720 714 18.0" 
$ns at 0.0 "$node_(81) setdest 1353 165 3.0" 
$ns at 25.1905521153276 "$node_(81) setdest 2383 136 9.0" 
$ns at 72.6750476680534 "$node_(81) setdest 1394 9 5.0" 
$ns at 140.65927503615268 "$node_(81) setdest 1435 794 2.0" 
$ns at 263.0618495297788 "$node_(81) setdest 946 439 1.0" 
$ns at 512.2525921517588 "$node_(81) setdest 1970 198 14.0" 
$ns at 0.0 "$node_(82) setdest 1022 243 1.0" 
$ns at 23.854933927607956 "$node_(82) setdest 2819 488 8.0" 
$ns at 112.81261883083275 "$node_(82) setdest 2027 76 5.0" 
$ns at 211.1677489122587 "$node_(82) setdest 433 80 19.0" 
$ns at 431.13239946431656 "$node_(82) setdest 1366 777 18.0" 
$ns at 837.7379162581385 "$node_(82) setdest 2846 256 16.0" 
$ns at 0.0 "$node_(83) setdest 1846 244 13.0" 
$ns at 83.69515988333177 "$node_(83) setdest 2083 757 14.0" 
$ns at 143.7146769345404 "$node_(83) setdest 2143 590 15.0" 
$ns at 302.70964152434635 "$node_(83) setdest 1196 737 15.0" 
$ns at 455.4650950343794 "$node_(83) setdest 1376 524 7.0" 
$ns at 741.723716696786 "$node_(83) setdest 816 628 3.0" 
$ns at 0.0 "$node_(84) setdest 2550 172 18.0" 
$ns at 53.73733677014721 "$node_(84) setdest 873 780 12.0" 
$ns at 181.25176386858408 "$node_(84) setdest 403 802 15.0" 
$ns at 384.5702071837696 "$node_(84) setdest 1892 939 6.0" 
$ns at 536.1900599548138 "$node_(84) setdest 2941 134 14.0" 
$ns at 860.7171771203534 "$node_(84) setdest 13 896 8.0" 
$ns at 0.0 "$node_(85) setdest 1669 227 15.0" 
$ns at 153.02467730767444 "$node_(85) setdest 641 897 15.0" 
$ns at 300.9692817162967 "$node_(85) setdest 1320 123 18.0" 
$ns at 536.7522565608479 "$node_(85) setdest 1373 639 14.0" 
$ns at 777.7142523063197 "$node_(85) setdest 1584 713 16.0" 
$ns at 0.0 "$node_(86) setdest 609 941 2.0" 
$ns at 32.08233510787667 "$node_(86) setdest 1138 539 1.0" 
$ns at 66.97146244400875 "$node_(86) setdest 2001 411 19.0" 
$ns at 143.41803302329043 "$node_(86) setdest 1988 485 10.0" 
$ns at 345.31003087236263 "$node_(86) setdest 634 704 4.0" 
$ns at 609.4404831112004 "$node_(86) setdest 1902 551 16.0" 
$ns at 0.0 "$node_(87) setdest 598 195 8.0" 
$ns at 82.51217885442081 "$node_(87) setdest 2477 192 14.0" 
$ns at 237.05613632280074 "$node_(87) setdest 356 145 18.0" 
$ns at 406.65981287513785 "$node_(87) setdest 1089 908 13.0" 
$ns at 534.890406634275 "$node_(87) setdest 51 710 4.0" 
$ns at 812.6549286401315 "$node_(87) setdest 1785 53 3.0" 
$ns at 0.0 "$node_(88) setdest 1662 352 15.0" 
$ns at 141.24534151099 "$node_(88) setdest 2869 64 2.0" 
$ns at 187.97561953370248 "$node_(88) setdest 660 498 8.0" 
$ns at 320.0981714470836 "$node_(88) setdest 724 570 1.0" 
$ns at 443.5884088894592 "$node_(88) setdest 1563 531 6.0" 
$ns at 704.5113922154685 "$node_(88) setdest 2141 91 20.0" 
$ns at 0.0 "$node_(89) setdest 545 429 19.0" 
$ns at 24.44427223821454 "$node_(89) setdest 2185 277 16.0" 
$ns at 54.5905838465698 "$node_(89) setdest 2005 661 17.0" 
$ns at 186.62220738822305 "$node_(89) setdest 2374 900 6.0" 
$ns at 352.9751374275896 "$node_(89) setdest 1736 139 8.0" 
$ns at 624.3848529502607 "$node_(89) setdest 698 52 9.0" 
$ns at 0.0 "$node_(90) setdest 2114 335 10.0" 
$ns at 91.43515642539266 "$node_(90) setdest 2756 260 5.0" 
$ns at 135.13135034904332 "$node_(90) setdest 2445 886 4.0" 
$ns at 222.8995273488448 "$node_(90) setdest 2043 471 15.0" 
$ns at 391.9049360327106 "$node_(90) setdest 1377 262 9.0" 
$ns at 642.5831924577667 "$node_(90) setdest 1152 118 12.0" 
$ns at 0.0 "$node_(91) setdest 1029 342 18.0" 
$ns at 70.10113099993575 "$node_(91) setdest 2433 719 18.0" 
$ns at 243.4400907386538 "$node_(91) setdest 248 963 16.0" 
$ns at 450.53749394669296 "$node_(91) setdest 2374 721 12.0" 
$ns at 671.9267619857611 "$node_(91) setdest 1125 800 14.0" 
$ns at 0.0 "$node_(92) setdest 742 546 16.0" 
$ns at 21.88537718240502 "$node_(92) setdest 2700 127 19.0" 
$ns at 129.15588793029585 "$node_(92) setdest 253 39 17.0" 
$ns at 311.57689339331773 "$node_(92) setdest 1480 317 8.0" 
$ns at 506.85308297346717 "$node_(92) setdest 301 783 12.0" 
$ns at 766.7164968464037 "$node_(92) setdest 1201 152 12.0" 
$ns at 0.0 "$node_(93) setdest 1028 986 19.0" 
$ns at 112.98563200224336 "$node_(93) setdest 1957 272 16.0" 
$ns at 205.6907000599666 "$node_(93) setdest 1750 894 8.0" 
$ns at 339.02406296829736 "$node_(93) setdest 2627 358 7.0" 
$ns at 500.56604325520277 "$node_(93) setdest 2535 943 17.0" 
$ns at 822.3428141278423 "$node_(93) setdest 226 860 14.0" 
$ns at 0.0 "$node_(94) setdest 443 95 2.0" 
$ns at 31.191226580268054 "$node_(94) setdest 608 377 8.0" 
$ns at 121.26024822380302 "$node_(94) setdest 2713 85 9.0" 
$ns at 189.9229470194752 "$node_(94) setdest 1644 2 3.0" 
$ns at 334.242558648055 "$node_(94) setdest 1924 513 16.0" 
$ns at 588.157947138139 "$node_(94) setdest 811 221 7.0" 
$ns at 0.0 "$node_(95) setdest 2909 5 11.0" 
$ns at 60.19080359818373 "$node_(95) setdest 1810 195 10.0" 
$ns at 183.27553749035735 "$node_(95) setdest 2946 897 4.0" 
$ns at 245.4345923294203 "$node_(95) setdest 1649 518 9.0" 
$ns at 371.862294893551 "$node_(95) setdest 1502 139 17.0" 
$ns at 781.0753086661291 "$node_(95) setdest 310 767 5.0" 
$ns at 0.0 "$node_(96) setdest 2563 389 2.0" 
$ns at 20.47860212792056 "$node_(96) setdest 932 435 18.0" 
$ns at 131.1294481817149 "$node_(96) setdest 325 494 19.0" 
$ns at 192.40800815748918 "$node_(96) setdest 2142 79 5.0" 
$ns at 313.6341823142186 "$node_(96) setdest 2771 828 19.0" 
$ns at 577.8959594673197 "$node_(96) setdest 2946 767 5.0" 
$ns at 0.0 "$node_(97) setdest 1409 174 15.0" 
$ns at 144.95228902583523 "$node_(97) setdest 2329 141 11.0" 
$ns at 246.88010512331715 "$node_(97) setdest 212 126 8.0" 
$ns at 325.77224794043184 "$node_(97) setdest 467 706 4.0" 
$ns at 461.0640147583813 "$node_(97) setdest 1518 210 2.0" 
$ns at 702.1027780121804 "$node_(97) setdest 208 151 7.0" 
$ns at 0.0 "$node_(98) setdest 434 178 20.0" 
$ns at 64.20215075321707 "$node_(98) setdest 2211 790 12.0" 
$ns at 183.79563881422422 "$node_(98) setdest 1009 188 2.0" 
$ns at 253.84378963333586 "$node_(98) setdest 2913 472 14.0" 
$ns at 433.0606450110828 "$node_(98) setdest 2214 828 3.0" 
$ns at 687.4269190554318 "$node_(98) setdest 2213 515 10.0" 
$ns at 0.0 "$node_(99) setdest 1493 180 3.0" 
$ns at 19.082557357374185 "$node_(99) setdest 1531 523 8.0" 
$ns at 118.55191336670184 "$node_(99) setdest 1433 393 18.0" 
$ns at 348.40193186916304 "$node_(99) setdest 644 140 11.0" 
$ns at 544.4835995484781 "$node_(99) setdest 2803 471 1.0" 
$ns at 794.3057901358135 "$node_(99) setdest 2448 103 19.0" 


#Set a TCP connection between node_(34) and node_(22)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(0)
$ns attach-agent $node_(22) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(77) and node_(21)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(1)
$ns attach-agent $node_(21) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(84) and node_(15)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(2)
$ns attach-agent $node_(15) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(55) and node_(37)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(3)
$ns attach-agent $node_(37) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(26) and node_(59)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(4)
$ns attach-agent $node_(59) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(77) and node_(42)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(5)
$ns attach-agent $node_(42) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(46) and node_(63)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(6)
$ns attach-agent $node_(63) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(88) and node_(73)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(7)
$ns attach-agent $node_(73) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(47) and node_(82)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(8)
$ns attach-agent $node_(82) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(4) and node_(65)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(9)
$ns attach-agent $node_(65) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(69) and node_(91)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(10)
$ns attach-agent $node_(91) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(21) and node_(85)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(11)
$ns attach-agent $node_(85) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(77) and node_(17)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(12)
$ns attach-agent $node_(17) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(11) and node_(6)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(13)
$ns attach-agent $node_(6) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(19) and node_(84)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(14)
$ns attach-agent $node_(84) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(81) and node_(63)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(15)
$ns attach-agent $node_(63) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(7) and node_(5)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(16)
$ns attach-agent $node_(5) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(68) and node_(55)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(17)
$ns attach-agent $node_(55) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(50) and node_(0)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(18)
$ns attach-agent $node_(0) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(10) and node_(98)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(19)
$ns attach-agent $node_(98) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(79) and node_(2)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(20)
$ns attach-agent $node_(2) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(8) and node_(68)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(21)
$ns attach-agent $node_(68) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(57) and node_(36)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(22)
$ns attach-agent $node_(36) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(90) and node_(45)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(23)
$ns attach-agent $node_(45) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(72) and node_(76)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(24)
$ns attach-agent $node_(76) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(64) and node_(55)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(25)
$ns attach-agent $node_(55) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(29) and node_(67)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(26)
$ns attach-agent $node_(67) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(87) and node_(89)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(27)
$ns attach-agent $node_(89) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(68) and node_(11)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(28)
$ns attach-agent $node_(11) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(37) and node_(83)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(29)
$ns attach-agent $node_(83) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(1) and node_(71)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(30)
$ns attach-agent $node_(71) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(42) and node_(8)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(31)
$ns attach-agent $node_(8) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(79) and node_(68)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(32)
$ns attach-agent $node_(68) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(14) and node_(1)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(33)
$ns attach-agent $node_(1) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(48) and node_(8)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(34)
$ns attach-agent $node_(8) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(64) and node_(84)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(35)
$ns attach-agent $node_(84) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(20) and node_(79)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(36)
$ns attach-agent $node_(79) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(35) and node_(54)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(37)
$ns attach-agent $node_(54) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(65) and node_(33)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(38)
$ns attach-agent $node_(33) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(44) and node_(15)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(39)
$ns attach-agent $node_(15) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(39) and node_(64)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(40)
$ns attach-agent $node_(64) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(97) and node_(64)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(41)
$ns attach-agent $node_(64) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(20) and node_(59)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(42)
$ns attach-agent $node_(59) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(54) and node_(24)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(43)
$ns attach-agent $node_(24) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(63) and node_(84)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(44)
$ns attach-agent $node_(84) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(16) and node_(60)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(45)
$ns attach-agent $node_(60) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(74) and node_(87)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(46)
$ns attach-agent $node_(87) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(17) and node_(85)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(47)
$ns attach-agent $node_(85) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(21) and node_(2)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(48)
$ns attach-agent $node_(2) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(6) and node_(14)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(49)
$ns attach-agent $node_(14) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(22) and node_(82)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(50)
$ns attach-agent $node_(82) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(54) and node_(97)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(51)
$ns attach-agent $node_(97) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(15) and node_(78)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(52)
$ns attach-agent $node_(78) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(37) and node_(3)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(53)
$ns attach-agent $node_(3) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(78) and node_(57)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(54)
$ns attach-agent $node_(57) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(60) and node_(61)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(55)
$ns attach-agent $node_(61) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(5) and node_(59)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(56)
$ns attach-agent $node_(59) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(86) and node_(5)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(57)
$ns attach-agent $node_(5) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(11) and node_(87)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(58)
$ns attach-agent $node_(87) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(50) and node_(85)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(59)
$ns attach-agent $node_(85) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(93) and node_(2)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(60)
$ns attach-agent $node_(2) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(80) and node_(5)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(61)
$ns attach-agent $node_(5) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(20) and node_(90)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(62)
$ns attach-agent $node_(90) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(77) and node_(82)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(63)
$ns attach-agent $node_(82) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(26) and node_(59)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(64)
$ns attach-agent $node_(59) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(14) and node_(55)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(65)
$ns attach-agent $node_(55) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(89) and node_(14)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(66)
$ns attach-agent $node_(14) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(28) and node_(50)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(67)
$ns attach-agent $node_(50) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(64) and node_(28)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(68)
$ns attach-agent $node_(28) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(81) and node_(31)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(69)
$ns attach-agent $node_(31) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(75) and node_(31)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(70)
$ns attach-agent $node_(31) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(28) and node_(48)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(71)
$ns attach-agent $node_(48) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(73) and node_(16)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(72)
$ns attach-agent $node_(16) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(49) and node_(64)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(73)
$ns attach-agent $node_(64) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(98) and node_(42)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(74)
$ns attach-agent $node_(42) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(29) and node_(19)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(75)
$ns attach-agent $node_(19) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(53) and node_(87)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(76)
$ns attach-agent $node_(87) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(74) and node_(60)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(77)
$ns attach-agent $node_(60) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(54) and node_(22)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(78)
$ns attach-agent $node_(22) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(50) and node_(97)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(79)
$ns attach-agent $node_(97) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(88) and node_(96)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(80)
$ns attach-agent $node_(96) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(29) and node_(11)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(81)
$ns attach-agent $node_(11) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(72) and node_(64)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(82)
$ns attach-agent $node_(64) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(0) and node_(26)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(83)
$ns attach-agent $node_(26) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(98) and node_(20)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(84)
$ns attach-agent $node_(20) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(94) and node_(75)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(85)
$ns attach-agent $node_(75) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(70) and node_(10)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(86)
$ns attach-agent $node_(10) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(1) and node_(62)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(87)
$ns attach-agent $node_(62) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(24) and node_(33)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(88)
$ns attach-agent $node_(33) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(39) and node_(89)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(89)
$ns attach-agent $node_(89) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(98) and node_(73)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(90)
$ns attach-agent $node_(73) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(87) and node_(43)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(91)
$ns attach-agent $node_(43) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(68) and node_(11)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(92)
$ns attach-agent $node_(11) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(83) and node_(12)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(93)
$ns attach-agent $node_(12) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(61) and node_(84)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(94)
$ns attach-agent $node_(84) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(66) and node_(48)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(95)
$ns attach-agent $node_(48) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(90) and node_(37)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(96)
$ns attach-agent $node_(37) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(23) and node_(36)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(97)
$ns attach-agent $node_(36) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(58) and node_(24)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(98)
$ns attach-agent $node_(24) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(32) and node_(67)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(99)
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
