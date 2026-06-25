# SKRYPT SYMULACYJNY - PROTOKOL AntHocNet Andrzej Podrucki

set val(chan)           Channel/WirelessChannel    ;#Channel Type		/Typ kanalu
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             2                          ;# number of mobilenodes
set val(rp)             AntHocNet                  ;# routing protocol
set val(x)		1000
set val(y)		1000


# Initialize Global Variables	/Inicjowanie zmiennych globalnych
set ns_		[new Simulator]
set tracefd     [open low-ant.tr w]
$ns_ trace-all $tracefd

set namtrace [open low-ant-wrls.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object	/Utworzenie obiektu topograficznego
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

# Create God			/Tworzenie GOD
create-god $val(nn)

# New API to config node: 					/Nowe API do konfiguracji węzła:
# 1. Create channel (or multiple-channels);			/1. Tworzenie kanału (lub kilku kanałów);
# 2. Specify channel in node-config (instead of channelType);	/2. Określ kanału w node-config (zamiast channelType);
# 3. Create nodes for simulations.				/3. Tworzenie węzłów dla symulacji.

# Create channel #1 and #2	/Tworzenie kanału 1 i 2
set chan_1_ [new $val(chan)]
set chan_2_ [new $val(chan)]


# Create node(0) "attached" to channel #1	/Tworzenie wezla node(0) "dolaczonego" do kanalu 1

# configure node, please note the change below.	/Konfiguracji węzła, należy zwrócić uwagę na zmiany poniżej
$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace OFF \
		-channel $chan_1_ 

# Ustawienie wartosci dla AntHocNet
#Agent/AntHocNet set num_nodes_ 2		# number of nodes in topology				//liczba węzłów w topologii
#Agent/AntHocNet set num_nodes_x_ 2		# number of nodes in row (for regular mesh topology)	//liczba węzłów w rzędzie (dla stałych topologii mesh)
#Agent/AntHocNet set num_nodes_y_ 2		# number of nodes in column (for regular mesh topology)	//liczba węzłów w kolumnie (regularne topologii mesh)
#Agent/AntHocNet set r_factor_ 1		# reinforcement factor					//czynnik wzmocnienia
#Agent/AntHocNet set timer_ant_ 1		# timer for generation of forward ants			//timer do generowania mrówki do przodu

# node_(1) can also be created with the same configuration, or with a different	/ node_(1) moze byc takze tworzony z taka sama konfiguracja, lub z innym
# channel specified.								/ specyfikacja kanalu
# Uncomment below two lines will create node_(1) with a different channel.	/ Odkomentuj poniżej dwie linie stworza node_(1) z innegym kanałem.
#  $ns_ node-config \								
#		 -channel $chan_2_ 						


set node_(0) [$ns_ node]
set node_(1) [$ns_ node]

$node_(0) random-motion 0
$node_(1) random-motion 0

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 20
}

#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes		/Poczatkowe (X, Y, teraz Z = 0) wspolrzedne dla mobilnych węzlow
#
$node_(0) set X_ 5.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 8.0
$node_(1) set Y_ 5.0
$node_(1) set Z_ 0.0

#
# Now produce some simple node movements		/Teraz wytwarzymy kilka prostych przemieszczeń węzla
# Node_(1) starts to move towards node_(0)		/Node_(1) zacznie się poruszać w kierunku node_(0)
#
$ns_ at 3.0 "$node_(1) setdest 50.0 40.0 25.0"
$ns_ at 3.0 "$node_(0) setdest 48.0 38.0 5.0"

# Node_(1) then starts to move away from node_(0)	/Node_(1) następnie zaczynie się oddalac od node_(0)
$ns_ at 20.0 "$node_(1) setdest 490.0 480.0 30.0" 

# Setup traffic flow between nodes			/Ustawienia ruchu między węzłami
# TCP connections between node_(0) and node_(1)		/Polaczenie TCP pomiedzy wezlami node_(0) i node_(1)

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 3.0 "$ftp start" 

#
# Tell nodes when the simulation ends			/Powiedz węzłom gdy symulacja sie kończy
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 30.0 "$node_($i) reset";
}
$ns_ at 30.0 "stop"
$ns_ at 30.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

puts "Starting Simulation..."
$ns_ run
