/**
 * @author Daniel Henrique Joppi 25/12/2008
 */

#ifndef _ahn_ant_nest_
#define _ahn_ant_nest_

#include <set>
#include <list>
#include <cstdlib>
#include <node.h>

#include "anthocnet/ahn_pheromone_table.h"
#include "anthocnet/ahn_protocol_utils.h"
#include "anthocnet/ant_packet.h"

using namespace std;

/// Macro to retrieve current simulator time
#define CURRENT_TIME    		(double) Scheduler::instance().clock()

class AntHocNet; // forward declaration

/**
 * Class to implement a ant nest.
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntNest
{
	friend class AntHocNet;

	private:
		PheromoneTable* pheromone_rt_;
		MapAntPQueue mapQueue;

		AntHistoryList history; // history of ant packet to send by node

		nsaddr_t addr_; // address of the agent
		u_int8_t ant_seq_num_; // sequence number for ant packets

		/// Method to lookup the pheromone table
		// Author Daniel Henrique Joppi 01/09/2011
		// Parameters: destination node, neighbor node
		PheromoneTable* pheromoneTable() const;


		double evaporatePheromone(double phValue);
		double incressPheromone(double phValue, double phUpdate);

	public:
		AntNest(nsaddr_t addr)
		{
			pheromone_rt_ = new PheromoneTable();
			ant_seq_num_ = 0;
			addr_ = addr;
		}
		~AntNest()
		{
			delete pheromone_rt_;
		}


		inline nsaddr_t& addr()
		{
			return addr_;
		}

		void cleanNeighborPheromone(nsaddr_t neighbor);
		void cleanNeighborPheromone(nsaddr_t neighbor, bool isRegular);

		Packet* createAntHelloPacket();

		Packet* createAntBackPacket(Packet* pfw);

		Packet* createAntForwardPacket(u_int8_t antType, nsaddr_t destination);

		void killAntPacket(Packet* p);

		/// Method to updates the pheromone path neighbor wish connect to destination node
		// Author Daniel Henrique Joppi 01/09/2011
		// Parameters: destination node, neighbor node
		PheromoneTable* updateRegularPheromone(nsaddr_t destination, nsaddr_t neighbor, double phUpdate);

		/// Method to updates the pheromone path neighbor wish connect to destination node
		// Author Daniel Henrique Joppi 04/10/2011
		// Parameters: ant hello packet
		PheromoneTable* updateVirtualPheromone(AntHelloPacket* ah);

		bool hasRegularDestination(nsaddr_t destination);
		bool hasVirtualDestination(nsaddr_t destination);

		/// Method to get next neighbor to wisper
		// Author Daniel Henrique Joppi 01/09/2011
		// Parameters: destination node, neighbor node
		nsaddr_t randomNeighbor();

		nsaddr_t randomDestination();

		inline unsigned int sizeNeighbors()
		{
			return this->pheromoneTable()->getNumNeighbors();
		}

		inline void addNeighbor(Node* neighbor)
		{
			this->addNeighbor(neighbor->address());
		}
		inline void addNeighbor(nsaddr_t neighbor)
		{
			this->pheromoneTable()->addNeighbor(neighbor);
		}

		inline void removeNeighbor(Node* neighbor)
		{
			this->removeNeighbor(neighbor->address());
		}
		inline void removeNeighbor(nsaddr_t neighbor)
		{
			this->pheromoneTable()->removeNeighbor(neighbor);
		}

		void addPacketInQueue(Packet* p);
};

#endif /* _ahn_ant_nest_ */
