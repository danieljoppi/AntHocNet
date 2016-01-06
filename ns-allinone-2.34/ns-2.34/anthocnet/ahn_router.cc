/* Implementation file for Agent AntHocNet
 *
 *	@author Daniel Henrique Joppi 27/12/2008
 */

#include "anthocnet/ahn_router.h"
#include "address.h" // to fascilitate inlines
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <typeinfo>
#include <iostream>


int AntBasicPacket::offset_; // to access ant packet header
/*extern */double r; // reinforcement factor
/*extern */int N; // number of neighbors of a node
/*extern */int NUM_NODES; // total number of nodes in the topology

/**
 *  tcl binding for new packet: Ant
 *
 *	@author Daniel Henrique Joppi 18/03/2009
 */
static class AntHeaderClass:
		public PacketHeaderClass
{
	public:
		AntHeaderClass() :
			PacketHeaderClass("PacketHeader/AntHocNet", sizeof(AntBasicPacket))
		{
			bind_offset(&AntBasicPacket::offset_);
		}
} class_rtProtoAntHocNet_hdr;

/**
 *  tcl binding for new Agent: AntHocNet
 *
 *	@author Daniel Henrique Joppi 18/03/2009
 */
static class AntHocNetClass:
		public TclClass
{
	public:
		AntHocNetClass() :
			TclClass("Agent/AntHocNet")
		{
		}
		TclObject* create(int argc, const char* const * argv)
		{
			assert(argc == 5);
			return (new AntHocNet((nsaddr_t) Address::instance().str2addr(argv[4])));
		}
} class_rtProtoAntHocNet;

/**
 *  tcl binding for agent parameters
 *  default values defined in ns-default.tcl
 *
 *	@author Daniel Henrique Joppi 18/03/2009
 */
AntHocNet::AntHocNet(nsaddr_t id) :
	Agent(PT_ANT), ant_timer_(this), dmux_(0), hello_timer_(this), neighbor_timer_(this), proactive_timer_(this), router_cache_(this)
{

	bind("num_nodes_", &num_nodes_); // number of nodes in topology
	bind("num_nodes_x_", &num_nodes_x_); // number of nodes in row (for regular mesh topology)
	bind("num_nodes_y_", &num_nodes_y_); // number of nodes in column (for regular mesh topology)
	bind("r_factor_", &r_factor_); // reinforcement factor
	bind("timer_ant_", &timer_ant_); // timer for generation of forward ants

	ant_nest_ = new AntNest(id); // initialize ant nest
}

/**
 *  commands that the agent can handle
 *
 *	@author Daniel Henrique Joppi 18/03/2009
 */
int AntHocNet::command(int argc, const char* const * argv)
{
	if (argc == 2)
	{
		  Tcl& tcl = Tcl::instance();

		if(strncasecmp(argv[1], "id", 2) == 0) {
		  tcl.resultf("%d", addr());
		  return TCL_OK;
		}

		// begin AntHocNet algorithm
		if (strcasecmp(argv[1], "start") == 0)
		{
			initializeRouterTable(); // initialize routing tables
			ant_timer_.resched(0.); // schedule timer to begin ant generation now
		    proactive_timer_.handle((Event*) 0);
#ifndef ANT_LINK_LAYER_DETECTION
		    hello_timer_.handle((Event*) 0);
		    neighbor_timer_.handle((Event*) 0);
#endif // LINK LAYER DETECTION
		    router_cache_.handle((Event*) 0);
			return TCL_OK;
		}
		// stop AntHocNet algorithm
		else if (strcasecmp(argv[1], "stop") == 0)
		{
			ant_timer_.cancel(); // cancel any scheduled timers
			return TCL_OK;
		}
		// print routing tables to a file
		else if (strcasecmp(argv[1], "print_rtable") == 0)
		{
			FILE *fp = fopen(file_rtable, "a"); // file name defined in antnet_common.h
			//fprintf(fp, "Routing table at node %d\n", addr());
			fclose(fp);
			this->ant_nest_->pheromoneTable()->printPheromoneTable(); // call method to print routing table
			return TCL_OK;
		}
	}
	else if (argc == 3)
	{
		// obtain corresponding dmux to carry packets
		if (strcmp(argv[1], "port-dmux") == 0)
		{
			dmux_ = (PortClassifier*) TclObject::lookup(argv[2]);
			if (dmux_ == 0)
			{
				//fprintf(stderr, "%s: %s lookup of %s failed\n", __FILE__, argv[1], argv[2]);
				return TCL_ERROR;
			}
			return TCL_OK;
		}
		// obtain corresponding tracer
		else if (strcmp(argv[1], "log-target") == 0 || strcmp(argv[1], "tracetarget") == 0)
		{
			logtarget_ = (Trace*) TclObject::lookup(argv[2]);
			if (logtarget_ == 0)
				return TCL_ERROR;
			return TCL_OK;
		}
	}
	// add node1 to neighbor list of node2 and vice-versa (we assume duplex link)
	else if (argc == 4)
	{
		if (strcmp(argv[1], "add-neighbor") == 0)
		{
			Node *node1 = (Node*) TclObject::lookup(argv[2]);
			Node *node2 = (Node*) TclObject::lookup(argv[3]);
			addNeighbor(node1, node2);
			return TCL_OK;
		}
	}

	// Pass the command to the base class
	return Agent::command(argc, argv);
}

/**
 *  Agent receives ant packets
 *
 *	@author Daniel Henrique Joppi 18/03/2009
 */
