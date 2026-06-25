#sim-scn1-6.tcl 
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
set tracefd       [open sim-scn1-6-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-6-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-6-$val(rp).nam w]

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
$node_(0) set X_ 2735 
$node_(0) set Y_ 758 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2347 
$node_(1) set Y_ 412 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2441 
$node_(2) set Y_ 821 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 319 
$node_(3) set Y_ 994 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1508 
$node_(4) set Y_ 142 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 910 
$node_(5) set Y_ 205 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2720 
$node_(6) set Y_ 848 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2982 
$node_(7) set Y_ 187 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 1264 
$node_(8) set Y_ 182 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 706 
$node_(9) set Y_ 437 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 2336 
$node_(10) set Y_ 304 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2797 
$node_(11) set Y_ 171 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 355 
$node_(12) set Y_ 434 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2760 
$node_(13) set Y_ 696 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1305 
$node_(14) set Y_ 530 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2442 
$node_(15) set Y_ 685 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1940 
$node_(16) set Y_ 902 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2644 
$node_(17) set Y_ 684 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 65 
$node_(18) set Y_ 33 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 766 
$node_(19) set Y_ 738 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1801 
$node_(20) set Y_ 416 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2370 
$node_(21) set Y_ 776 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1641 
$node_(22) set Y_ 400 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2204 
$node_(23) set Y_ 244 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 211 
$node_(24) set Y_ 861 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 549 
$node_(25) set Y_ 580 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2042 
$node_(26) set Y_ 36 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2875 
$node_(27) set Y_ 249 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 143 
$node_(28) set Y_ 994 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 555 
$node_(29) set Y_ 491 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2038 
$node_(30) set Y_ 35 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 916 
$node_(31) set Y_ 386 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2839 
$node_(32) set Y_ 773 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2133 
$node_(33) set Y_ 531 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2219 
$node_(34) set Y_ 777 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 1426 
$node_(35) set Y_ 472 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 528 
$node_(36) set Y_ 431 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2691 
$node_(37) set Y_ 970 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 996 
$node_(38) set Y_ 91 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2090 
$node_(39) set Y_ 362 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2805 
$node_(40) set Y_ 739 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2220 
$node_(41) set Y_ 528 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 932 
$node_(42) set Y_ 44 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 328 
$node_(43) set Y_ 482 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1959 
$node_(44) set Y_ 169 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 568 
$node_(45) set Y_ 145 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2577 
$node_(46) set Y_ 715 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 562 
$node_(47) set Y_ 673 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2279 
$node_(48) set Y_ 910 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 532 
$node_(49) set Y_ 615 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1681 
$node_(50) set Y_ 513 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 934 
$node_(51) set Y_ 235 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2104 
$node_(52) set Y_ 953 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 981 
$node_(53) set Y_ 590 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 467 
$node_(54) set Y_ 885 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2571 
$node_(55) set Y_ 330 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 1152 
$node_(56) set Y_ 694 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 971 
$node_(57) set Y_ 723 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 2342 
$node_(58) set Y_ 491 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 1236 
$node_(59) set Y_ 129 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 1413 
$node_(60) set Y_ 761 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 576 
$node_(61) set Y_ 978 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2216 
$node_(62) set Y_ 178 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2953 
$node_(63) set Y_ 346 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 613 
$node_(64) set Y_ 29 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2892 
$node_(65) set Y_ 366 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 317 
$node_(66) set Y_ 335 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 943 
$node_(67) set Y_ 60 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2048 
$node_(68) set Y_ 26 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1431 
$node_(69) set Y_ 639 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2166 
$node_(70) set Y_ 463 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1969 
$node_(71) set Y_ 970 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 2300 
$node_(72) set Y_ 188 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 875 
$node_(73) set Y_ 698 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1111 
$node_(74) set Y_ 41 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1920 
$node_(75) set Y_ 463 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 119 
$node_(76) set Y_ 667 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 2893 
$node_(77) set Y_ 744 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 562 
$node_(78) set Y_ 18 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 238 
$node_(79) set Y_ 163 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 1500 
$node_(80) set Y_ 652 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 500 
$node_(81) set Y_ 439 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1850 
$node_(82) set Y_ 515 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 2506 
$node_(83) set Y_ 836 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 2726 
$node_(84) set Y_ 414 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 1158 
$node_(85) set Y_ 594 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1343 
$node_(86) set Y_ 574 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 310 
$node_(87) set Y_ 804 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2911 
$node_(88) set Y_ 521 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 605 
$node_(89) set Y_ 159 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 2229 
$node_(90) set Y_ 19 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2198 
$node_(91) set Y_ 264 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2315 
$node_(92) set Y_ 942 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 1094 
$node_(93) set Y_ 525 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2123 
$node_(94) set Y_ 787 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1339 
$node_(95) set Y_ 145 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 462 
$node_(96) set Y_ 985 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 550 
$node_(97) set Y_ 425 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 2390 
$node_(98) set Y_ 287 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 208 
$node_(99) set Y_ 419 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2838 295 19.0" 
$ns at 191.1521001236913 "$node_(0) setdest 1847 632 3.0" 
$ns at 250.83009756128766 "$node_(0) setdest 692 339 7.0" 
$ns at 333.09187809857247 "$node_(0) setdest 1239 825 9.0" 
$ns at 503.3398090570179 "$node_(0) setdest 225 120 3.0" 
$ns at 769.5813647101575 "$node_(0) setdest 641 224 13.0" 
$ns at 0.0 "$node_(1) setdest 1186 51 17.0" 
$ns at 151.85877345660407 "$node_(1) setdest 2697 880 7.0" 
$ns at 182.02141808765177 "$node_(1) setdest 2662 200 6.0" 
$ns at 294.4048407861355 "$node_(1) setdest 2336 566 4.0" 
$ns at 433.9094483410437 "$node_(1) setdest 574 384 8.0" 
$ns at 712.2449972385543 "$node_(1) setdest 1378 590 7.0" 
$ns at 0.0 "$node_(2) setdest 2179 782 2.0" 
$ns at 19.300543968377237 "$node_(2) setdest 180 722 20.0" 
$ns at 160.3673585713735 "$node_(2) setdest 2581 65 17.0" 
$ns at 247.88319326533508 "$node_(2) setdest 211 807 14.0" 
$ns at 469.48787484238517 "$node_(2) setdest 1046 212 13.0" 
$ns at 768.358446183536 "$node_(2) setdest 1235 916 4.0" 
$ns at 0.0 "$node_(3) setdest 641 504 14.0" 
$ns at 136.54447595533304 "$node_(3) setdest 1481 95 17.0" 
$ns at 191.6857145129232 "$node_(3) setdest 1477 370 6.0" 
$ns at 280.64771878184126 "$node_(3) setdest 957 57 3.0" 
$ns at 417.1269664930137 "$node_(3) setdest 1574 69 5.0" 
$ns at 688.9155992250137 "$node_(3) setdest 2821 403 12.0" 
$ns at 0.0 "$node_(4) setdest 2146 402 3.0" 
$ns at 37.27820300883092 "$node_(4) setdest 2452 187 8.0" 
$ns at 77.57990557001295 "$node_(4) setdest 2809 906 3.0" 
$ns at 159.08451679128 "$node_(4) setdest 2622 922 16.0" 
$ns at 419.4874245232597 "$node_(4) setdest 6 256 13.0" 
$ns at 662.5615723797503 "$node_(4) setdest 930 359 15.0" 
$ns at 0.0 "$node_(5) setdest 2675 811 12.0" 
$ns at 91.0028403581548 "$node_(5) setdest 1388 607 1.0" 
$ns at 124.32814268200286 "$node_(5) setdest 1922 521 19.0" 
$ns at 259.26661244266467 "$node_(5) setdest 829 441 2.0" 
$ns at 385.8495995017645 "$node_(5) setdest 251 658 2.0" 
$ns at 637.7676255885357 "$node_(5) setdest 517 877 18.0" 
$ns at 0.0 "$node_(6) setdest 2606 61 18.0" 
$ns at 147.97683753965836 "$node_(6) setdest 1132 337 9.0" 
$ns at 186.1125696630246 "$node_(6) setdest 1269 871 17.0" 
$ns at 379.62080216245727 "$node_(6) setdest 19 999 17.0" 
$ns at 545.0216460047159 "$node_(6) setdest 2372 950 1.0" 
$ns at 789.0900627893939 "$node_(6) setdest 1360 149 18.0" 
$ns at 0.0 "$node_(7) setdest 1580 449 15.0" 
$ns at 164.71689172018878 "$node_(7) setdest 2667 638 20.0" 
$ns at 235.78945947907516 "$node_(7) setdest 186 219 9.0" 
$ns at 338.93719493969866 "$node_(7) setdest 2755 751 3.0" 
$ns at 464.0433910623415 "$node_(7) setdest 678 44 16.0" 
$ns at 728.7857006410361 "$node_(7) setdest 2085 89 5.0" 
$ns at 0.0 "$node_(8) setdest 2533 885 9.0" 
$ns at 28.091233894604034 "$node_(8) setdest 145 292 15.0" 
$ns at 167.7828106337014 "$node_(8) setdest 1778 589 9.0" 
$ns at 243.1801530726907 "$node_(8) setdest 1261 678 17.0" 
$ns at 520.0725036873846 "$node_(8) setdest 1590 798 18.0" 
$ns at 884.8128231632145 "$node_(8) setdest 1988 135 8.0" 
$ns at 0.0 "$node_(9) setdest 2962 973 18.0" 
$ns at 139.98194339585 "$node_(9) setdest 1 850 11.0" 
$ns at 241.02051160249826 "$node_(9) setdest 2212 780 12.0" 
$ns at 374.61994065147417 "$node_(9) setdest 2106 705 1.0" 
$ns at 503.232504621188 "$node_(9) setdest 1871 269 16.0" 
$ns at 775.2926301573701 "$node_(9) setdest 815 420 16.0" 
$ns at 0.0 "$node_(10) setdest 215 565 10.0" 
$ns at 46.83896346869537 "$node_(10) setdest 598 776 5.0" 
$ns at 114.69340017434497 "$node_(10) setdest 471 20 17.0" 
$ns at 337.17042748997795 "$node_(10) setdest 1739 507 5.0" 
$ns at 490.5020427249076 "$node_(10) setdest 484 43 8.0" 
$ns at 808.2242557198456 "$node_(10) setdest 440 678 1.0" 
$ns at 0.0 "$node_(11) setdest 2361 61 5.0" 
$ns at 32.12553917803969 "$node_(11) setdest 1580 647 8.0" 
$ns at 96.84192268056871 "$node_(11) setdest 1374 304 1.0" 
$ns at 166.15669558295411 "$node_(11) setdest 2267 931 4.0" 
$ns at 303.99011796791433 "$node_(11) setdest 1152 405 19.0" 
$ns at 552.7949564335358 "$node_(11) setdest 1109 570 8.0" 
$ns at 0.0 "$node_(12) setdest 931 978 10.0" 
$ns at 45.96465131796488 "$node_(12) setdest 1835 804 3.0" 
$ns at 105.95010171326692 "$node_(12) setdest 401 674 18.0" 
$ns at 275.382544982711 "$node_(12) setdest 1679 167 5.0" 
$ns at 424.7856266858007 "$node_(12) setdest 2416 384 17.0" 
$ns at 688.701136356285 "$node_(12) setdest 676 303 6.0" 
$ns at 0.0 "$node_(13) setdest 601 581 9.0" 
$ns at 90.40456146218712 "$node_(13) setdest 2777 121 1.0" 
$ns at 129.18456143817338 "$node_(13) setdest 2635 974 5.0" 
$ns at 222.49958271893652 "$node_(13) setdest 1426 79 6.0" 
$ns at 356.7989872873893 "$node_(13) setdest 2730 962 4.0" 
$ns at 620.5650889611735 "$node_(13) setdest 13 722 7.0" 
$ns at 0.0 "$node_(14) setdest 588 576 5.0" 
$ns at 26.621950335997113 "$node_(14) setdest 1343 768 16.0" 
$ns at 190.16952036161427 "$node_(14) setdest 2865 865 3.0" 
$ns at 262.8933809285174 "$node_(14) setdest 38 352 2.0" 
$ns at 392.4382710428426 "$node_(14) setdest 915 948 11.0" 
$ns at 665.3983091728319 "$node_(14) setdest 508 249 11.0" 
$ns at 0.0 "$node_(15) setdest 344 177 15.0" 
$ns at 100.2751354669794 "$node_(15) setdest 2903 151 5.0" 
$ns at 175.208228959701 "$node_(15) setdest 1656 119 1.0" 
$ns at 235.8755754613031 "$node_(15) setdest 2204 341 16.0" 
$ns at 443.4045652824756 "$node_(15) setdest 2999 317 7.0" 
$ns at 741.4616648939882 "$node_(15) setdest 1340 351 5.0" 
$ns at 0.0 "$node_(16) setdest 821 41 1.0" 
$ns at 17.07842506238522 "$node_(16) setdest 992 409 15.0" 
$ns at 168.3635421146269 "$node_(16) setdest 932 470 7.0" 
$ns at 284.46076583822736 "$node_(16) setdest 1490 797 18.0" 
$ns at 532.9162931030464 "$node_(16) setdest 2266 39 4.0" 
$ns at 781.8198479616308 "$node_(16) setdest 1951 409 7.0" 
$ns at 0.0 "$node_(17) setdest 368 873 17.0" 
$ns at 179.21697285334108 "$node_(17) setdest 554 134 8.0" 
$ns at 214.8703986421867 "$node_(17) setdest 1377 557 9.0" 
$ns at 355.83913272226243 "$node_(17) setdest 619 853 1.0" 
$ns at 481.8838543751609 "$node_(17) setdest 2049 654 18.0" 
$ns at 748.7379598316202 "$node_(17) setdest 882 173 12.0" 
$ns at 0.0 "$node_(18) setdest 66 716 6.0" 
$ns at 38.614542384328566 "$node_(18) setdest 112 198 8.0" 
$ns at 146.18149784990382 "$node_(18) setdest 700 721 9.0" 
$ns at 282.00948858951415 "$node_(18) setdest 1997 936 5.0" 
$ns at 407.62328171737136 "$node_(18) setdest 1570 158 12.0" 
$ns at 697.4061503313096 "$node_(18) setdest 920 169 14.0" 
$ns at 0.0 "$node_(19) setdest 1047 202 11.0" 
$ns at 112.5997453781603 "$node_(19) setdest 2050 870 20.0" 
$ns at 166.85096134521547 "$node_(19) setdest 1566 703 10.0" 
$ns at 230.1838148102494 "$node_(19) setdest 894 497 13.0" 
$ns at 376.7412815556778 "$node_(19) setdest 892 933 12.0" 
$ns at 619.3702966717076 "$node_(19) setdest 1208 745 17.0" 
$ns at 0.0 "$node_(20) setdest 1090 302 19.0" 
$ns at 128.0138758062639 "$node_(20) setdest 920 593 9.0" 
$ns at 194.73543024892274 "$node_(20) setdest 2754 503 16.0" 
$ns at 381.6157903249479 "$node_(20) setdest 2478 720 13.0" 
$ns at 531.115716150497 "$node_(20) setdest 760 790 5.0" 
$ns at 783.6681130809856 "$node_(20) setdest 2762 636 18.0" 
$ns at 0.0 "$node_(21) setdest 1562 343 6.0" 
$ns at 34.75396030181108 "$node_(21) setdest 2465 90 19.0" 
$ns at 138.03917703568953 "$node_(21) setdest 1822 940 4.0" 
$ns at 222.15657992445628 "$node_(21) setdest 606 603 7.0" 
$ns at 380.3561049383246 "$node_(21) setdest 905 371 1.0" 
$ns at 625.1437654431838 "$node_(21) setdest 560 205 15.0" 
$ns at 0.0 "$node_(22) setdest 488 323 4.0" 
$ns at 53.2803760839103 "$node_(22) setdest 774 705 8.0" 
$ns at 123.48808097577367 "$node_(22) setdest 2351 681 2.0" 
$ns at 199.685983511208 "$node_(22) setdest 1063 72 20.0" 
$ns at 441.75289483922063 "$node_(22) setdest 1092 457 7.0" 
$ns at 730.4194365857768 "$node_(22) setdest 2131 770 18.0" 
$ns at 0.0 "$node_(23) setdest 2314 794 9.0" 
$ns at 102.74650602193667 "$node_(23) setdest 743 121 15.0" 
$ns at 240.73653236476895 "$node_(23) setdest 1553 772 2.0" 
$ns at 305.8979579835339 "$node_(23) setdest 1670 30 16.0" 
$ns at 551.4433368881903 "$node_(23) setdest 982 948 12.0" 
$ns at 0.0 "$node_(24) setdest 2330 657 18.0" 
$ns at 94.22707490131901 "$node_(24) setdest 649 863 16.0" 
$ns at 162.7556765136054 "$node_(24) setdest 2779 856 14.0" 
$ns at 275.12913334306614 "$node_(24) setdest 809 946 14.0" 
$ns at 473.9509846135851 "$node_(24) setdest 1433 485 18.0" 
$ns at 809.6203367866879 "$node_(24) setdest 1591 549 5.0" 
$ns at 0.0 "$node_(25) setdest 701 897 16.0" 
$ns at 82.97856738431233 "$node_(25) setdest 2058 49 2.0" 
$ns at 114.42178415209588 "$node_(25) setdest 2406 207 16.0" 
$ns at 233.62703944033328 "$node_(25) setdest 1415 236 19.0" 
$ns at 542.1682249175445 "$node_(25) setdest 667 162 8.0" 
$ns at 845.5334860249659 "$node_(25) setdest 2908 432 12.0" 
$ns at 0.0 "$node_(26) setdest 1634 700 8.0" 
$ns at 94.66910763960917 "$node_(26) setdest 680 72 1.0" 
$ns at 126.45801176682427 "$node_(26) setdest 1220 522 15.0" 
$ns at 193.3485641621075 "$node_(26) setdest 2618 672 9.0" 
$ns at 328.46272005763564 "$node_(26) setdest 2761 268 18.0" 
$ns at 685.4465025338045 "$node_(26) setdest 1970 415 11.0" 
$ns at 0.0 "$node_(27) setdest 1216 129 7.0" 
$ns at 28.31961851842975 "$node_(27) setdest 249 804 8.0" 
$ns at 69.80504568767319 "$node_(27) setdest 2349 966 5.0" 
$ns at 144.75318663628428 "$node_(27) setdest 1713 88 17.0" 
$ns at 274.0774516327884 "$node_(27) setdest 2015 280 16.0" 
$ns at 613.1414877028874 "$node_(27) setdest 2444 418 3.0" 
$ns at 0.0 "$node_(28) setdest 1470 608 2.0" 
$ns at 27.980439259227975 "$node_(28) setdest 799 944 6.0" 
$ns at 82.87859720270923 "$node_(28) setdest 352 184 1.0" 
$ns at 150.9969243974333 "$node_(28) setdest 2768 308 10.0" 
$ns at 366.10918422135705 "$node_(28) setdest 2731 939 19.0" 
$ns at 634.022377479118 "$node_(28) setdest 2512 233 17.0" 
$ns at 0.0 "$node_(29) setdest 391 175 18.0" 
$ns at 62.898472355974434 "$node_(29) setdest 108 178 17.0" 
$ns at 97.89641716001766 "$node_(29) setdest 234 498 5.0" 
$ns at 181.40539039385283 "$node_(29) setdest 2275 260 4.0" 
$ns at 319.16580954183985 "$node_(29) setdest 1468 838 16.0" 
$ns at 586.3279337605968 "$node_(29) setdest 626 891 13.0" 
$ns at 0.0 "$node_(30) setdest 2972 642 18.0" 
$ns at 15.94988590177348 "$node_(30) setdest 693 856 15.0" 
$ns at 124.65612627900404 "$node_(30) setdest 2008 565 11.0" 
$ns at 218.80749680596966 "$node_(30) setdest 1780 771 17.0" 
$ns at 431.80745515816886 "$node_(30) setdest 153 254 2.0" 
$ns at 688.087870981788 "$node_(30) setdest 2411 139 16.0" 
$ns at 0.0 "$node_(31) setdest 137 38 6.0" 
$ns at 58.429016110208195 "$node_(31) setdest 1892 458 19.0" 
$ns at 233.1779157475753 "$node_(31) setdest 1960 627 15.0" 
$ns at 381.4279657454823 "$node_(31) setdest 2282 84 1.0" 
$ns at 506.25814901231496 "$node_(31) setdest 1466 136 7.0" 
$ns at 786.8406510840593 "$node_(31) setdest 783 813 2.0" 
$ns at 0.0 "$node_(32) setdest 1248 20 4.0" 
$ns at 18.730800335462355 "$node_(32) setdest 2340 387 7.0" 
$ns at 92.04259946837115 "$node_(32) setdest 2569 764 13.0" 
$ns at 256.9787792712898 "$node_(32) setdest 1966 373 13.0" 
$ns at 484.5427666375395 "$node_(32) setdest 1669 390 19.0" 
$ns at 838.2235180348259 "$node_(32) setdest 1083 137 20.0" 
$ns at 0.0 "$node_(33) setdest 2637 122 19.0" 
$ns at 196.83947324758805 "$node_(33) setdest 2893 856 6.0" 
$ns at 273.131431298121 "$node_(33) setdest 2734 803 10.0" 
$ns at 412.83091124605005 "$node_(33) setdest 1565 783 1.0" 
$ns at 542.6070964961225 "$node_(33) setdest 2822 877 19.0" 
$ns at 0.0 "$node_(34) setdest 1764 219 16.0" 
$ns at 87.9949709790523 "$node_(34) setdest 310 23 16.0" 
$ns at 232.34640174873988 "$node_(34) setdest 794 901 11.0" 
$ns at 295.39230135004567 "$node_(34) setdest 756 784 9.0" 
$ns at 431.8455701129541 "$node_(34) setdest 1394 763 5.0" 
$ns at 679.9582941130562 "$node_(34) setdest 1043 764 9.0" 
$ns at 0.0 "$node_(35) setdest 945 270 1.0" 
$ns at 22.745432184346733 "$node_(35) setdest 2763 217 7.0" 
$ns at 92.83118523222899 "$node_(35) setdest 2641 796 2.0" 
$ns at 171.3544288559477 "$node_(35) setdest 1227 134 11.0" 
$ns at 383.02898942871445 "$node_(35) setdest 1873 739 17.0" 
$ns at 700.5164431891875 "$node_(35) setdest 1248 132 15.0" 
$ns at 0.0 "$node_(36) setdest 884 338 11.0" 
$ns at 103.7116702424039 "$node_(36) setdest 595 746 4.0" 
$ns at 163.76791232239412 "$node_(36) setdest 440 400 3.0" 
$ns at 240.8449947029526 "$node_(36) setdest 2775 954 19.0" 
$ns at 385.4063801983707 "$node_(36) setdest 2073 383 9.0" 
$ns at 671.599656498748 "$node_(36) setdest 1548 5 18.0" 
$ns at 0.0 "$node_(37) setdest 1152 562 15.0" 
$ns at 33.2074847222036 "$node_(37) setdest 320 895 7.0" 
$ns at 132.42489056013585 "$node_(37) setdest 2825 209 8.0" 
$ns at 264.5042549824082 "$node_(37) setdest 1321 70 9.0" 
$ns at 397.12817491662764 "$node_(37) setdest 598 23 3.0" 
$ns at 666.8156927980235 "$node_(37) setdest 2219 186 7.0" 
$ns at 0.0 "$node_(38) setdest 2086 240 6.0" 
$ns at 64.47747951198093 "$node_(38) setdest 2577 1 12.0" 
$ns at 206.02128914221365 "$node_(38) setdest 1206 147 12.0" 
$ns at 373.6851345649835 "$node_(38) setdest 2291 749 6.0" 
$ns at 496.8365920818377 "$node_(38) setdest 850 956 16.0" 
$ns at 874.2755194930405 "$node_(38) setdest 1937 564 13.0" 
$ns at 0.0 "$node_(39) setdest 1800 234 4.0" 
$ns at 35.08585178165567 "$node_(39) setdest 646 784 2.0" 
$ns at 69.89037163223387 "$node_(39) setdest 433 359 6.0" 
$ns at 152.77972249122018 "$node_(39) setdest 2944 233 6.0" 
$ns at 298.8529630585323 "$node_(39) setdest 2469 701 7.0" 
$ns at 545.7631011100686 "$node_(39) setdest 1680 789 7.0" 
$ns at 0.0 "$node_(40) setdest 813 487 1.0" 
$ns at 20.18011272821052 "$node_(40) setdest 963 850 16.0" 
$ns at 136.68422890186636 "$node_(40) setdest 1248 558 11.0" 
$ns at 244.27716766971395 "$node_(40) setdest 2752 498 13.0" 
$ns at 387.98276397091587 "$node_(40) setdest 522 476 12.0" 
$ns at 682.2468744549324 "$node_(40) setdest 1506 471 19.0" 
$ns at 0.0 "$node_(41) setdest 2099 683 16.0" 
$ns at 35.73302649107056 "$node_(41) setdest 2041 253 13.0" 
$ns at 129.4602618079506 "$node_(41) setdest 2599 677 3.0" 
$ns at 207.39899174939478 "$node_(41) setdest 1500 883 1.0" 
$ns at 329.7327056427463 "$node_(41) setdest 2710 402 13.0" 
$ns at 600.4858306543365 "$node_(41) setdest 92 297 8.0" 
$ns at 0.0 "$node_(42) setdest 1099 322 19.0" 
$ns at 40.69491639182178 "$node_(42) setdest 987 301 20.0" 
$ns at 194.6902259602183 "$node_(42) setdest 2594 868 8.0" 
$ns at 284.86078276017304 "$node_(42) setdest 2543 494 4.0" 
$ns at 420.4291946920555 "$node_(42) setdest 669 239 17.0" 
$ns at 729.9805687693096 "$node_(42) setdest 1749 736 14.0" 
$ns at 0.0 "$node_(43) setdest 7 739 19.0" 
$ns at 18.699073488713186 "$node_(43) setdest 1537 975 2.0" 
$ns at 63.69863148014065 "$node_(43) setdest 1671 125 1.0" 
$ns at 130.6207073962449 "$node_(43) setdest 381 540 1.0" 
$ns at 258.9889430618322 "$node_(43) setdest 160 663 14.0" 
$ns at 549.0957345602958 "$node_(43) setdest 314 207 3.0" 
$ns at 0.0 "$node_(44) setdest 372 859 14.0" 
$ns at 128.42774241759247 "$node_(44) setdest 1284 634 18.0" 
$ns at 173.11258956302936 "$node_(44) setdest 257 55 17.0" 
$ns at 285.42332122946783 "$node_(44) setdest 1489 995 8.0" 
$ns at 422.0748391201266 "$node_(44) setdest 2688 372 14.0" 
$ns at 680.3966237307358 "$node_(44) setdest 99 896 20.0" 
$ns at 0.0 "$node_(45) setdest 825 680 18.0" 
$ns at 35.36663874898977 "$node_(45) setdest 2517 899 15.0" 
$ns at 111.09363347024382 "$node_(45) setdest 1993 572 12.0" 
$ns at 221.04422461509932 "$node_(45) setdest 2075 243 10.0" 
$ns at 367.83733559076717 "$node_(45) setdest 2866 539 18.0" 
$ns at 620.2261027031279 "$node_(45) setdest 2834 589 16.0" 
$ns at 0.0 "$node_(46) setdest 473 809 9.0" 
$ns at 18.431679345328146 "$node_(46) setdest 1865 875 20.0" 
$ns at 110.56292462660863 "$node_(46) setdest 1307 549 13.0" 
$ns at 281.62454467289206 "$node_(46) setdest 190 614 18.0" 
$ns at 504.17053124481413 "$node_(46) setdest 559 398 3.0" 
$ns at 745.873962798381 "$node_(46) setdest 1262 204 10.0" 
$ns at 0.0 "$node_(47) setdest 268 528 5.0" 
$ns at 64.1038550729453 "$node_(47) setdest 1658 107 13.0" 
$ns at 139.28010887936009 "$node_(47) setdest 898 695 2.0" 
$ns at 212.54116324189317 "$node_(47) setdest 364 951 20.0" 
$ns at 466.45550481600293 "$node_(47) setdest 630 984 2.0" 
$ns at 723.6276388464883 "$node_(47) setdest 2830 908 1.0" 
$ns at 0.0 "$node_(48) setdest 1395 215 16.0" 
$ns at 92.38790499534005 "$node_(48) setdest 2675 922 15.0" 
$ns at 229.30577520553615 "$node_(48) setdest 418 197 7.0" 
$ns at 356.43218337679326 "$node_(48) setdest 2702 617 13.0" 
$ns at 572.3580333573177 "$node_(48) setdest 812 310 1.0" 
$ns at 814.8567433088074 "$node_(48) setdest 2638 967 6.0" 
$ns at 0.0 "$node_(49) setdest 489 107 8.0" 
$ns at 64.15387249326326 "$node_(49) setdest 1729 71 19.0" 
$ns at 154.63861215708152 "$node_(49) setdest 421 893 20.0" 
$ns at 280.4893212992144 "$node_(49) setdest 2106 599 6.0" 
$ns at 439.99652726148264 "$node_(49) setdest 2030 502 18.0" 
$ns at 844.4558926066268 "$node_(49) setdest 2577 749 5.0" 
$ns at 0.0 "$node_(50) setdest 223 710 2.0" 
$ns at 27.419828185116266 "$node_(50) setdest 237 804 13.0" 
$ns at 151.05578234405095 "$node_(50) setdest 366 7 1.0" 
$ns at 213.22503331721177 "$node_(50) setdest 54 601 1.0" 
$ns at 342.7768790893777 "$node_(50) setdest 1214 673 5.0" 
$ns at 598.4901584879048 "$node_(50) setdest 334 520 19.0" 
$ns at 0.0 "$node_(51) setdest 573 373 3.0" 
$ns at 38.51055610314661 "$node_(51) setdest 720 800 13.0" 
$ns at 127.3650029959045 "$node_(51) setdest 225 729 13.0" 
$ns at 188.6654274020081 "$node_(51) setdest 2112 289 2.0" 
$ns at 311.3878177412501 "$node_(51) setdest 2400 565 16.0" 
$ns at 553.5499757451636 "$node_(51) setdest 1688 928 16.0" 
$ns at 0.0 "$node_(52) setdest 2806 796 4.0" 
$ns at 43.23575468489345 "$node_(52) setdest 1898 592 2.0" 
$ns at 88.34575061118373 "$node_(52) setdest 1007 156 20.0" 
$ns at 308.39183932982814 "$node_(52) setdest 2105 77 19.0" 
$ns at 484.35085693185795 "$node_(52) setdest 1677 235 13.0" 
$ns at 743.1600355099249 "$node_(52) setdest 2268 354 18.0" 
$ns at 0.0 "$node_(53) setdest 1998 516 15.0" 
$ns at 89.90173908599333 "$node_(53) setdest 814 387 14.0" 
$ns at 124.8619728240835 "$node_(53) setdest 238 384 3.0" 
$ns at 185.63494953400823 "$node_(53) setdest 2615 128 14.0" 
$ns at 313.61273242134143 "$node_(53) setdest 1278 306 5.0" 
$ns at 554.0513821115167 "$node_(53) setdest 2705 499 7.0" 
$ns at 0.0 "$node_(54) setdest 1630 636 8.0" 
$ns at 61.401364985915436 "$node_(54) setdest 2154 453 12.0" 
$ns at 169.5540205213128 "$node_(54) setdest 205 769 17.0" 
$ns at 308.2365259766691 "$node_(54) setdest 2246 443 18.0" 
$ns at 467.5426918615859 "$node_(54) setdest 867 571 9.0" 
$ns at 708.2591926032475 "$node_(54) setdest 1856 886 15.0" 
$ns at 0.0 "$node_(55) setdest 558 327 20.0" 
$ns at 22.910674265767526 "$node_(55) setdest 2698 444 17.0" 
$ns at 199.4484990730548 "$node_(55) setdest 2509 635 1.0" 
$ns at 262.2602976681327 "$node_(55) setdest 819 216 10.0" 
$ns at 447.60026529180993 "$node_(55) setdest 1816 973 19.0" 
$ns at 760.0249690094155 "$node_(55) setdest 517 162 15.0" 
$ns at 0.0 "$node_(56) setdest 2417 878 14.0" 
$ns at 127.98261955427158 "$node_(56) setdest 569 348 9.0" 
$ns at 160.5266124319644 "$node_(56) setdest 2237 967 6.0" 
$ns at 228.2117878466084 "$node_(56) setdest 2431 848 2.0" 
$ns at 355.1077671375011 "$node_(56) setdest 1039 233 18.0" 
$ns at 677.2906045198664 "$node_(56) setdest 802 366 9.0" 
$ns at 0.0 "$node_(57) setdest 2250 335 7.0" 
$ns at 19.609172707607225 "$node_(57) setdest 1714 937 20.0" 
$ns at 131.03541318557257 "$node_(57) setdest 1783 850 11.0" 
$ns at 241.1894083917925 "$node_(57) setdest 49 267 7.0" 
$ns at 404.4322549177539 "$node_(57) setdest 2660 662 5.0" 
$ns at 663.7156762309264 "$node_(57) setdest 2128 555 11.0" 
$ns at 0.0 "$node_(58) setdest 1925 984 8.0" 
$ns at 66.26479289147386 "$node_(58) setdest 2784 877 9.0" 
$ns at 107.91571254359704 "$node_(58) setdest 2156 690 3.0" 
$ns at 184.65809559153894 "$node_(58) setdest 1063 462 15.0" 
$ns at 442.7500113082999 "$node_(58) setdest 1588 929 9.0" 
$ns at 734.4301124050003 "$node_(58) setdest 1461 442 8.0" 
$ns at 0.0 "$node_(59) setdest 1626 221 20.0" 
$ns at 78.9772804336465 "$node_(59) setdest 2349 914 15.0" 
$ns at 139.01511849619845 "$node_(59) setdest 2279 503 15.0" 
$ns at 203.17662479271635 "$node_(59) setdest 984 387 5.0" 
$ns at 360.2568711106989 "$node_(59) setdest 1788 813 5.0" 
$ns at 613.9784658635424 "$node_(59) setdest 262 953 8.0" 
$ns at 0.0 "$node_(60) setdest 2480 589 17.0" 
$ns at 70.38902669316315 "$node_(60) setdest 114 762 18.0" 
$ns at 210.47337793326028 "$node_(60) setdest 1622 778 7.0" 
$ns at 312.83208547230373 "$node_(60) setdest 2202 627 17.0" 
$ns at 518.0827087921645 "$node_(60) setdest 801 218 15.0" 
$ns at 766.1011884457022 "$node_(60) setdest 306 855 6.0" 
$ns at 0.0 "$node_(61) setdest 2116 990 5.0" 
$ns at 35.11255643306991 "$node_(61) setdest 1568 625 15.0" 
$ns at 201.29541430118115 "$node_(61) setdest 2192 713 13.0" 
$ns at 342.8294751658906 "$node_(61) setdest 1483 488 8.0" 
$ns at 503.7760112643089 "$node_(61) setdest 1817 977 8.0" 
$ns at 752.0217747646018 "$node_(61) setdest 1302 850 14.0" 
$ns at 0.0 "$node_(62) setdest 1708 375 16.0" 
$ns at 51.68465773498504 "$node_(62) setdest 1238 480 17.0" 
$ns at 216.60713592578048 "$node_(62) setdest 694 834 19.0" 
$ns at 380.1941775943739 "$node_(62) setdest 2632 411 12.0" 
$ns at 540.8853160920785 "$node_(62) setdest 1343 224 14.0" 
$ns at 865.6245591228713 "$node_(62) setdest 1980 793 6.0" 
$ns at 0.0 "$node_(63) setdest 1805 418 10.0" 
$ns at 28.323222927561083 "$node_(63) setdest 2482 540 17.0" 
$ns at 164.27274218443253 "$node_(63) setdest 1410 293 1.0" 
$ns at 226.52067754560824 "$node_(63) setdest 498 853 11.0" 
$ns at 364.5426908636052 "$node_(63) setdest 278 356 17.0" 
$ns at 709.7282076577387 "$node_(63) setdest 1082 941 10.0" 
$ns at 0.0 "$node_(64) setdest 991 965 16.0" 
$ns at 63.890430101479936 "$node_(64) setdest 477 542 1.0" 
$ns at 102.51575644726447 "$node_(64) setdest 94 348 9.0" 
$ns at 251.92436185056962 "$node_(64) setdest 249 55 15.0" 
$ns at 518.2388378581352 "$node_(64) setdest 2940 871 17.0" 
$ns at 792.3821089572396 "$node_(64) setdest 1431 374 16.0" 
$ns at 0.0 "$node_(65) setdest 186 275 18.0" 
$ns at 194.22261651188126 "$node_(65) setdest 2860 762 13.0" 
$ns at 336.37496946799195 "$node_(65) setdest 940 828 16.0" 
$ns at 500.37751090410234 "$node_(65) setdest 1581 335 4.0" 
$ns at 648.0480328442578 "$node_(65) setdest 2345 603 19.0" 
$ns at 0.0 "$node_(66) setdest 1 999 11.0" 
$ns at 78.70337850455505 "$node_(66) setdest 1133 340 16.0" 
$ns at 171.50948511646308 "$node_(66) setdest 1159 913 2.0" 
$ns at 242.21757630285947 "$node_(66) setdest 424 593 14.0" 
$ns at 488.44945945607907 "$node_(66) setdest 1306 813 2.0" 
$ns at 739.328213215565 "$node_(66) setdest 1789 135 19.0" 
$ns at 0.0 "$node_(67) setdest 1652 789 4.0" 
$ns at 22.516424087326786 "$node_(67) setdest 368 804 6.0" 
$ns at 62.10923578441492 "$node_(67) setdest 1978 327 1.0" 
$ns at 129.80460903308602 "$node_(67) setdest 1555 269 13.0" 
$ns at 372.29933926370745 "$node_(67) setdest 2476 717 16.0" 
$ns at 662.8197269196953 "$node_(67) setdest 541 408 15.0" 
$ns at 0.0 "$node_(68) setdest 1993 148 7.0" 
$ns at 23.04821250963573 "$node_(68) setdest 1740 267 12.0" 
$ns at 153.8408294335208 "$node_(68) setdest 2580 73 2.0" 
$ns at 227.43017131502933 "$node_(68) setdest 2863 795 8.0" 
$ns at 358.4668398889404 "$node_(68) setdest 983 686 6.0" 
$ns at 615.1366389285786 "$node_(68) setdest 1181 822 6.0" 
$ns at 0.0 "$node_(69) setdest 2495 577 15.0" 
$ns at 79.82250722049174 "$node_(69) setdest 2256 983 3.0" 
$ns at 127.53585859687287 "$node_(69) setdest 313 910 1.0" 
$ns at 187.7793065818633 "$node_(69) setdest 149 544 1.0" 
$ns at 308.1193583514568 "$node_(69) setdest 2303 700 9.0" 
$ns at 629.6799425808983 "$node_(69) setdest 905 335 16.0" 
$ns at 0.0 "$node_(70) setdest 1831 21 13.0" 
$ns at 35.51843550363257 "$node_(70) setdest 2825 258 14.0" 
$ns at 201.29091588098987 "$node_(70) setdest 49 235 18.0" 
$ns at 331.22407171842036 "$node_(70) setdest 816 62 2.0" 
$ns at 454.18924071108404 "$node_(70) setdest 1809 556 18.0" 
$ns at 824.7581980859178 "$node_(70) setdest 1831 355 15.0" 
$ns at 0.0 "$node_(71) setdest 1083 555 18.0" 
$ns at 84.03972376071874 "$node_(71) setdest 192 45 8.0" 
$ns at 172.86049256267927 "$node_(71) setdest 2565 417 19.0" 
$ns at 415.79695671728837 "$node_(71) setdest 317 691 7.0" 
$ns at 554.4055282893316 "$node_(71) setdest 836 43 8.0" 
$ns at 863.6228287972224 "$node_(71) setdest 1116 440 9.0" 
$ns at 0.0 "$node_(72) setdest 1265 327 1.0" 
$ns at 19.779919202454398 "$node_(72) setdest 1112 538 11.0" 
$ns at 145.36082537545047 "$node_(72) setdest 2528 190 8.0" 
$ns at 206.6905546920204 "$node_(72) setdest 35 598 18.0" 
$ns at 362.68042735333427 "$node_(72) setdest 2416 204 6.0" 
$ns at 613.0165635304929 "$node_(72) setdest 431 91 8.0" 
$ns at 0.0 "$node_(73) setdest 2315 882 7.0" 
$ns at 82.08145996276436 "$node_(73) setdest 1565 776 12.0" 
$ns at 147.65442068469216 "$node_(73) setdest 1535 975 5.0" 
$ns at 227.67441001046348 "$node_(73) setdest 2637 12 10.0" 
$ns at 371.0399253937678 "$node_(73) setdest 363 352 5.0" 
$ns at 659.2743266119694 "$node_(73) setdest 94 158 16.0" 
$ns at 0.0 "$node_(74) setdest 1510 300 9.0" 
$ns at 93.1736458837851 "$node_(74) setdest 567 542 1.0" 
$ns at 123.30657080038786 "$node_(74) setdest 357 316 13.0" 
$ns at 270.25130363913246 "$node_(74) setdest 2701 666 6.0" 
$ns at 432.70240272543793 "$node_(74) setdest 134 736 1.0" 
$ns at 680.4115921349505 "$node_(74) setdest 917 650 12.0" 
$ns at 0.0 "$node_(75) setdest 1951 775 1.0" 
$ns at 22.553455335692348 "$node_(75) setdest 1877 80 17.0" 
$ns at 151.7209388483748 "$node_(75) setdest 1332 813 3.0" 
$ns at 231.63923669432694 "$node_(75) setdest 178 744 13.0" 
$ns at 412.4543835085624 "$node_(75) setdest 2640 5 8.0" 
$ns at 703.8100027317662 "$node_(75) setdest 1560 956 8.0" 
$ns at 0.0 "$node_(76) setdest 566 551 8.0" 
$ns at 61.37626393528785 "$node_(76) setdest 2640 419 1.0" 
$ns at 93.62308266446826 "$node_(76) setdest 1571 212 20.0" 
$ns at 283.3790645057436 "$node_(76) setdest 1975 844 2.0" 
$ns at 406.18481324645745 "$node_(76) setdest 2930 889 8.0" 
$ns at 716.3383622852075 "$node_(76) setdest 948 771 19.0" 
$ns at 0.0 "$node_(77) setdest 795 368 1.0" 
$ns at 16.56429636098761 "$node_(77) setdest 1787 310 1.0" 
$ns at 56.03985969898201 "$node_(77) setdest 417 546 1.0" 
$ns at 119.34492048865823 "$node_(77) setdest 1719 751 12.0" 
$ns at 292.6610786958445 "$node_(77) setdest 2436 724 8.0" 
$ns at 552.8233427967018 "$node_(77) setdest 1056 253 19.0" 
$ns at 0.0 "$node_(78) setdest 2883 810 15.0" 
$ns at 158.90422203396892 "$node_(78) setdest 1720 73 19.0" 
$ns at 276.13752127045154 "$node_(78) setdest 309 493 6.0" 
$ns at 357.9591200621253 "$node_(78) setdest 507 30 15.0" 
$ns at 479.770102063278 "$node_(78) setdest 1184 747 18.0" 
$ns at 736.40889685241 "$node_(78) setdest 99 176 1.0" 
$ns at 0.0 "$node_(79) setdest 465 216 11.0" 
$ns at 57.156070875206176 "$node_(79) setdest 1606 874 17.0" 
$ns at 223.15950482318686 "$node_(79) setdest 2003 342 1.0" 
$ns at 284.8904336931212 "$node_(79) setdest 178 732 18.0" 
$ns at 481.9344746502342 "$node_(79) setdest 168 297 15.0" 
$ns at 838.5083039854555 "$node_(79) setdest 2941 120 5.0" 
$ns at 0.0 "$node_(80) setdest 860 60 1.0" 
$ns at 23.017238315705946 "$node_(80) setdest 2307 205 10.0" 
$ns at 145.76835299770377 "$node_(80) setdest 1809 220 14.0" 
$ns at 231.79705743019485 "$node_(80) setdest 420 728 14.0" 
$ns at 415.21164581190783 "$node_(80) setdest 2801 336 3.0" 
$ns at 670.7120683435288 "$node_(80) setdest 1272 967 3.0" 
$ns at 0.0 "$node_(81) setdest 253 938 6.0" 
$ns at 15.689681121448732 "$node_(81) setdest 1769 607 4.0" 
$ns at 74.09217365310533 "$node_(81) setdest 2274 493 6.0" 
$ns at 182.89993186671543 "$node_(81) setdest 1763 456 19.0" 
$ns at 426.0219976065682 "$node_(81) setdest 2119 936 6.0" 
$ns at 695.6147951982101 "$node_(81) setdest 2844 238 2.0" 
$ns at 0.0 "$node_(82) setdest 1692 576 2.0" 
$ns at 33.04388005673986 "$node_(82) setdest 2401 890 17.0" 
$ns at 71.23944981449966 "$node_(82) setdest 493 476 9.0" 
$ns at 200.7080151071058 "$node_(82) setdest 2248 104 3.0" 
$ns at 346.6003941815144 "$node_(82) setdest 1171 628 16.0" 
$ns at 699.1416928995747 "$node_(82) setdest 825 34 6.0" 
$ns at 0.0 "$node_(83) setdest 2575 513 16.0" 
$ns at 85.74233503270825 "$node_(83) setdest 1762 414 5.0" 
$ns at 120.06961133050876 "$node_(83) setdest 2960 874 8.0" 
$ns at 226.6264996085073 "$node_(83) setdest 335 509 15.0" 
$ns at 392.33864477446934 "$node_(83) setdest 758 786 4.0" 
$ns at 636.0677359463637 "$node_(83) setdest 79 631 3.0" 
$ns at 0.0 "$node_(84) setdest 2049 347 8.0" 
$ns at 40.5682156837256 "$node_(84) setdest 1598 162 8.0" 
$ns at 129.1027382694749 "$node_(84) setdest 2649 589 2.0" 
$ns at 195.85992389248622 "$node_(84) setdest 2346 301 16.0" 
$ns at 339.60480189094494 "$node_(84) setdest 464 425 17.0" 
$ns at 719.9105408412752 "$node_(84) setdest 1902 982 14.0" 
$ns at 0.0 "$node_(85) setdest 1508 716 8.0" 
$ns at 81.36084919052826 "$node_(85) setdest 2022 682 18.0" 
$ns at 280.743721877624 "$node_(85) setdest 1743 805 4.0" 
$ns at 344.11912542162224 "$node_(85) setdest 486 63 8.0" 
$ns at 536.8776221076425 "$node_(85) setdest 2637 77 15.0" 
$ns at 892.0673734701672 "$node_(85) setdest 2537 671 19.0" 
$ns at 0.0 "$node_(86) setdest 2099 398 20.0" 
$ns at 184.08307124714798 "$node_(86) setdest 2411 126 3.0" 
$ns at 228.99799948640754 "$node_(86) setdest 2190 500 15.0" 
$ns at 347.94096626014436 "$node_(86) setdest 2263 539 2.0" 
$ns at 468.71316616531595 "$node_(86) setdest 762 652 15.0" 
$ns at 790.5978754610999 "$node_(86) setdest 1498 85 13.0" 
$ns at 0.0 "$node_(87) setdest 926 198 9.0" 
$ns at 101.99148758957281 "$node_(87) setdest 1293 961 2.0" 
$ns at 136.64923633342806 "$node_(87) setdest 1008 793 15.0" 
$ns at 343.03086739806304 "$node_(87) setdest 830 168 12.0" 
$ns at 517.700910718463 "$node_(87) setdest 386 419 7.0" 
$ns at 809.7332917587456 "$node_(87) setdest 1529 845 1.0" 
$ns at 0.0 "$node_(88) setdest 371 508 7.0" 
$ns at 27.597991473838036 "$node_(88) setdest 298 85 1.0" 
$ns at 66.81164326480163 "$node_(88) setdest 1017 769 2.0" 
$ns at 135.389837717674 "$node_(88) setdest 1579 470 10.0" 
$ns at 354.08246590846557 "$node_(88) setdest 1538 533 3.0" 
$ns at 597.0122427962561 "$node_(88) setdest 721 752 3.0" 
$ns at 0.0 "$node_(89) setdest 711 711 1.0" 
$ns at 21.271682870580772 "$node_(89) setdest 2957 416 4.0" 
$ns at 63.13795996606579 "$node_(89) setdest 428 687 4.0" 
$ns at 140.81212764152986 "$node_(89) setdest 2011 57 18.0" 
$ns at 426.76101704978385 "$node_(89) setdest 1299 740 4.0" 
$ns at 697.7708332304617 "$node_(89) setdest 2105 799 1.0" 
$ns at 0.0 "$node_(90) setdest 955 816 14.0" 
$ns at 59.20553622350997 "$node_(90) setdest 2911 191 5.0" 
$ns at 135.16527253448834 "$node_(90) setdest 458 734 1.0" 
$ns at 195.83634411152863 "$node_(90) setdest 2707 311 17.0" 
$ns at 341.6855916668213 "$node_(90) setdest 970 170 9.0" 
$ns at 587.8032181459965 "$node_(90) setdest 776 13 13.0" 
$ns at 0.0 "$node_(91) setdest 570 980 6.0" 
$ns at 66.91856837157019 "$node_(91) setdest 1823 546 12.0" 
$ns at 199.05674413504482 "$node_(91) setdest 1898 711 8.0" 
$ns at 329.93363928042726 "$node_(91) setdest 1927 978 11.0" 
$ns at 516.8530035202846 "$node_(91) setdest 2999 376 1.0" 
$ns at 757.8635340107021 "$node_(91) setdest 2328 149 13.0" 
$ns at 0.0 "$node_(92) setdest 1544 830 19.0" 
$ns at 134.2614501043927 "$node_(92) setdest 2051 111 1.0" 
$ns at 167.82673489953964 "$node_(92) setdest 1312 311 15.0" 
$ns at 252.20466377041902 "$node_(92) setdest 2161 245 11.0" 
$ns at 478.0351298911149 "$node_(92) setdest 1595 10 11.0" 
$ns at 761.1161226854583 "$node_(92) setdest 1171 533 9.0" 
$ns at 0.0 "$node_(93) setdest 1930 716 15.0" 
$ns at 130.72333451241775 "$node_(93) setdest 879 679 20.0" 
$ns at 178.8845631900933 "$node_(93) setdest 1297 900 15.0" 
$ns at 287.64419924861386 "$node_(93) setdest 664 36 7.0" 
$ns at 463.856654329889 "$node_(93) setdest 1709 796 20.0" 
$ns at 773.5043015260621 "$node_(93) setdest 1022 558 5.0" 
$ns at 0.0 "$node_(94) setdest 2820 324 15.0" 
$ns at 40.57388830791313 "$node_(94) setdest 1849 214 4.0" 
$ns at 90.37392748316292 "$node_(94) setdest 1967 935 14.0" 
$ns at 201.43495508833593 "$node_(94) setdest 2788 590 1.0" 
$ns at 329.0401129137363 "$node_(94) setdest 2806 707 7.0" 
$ns at 572.5819125952924 "$node_(94) setdest 1621 633 9.0" 
$ns at 0.0 "$node_(95) setdest 424 276 10.0" 
$ns at 33.603126289852845 "$node_(95) setdest 2517 723 4.0" 
$ns at 77.96206929870289 "$node_(95) setdest 1600 435 11.0" 
$ns at 247.00163531831197 "$node_(95) setdest 1653 568 6.0" 
$ns at 383.923045733299 "$node_(95) setdest 1598 479 15.0" 
$ns at 758.9440442292183 "$node_(95) setdest 2477 588 11.0" 
$ns at 0.0 "$node_(96) setdest 1666 635 8.0" 
$ns at 69.64045289448794 "$node_(96) setdest 2654 779 4.0" 
$ns at 130.39367239704316 "$node_(96) setdest 2119 153 15.0" 
$ns at 285.78241199719014 "$node_(96) setdest 466 241 3.0" 
$ns at 406.80681622678776 "$node_(96) setdest 2682 888 6.0" 
$ns at 705.6414732445305 "$node_(96) setdest 185 840 15.0" 
$ns at 0.0 "$node_(97) setdest 479 466 14.0" 
$ns at 136.72613195665673 "$node_(97) setdest 2719 705 13.0" 
$ns at 284.1504946352924 "$node_(97) setdest 825 355 19.0" 
$ns at 465.93508595442944 "$node_(97) setdest 1531 521 1.0" 
$ns at 587.3425867125077 "$node_(97) setdest 2726 428 8.0" 
$ns at 844.835714963531 "$node_(97) setdest 1627 818 10.0" 
$ns at 0.0 "$node_(98) setdest 2736 846 10.0" 
$ns at 94.9618294590547 "$node_(98) setdest 2138 723 19.0" 
$ns at 199.76014303887013 "$node_(98) setdest 1577 353 7.0" 
$ns at 275.5832658073953 "$node_(98) setdest 760 873 16.0" 
$ns at 511.2968647844997 "$node_(98) setdest 1668 298 9.0" 
$ns at 812.9379367613974 "$node_(98) setdest 1103 453 17.0" 
$ns at 0.0 "$node_(99) setdest 2474 990 1.0" 
$ns at 21.299700031659533 "$node_(99) setdest 1701 564 2.0" 
$ns at 55.55807605804033 "$node_(99) setdest 1320 189 14.0" 
$ns at 125.49013486254688 "$node_(99) setdest 226 367 15.0" 
$ns at 314.12395248064513 "$node_(99) setdest 2073 841 11.0" 
$ns at 622.7681058661008 "$node_(99) setdest 2185 735 4.0" 


