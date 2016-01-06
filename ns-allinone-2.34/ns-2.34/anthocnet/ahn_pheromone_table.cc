/**
 * @author Daniel Henrique Joppi 03/01/2009
 */

#include <cstdlib>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <math.h>

#include "anthocnet/ant_types.h"
#include "anthocnet/ahn_pheromone_table.h";
#include "anthocnet/ahn_protocol_utils.h";

/**
 * Method to add an entry in neighbor table.
 *
 * @author Daniel Henrique Joppi 06/01/2009
 * @param neighbor node
 */
void PheromoneTable::addNeighbor(nsaddr_t neighbor)
{
	//insert >neighbor, but only if val doesn't already exist
	this->neighbor_table.insert(neighbor);
	this->dest_table_regular.insert(neighbor);
	this->dest_table_virtual.insert(neighbor);

	//fprintf(stdout, "PheromoneTable::addNeighbor -> (neigbor %d -- size %d) -- (dest %d -- size %d)\n", neighbor, this->neighbor_table.size(), neighbor, this->dest_table_regular.size());
}

/**
 * Method to remove an entry in neighbor table.
 *
 * @author Daniel Henrique Joppi 06/01/2009
 * @param neighbor node
 */
void PheromoneTable::removeNeighbor(nsaddr_t neighbor)
{
	this->neighbor_table.erase(neighbor);
}

/**
 * Method to add an entry in routing table.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 * @param destination node
 * @param neighbor node
 * @param phvalue pheromone value
 */
void PheromoneTable::addPheromoneRegular(nsaddr_t destination, nsaddr_t neighbor, double phvalue)
{
	this->dest_table_regular.insert(destination);

	this->pheromone_regular [ANT_ENTRY(neighbor, destination)] = phvalue;
}

/**
 * Method to add an entry in routing table.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 * @param destination node
 * @param neighbor node
 * @param phvalue pheromone value
 */
void PheromoneTable::addPheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor, double phvalue)
{
	this->dest_table_virtual.insert(destination);

	this->pheromone_virtual [ANT_ENTRY(neighbor, destination)] = phvalue;
}

/**
 * Method to remove an entry in routing table.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 * @param destination node
 * @param neighbor node
 */
void PheromoneTable::removePheromoneRegular(nsaddr_t destination, nsaddr_t neighbor)
{
	this->pheromone_regular.erase(ANT_ENTRY(neighbor, destination));
}

/**
 * Method to remove an entry in routing table.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 * @param destination node
 * @param neighbor node
 */
void PheromoneTable::removePheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor)
{
	this->pheromone_virtual.erase(ANT_ENTRY(neighbor, destination));
}

/**
 * Method to get an entry in routing table.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 * @param destination node
 * @param neighbor node
 */
double PheromoneTable::getPheromoneRegular(nsaddr_t destination, nsaddr_t neighbor)
{
	MapNodePheromone_it iter = this->pheromone_regular.find(ANT_ENTRY(neighbor, destination));

	// destination entry exist in pheromone_table
	if (iter != this->pheromone_regular.end()) {
		return (iter->second);
	} else {
		return 0;
	}
}

/**
 * Method to get an entry in routing table.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 * @param destination node
 * @param neighbor node
 */
double PheromoneTable::getPheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor)
{
	MapNodePheromone_it iter = this->pheromone_regular.find(ANT_ENTRY(neighbor, destination));

	// destination entry exist in pheromone_table
	if (iter != this->pheromone_regular.end()) {
		return (iter->second);
	} else {
		return 0;
	}
}

/**
 * Method to set an entry in routing table.
 *
 * @author Daniel Henrique Joppi 04/09/2011
 * @param destination node
 * @param neighbor node
 * @param phvalue pheromone value
 */