void AntHocNet::recv(Packet *p, Handler *h)
{
	struct hdr_cmn *ch = HDR_CMN(p); // common header
	struct hdr_ip *ih = HDR_IP(p); // ip header

#ifdef DEBUG
	if (ch->ptype() == PT_ANT && HDR_AHN(p)->getAntType() != ANTTYPEHELLO)
	{
		debug("AntHocNet::recv", p);
		fprintf(stdout, "start >> AntHocNet:: ant type %d \n",ch->ptype());
		fprintf(stdout, "start >> AntHocNet:: source %d - dest %d >> this %d \n",ih->saddr(), ih->daddr(), addr());
	} else if (ch->ptype() != PT_ANT) {

		fprintf(stdout, "AntHocNet::recv (type %d): direct %d, source %d == this %d == dest %d >> *p %d\n", ch->ptype(), ch->direction(), ih->saddr(), addr(), ih->daddr(), p);
	}
#endif

	if ((int) ih->saddr() == addr())
	{
		// If loop, drop the packet
		if (ch->num_forwards() > 0)
		{
			drop(p, DROP_RTR_ROUTE_LOOP);
			return;
		}
		// else if reciever is the source
		else if (ch->num_forwards() == 0)
		{
			/*
			 * Add the IP Header.
			 * TCP adds the IP header too, so to avoid setting it twice, we check if
			 * this packet is not a TCP or ACK segment.
			 */
			if (ch->ptype() != PT_TCP && ch->ptype() != PT_ACK) {
				ch->size() += IP_HDR_LEN;
			}
			if ((u_int32_t) ih->daddr() != IP_BROADCAST) {
				ih->ttl_ = NETWORK_DIAMETER;
			}
		}
	}
	/*
	 *  Check the TTL.  If it is zero, then discard.
	 */
	else if (--ih->ttl_ == 0)
	{
		drop(p, DROP_RTR_TTL);
		return;
	}

	// recieved packet is an Ant packet
	if (ch->ptype() == PT_ANT)
	{
		// call method to handle ant packet
		recvAHN(p);
		ih->ttl_ -= 1;
	}
	// if not Ant packet, forward
	else
	{
		 if ( (u_int32_t)ih->daddr() != IP_BROADCAST)
		 {
			 search(p);
		 }
		 else
		 {
			 forward(p, NO_DELAY);
		 }
	}
}

/**
 *
 *	@author Daniel Henrique Joppi 18/03/2009
 */
void AntHocNet::recvAHN(Packet *p)
{
	AntBasicPacket *ah = HDR_AHN(p);// ant header
	//if (ah->getAntType() != ANTTYPEHELLO)
	//	//fprintf(stdout, "AntHocNet::recvAHN (%d) >> %d\n", addr(), ah->getAntType());

	assert(HDR_IP(p)->sport() == RT_PORT);
	assert(HDR_IP(p)->dport() == RT_PORT);

	AntHistory hist = ANT_HISTORY(ah->getSorceAddress(), ah->getSeqNum());
	AntHistoryList_it itAnt = this->ant_nest_->history.find(hist);
	if (itAnt == this->ant_nest_->history.end()) {
#ifdef DEBUG
		debug("add history", p);
#endif //DEBUG

		this->ant_nest_->history.insert(hist);
	} else {
#ifdef DEBUG
		debug("loop ant packet", p);
#endif //DEBUG

		drop(p);
		return;
	}

#ifdef ANT_LINK_LAYER_DETECTION
	nsaddr_t node = HDR_CMN(p)->prev_hop_;
	if (node > -1) {
		this->ant_nest_->addNeighbor(node);
		if (nb_timer_list.find(node) != nb_timer_list.end()) {
			nb_timer_list.erase(node);
		}
		nb_timer_list.insert(std::make_pair<nsaddr_t, double>(node, CURRENT_TIME));


		// initialize equal pheromone value to all neighbor links
		double phvalue = 1;
		// add routing table entry
		this->ant_nest_->updateRegularPheromone(node, node, phvalue);
	}
#endif

	/*
	 * Incoming Packets.
	 */
	switch (ah->getAntType())
	{
		case ANTTYPEHELLO:
			recvAntHello(p);
			break;
		case ANTTYPEREACTIVE:
			recvAntPacket(p, AntHocNetUtils::REACTIVE);
			break;
		case ANTTYPEPROACTIVE:
			recvAntPacket(p, AntHocNetUtils::PROACTIVE);
			break;
		case ANTTYPEREPAIR:
			recvAntPacket(p, AntHocNetUtils::REPAIR);
			break;

		default:
			fprintf(stderr, "Invalid AntHocNet type (%x)\n", ah->getAntType());
			exit(1);
	}
	//fprintf(stdout, "finish >> AntHocNet::recvAHN(Packet *p)\n");
}

/**
 * Method to receive reactive forward ant
 *
 * @author Daniel Henrique Joppi 05/09/2011
 */
void AntHocNet::recvREFA(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);
	AntForwardPacket *ah = HDR_AHN_REFA(p);
	//fprintf(stderr, "AntHocNet::recvREFA(Packet* p) (%d)\n", addr());
	if(ah->getDestinationAddres() == addr())
	{
#ifdef DEBUG
		debug("recvREFA -- congratulation", p);
#endif //DEBUG
		sendREBA(p);
		return;
	}

	/*
	 * Drop if:
	 *      - I'm the source
	 *      - I recently heard this request.
	 */

	if (ah->getSorceAddress() == addr()) {
#ifdef DEBUG
		fprintf(stderr, "%s: got my own REQUEST\n", __FUNCTION__);
#endif // DEBUG
		this->ant_nest_->killAntPacket(p);
		//fprintf(stderr, "morreu (%d) num = %d\n", addr(), ch->num_forwards());
		return;
	}

	// find node in pheromone table
	nsaddr_t next = ant_nest_->pheromoneTable()->lookup(ah->getDestinationAddres());
	if (next == -1) {
#ifdef DEBUG
		debug("recvREFA -- forward(broadcast)", p);
#endif //DEBUG
		forward(p, NO_DELAY);
	}
	else {
		ch->next_hop_ = next;
		ch->addr_type() = NS_AF_INET;
		ch->prev_hop_  = addr();
		forward(p, NO_DELAY);
#ifdef DEBUG
		debug("recvREFA -- forward(simple)", p);
#endif //DEBUG
	}
}

