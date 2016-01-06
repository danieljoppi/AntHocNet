/**
 * @author Daniel Henrique Joppi 25/12/2008
 */

#ifndef _ahn_packet_h_
#define _ahn_packet_h_

#include <config.h>
#include <packet.h>
#include <vector>
#include <string>

#include "anthocnet/ant_types.h"

/*
 * Packet Formats...
 *
 * @author Daniel Henrique Joppi 28/12/2008
 */
#define ANTTYPEHELLO  		0x01
#define ANTTYPEREACTIVE		0x02
#define ANTTYPEPROACTIVE	0x04
#define ANTTYPEREPAIR		0x08

/*
 * Packet Direction...
 *
 * @author Daniel Henrique Joppi 28/12/2008
 */
#define ANT_DOWN  		0x11
#define ANT_UP			0x12

/*
 * AntHocNet Routing Protocol Header Macros
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
#define HDR_AHN(p)			((AntBasicPacket*)		AntBasicPacket::access(p))
#define HDR_AHN_HELLO(p)	((AntHelloPacket*)		AntHelloPacket::access(p))
#define HDR_AHN_REBA(p)     ((AntBackPacket*)		AntBackPacket::access(p))
#define HDR_AHN_REFA(p)     ((AntForwardPacket*)	AntForwardPacket::access(p))
#define HDR_AHN_PRBA(p)     ((AntBackPacket*)		AntBackPacket::access(p))
#define HDR_AHN_PRFA(p)     ((AntForwardPacket*)	AntForwardPacket::access(p))
#define HDR_AHN_RRBA(p)     ((AntBackRepairPacket*)	AntBackRepairPacket::access(p))
#define HDR_AHN_RRFA(p)     ((AntForwardRepairPacket*)AntForwardRepairPacket::access(p))

class AntBasicPacket;
class AntHelloPacket;
class AntForwardPacket;
class AntBackPacket;
class AntBackRepairPacket;
class AntForwardRepairPacket;

/**
 * Class for a basic ant
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntBasicPacket
{
	protected:
		u_int8_t antType;
		u_int8_t antDirection;

		AntTimeEntry** visitedNodes; // this will simulate a stack for ant
		int sizeNodes_; // number of nodes in list
		nsaddr_t sourceAddress; //the source node
		nsaddr_t destinationAddress; //the final destination
		double timeStartAnt; //time to start ant packet
		u_int8_t seqNum;	// packet sequence number

	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel henrique Joppi 21/03/2009
		 */
		AntBasicPacket()
		{

		}
		virtual ~AntBasicPacket()
		{
			for (int i=0; i<sizeNodes_; i++) {
				delete visitedNodes[i];
			}
			free(visitedNodes);
		}

		// Header access methods
		static int offset_; // required by PacketHeaderManager
		inline static int& offset()
		{
			return offset_;
		}
		inline static AntBasicPacket* access(const Packet* p)
		{
			return (AntBasicPacket*) p->access(offset_);
		}

		// cycleNode Lists
		int sizeNodes() {
			return sizeNodes_;
		}
		void sizeNodes(int size) {
			sizeNodes_ = size;
		}

		void addToNodes(AntTimeEntry* entry);

		AntTimeEntry* pop_back();

		/**
		 * Get methods
		 *
		 * @author Daniel Henrique Joppi 20/03/2009
		 */
		inline u_int8_t getAntType() const
		{
			return this->antType;
		}
		inline u_int8_t getAntDirection() const
		{
			return this->antDirection;
		}
		inline nsaddr_t getDestinationAddres() const
		{
			return this->destinationAddress;
		}
		inline nsaddr_t getSorceAddress() const
		{
			return this->sourceAddress;
		}
		inline double getTimeStartAnt() const
		{
			return this->timeStartAnt;
		}
		inline u_int8_t getSeqNum() const
		{
			return this->seqNum;
		}
		AntTimeEntry** getVisitedNodes();

		/**
		 * Set methods
		 *
		 * @author Daniel Henrique Joppi 20/03/2009
		 */
		inline void setAntType(u_int8_t antType)
		{
			this->antType = antType;
		}
		inline void setAntDirection(u_int8_t antDirection)
		{
			this->antDirection = antDirection;
		}
		inline void setDestinationAddres(nsaddr_t destinationAddress)
		{
			this->destinationAddress = destinationAddress;
		}
		inline void setSorceAddress(nsaddr_t sourceAddress)
		{
			this->sourceAddress = sourceAddress;
		}
		inline void setTimeStartAnt(double timeStartAnt)
		{
			this->timeStartAnt = timeStartAnt;
		}
		inline void setSeqNum(u_int8_t seqNum)
		{
			this->seqNum = seqNum;
		}
		inline void setVisitedNodes(AntTimeEntry** visitedNodes)
		{
			this->visitedNodes = visitedNodes;
		}

		int size();
	protected:
		inline int sizeChildrenRepair()
		{
			return 0;
		}
};

/**
 * Class for a hello ant
 *
 * @author Daniel Henrique Joppi 04/09/2011
 */
