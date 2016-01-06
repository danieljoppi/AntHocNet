/**
 * @author Daniel Henrique Joppi 25/12/2008
 */

#include "anthocnet/ahn_ant_nest.h"
#include <algorithm>

/*
 * Method to update routing table. This method increments and evaporates
 * pheromone values as per AntHocNet algorithm.
 *
 * @author Daniel Henrique Joppi 17/02/2009
 * @param dest destination node address
 * @param next neighbor node address
 */
PheromoneTable* AntNest::updateRegularPheromone(nsaddr_t destination, nsaddr_t neighbor, double phUpdate)
{
	AntDestinations destsRem;

	AntNeighbors neighbor_table = pheromoneTable()->getNeighbors();

	//fprintf(stdout, "AntNest::updateRegularPheromone -> (neighbors size %d) \n", neighbor_table.size());

	for (AntNeighbors::iterator it = neighbor_table.begin(); it != neighbor_table.end(); it++) {
		double phValue = pheromoneTable()->getPheromoneRegular(destination, *it);

		//fprintf(stdout, "AntNest::updateRegularPheromone (source %d) -> dest %d -- next (%d) == this neighbor (%d) >>pheromone (%f) + update pheromone (%f)\n", addr_, destination, neighbor, *iterNeigh, phValue, phUpdate);

		if (*it == neighbor) {
			double pIncress = this->incressPheromone(phValue, phUpdate);
			pheromoneTable()->setPheromoneRegular(destination, neighbor, pIncress); // increase ph value for link travelled by ant
			//double v  = pheromoneTable()->getNeighborRegular(destination, neighbor);
			//fprintf(stdout, "updateRegularPheromone destination(%d), neighbor(%d))  = (%f) \n", destination, neighbor, v);
		} else if (phValue > 0) {
			if (phValue < AntHocNetUtils::MIN_PHEROMONE) {
				pheromoneTable()->removePheromoneRegular(destination, neighbor); // low pheromone .. remove link

				if (!hasRegularDestination(destination)) {
					destsRem.insert(destination);
				}
			} else {
				double pEvap = this->evaporatePheromone(phValue);
				pheromoneTable()->setPheromoneRegular(destination, neighbor, pEvap); // evaporate pheromone for other links
			}
		}
	}

	if (!destsRem.empty()) {
		// remove missing destinations
		AntDestinations_it itRem;
		AntNeighbors::iterator itNeigh;
		//fprintf(stdout, "AntNest::updateRegularPheromone (source %d) remove destination -> dest %d \n", addr_, destination);

		// remove all previous routes
		for (AntNeighbors::iterator itNeigh = neighbor_table.begin(); itNeigh != neighbor_table.end(); itNeigh++) {
			pheromoneTable()->removePheromoneRegular(destination, *itNeigh);
		}
		// if a destination is a neighbor
		if (neighbor_table.find(destination) != neighbor_table.end()) {
			//fprintf(stdout, "AntNest::updateRegularPheromone (source %d) remove neighbor-> dest %d \n", addr_, destination);
			pheromoneTable()->removeNeighbor(destination);
		}
	}

	return pheromoneTable();
}

/*
 * Method to update routing table. This method increments and evaporates
 * pheromone values as per AntHocNet algorithm.
 *
 * @author Daniel Henrique Joppi 04/10/2011
 * @param ant hello packet
 */