void AntHocNet::recvREBA(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);
	AntBackPacket *ah = HDR_AHN_REBA(p);

	if(ah->getDestinationAddres() == addr())
	{
#ifdef DEBUG
		debug("recvREBA -- congratulation", p);
#endif //DEBUG
		updateRouterTable(p);
		sendPacketsInQueue(p);

		this->ant_nest_->killAntPacket(p);
		return;
	}

	/*
	 * Drop if:
	 *      - I'm the source
	 *      - I recently heard this request.
	 */

	if (ah->getSorceAddress() == addr()) {
#ifdef DEBUG
		fprintf(stderr, "%s: got my own REQUEST\n", __FUNCTION__);
#endif // DEBUG
		this->ant_nest_->killAntPacket(p);
		return;
	}
	// retrieve last second entry in memory (last entry is this node)
	nsaddr_t next = ah->findNextHop(addr());

	ch->next_hop() = next; // next hop as determined from memory
	ih->daddr() = next; // destination address
#ifdef DEBUG
	debug("recvREBA -- forward(simple)", p);
#endif // DEBUG
	ch->prev_hop_ = addr();

	forward(p, NO_DELAY);
}

void AntHocNet::recvPRFA(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);
	AntForwardPacket *ah = HDR_AHN_PRFA(p);

	if(ah->getDestinationAddres() == addr())
	{
#ifdef DEBUG
		debug("recvPRFA -- congratulation", p);
#endif //DEBUG
		sendPRBA(p);
		return;
	}

	/*
	 * Drop if:
	 *      - I'm the source
	 *      - I recently heard this request.
	 */

	if (ah->getSorceAddress() == addr()) {
#ifdef DEBUG
		fprintf(stderr, "%s: got my own REQUEST\n", __FUNCTION__);
#endif // DEBUG
		this->ant_nest_->killAntPacket(p);
		return;
	}

	// find node in pheromone table
	if (ih->ttl_ >= 1) {
#ifdef DEBUG
		debug("recvREFA -- forward(broadcast)", p);
#endif //DEBUG
		forward(p, NO_DELAY);
	} else {
		if (ah->getDestinationAddres() == -1) {
			ah->setDestinationAddres(addr());
			sendPRBA(p);
		} else {
			nsaddr_t next = ant_nest_->pheromoneTable()->lookup(ah->getDestinationAddres());
			if (next == -1) {
				this->ant_nest_->killAntPacket(p);
				return;
			}

			ih->ttl_ ++;
			ch->next_hop_ = next;
			ch->addr_type() = NS_AF_INET;
			ch->prev_hop_  = addr();
			forward(p, NO_DELAY);
		}
#ifdef DEBUG
		debug("recvREFA -- forward(simple)", p);
#endif //DEBUG
	}

	debug("recvPRFA -- search", p);
	// find next hop
}

void AntHocNet::recvPRBA(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);
	AntBackPacket *ah = HDR_AHN_REBA(p);

	if(ah->getDestinationAddres() == addr())
	{
#ifdef DEBUG
		debug("recvPRBA -- congratulation", p);
#endif //DEBUG
		updateRouterTable(p);
#ifdef DEBUG
		//fprintf(stdout, "update pheromone table ... size %d\n", queue.size());
#endif //DEBUG

		this->ant_nest_->killAntPacket(p);
		return;
	}

	/*
	 * Drop if:
	 *      - I'm the source
	 *      - I recently heard this request.
	 */

	if (ah->getSorceAddress() == addr()) {
#ifdef DEBUG
		//fprintf(stderr, "%s: got my own REQUEST\n", __FUNCTION__);
#endif // DEBUG
		this->ant_nest_->killAntPacket(p);
		return;
	}
	// retrieve last second entry in memory (last entry is this node)
	nsaddr_t next = ah->findNextHop(addr());

	ch->next_hop() = next; // next hop as determined from memory
	ih->daddr() = next; // destination address
#ifdef DEBUG
	debug("recvPRBA -- forward(simple)", p);
#endif // DEBUG
	ch->prev_hop_ = addr();

	forward(p, NO_DELAY);
}

void AntHocNet::recvRRFA(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);
	AntForwardRepairPacket *ah = HDR_AHN_RRFA(p);

	double time = CURRENT_TIME - ah->getTimeStartAnt(); // trip time to this node
	if (time > ah->getLifeAnt()) {
		ant_nest_->killAntPacket(p);
		return;
	}

	//fprintf(stderr, "AntHocNet::recvREFA(Packet* p) (%d)\n", addr());
	if(ah->getDestinationAddres() == addr())
	{
#ifdef DEBUG
		debug("recvRRFA -- congratulation", p);
#endif //DEBUG
		sendRRBA(p);
		return;
	}

	/*
	 * Drop if:
	 *      - I'm the source
	 *      - I recently heard this request.
	 */

	if (ah->getSorceAddress() == addr()) {
#ifdef DEBUG
		fprintf(stderr, "%s: got my own REQUEST\n", __FUNCTION__);
#endif // DEBUG
		ant_nest_->killAntPacket(p);
		return;
	}

	// find node in pheromone table
	nsaddr_t next = ant_nest_->pheromoneTable()->lookup(ah->getDestinationAddres());
	if (next == -1) {
#ifdef DEBUG
		debug("recvRRFA -- forward(broadcast)", p);
#endif //DEBUG
		forward(p, NO_DELAY);
	} else {
		/*
#ifdef DEBUG
		debug("recvRRFA -- find possible path", p);
#endif //DEBUG
		sendRRBA(p);*/

		ch->next_hop_ = next;
		ch->addr_type() = NS_AF_INET;
		ch->prev_hop_  = addr();

		// xunxo
		ah->setLifeAnt(LIFE_ANT * 10);

		forward(p, NO_DELAY);
#ifdef DEBUG
		debug("recvRRFA -- forward(simple)", p);
#endif //DEBUG

	}
}