class AntHelloPacket:
		public AntBasicPacket
{
	private:
		AntNode** destinations;
		int sizeDests_;

	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel henrique Joppi 04/09/2011
		 */
		AntHelloPacket()
		{
			//compiler automatically AntBasicPacket()
		}

		virtual  ~AntHelloPacket()
		{
			//compiler automatically ~AntBasicPacket()
			for (int i=0; i<sizeDests_; i++) {
				delete destinations[i];
			}
			free(destinations);
		}

		int sizeDests() {
			return sizeDests_;
		}
		void sizeDests(int size) {
			sizeDests_ = size;
		}

		void addDestination(AntNode* destination);

		/**
		 * Get methods
		 *
		 * @author Daniel Henrique Joppi 04/09/2011
		 */
		AntNode** getDestinations();

		/**
		 * Set methods
		 *
		 * @author Daniel Henrique Joppi 04/09/2011
		 */
		inline void setDestinations(AntNode** destinations)
		{
			this->destinations = destinations;
		}
};

/**
 * Class for a forward ant
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntForwardPacket:
		public AntBasicPacket
{
	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel henrique Joppi 21/03/2009
		 */
		AntForwardPacket()
		{
			//compiler automatically AntBasicPacket()
		}

		virtual  ~AntForwardPacket()
		{
			//compiler automatically ~AntBasicPacket()
		}
};

/*
 * Class for a backward ant
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntBackPacket:
		public AntBasicPacket
{
	protected:
		AntTimeEntry** visitedNodesHist; // this will simulate a stack for ant
		int sizeNodesHist_; // number of nodes in list
		nsaddr_t prevHop; // previous node
		int hops; // count numbers of hops to current node
		double prevSINR; // Hop time estimated at the mac layer of the previous node
		double pheromone; // value of pheromone

	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel Henrique Joppi 21/03/2009
		 */
		AntBackPacket()
		{
			//compiler automatically AntBasicPacket()
			prevHop = -1;
			hops = 0;
			prevSINR = 0;
			pheromone = 0;
		}

		virtual  ~AntBackPacket()
		{
			//compiler automatically ~AntBasicPacket()
		}

		inline AntTimeEntry** getVisitedNodesHist()
		{
			return this->visitedNodesHist;
		}

		// cycleNode Lists
		int sizeNodesHist() {
			return sizeNodesHist_;
		}

		// Method to find next neighbor visited by ant forward
		// Daniel Henrique Joppi 11/09/2011
		nsaddr_t findNextHop(nsaddr_t sddr);

		// Method to find previous neighbor visited by ant forward
		// used for update pheromone table
		// Daniel Henrique Joppi 11/09/2011

		inline nsaddr_t findPrevHop()
		{
			return this->prevHop;
		}

		/**
		 * Get methods
		 *
		 * @author Daniel Henrique Joppi 20/03/2009
		 */
		inline double getPrevSINR() const
		{
			return this->prevSINR;
		}
		inline double getPheromone() const
		{
			return this->pheromone;
		}

		/**
		 * Set methods
		 *
		 * @author Daniel Henrique Joppi 20/03/2009
		 */
		inline void setPrevSINR(double prevSINR)
		{
			this->prevSINR = prevSINR;
		}
		inline void setPheromone(double pheromone)
		{
			this->pheromone = pheromone;
		}

		int size();
};

/**
 * Class for a repair ant
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntRepairPacket
{
	protected:
		double lifeAnt;

	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel Henrique Joppi 21/03/2009
		 */
		AntRepairPacket()
		{

		}
		virtual  ~AntRepairPacket()
		{

		}

		/**
		 * Get methods
		 *
		 * @author Daniel Henrique Joppi 20/03/2009
		 */
		inline double getLifeAnt() const
		{
			return this->lifeAnt;
		}

		/**
		 * Set methods
		 *
		 * @author Daniel Henrique Joppi 20/03/2009
		 */
		inline void setLifeAnt(double lifeAnt)
		{
			this->lifeAnt = lifeAnt;
		}
	protected:
		// see class AntBasicPacket
		virtual int sizeChildrenRepair();
};

/**
 * Class for a forward repair ant
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntForwardRepairPacket:
		public AntForwardPacket,
		public AntRepairPacket
{
	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel Henrique Joppi 21/03/2009
		 */
		AntForwardRepairPacket()
		{
			//compiler automatically AntForwardPacket()
			//compiler automatically AntRepairPacket()
		}

		virtual  ~AntForwardRepairPacket()
		{
			//compiler automatically ~AntForwardPacket()
			//compiler automatically ~AntRepairPacket()
		}
};

/**
 * Class for a back repair ant
 *
 * @author Daniel Henrique Joppi 25/12/2008
 */
class AntBackRepairPacket:
		public AntBackPacket,
		public AntRepairPacket
{
	public:
		/**
		 * Add Constructor and Destructor
		 *
		 * @author Daniel Henrique Joppi 21/03/2009
		 */
		AntBackRepairPacket()
		{
			//compiler automatically AntBackPacket()
			//compiler automatically AntRepairPacket()
		}

		virtual  ~AntBackRepairPacket()
		{
			//compiler automatically ~AntBackPacket()
			//compiler automatically ~AntRepairPacket()
		}
};

#endif /* _ahn_packet_h_ */
