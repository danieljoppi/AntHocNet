/**
 * @author Daniel Henrique Joppi 04/09/2011
 */

#ifndef _ahn_ant_types_
#define _ahn_ant_types_

#include <config.h>
#include <map>
#include <vector>
#include <list>
#include <stack>
#include <deque>
#include <set>
#include <utility>
#include <cstdlib>

using namespace std;

class Packet;

struct ant_node_less_adapter
{
	bool operator() (const nsaddr_t lhs, const nsaddr_t rhs)
	{
	   return lhs < rhs;
	}
};

struct ant_dest_less_adapter
{
	bool operator() (const nsaddr_t lhs, const nsaddr_t rhs)
	{
	   return lhs < rhs;
	}
};

typedef std::set<nsaddr_t, ant_node_less_adapter> AntNeighbors;
typedef AntNeighbors::iterator AntNeighbors_it;

typedef std::map<nsaddr_t, double> AntNeighborTime;

// Author Daniel Henrique Joppi 04/09/2011
// <neighbor , destination>
typedef std::pair<nsaddr_t,nsaddr_t> NodeEntry;

// Author Daniel Henrique Joppi 04/09/2011
// <node , ant_seq_num_>
typedef std::pair<nsaddr_t, u_int8_t> AntHistory;
typedef std::set<AntHistory> AntHistoryList;
typedef AntHistoryList::iterator AntHistoryList_it;

// Author Daniel Henrique Joppi 04/09/2011
// <neighbor , pheromoneValue> or <destination , pheromoneValue>
class AntNode {
private:
	int node_;
	double phValue_;

public:
	AntNode(nsaddr_t node, double phValue) {
		this->node_ = node;
		this->phValue_ = phValue;
	}

	nsaddr_t node() const {
		return node_;
	}
	double phValue() const {
		return phValue_;
	}
};
typedef std::set<AntNode> AntNodeList;
typedef AntNodeList::iterator AntNodeList_it;

// Author Daniel Henrique Joppi 04/09/2011
// <neighbor , destination> = pheromoneValue
typedef std::map<NodeEntry, double> MapNodePheromone;
typedef MapNodePheromone::iterator MapNodePheromone_it;

// Author Daniel Henrique Joppi 04/09/2011
typedef std::set<nsaddr_t, ant_dest_less_adapter> AntDestinations;
typedef AntDestinations::iterator AntDestinations_it;

// Author Daniel Henrique Joppi 04/09/2011
// <node, time>
class AntTimeEntry {
private:
	int node_;
	double time_;

public:
	AntTimeEntry(nsaddr_t node, double time) {
		this->node_ = node;
		this->time_ = time;
	}

	nsaddr_t node() const {
		return node_;
	}
	double time() const {
		return time_;
	}
};
typedef std::vector<AntTimeEntry*> AntTimeEntryList;
typedef AntTimeEntryList::reverse_iterator AntTimeEntryList_rit;

// Author Daniel Henrique Joppi 05/09/2011
// queue for packets waiting for next hop
typedef std::set<Packet*> AntPQueue;
typedef AntPQueue::iterator AntPQueue_it;
typedef std::map<nsaddr_t, AntPQueue> MapAntPQueue;
typedef MapAntPQueue::iterator MapAntPQueue_it;

/*
 * AntHocNet Types Macros
 *
 * @author Daniel Henrique Joppi 04/09/2011
 */
#define ANT_ENTRY(neighbor, destination)	(std::make_pair(neighbor, destination))
#define ANT_NODE(neighbor, phValue)			(new AntNode(neighbor, phValue))
#define ANT_TIME_ENTRY(node, time)			(new AntTimeEntry(node, time))
#define ANT_HISTORY(node, seq_num)			(std::make_pair(node, seq_num))
#define REMOVE_PACKETS(destination, map)	(map.erase(destination))
#define GET_PACKETS(destination, map)		(map[destination])


#endif /* _ahn_ant_types_ */
