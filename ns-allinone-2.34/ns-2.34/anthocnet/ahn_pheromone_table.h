/**
 * @author Daniel Henrique Joppi 03/01/2009
 */

#ifndef _ahn_pheromone_table_
#define _ahn_pheromone_table_

#include <config.h>
#include <map>
#include <vector>
#include <set>

#include "anthocnet/ant_types.h"

class PheromoneTable;

/**
 * Router Table of pheromone values: regular and virtual
 * And Neighbor Table
 * (represents entry in routing table corresponding to a destination)
 *
 * @author Daniel Henrique Joppi 03/01/2009
 */
class PheromoneTable
{
	private:
		MapNodePheromone pheromone_regular;
		MapNodePheromone pheromone_virtual;

		AntNeighbors neighbor_table;

		AntDestinations dest_table_regular;
		AntDestinations dest_table_virtual;

		/// Method to sum pheromone table
		// Author Daniel Henrique Joppi 04/01/2009
		double sumProbability(MapNodePheromone pheromone_table, const nsaddr_t destination);
		double sumMaxProbability(const nsaddr_t destination);

	public:
		PheromoneTable()
		{

		}
		virtual ~PheromoneTable()
		{

		}

		/// Method to add an entry in routing table
		// Author Daniel Henrique Joppi 03/01/2009
		// Parameters: destination node, neighbor node, pheromone value
		void addPheromoneRegular(nsaddr_t destination, nsaddr_t neighbor, double phvalue);
		void addPheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor, double phvalue);

		/// Method to remove an entry in routing table
		// Author Daniel Henrique Joppi 03/01/2009
		// Parameters: destination node, neighbor node
		void removePheromoneRegular(nsaddr_t destination, nsaddr_t neighbor);
		void removePheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor);

		/// Method to get an entry in routing table
		// Author Daniel Henrique Joppi 17/02/2009
		// Parameters: destination node, neighbor node
		double getPheromoneRegular(nsaddr_t destination, nsaddr_t neighbor);
		double getPheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor);

		/// Method to set an entry in routing table
		// Author Daniel Henrique Joppi 04/09/2011
		// Parameters: destination node, neighbor node, pheromone value
		void setPheromoneRegular(nsaddr_t destination, nsaddr_t neighbor, double phvalue);
		void setPheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor, double phvalue);

		/// Method to evaporate pheromone for other links
		// Author Daniel Henrique Joppi 04/09/2011
		// Parameters: destination node, neighbor node, pheromone value
		//double incressPheromone(nsaddr_t destination, nsaddr_t neighbor, double phvalue);

		/// Method to increase ph value for link travelled by ant
		// Author Daniel Henrique Joppi 04/09/2011
		// Parameters: destination node, neighbor node, pheromone value
		//double evaporatePheromone(nsaddr_t destination, nsaddr_t neighbor, double phvalue);

		/// Method to check if list is empty
		// Author Daniel Henrique Joppi 03/01/2009
		inline bool isEmptyRegular()
		{
			return this->pheromone_regular.empty();
		}
		inline bool isEmptyVirtual()
		{
			return this->pheromone_virtual.empty();
		}

		nsaddr_t lookup(const nsaddr_t destination);
		nsaddr_t randomDestination();

		// in neghbor table
		// Author Daniel Henrique Joppi 06/01/2009
		void addNeighbor(nsaddr_t neighbor);
		void removeNeighbor(nsaddr_t neighbor);

		// Author Daniel Henrique Joppi 17/02/2009
		inline AntNeighbors getNeighbors()
		{
			return this->neighbor_table;
		}

		// Author Daniel Henrique Joppi 18/03/2009
		inline unsigned int getNumNeighbors()
		{
			return this->neighbor_table.size();
		}

		// Author Daniel Henrique Joppi 06/01/2009
		inline bool hasNeighbor()
		{
			return (this->neighbor_table.empty() || this->neighbor_table.size()<=0);
		}

		// Author Daniel Henrique Joppi 04/10/2011
		inline AntDestinations getRegularDestinations()
		{
			return this->dest_table_regular;
		}

		// Author Daniel Henrique Joppi 04/10/2011
		inline AntDestinations getVirtualDestinations()
		{
			return this->dest_table_virtual;
		}

		/// Method to print routing table
		// Author Daniel Henrique Joppi 03/01/2009
		void printPheromoneTable();
		/// returns next hop node for given source destination pair
		// Author Daniel Henrique Joppi 03/01/2009
		// Parameters: destination node
		nsaddr_t nextNeighborNode(nsaddr_t destination, bool isProactiveAnt);
};

#endif /* _ahn_pheromone_table_ */