void AntHocNet::recvRRBA(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);
	AntBackRepairPacket *ah = HDR_AHN_RRBA(p);

	/*double time = CURRENT_TIME - ah->getTimeStartAnt(); // trip time to this node
	if (time > ah->getLifeAnt()) {
		ant_nest_->killAntPacket(p);
		return;
	}*/

	if(ah->getDestinationAddres() == addr())
	{
#ifdef DEBUG
		debug("recvRRBA -- congratulation", p);
#endif //DEBUG
		updateRouterTable(p);

		sendPacketsInQueue(p);
		this->ant_nest_->killAntPacket(p);
		return;
	}

	/*
	 * Drop if:
	 *      - I'm the source
	 *      - I recently heard this request.
	 */

	if (ah->getSorceAddress() == addr()) {
#ifdef DEBUG
		//fprintf(stderr, "%s: got my own REQUEST\n", __FUNCTION__);
#endif // DEBUG
		this->ant_nest_->killAntPacket(p);
		return;
	}
	// retrieve last second entry in memory (last entry is this node)
	nsaddr_t next = ah->findNextHop(addr());

	ch->next_hop() = next; // next hop as determined from memory
	ih->daddr() = next; // destination address
#ifdef DEBUG
	debug("recvRRBA -- forward(simple)", p);
#endif // DEBUG
	ch->prev_hop_ = addr();

	forward(p, NO_DELAY);
}

/**
 * Method to recieve Ant packet at the Agent
 * Calls appropriate methods to process forward and backward ants
 *
 * @author Daniel Henrique Joppi 02/01/2009
 */
void AntHocNet::recvAntPacket(Packet* p, int typeAnt)
{
	struct hdr_ip* ih = HDR_IP(p); // ip header
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	AntBasicPacket* ah = HDR_AHN(p);// ant header

	assert(ih->sport() == RT_PORT);
	assert(ih->dport() == RT_PORT);
	debug("AntHocNet::recvAntPacket", p);
#ifdef DEBUG
	printf("In recv_antnet_pkt() %d at node %d %d source %d dest %d\n",
			ch->direction(), addr(), ih->daddr(), ah->getSorceAddress(),
			ah->getDestinationAddres());
#endif //DEBUG
	// forward ant
	if (ah->getAntDirection() == ANT_UP)
	{
		// add this node to memory
		double time = CURRENT_TIME - ah->getTimeStartAnt(); // trip time to this node
		// add current node to memory
		AntTimeEntry* antSE = new AntTimeEntry(addr(), time);
		//printf(" AntStackEntry source %d >>> time %f\n", antSE->node(), antSE->time());
		ah->addToNodes(antSE);
		debug("add visited stack ants", p);
		// send forward ant to next hop node as determined by AntHocNet algorithm
		switch (ah->getAntType())
		{
			case ANTTYPEHELLO:
				recvAntHello(p);
				break;
			case ANTTYPEREACTIVE:
				recvREFA(p);
				break;
			case ANTTYPEPROACTIVE:
				recvPRFA(p);
				break;
			case ANTTYPEREPAIR:
				recvRRFA(p);
				break;
		}
	}
	// backward ant
	else
	{
		// update routing table
		updateRouterTable(p);
		// send backward ant to next hop node as determined by memory
		switch (ah->getAntType())
		{
			case ANTTYPEHELLO:
				recvAntHello(p);
				break;
			case ANTTYPEREACTIVE:
				recvREBA(p);
				break;
			case ANTTYPEPROACTIVE:
				recvPRBA(p);
				break;
			case ANTTYPEREPAIR:
				recvRRBA(p);
				break;
		};
	}
}

/**
 * Method to send forward ant packet to next hop node as determined by AntHocNet algorithm
 *
 * @author Daniel Henrique Joppi 02/01/2009
 */
void AntHocNet::sendAntPacket(Packet* p, int typeAnt)
{
	//fprintf(stdout, "start >> AntHocNet::sendAntPacket(Packet* p, int typeAnt)\n");
	struct hdr_ip* ih = HDR_IP(p); // ip header
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	AntBasicPacket* ah = HDR_AHN(p);// ant header

	// if back ant
	if (ah->getAntDirection() == ANT_DOWN)
	{
		if(AntHocNetUtils::PROACTIVE) {
			ih->daddr() = this->ant_nest_->pheromoneTable()->nextNeighborNode(ah->getDestinationAddres(), true);
		} else {
			// check REPAIR e REACTIVE são broadcast
			ih->daddr() = IP_BROADCAST; // set destination address in ip header
		}

		switch(typeAnt)
		{
			 // ant header
			case AntHocNetUtils::PROACTIVE:
				ah= HDR_AHN_PRBA(p);
				break;
			case AntHocNetUtils::REACTIVE:
				ah = HDR_AHN_REBA(p);
				break;
			case AntHocNetUtils::REPAIR:
				ah = HDR_AHN_RRBA(p);
				break;
		}

#ifdef DEBUG
		fprintf(
				stdout,
				"forwarding antnet packet from %d source %d dest %d next hop %d\n",
				addr(), ah->getSorceAddress(), ah->getDestinationAddres(),
				ih->daddr());
#endif	// DEBUG
	}
	// else foward ant
	else
	{
		switch(typeAnt)
		{
			 // ant header
			case AntHocNetUtils::PROACTIVE:
				ah = HDR_AHN_PRFA(p);
				break;
			case AntHocNetUtils::REACTIVE:
				ah = HDR_AHN_REFA(p);
				break;
			case AntHocNetUtils::REPAIR:
				ah = HDR_AHN_RRFA(p);
				break;
		}

#ifdef DEBUG
		fprintf(
				stdout,
				"forwarding backward antnet packet from %d source %d dest %d next hop %d\n",
				addr(), ah->getSorceAddress(), ah->getDestinationAddres(),
				ih->daddr());
#endif	// DEBUG
	}

	switch(typeAnt)
	{
		case AntHocNetUtils::PROACTIVE:
			ah->setAntType(ANTTYPEPROACTIVE);
			break;
		case AntHocNetUtils::REACTIVE:
			ah->setAntType(ANTTYPEREACTIVE);
			break;
		case AntHocNetUtils::REPAIR:
			ah->setAntType(ANTTYPEREPAIR);
			break;
	}

	// send packet to next hop node
	Scheduler::instance().schedule(target_, p, 0.);
}