void PheromoneTable::setPheromoneRegular(nsaddr_t destination, nsaddr_t neighbor, double phvalue)
{
	this->dest_table_regular.insert(destination);
	this->addNeighbor(neighbor);

	//fprintf(stdout, "setNeighborRegular -> (dest %d) -- next (%d) == pheromone (%f)\n", destination, neighbor, phvalue);

	NodeEntry node = ANT_ENTRY(neighbor, destination);
	MapNodePheromone_it iter = this->pheromone_regular.find(node);

	// destination entry exist in pheromone_table
	if (iter != this->pheromone_regular.end()) {
		this->pheromone_regular.erase(node);
	}

	this->pheromone_regular[node] = phvalue;
}

/**
 * Method to set an entry in routing table.
 *
 * @author Daniel Henrique Joppi 04/09/2011
 * @param destination node
 * @param neighbor node
 * @param phvalue pheromone value
 */
void PheromoneTable::setPheromoneVirtual(nsaddr_t destination, nsaddr_t neighbor, double phvalue)
{
	this->dest_table_virtual.insert(destination);

	NodeEntry node = ANT_ENTRY(neighbor, destination);
	MapNodePheromone_it iter = this->pheromone_virtual.find(node);

	// destination entry exist in pheromone_table
	if (iter != this->pheromone_virtual.end()) {
		this->pheromone_virtual.erase(node);
	}

	this->pheromone_virtual[node] = phvalue;
}

/**
 * Method to print pheromone routing table: regular and virtual.
 *
 * @author Daniel Henrique Joppi 03/01/2009
 */
void PheromoneTable::printPheromoneTable()
{

}

/**
 * Method to returns next hop node for given source destination pair.
 *
 * @author Daniel Henrique Joppi 13/01/2009
 * @param destination node./
 * @return next hop node for given source destination pair. If return -1,
 * 			the next hop not exists.
 */
nsaddr_t PheromoneTable::nextNeighborNode(const nsaddr_t destination, bool isProactiveAnt)
{
	nsaddr_t neighbor = -1;

	// check if node now destionation
	AntDestinations_it itDest = this->dest_table_regular.find(destination);
	if (itDest == this->dest_table_regular.end()) {

		AntNeighbors neighbors = this->neighbor_table;
		for (AntNeighbors_it iter = neighbors.begin(); iter != neighbors.end(); iter++) {
			nsaddr_t neighbor = *iter;
			//fprintf(stdout, " ---- neighbor %d \n", neighbor);
		}
		return neighbor;
	}

	const double phSumValue = (isProactiveAnt) ? this->sumMaxProbability(destination) : this->sumProbability(this->pheromone_regular, destination);

	// if not exitings pheromone ... no routing
	if (phSumValue == 0) {
		return neighbor;
	}

	AntNeighbors neighbors = this->neighbor_table;
	double random = rand() / (RAND_MAX * 1.0);

	//fprintf(stdout, "nextNeighborNode (size %d) -> SumPheromone %f - random %f \n", neighbors.size(), phSumValue, random);

	const MapNodePheromone_it rend = this->pheromone_regular.end();
	const MapNodePheromone_it vend = this->pheromone_virtual.end();

	for (AntNeighbors_it it = neighbors.begin(); it != neighbors.end(); it++) {
		neighbor = *it;

		const MapNodePheromone_it iterR = this->pheromone_regular.find(ANT_ENTRY(neighbor, destination));
		const MapNodePheromone_it iterV = this->pheromone_virtual.find(ANT_ENTRY(neighbor, destination));

		bool useRegular = (iterR != rend);
		bool useVitural = (iterV != vend) && isProactiveAnt;

		double phValueR = (useRegular) ? iterR->second : 0;
		double phValueV = (useVitural) ? iterV->second : 0;

		if(phValueR > phValueV) {
			random -= (pow(phValueR, AntHocNetUtils::BETA) / phSumValue);
		} else {
			random -= (pow(phValueV, AntHocNetUtils::BETA) / phSumValue);
		}

		//fprintf(stdout, "nextNeighborNode -> SumPheromone %f - random %f \n", phSumValue, random);

		if(random <= 0) {
			break;
		}
	}

	//fprintf(stdout, "nextNeighborNode -> find next %d \n", neighbor);

	return neighbor;
}