#Set a TCP connection between node_(61) and node_(37)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(0)
$ns attach-agent $node_(37) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(28) and node_(96)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(1)
$ns attach-agent $node_(96) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(4) and node_(34)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(2)
$ns attach-agent $node_(34) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(15) and node_(30)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(3)
$ns attach-agent $node_(30) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(55) and node_(14)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(4)
$ns attach-agent $node_(14) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(1) and node_(60)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(5)
$ns attach-agent $node_(60) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(35) and node_(42)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(6)
$ns attach-agent $node_(42) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(21) and node_(11)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(7)
$ns attach-agent $node_(11) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(19) and node_(85)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(8)
$ns attach-agent $node_(85) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(51) and node_(5)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(9)
$ns attach-agent $node_(5) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(28) and node_(62)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(10)
$ns attach-agent $node_(62) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(62) and node_(60)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(11)
$ns attach-agent $node_(60) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(0) and node_(4)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(12)
$ns attach-agent $node_(4) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(70) and node_(90)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(13)
$ns attach-agent $node_(90) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(84) and node_(71)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(14)
$ns attach-agent $node_(71) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(31) and node_(43)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(15)
$ns attach-agent $node_(43) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(95) and node_(51)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(16)
$ns attach-agent $node_(51) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(34) and node_(91)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(17)
$ns attach-agent $node_(91) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(2) and node_(62)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(18)
$ns attach-agent $node_(62) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(29) and node_(5)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(19)
$ns attach-agent $node_(5) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(41) and node_(13)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(20)
$ns attach-agent $node_(13) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(3) and node_(8)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(21)
$ns attach-agent $node_(8) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(88) and node_(52)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(22)
$ns attach-agent $node_(52) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(88) and node_(91)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(23)
$ns attach-agent $node_(91) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(44) and node_(20)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(24)
$ns attach-agent $node_(20) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(57) and node_(85)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(25)
$ns attach-agent $node_(85) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(58) and node_(27)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(26)
$ns attach-agent $node_(27) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(93) and node_(55)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(27)
$ns attach-agent $node_(55) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(88) and node_(32)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(28)
$ns attach-agent $node_(32) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(84) and node_(88)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(29)
$ns attach-agent $node_(88) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(34) and node_(82)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(30)
$ns attach-agent $node_(82) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(80) and node_(16)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(31)
$ns attach-agent $node_(16) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(9) and node_(88)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(32)
$ns attach-agent $node_(88) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(89) and node_(64)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(33)
$ns attach-agent $node_(64) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(49) and node_(37)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(34)
$ns attach-agent $node_(37) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(35) and node_(24)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(35)
$ns attach-agent $node_(24) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(54) and node_(32)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(36)
$ns attach-agent $node_(32) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(31) and node_(73)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(37)
$ns attach-agent $node_(73) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(90) and node_(83)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(38)
$ns attach-agent $node_(83) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(39) and node_(75)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(39)
$ns attach-agent $node_(75) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(8) and node_(20)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(40)
$ns attach-agent $node_(20) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(74) and node_(28)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(41)
$ns attach-agent $node_(28) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(30) and node_(49)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(42)
$ns attach-agent $node_(49) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(92) and node_(77)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(43)
$ns attach-agent $node_(77) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(3) and node_(14)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(44)
$ns attach-agent $node_(14) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(28) and node_(81)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(45)
$ns attach-agent $node_(81) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(55) and node_(29)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(46)
$ns attach-agent $node_(29) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(87) and node_(96)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(47)
$ns attach-agent $node_(96) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(4) and node_(78)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(48)
$ns attach-agent $node_(78) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(81) and node_(33)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(49)
$ns attach-agent $node_(33) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(26) and node_(33)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(50)
$ns attach-agent $node_(33) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(33) and node_(83)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(51)
$ns attach-agent $node_(83) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(99) and node_(10)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(52)
$ns attach-agent $node_(10) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(12) and node_(63)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(53)
$ns attach-agent $node_(63) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(29) and node_(95)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(54)
$ns attach-agent $node_(95) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(47) and node_(46)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(55)
$ns attach-agent $node_(46) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(67) and node_(62)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(56)
$ns attach-agent $node_(62) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(73) and node_(28)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(57)
$ns attach-agent $node_(28) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(1) and node_(11)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(58)
$ns attach-agent $node_(11) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(52) and node_(72)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(59)
$ns attach-agent $node_(72) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(64) and node_(24)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(60)
$ns attach-agent $node_(24) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(79) and node_(84)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(61)
$ns attach-agent $node_(84) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(63) and node_(14)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(62)
$ns attach-agent $node_(14) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(68) and node_(97)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(63)
$ns attach-agent $node_(97) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(25) and node_(85)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(64)
$ns attach-agent $node_(85) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(33) and node_(62)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(65)
$ns attach-agent $node_(62) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(91) and node_(42)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(66)
$ns attach-agent $node_(42) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(63) and node_(87)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(67)
$ns attach-agent $node_(87) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(60) and node_(2)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(68)
$ns attach-agent $node_(2) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(25) and node_(5)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(69)
$ns attach-agent $node_(5) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(39) and node_(71)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(70)
$ns attach-agent $node_(71) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(30) and node_(73)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(71)
$ns attach-agent $node_(73) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(56) and node_(51)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(72)
$ns attach-agent $node_(51) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(20) and node_(0)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(73)
$ns attach-agent $node_(0) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(5) and node_(75)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(74)
$ns attach-agent $node_(75) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(48) and node_(98)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(75)
$ns attach-agent $node_(98) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(83) and node_(59)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(76)
$ns attach-agent $node_(59) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(52) and node_(20)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(77)
$ns attach-agent $node_(20) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(55) and node_(87)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(78)
$ns attach-agent $node_(87) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(16) and node_(81)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(79)
$ns attach-agent $node_(81) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(93) and node_(28)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(80)
$ns attach-agent $node_(28) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(32) and node_(9)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(81)
$ns attach-agent $node_(9) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(36) and node_(32)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(82)
$ns attach-agent $node_(32) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(16) and node_(7)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(83)
$ns attach-agent $node_(7) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(79) and node_(84)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(84)
$ns attach-agent $node_(84) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(86) and node_(8)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(85)
$ns attach-agent $node_(8) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(13) and node_(39)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(86)
$ns attach-agent $node_(39) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(80) and node_(73)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(87)
$ns attach-agent $node_(73) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(23) and node_(51)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(88)
$ns attach-agent $node_(51) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(65) and node_(96)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(89)
$ns attach-agent $node_(96) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(32) and node_(62)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(90)
$ns attach-agent $node_(62) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(95) and node_(73)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(91)
$ns attach-agent $node_(73) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(61) and node_(94)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(92)
$ns attach-agent $node_(94) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(9) and node_(97)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(93)
$ns attach-agent $node_(97) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(90) and node_(70)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(94)
$ns attach-agent $node_(70) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(41) and node_(75)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(95)
$ns attach-agent $node_(75) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(44) and node_(8)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(96)
$ns attach-agent $node_(8) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(37) and node_(74)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(97)
$ns attach-agent $node_(74) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(47) and node_(67)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(98)
$ns attach-agent $node_(67) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(49) and node_(29)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(99)
$ns attach-agent $node_(29) $sink_(99)
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