void AntHocNet::sendREFA(nsaddr_t destination)
{
	Packet* p = this->ant_nest_->createAntForwardPacket(ANTTYPEREACTIVE, destination);
	struct hdr_ip* ih = HDR_IP(p); // ip header
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	AntForwardPacket* ah = HDR_AHN_REFA(p); // ant header

	ch->addr_type() = NS_AF_NONE; // used for broadcasting messages
	ih->daddr() = IP_BROADCAST; // set destination address in ip header
	ih->ttl_ = NETWORK_DIAMETER; // network-wide broadcast

#ifdef DEBUG
	fprintf(stdout, "sending REFA packet from %d to %d next hop %d\n",
			ah->getSorceAddress(), ah->getDestinationAddres(), ih->daddr());
#endif //DEBUG

	Scheduler::instance().schedule(target_, p, 0.);
}

void AntHocNet::sendREBA(Packet* p)
{
	Packet* pbk = this->ant_nest_->createAntBackPacket(p);
	struct hdr_ip* ih = HDR_IP(pbk); // ip header
	struct hdr_cmn* ch = HDR_CMN(pbk); // common header
	AntBackPacket* ah = HDR_AHN_REBA(pbk); // ant header

	ih->ttl_ = NETWORK_DIAMETER;

#ifdef DEBUG
	debug("creating REBA packet from source", pbk);
#endif //DEBUG
	// send backward ant packet
	Scheduler::instance().schedule(target_, pbk, 0.);
}

/**
 * Method to send a forward ant
 * Called when ant timer expires
 *
 * @author Daniel Henrique Joppi 02/01/2009
 */
void AntHocNet::sendPRFA()
{
#ifndef ANT_LINK_LAYER_DETECTION
	if (this->ant_nest_->sizeNeighbors() == 0) {
		return;
	}
#endif

	nsaddr_t dest = this->ant_nest_->randomDestination();// generate random destination
#ifndef ANT_LINK_LAYER_DETECTION
	if (dest == -1) {
		return;
	}
#endif
	this->sendPRFA(dest);
}

void AntHocNet::sendPRFA(nsaddr_t destination) {
#ifndef ANT_LINK_LAYER_DETECTION
	// generate next hop as per AntHocNet algorithm
	nsaddr_t next = this->ant_nest_->pheromoneTable()->nextNeighborNode(next, true);
#endif

	Packet* p = this->ant_nest_->createAntForwardPacket(ANTTYPEPROACTIVE, destination);
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	struct hdr_ip* ih = HDR_IP(p); // ip header

#ifdef ANT_LINK_LAYER_DETECTION
	ch->addr_type() = NS_AF_NONE; // used for broadcasting messages
	ih->daddr() = IP_BROADCAST; // set destination address in ip header
	ih->ttl_ = 3; // network-wide broadcast
#else
	ch->next_hop() = next; // set next hop address in common header
	ch->addr_type() = NS_AF_INET; // used for routing protocols implemented as Internet protocol
	ih->ttl_ = NETWORK_DIAMETER;
#endif

	ih->daddr() = destination; // set destination address in ip header
#ifdef DEBUG
	debug("sendPRFA", p);
#endif //DEBUG

	Scheduler::instance().schedule(target_, p, 0.);
}

void AntHocNet::sendPRBA(Packet* p)
{
	Packet* pbk = this->ant_nest_->createAntBackPacket(p);
	struct hdr_ip* ih = HDR_IP(p); // ip header
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	AntBackPacket* ah = HDR_AHN_PRBA(p); // ant header

	ih->ttl_ = NETWORK_DIAMETER;

#ifdef DEBUG
	debug("creating PRBA packet from source", pbk);
#endif //DEBUG
	// send backward ant packet
	Scheduler::instance().schedule(target_, pbk, 0.);
}

void AntHocNet::sendRRFA(nsaddr_t destination)
{
	Packet* p = this->ant_nest_->createAntForwardPacket(ANTTYPEREPAIR, destination);
	struct hdr_ip* ih = HDR_IP(p); // ip header
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	AntForwardRepairPacket* ah = HDR_AHN_RRFA(p); // ant header

	ch->addr_type() = NS_AF_NONE; // used for broadcasting messages
	ih->daddr() = IP_BROADCAST; // set destination address in ip header
	ih->ttl_ = 10; // network-wide broadcast

	ah->setLifeAnt(LIFE_ANT);

#ifdef DEBUG
	fprintf(stdout, "sending RRFA packet from %d to %d next hop %d\n",
			ah->getSorceAddress(), ah->getDestinationAddres(), ih->daddr());
#endif //DEBUG

	Scheduler::instance().schedule(target_, p, 0.);
}

void AntHocNet::sendRRBA(Packet* p)
{
	Packet* pbk = this->ant_nest_->createAntBackPacket(p);
	struct hdr_ip* ih = HDR_IP(pbk); // ip header
	struct hdr_cmn* ch = HDR_CMN(pbk); // common header
	AntBackRepairPacket* ah = HDR_AHN_RRBA(pbk); // ant header

	ih->ttl_ = NETWORK_DIAMETER;

	ah->setLifeAnt(LIFE_ANT);

#ifdef DEBUG
	debug("creating RRBA packet from source", pbk);
#endif //DEBUG
	// send backward ant packet
	Scheduler::instance().schedule(target_, pbk, 0.);
}

/**
 * Link Failure Management Functions
 *
 * @author Daniel Henrique Joppi 18/10/2011
 */

void ant_rt_failed_callback(Packet *p, void *arg) {
	((AntHocNet*) arg)->link_failed(p);
}