PheromoneTable* AntNest::updateVirtualPheromone(AntHelloPacket* ah)
{
	AntDestinations destsRem;

	// evaporate virtual pheromone
	AntDestinations dest_table = pheromoneTable()->getVirtualDestinations();
	for (AntDestinations_it itDest = dest_table.begin(); itDest != dest_table.end(); itDest++) {
		nsaddr_t destination = *itDest;

		AntNeighbors neighbor_table = pheromoneTable()->getNeighbors();

		for (AntNeighbors::iterator itNeigh = neighbor_table.begin(); itNeigh != neighbor_table.end(); itNeigh++) {
			nsaddr_t neighbor = *itNeigh;
			double phValue = pheromoneTable()->getPheromoneVirtual(destination, neighbor);

			if (phValue < AntHocNetUtils::MIN_PHEROMONE) {
				//fprintf(stdout, "AntNest::updateVirtualPheromone(source %d) remove -> dest %d -- neighbor %d\n", addr_, destination, neighbor);
				pheromoneTable()->removePheromoneVirtual(destination, neighbor); // low pheromone .. remove link

				if (!hasVirtualDestination(destination)) {
					destsRem.insert(destination);
				}
			} else {
				double pEvap = this->evaporatePheromone(phValue);
				//fprintf(stdout, "AntNest::updateVirtualPheromone(source %d) evaporate-> dest %d -- neighbor %d >> pheromone %f < evaporate %f\n", addr_, destination, neighbor, phValue, pEvap);
				pheromoneTable()->setPheromoneVirtual(destination, neighbor, pEvap); // evaporate pheromone for other links
			}
		}
	}

	if (!destsRem.empty()) {

		// remove missing virtual destinations
		AntDestinations_it itRem;
		for (itRem = destsRem.begin(); itRem != destsRem.end(); itRem++) {
			nsaddr_t destination = *itRem;

			AntNeighbors neighbor_table = pheromoneTable()->getNeighbors();
			AntNeighbors::iterator itNeigh;
			// remove all previous routes
			for (AntNeighbors::iterator itNeigh = neighbor_table.begin(); itNeigh != neighbor_table.end(); itNeigh++) {
				nsaddr_t neighbor = *itNeigh;
				pheromoneTable()->removePheromoneVirtual(destination, neighbor);
			}
		}
	}

	// update virtual pheromone
	nsaddr_t neighbor = ah->getSorceAddress();
	AntNode** dests = ah->getDestinations();
	int size = ah->sizeDests();

	//fprintf(stdout, "AntNest::updateVirtualPheromone(source %d) -> number of virtual destinations %d \n", addr_, size);

	for (int i=0; i< size; i++) {
		AntNode* node = dests[i];
		nsaddr_t destination = node->node();
		double phValue = pheromoneTable()->getPheromoneVirtual(destination, neighbor);
		double phUpdate = node->phValue();
		double pIncress = this->incressPheromone(phValue, phUpdate);
		//fprintf(stdout, "AntNest::updateVirtualPheromone(source %d) -> dest %d -- neighbor (%d) >> pheromone %f + update pheromone %f = incress %f\n", addr_, destination, neighbor, phValue, phUpdate, pIncress);
		pheromoneTable()->setPheromoneVirtual(destination, neighbor, pIncress); // increase ph value for link travelled by ant
	}

	return pheromoneTable();
}

bool AntNest::hasRegularDestination(nsaddr_t destination)
{
	AntNeighbors neighbor_table = pheromoneTable()->getNeighbors();

	for (AntNeighbors::iterator it = neighbor_table.begin(); it != neighbor_table.end(); it++) {
		nsaddr_t neighbor = *it;
		double phValue = pheromoneTable()->getPheromoneRegular(destination, neighbor);

		if (phValue > AntHocNetUtils::MIN_PHEROMONE) {
			return true;
		}
	}
	return false;
}

bool AntNest::hasVirtualDestination(nsaddr_t destination)
{
	AntNeighbors neighbor_table = pheromoneTable()->getNeighbors();

	for (AntNeighbors::iterator it = neighbor_table.begin(); it != neighbor_table.end(); it++) {
		nsaddr_t neighbor = *it;
		double phValue = pheromoneTable()->getPheromoneVirtual(destination, neighbor);

		if (phValue > AntHocNetUtils::MIN_PHEROMONE) {
			return true;
		}
	}
	return false;
}

/*
 * @author Daniel Henrique Joppi 01/09/2011
 */
PheromoneTable* AntNest::pheromoneTable() const
{
	return this->pheromone_rt_;
}

/*
 * @author Daniel Henrique Joppi 01/09/2011
 */
nsaddr_t AntNest::randomNeighbor() {
	int size = this->pheromone_rt_->getNeighbors().size();
	int randNode = (rand()%size);

	int cont = 0;
	for (AntNeighbors::iterator iter = pheromoneTable()->getNeighbors().begin(); iter != pheromoneTable()->getNeighbors().end(); iter++)
	{
		if(randNode == cont)
		{
			return *iter;
		}
		cont++;
	}
	return *(this->pheromone_rt_->getNeighbors().begin());
}

/*
 * @author Daniel Henrique Joppi 03/10/2011
 */
nsaddr_t AntNest::randomDestination() {
	return this->pheromone_rt_->randomDestination();
}