/**
 * Method to returns next hop node for given source destination pair.
 *
 * @author Daniel Henrique Joppi 05/09/2011
 * @param destination node.
 * @return next hop node for given source destination pair. If return -1,
 * 			the next hop not exists.
 */
nsaddr_t PheromoneTable::lookup(const nsaddr_t destination)
{
	return nextNeighborNode(destination, false);
}

nsaddr_t PheromoneTable::randomDestination() {
	int size = this->dest_table_regular.size();
	if (size == 0) {
		return -1;
	}
	double random = rand() / (RAND_MAX * 1.0);

	nsaddr_t dest = -1;

	AntDestinations_it it;
	int count = 1;

	for (it = this->dest_table_regular.begin(); it != this->dest_table_regular.end(); it++) {
		double value = (count++) / size;
		random -= value;

		dest = *it;

		if(random <= 0) {
			break;
		}
	}
	//fprintf(stdout, "randomDestination -> find dest %d \n", dest);

	return dest;
}

/**
 * Method to sum pheromone table.
 *
 * @author Daniel Henrique Joppi 04/01/2009
 * @param pheromone_table pheromone table
 * @param destination node
 * @return sum.
 */
double PheromoneTable::sumProbability(MapNodePheromone pheromone_table, const nsaddr_t destination)
{
	double phSumValue = 0;
	AntNeighbors neighbors = this->neighbor_table;

	const MapNodePheromone_it tend = pheromone_table.end();

	for (AntNeighbors_it iter = neighbors.begin(); iter != neighbors.end(); iter++) {
		nsaddr_t neighbor = *iter;
		NodeEntry node = ANT_ENTRY(neighbor, destination);
		const MapNodePheromone_it iterT = pheromone_table.find(node);

		if (iterT == tend) {
			continue;
		}

		phSumValue += pow(iterT->second, AntHocNetUtils::BETA);
		//fprintf(stdout, "pow(iterT->second, AntHocNetUtils::BETA) -> %f \n", phSumValue);
	}
	//fprintf(stdout, "total pheromone >> %f \n", phSumValue);
	return phSumValue;
}

/**
 * Method to sum pheromone table.
 *
 * @author Daniel Henrique Joppi 06/01/2009
 * @param destination node
 * @return sum.
 */
double PheromoneTable::sumMaxProbability(const nsaddr_t destination)
{
	double phSumValue = 0;
	AntNeighbors neighbors = this->neighbor_table;

	const MapNodePheromone_it rend = this->pheromone_regular.end();
	const MapNodePheromone_it vend = this->pheromone_virtual.end();

	for (AntNeighbors_it iter = neighbors.begin(); iter != neighbors.end(); iter++)
	{
		nsaddr_t neighbor = *iter;

		const MapNodePheromone_it iterR = this->pheromone_regular.find(ANT_ENTRY(neighbor, destination));
		const MapNodePheromone_it iterV = this->pheromone_virtual.find(ANT_ENTRY(neighbor, destination));

		bool useRegular = (iterR != rend);
		bool useVitural = (iterV != vend);

		double phValueR = (useRegular) ? iterR->second : 0;
		double phValueV = (useVitural) ? iterV->second : 0;

		if(phValueR > phValueV) {
			phSumValue += pow(phValueR, AntHocNetUtils::BETA);
		} else {
			phSumValue += pow(phValueV, AntHocNetUtils::BETA);
		}
		//fprintf(stdout, "max >> pow(iterT->second, AntHocNetUtils::BETA) -> %f \n", phSumValue);
	}
	//fprintf(stdout, "total max pheromone >> %f \n", phSumValue);
	return phSumValue;
}