void AntHocNet::sendPacketsInQueue(Packet *p)
{
	AntBackPacket* ah = (AntBackPacket*) AntBackPacket::access(p); // ant header
	AntPQueue queue = GET_PACKETS(ah->getSorceAddress(), ant_nest_->mapQueue);
#ifdef DEBUG
	//fprintf(stdout, "update pheromone table ... size %d\n", queue.size());
#endif //DEBUG
	for(AntPQueue_it it = queue.begin(); it != queue.end(); it++) {
		Packet* pq = *it;
		struct hdr_cmn *ch = HDR_CMN(pq); // common header
		struct hdr_ip *ih = HDR_IP(pq); // ip header

		if (ch->ptype() == PT_ANT && HDR_AHN(pq)->getAntDirection() == ANT_DOWN) {
			AntBackPacket* ahbk = (AntBackPacket*) AntBackPacket::access(pq); // ant header
			// clean old visited list
			AntTimeEntry** ppbk = ahbk->getVisitedNodes();
			for (int i=0; i < ahbk->sizeNodes(); i++) {
				AntTimeEntry* entry = ppbk[i];
				delete entry;
			}

			nsaddr_t last = 0;
			// replace new path
			int size = ah->sizeNodesHist();
			AntTimeEntry** pp = ah->getVisitedNodesHist();
			for (int i=0; i < size; i++) {
				AntTimeEntry* entry = pp[i];
				ppbk[i] = new AntTimeEntry(entry->node(), entry->time());
				last = entry->node();
			}

			ahbk->sizeNodes(size);
			AntNeighbors neighbors = this->ant_nest_->pheromoneTable()->getNeighbors();
			if (addr() != last && neighbors.find(last) != neighbors.end()) {
				double time = CURRENT_TIME - ah->getTimeStartAnt(); // trip time to this node
				// add current node to memory
				AntTimeEntry* antSE = new AntTimeEntry(addr(), time);
				ahbk->addToNodes(antSE);
				//fprintf(stdout, "%d (%d : %d) == %d (%d) - %d\n", addr(), ah->getSorceAddress(), ah->getSeqNum(), last, ahbk->getDestinationAddres(), ahbk->sizeNodes());
			} else if (addr() != last) {
				fprintf(stdout, "aiii - %d (%d : %d) == %d (%d) - %d\n", addr(), ah->getSorceAddress(), ah->getSeqNum(), last, ahbk->getDestinationAddres(), size);
			}

			updateRouterTable(pq);
			// retrieve last second entry in memory (last entry is this node)
			nsaddr_t next = ahbk->findNextHop(addr());
			//nsaddr_t next = HDR_CMN(p)->prev_hop_;

			ch->next_hop() = next; // next hop as determined from memory
			ih->daddr() = next; // destination address
			ch->prev_hop_ = addr();

			forward(pq, NO_DELAY);
		} else {

#ifdef DEBUG
		//fprintf(stdout, "send packet(type %d) -- source (%d) >> dest (%d)\n", HDR_CMN(pq)->ptype(), addr(), HDR_IP(pq)->daddr());
#endif //DEBUG
			ih->ttl_ = NETWORK_DIAMETER;
			search(pq);
		}
	}

	REMOVE_PACKETS(ah->getSorceAddress(), ant_nest_->mapQueue);
}

/**
 * Method to remove neighbor missing
 *
 * @author Daniel Henrique Joppi 18/10/2011
 */
void AntHocNet::link_failed(Packet *p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);

	nsaddr_t broken_nbr = ch->next_hop_;

	this->nb_timer_list.erase(broken_nbr);

	if (ch->ptype() != PT_ANT) {
		nsaddr_t dest = (ch->ptype() == PT_ANT) ? HDR_AHN(p)->getDestinationAddres() : ih->daddr() ;
		ant_nest_->addPacketInQueue(p);

		sendRRFA(dest);
	} else {
		this->ant_nest_->killAntPacket(p);
	}

	this->ant_nest_->cleanNeighborPheromone(broken_nbr);
}

/**
 *  Method to search node destination and send packets
 *
 *  @author Daniel Henrique Joppi 05/09/2011
 */
void AntHocNet::search(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);

	nsaddr_t dest = (ch->ptype() == PT_ANT) ? HDR_AHN(p)->getDestinationAddres() : ih->daddr() ;
	nsaddr_t next = ant_nest_->pheromoneTable()->lookup(dest);

	if (next == -1) {
		if (ch->ptype() == PT_ANT) {
			AntBasicPacket* ah = HDR_AHN(p);

			bool antType = ah->getAntType() == ANTTYPEREACTIVE || ah->getAntType() == ANTTYPEREPAIR;
			if (antType && ah->getAntDirection() == ANT_UP) {

				ch->addr_type() = NS_AF_NONE; // used for broadcasting messages
				ih->daddr() = IP_BROADCAST; // set destination address in ip header

				forward(p, NO_DELAY);
			} else {
				ant_nest_->addPacketInQueue(p);
				sendRRFA(dest);
			}
		} else {
			ant_nest_->addPacketInQueue(p);
			sendREFA(dest);
		}
	} else {
		ch->next_hop() = next;
		ch->addr_type() = NS_AF_INET;
		ch->prev_hop_  = addr();

		forward(p, NO_DELAY);
	}
}

/**
 *  Method to forward packets
 *
 *  @author Daniel Henrique Joppi 05/09/2011
 */