Packet* AntNest::createAntHelloPacket()
{
	Packet* p = Packet::alloc(); // allocate new packet
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	struct hdr_ip* ih = HDR_IP(p); // ip header
	AntHelloPacket* ah = HDR_AHN_HELLO(p); // ant header

#ifdef DEBUG
	//fprintf(stderr, "sending Hello from %d at %.2f\n", index, Scheduler::instance().clock());
#endif // DEBUG
	ah->setAntType(ANTTYPEHELLO); // set ant type as Hello Ant
	ah->setAntDirection(ANT_UP); // set ant direction
	ah->setSorceAddress(addr()); // source address
	ah->setSeqNum(ant_seq_num_++); // sequence number
	ah->setTimeStartAnt(CURRENT_TIME); // packet generation time

	ah->setDestinationAddres(IP_BROADCAST); // set packet destination
	double time = 0;

	AntDestinations dest_table = pheromoneTable()->getRegularDestinations();
	AntDestinations_it it = dest_table.begin();
	for (; it != dest_table.end(); it++) {
		double random = rand() / (RAND_MAX * 1.0);

		if (dest_table.size() <= 10 || (random > 0.5 && ah->sizeNodes() < 10)) {
			nsaddr_t dest = *it;
			ah->addDestination(ANT_NODE(dest, 1.000));
		}
	}

	ch->ptype() = PT_ANT; // set packet type as Ant
	ch->size() = IP_HDR_LEN + ah->size(); // packet header size
	ch->iface() = -2;
	ch->error() = 0;
	ch->addr_type() = NS_AF_NONE; // used for broadcasting messages
	ch->prev_hop_ = addr(); // set source address in ip header

	ih->saddr() = addr(); // set source address in ip header
	ih->daddr() = IP_BROADCAST; // set destination address in ip header
	ih->sport() = RT_PORT;
	ih->dport() = RT_PORT;
	ih->ttl_ = 2;
#ifdef DEBUG
	//fprintf(stdout, "sending antnet packet from %d to %d next hop %d\n",
			ah->getSorceAddress(), ah->getDestinationAddres(), ih->daddr());
#endif //DEBUG
	return p;
}

/**
 *  Method to create backward ant packet
 *  called when forward ant reaches destination node
 *
 *  @author Daniel Henrique Joppi 17/03/2009
 */
Packet* AntNest::createAntBackPacket(Packet *pfw)
{
	struct hdr_ip* ihfw = HDR_IP(pfw);
	struct hdr_cmn* chfw = HDR_CMN(pfw);
	//fprintf(stdout, "bad cast aqui ... %d\n");
	AntForwardPacket* ahfw = (AntForwardPacket*) AntForwardPacket::access(pfw);

	Packet* pbk = Packet::alloc(); // allocate new packet
	struct hdr_ip* ih = HDR_IP(pbk);
	struct hdr_cmn* ch = HDR_CMN(pbk);
	AntBackPacket* ah = (AntBackPacket*) AntBackPacket::access(pbk);

	ah->setAntType(ahfw->getAntType()); // set ant type as  Ant
	ah->setAntDirection(ANT_DOWN); // set ant direction
	ah->setSeqNum(ant_seq_num_++); // sequence number
	ah->setTimeStartAnt(CURRENT_TIME); // packet generation time
	// swap source and destination address
	ah->setSorceAddress(addr()); // ahfw->getDestinationAddres()
	ah->setDestinationAddres(ahfw->getSorceAddress());

	// copy visited nodes list
	AntTimeEntryList tempV;
	int size = ahfw->sizeNodes();
	AntTimeEntry** pp = ah->getVisitedNodes();
	AntTimeEntry** ppfw = ahfw->getVisitedNodes();
	for (int i=0; i<size; i++) {
		AntTimeEntry* entry = ppfw[i];
		pp[i] = new AntTimeEntry(entry->node(), entry->time());
		//fprintf(stdout, " ---- pointer entry %d => time %f \n", entry->node(), entry->time());
	}
	ah->sizeNodes(size);
	// retrieve last second entry in memory (last entry is this node)
	//fprintf(stdout, " ouu ... <%d : %d>\n", addr(), ah->getSeqNum());
	nsaddr_t next = ah->findNextHop(addr());

	//ch->direction() = hdr_cmn::DOWN; // change direction to backward Ant
	ch->ptype() = PT_ANT; // set packet type as Ant
	ch->size() = IP_HDR_LEN + ah->size(); // packet header size
	ch->iface() = -2;
	ch->error() = 0;
	ch->addr_type() = NS_AF_INET;
	ch->prev_hop_ = addr();
	ch->next_hop() = next; // next hop as determined from memory

	ih->saddr() = addr(); // source address
	ih->daddr() = next; // destination address
	ih->sport() = RT_PORT;
	ih->dport() = RT_PORT;

	//fprintf(stdout, " forward ant seqnum: %d:%d >> back ant seqnum: %d:%d\n", ahfw->getSorceAddress(), ahfw->getSeqNum(), ah->getSorceAddress(), ah->getSeqNum());

	this->killAntPacket(pfw); // kill ant forward packet

	return pbk;
}