void AntHocNet::forward(Packet* p, double delay)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);

	if (ih->ttl_ == 0) {
#ifdef DEBUG
		fprintf(stderr, "%s: calling drop()\n", __PRETTY_FUNCTION__);
#endif // DEBUG
		drop(p, DROP_RTR_TTL);
		return;
	}

	if (((ch->ptype() != PT_ANT) && (ch->direction() == hdr_cmn::UP)
			&& ((u_int32_t) ih->daddr() == IP_BROADCAST)) || (ih->daddr() == addr())) {
		dmux_->recv(p, 0);
		//fprintf(stdout, "dmux_->recv(p, 0); \n");
		return;
	}

	/*
	 *  Set the transmit failure callback.  That
	 *  won't change.
	 */
	ch->xmit_failure_ = ant_rt_failed_callback;
	ch->xmit_failure_data_ = (void*) this;

	ch->prev_hop_  = addr();
	ch->direction() = hdr_cmn::DOWN;

	if (ih->daddr() == (nsaddr_t) IP_BROADCAST) {
		// If it is a broadcast packet
		if (ch->ptype() == PT_ANT) {
			/*
			 *  Jitter the sending of AntHocNet broadcast packets by 10ms
			 */
			Scheduler::instance().schedule(target_, p, 0.01 * Random::uniform());
		} else {
			Scheduler::instance().schedule(target_, p, 0.); // No jitter
		}
	} else { // Not a broadcast packet
		if (delay > 0.0) {
			Scheduler::instance().schedule(target_, p, delay);
		} else {
			// Not a broadcast packet, no delay, send immediately
			Scheduler::instance().schedule(target_, p, 0.);
		}
	}
}

/**
 *  Method to update routing table
 *
 *  @author Daniel Henrique Joppi 17/03/2009
 */
void AntHocNet::updateRouterTable(Packet* p)
{
	AntBackPacket* ah = (AntBackPacket*) AntBackPacket::access(p); // ant header

	// read node visited next to this node from memory
	// this is the neighbor node for which routing table will be updated
	nsaddr_t neigh = ah->findPrevHop();//HDR_CMN(p)->prev_hop_;

	// read destination nodef rom memory
	nsaddr_t dest = ah->getSorceAddress();

#ifdef DEBUG
	//fprintf(stdout, "updating ph at %d\n", addr());
	//fprintf(stdout, "next: %d\n", next);
#endif //DEBUG

	N = this->ant_nest_->sizeNeighbors();

	// routing table is updated for all the destination nodes that are visited after the neighbor node
	// update pheromone value corresponding to neighbor node and destination nodes visited thereafter
	// update pheromone valu fro neighbor node and this destination node
	//fprintf(stdout, "updateRegularPheromone -> source %d >> dest %d -- neigh (%d) == pheromone (%f)\n", addr(), dest, neigh, ah->getPheromone());
	this->ant_nest_->updateRegularPheromone(dest, neigh, ah->getPheromone());
}

/**
 * Method to initialize routing table
 *
 * @author Daniel Henrique Joppi 17/03/2009
 */
void AntHocNet::initializeRouterTable()
{
	//fprintf(stdout, "start >> AntHocNet::initializeRouterTable\n");
	//NUM_NODES = num_nodes_x_ * num_nodes_y_;
	NUM_NODES = num_nodes_; // set number of nodes in topology (read from tcl script)
	r = r_factor_; // set reinforcement factor (read from tcl script)

	// add destination entry for each node in topology
	Node *nd = nd->get_node_by_address(addr());
	//fprintf(stdout, "mind >> AntHocNet::initializeRouterTable ->>> nd->get_node_by_address(addr()) \n");

	int num_nb = this->ant_nest_->sizeNeighbors();
	//fprintf(stdout, "mind >> AntHocNet::initializeRouterTable ->>> phTable->getNumNeighbors() \n");

	for (int i = 0; i < NUM_NODES; i++)
	{
		if (addr() != i)
		{
			//fprintf(stdout, "mind >> AntHocNet::initializeRouterTable ->>> for %d: ",i);
			// read list of neighbors
			neighbor_list_node* nb = nd->neighbor_list_;
			while (nb != NULL)
			{
				this->ant_nest_->addNeighbor(i);
				// read node id of neighbor node
				int neighb = nb->nodeid;
				//fprintf(stdout, "(%d) ",neighb);
				// initialize equal pheromone value to all neighbor links
				double phvalue = 1.0 / num_nb;
				// add routing table entry
				PheromoneTable* phTable = this->ant_nest_->pheromoneTable();
				phTable->addPheromoneRegular(neighb, neighb, phvalue);
				phTable->addPheromoneVirtual(neighb, neighb, phvalue);
				// iterate in neighbor list
				nb = nb->next;
			}
		}
	}
	FILE *fp = fopen(file_rtable, "w");
	fclose(fp);
	//fprintf(stdout, "finish >> AntHocNet::initializeRouterTable\n");
}

/**
 *  Method to print neighbors of a node
 *
 *  @author Daniel Henrique Joppi 17/03/2009
 */
void AntHocNet::printNeighbors()
{
	nsaddr_t node_addr = addr();
	//fprintf(stdout, "addr: %d\taddr:%d\n", addr(), addr());
	Node *n = n->get_node_by_address(node_addr);
	//fprintf(stdout, "node id: %d\tnode address: %d\n", n->nodeid(), n->address());
	//fprintf(stdout, "Neighbors:\n");
	neighbor_list_node* nb = n->neighbor_list_;
	do
	{
		int neigh = nb->nodeid;
		//printf("%d\n", neigh);
		nb = nb->next;
	} while (nb != NULL);
}

/*
 *  Method to add neighbors of a node
 *  Parameters: addresses of two neighbor nodes (n1, n2)
 *  We assume duplex links
 *  - Add n1 to neighbor list of n2
 *  - Add n2 to neighbor list of n1
 *
 *  @author Daniel Henrique Joppi 17/03/2009
 */
void AntHocNet::addNeighbor(Node *n1, Node *n2)
{
	n1->addNeighbor(n2);
	n2->addNeighbor(n1);

	if (n1->address() != addr())
		this->ant_nest_->addNeighbor(n1);

	if (n2->address() != addr())
		this->ant_nest_->addNeighbor(n2);
}

void AntHocNet::sendAntHello()
{
	Packet* p = this->ant_nest_->createAntHelloPacket();

#ifdef DEBUG
	debug("sendAntHello",p);
#endif //DEBUG

	// send forward ant packet
	Scheduler::instance().schedule(target_, p, 0.);
}