Packet* AntNest::createAntForwardPacket(u_int8_t antType, nsaddr_t destination)
{
	Packet* p = Packet::alloc(); // allocate new packet
	struct hdr_cmn* ch = HDR_CMN(p); // common header
	struct hdr_ip* ih = HDR_IP(p); // ip header
	AntForwardPacket* ah = (AntForwardPacket*) AntForwardPacket::access(p); // ant header

	ah->setAntType(antType); // ant type
	ah->setAntDirection(ANT_UP); // set ant direction
	ah->setSorceAddress(addr()); // source address
	ah->setSeqNum(ant_seq_num_++); // sequence number
	ah->setTimeStartAnt(CURRENT_TIME); // packet generation time
	ah->setDestinationAddres(destination); // set packet destination
	double time = 0;
	AntTimeEntry* antSE = new AntTimeEntry(addr(), time);
	ah->addToNodes(antSE); // add source node to memory

	ch->ptype() = PT_ANT; // set packet type as Ant
	ch->size() = IP_HDR_LEN + ah->size(); // packet header size
	ch->iface() = -2;
	ch->error() = 0;
	//ch->direction() = hdr_cmn::UP;
	ch->prev_hop_ = addr(); // set source address in ip header

	ih->saddr() = addr(); // set source address in ip header
	ih->sport() = RT_PORT;
	ih->dport() = RT_PORT;
	return p;
}

void AntNest::killAntPacket(Packet *p)
{
	Packet::free(p);
}

double AntNest::evaporatePheromone(double phValue)
{
	return phValue - (1 - AntHocNetUtils::ALFA) * phValue;
}

double AntNest::incressPheromone(double phValue, double phUpdate)
{
	return (AntHocNetUtils::GAMA * phValue + (1 - AntHocNetUtils::GAMA) * phUpdate);
}

void AntNest::cleanNeighborPheromone(nsaddr_t neighbor)
{
	// evaporate regular pheromone
	cleanNeighborPheromone(neighbor, true);

	// evaporate virtual pheromone
	cleanNeighborPheromone(neighbor, false);

	pheromoneTable()->removeNeighbor(neighbor);
}

void AntNest::cleanNeighborPheromone(nsaddr_t neighbor, bool isRegular)
{
	AntDestinations destsRem;

	// clean pheromone
	AntDestinations dest_table = isRegular ? pheromoneTable()->getRegularDestinations() : pheromoneTable()->getVirtualDestinations();
	for (AntDestinations_it it = dest_table.begin(); it != dest_table.end(); it++) {
		nsaddr_t destination = *it;

		if (isRegular) {
			if (pheromoneTable()->getPheromoneRegular(destination, neighbor) < AntHocNetUtils::MIN_PHEROMONE) {
				continue;
			}

			pheromoneTable()->removePheromoneRegular(destination, neighbor);

			if (!hasRegularDestination(destination)) {
				destsRem.insert(destination);
			}
		} else {
			if (pheromoneTable()->getPheromoneVirtual(destination, neighbor) < AntHocNetUtils::MIN_PHEROMONE) {
				continue;
			}

			pheromoneTable()->removePheromoneVirtual(destination, neighbor);

			if (!hasVirtualDestination(destination)) {
				destsRem.insert(destination);
			}
		}
	}

	if (isRegular && !destsRem.empty()) {
		// remove missing destinations
		for (AntDestinations_it it = destsRem.begin(); it != destsRem.end(); it++) {
			nsaddr_t destination = *it;
			//fprintf(stdout, "AntNest::cleanNeighborPheromone (source %d) remove destination -> dest %d \n", addr_, destination);
			dest_table.erase(destination);
		}
		//fprintf(stdout, "AntNest::cleanNeighborPheromone (source %d) size destinations %d\n", dest_table.empty());
	}
}

void AntNest::addPacketInQueue(Packet* p)
{
	struct hdr_cmn *ch = HDR_CMN(p);
	struct hdr_ip *ih = HDR_IP(p);

	if (ch->ptype() == PT_ANT) {
		return;
	}

	nsaddr_t dest = (ch->ptype() == PT_ANT) ? HDR_AHN(p)->getDestinationAddres() : ih->daddr() ;

	if (mapQueue.end() != mapQueue.find(dest)) {
		(mapQueue.find(dest))->second.insert(p);
	} else {
		AntPQueue queue;
		queue.insert(p);
		mapQueue[dest] = queue;
	}
}