void AntHocNet::recvAntHello(Packet *p)
{
	//struct hdr_ip *ih = HDR_IP(p);
	AntHelloPacket* ah = HDR_AHN_HELLO(p);// ant header

#ifdef DEBUG
	debug("recvAntHello",p);
#endif //DEBUG

	nsaddr_t node = ah->getSorceAddress();
	this->ant_nest_->addNeighbor(node);
	if (nb_timer_list.find(node) != nb_timer_list.end()) {
		nb_timer_list.erase(node);
	}
	nb_timer_list.insert(std::make_pair<nsaddr_t, double>(node, CURRENT_TIME));


	// initialize equal pheromone value to all neighbor links
	double phvalue = 1;
	// add routing table entry
	this->ant_nest_->updateRegularPheromone(ah->getSorceAddress(), ah->getSorceAddress(), phvalue);
	this->ant_nest_->updateVirtualPheromone(ah);

	this->ant_nest_->killAntPacket(p);
}

/**
 *  Method to reset Ant timer
 *
 *  @author Daniel Henrique Joppi 17/03/2009
 */
void AntHocNet::resetAntTimer()
{
	ant_timer_.resched(timer_ant_);
}

void AntHocNet::debug(const char * str, Packet *p) {
	/*fprintf(stdout, "%s (ant type %d) - seqnum: %d:%d >> addr (%d) >> recv (%d) >> neig (%d) >> dest (%d) >< visited size %d -- *p %d \n", str, HDR_AHN(p)->getAntType(), HDR_AHN(p)->getSorceAddress(), HDR_AHN(p)->getSeqNum(),
			addr(), HDR_CMN(p)->prev_hop_, HDR_CMN(p)->next_hop(), HDR_AHN(p)->getDestinationAddres(), HDR_AHN(p)->sizeNodes(), p);*/
}

void AntHocNet::purgeMissNeighbor()
{
	if (nb_timer_list.size() <= 0) {
		return;
	}

	double timeNow = CURRENT_TIME;

	AntNeighbors neigborsRemove;

	AntNeighbors neigbors = ant_nest_->pheromoneTable()->getNeighbors();
	for (AntNeighbors_it it = neigbors.begin() ; it != neigbors.end(); it++) {
		if (nb_timer_list.find(*it) == nb_timer_list.end()) {
			continue;
		}
		double time = nb_timer_list.find(*it)->second;

		if ((timeNow - MaxHelloInterval) > time) {
			nsaddr_t node = nb_timer_list.find(*it)->first;
			neigborsRemove.insert(node);
		}
	}

	for (AntNeighbors_it it = neigborsRemove.begin() ; it != neigborsRemove.end(); it++) {
		nsaddr_t node = *it;
		//ant_nest_->pheromoneTable()->removeNeighbor(node);
		nb_timer_list.erase(node);
	}
}

void AntHocNet::purgeQueue()
{
	AntDestinations destRem;

	for (MapAntPQueue_it it = ant_nest_->mapQueue.begin(); it != ant_nest_->mapQueue.end(); it++) {
		nsaddr_t destination = (*it).first;
		AntDestinations dests_regular = this->ant_nest_->pheromoneTable()->getRegularDestinations();
		if (dests_regular.find(destination) == dests_regular.end()) {
			sendPRFA(destination);
			sendRRFA(destination);
		} else {
			AntPQueue queueRem;
			AntPQueue queue = (*it).second;
			for(AntPQueue_it itp = queue.begin(); itp != queue.end(); itp++) {
				Packet* pq = *itp;
				struct hdr_cmn *ch = HDR_CMN(pq); // common header
				struct hdr_ip *ih = HDR_IP(pq); // ip header

				//if ant - remove
				if (ch->ptype() != PT_ANT) {
					ih->ttl_ = NETWORK_DIAMETER;
					search(pq);
				}
				queueRem.insert(pq);
			}

			for(AntPQueue_it itp = queueRem.begin(); itp != queueRem.end(); itp++) {
				queue.erase(*itp);
			}
			if (queue.empty()) {
				destRem.insert(destination);
			}
		}
	}

	if (!destRem.empty()) {
		for (AntDestinations_it it = destRem.begin(); it != destRem.end(); it++) {
			nsaddr_t destination = *it;

			REMOVE_PACKETS(destination, ant_nest_->mapQueue);
		}
	}
}

/**
 *  Method to handle Ant timer expire event
 *
 *  @author Daniel Henrique Joppi 17/03/2009
 */
void AntTimer::expire(Event *e)
{
	// reschedule timer
	agent_->resetAntTimer();
}

/**
 *  Method to handle Ant hello timer to send
 *
 *  @author Daniel Henrique Joppi 04/09/2011
 */
void AntHelloTimer::handle(Event*) {
   agent->sendAntHello();
   double interval = MinHelloInterval + ((MaxHelloInterval - MinHelloInterval) * Random::uniform());
   assert(interval >= 0);
   Scheduler::instance().schedule(this, &intr, interval);
}



void AntNeighborTimer::handle(Event*) {
  agent->purgeMissNeighbor();

  double interval = 20 * HELLO_INTERVAL;
  assert(interval >= 0);
  Scheduler::instance().schedule(this, &intr, interval);
}

/**
 *  Method to handle Ant hello timer to send
 *
 *  @author Daniel Henrique Joppi 04/09/2011
 */
void AntProactiveTimer::handle(Event*) {
   agent->sendPRFA();
   double interval = MinProactiveInterval + ((MaxProactiveInterval - MinProactiveInterval) * Random::uniform());
   assert(interval >= 0);
   Scheduler::instance().schedule(this, &intr, interval);
}

void AntRouteCacheTimer::handle(Event*) {
   agent->purgeQueue();
   double interval = 0.5;//MinProactiveInterval + ((MaxProactiveInterval - MinProactiveInterval) * Random::uniform());
   assert(interval >= 0);
   Scheduler::instance().schedule(this, &intr, interval);
}
