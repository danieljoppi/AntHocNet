/**
 * @author Daniel Henrique Joppi 02/01/2009
 */

#include "anthocnet/ant_packet.h"
#include "anthocnet/ant_types.h"
#include "anthocnet/ahn_protocol_utils.h"

#include <exception>
#include <iostream>
#include <math.h>

AntTimeEntry** AntBasicPacket::getVisitedNodes()
{
	if (visitedNodes == NULL) {
		visitedNodes = (AntTimeEntry**)malloc(sizeof(AntTimeEntry*) * 100);
		sizeNodes_ = 0;
	}
	return visitedNodes;
}

void AntBasicPacket::addToNodes(AntTimeEntry* entry)
{
#ifdef DEBUG
	for (int i=0; i< sizeNodes_; i++) {
		AntTimeEntry* entry = visitedNodes[i];
		fprintf(stdout, " ---- old entry %d \n", entry);
		fprintf(stdout, " ---- old entry %d => time %f \n", entry->node(), entry->time());
	}
	fprintf(stdout, "addToNodes - seqnum: %d:%d >> <%d,%f> (size %d) %d \n", this->getSorceAddress(), this->getSeqNum(),
			entry->node(), entry->time(), sizeNodes_, visitedNodes);
#endif //DEBUG

	if (visitedNodes == NULL) {
		visitedNodes = (AntTimeEntry**)malloc(sizeof(AntTimeEntry*) * 100);
		sizeNodes_ = 0;
	}

	if (sizeNodes_ < 100) {
		visitedNodes[sizeNodes_++] = entry;
	}

#ifdef DEBUG
	for (int i=0; i< sizeNodes_; i++) {
		AntTimeEntry* entry = visitedNodes[i];
		fprintf(stdout, " ---- new entry %d \n", entry);
		fprintf(stdout, " ---- new entry %d => time %f \n", entry->node(), entry->time());
	}
#endif //DEBUG
}

AntTimeEntry* AntBasicPacket::pop_back() {
	if (sizeNodes_ == 0) {
		//fprintf(stdout, "iiii 1");
		return NULL;
	}

	AntTimeEntry* entry = visitedNodes[sizeNodes_--];
	return entry;
}

int AntBasicPacket::size()
{
	int sz = sizeChildrenRepair();

	sz += sizeof(u_int8_t);
	sz += sizeof(u_int8_t);

	sz += sizeof(visitedNodes);

	sz += sizeof(nsaddr_t);
	sz += sizeof(nsaddr_t);
	sz += sizeof(double);
	sz += sizeof(u_int8_t);
	return sz;
}

AntNode** AntHelloPacket::getDestinations()
{
	if (destinations == NULL) {
		destinations = (AntNode**)malloc(sizeof(AntNode*) * 10);
		sizeDests_ = 0;
	}

	return this->destinations;
}

void AntHelloPacket::addDestination(AntNode* destination)
{
	if (destinations == NULL) {
		destinations = (AntNode**)malloc(sizeof(AntNode*) * 10);
		sizeDests_ = 0;
	}

	if (sizeDests_ < 10) {
		destinations[sizeDests_++] = destination;
	}
}

int AntRepairPacket::sizeChildrenRepair()
{
	int sz = 0;
	sz += sizeof(double);
	return sz;
}

nsaddr_t AntBackPacket::findNextHop(nsaddr_t sddr)
{
	AntTimeEntry* entry = visitedNodes[sizeNodes_-1];
	//fprintf(stdout, "AntBackPacket:: entry* %d\n", entry);
	prevHop = entry->node();
	hops++;
	// time to back ant send "-" time to ant forward pass to node
	double time = entry->time();
	prevSINR += time;

	double simpleSINR = prevSINR / 1000;

	// calculate pheromone to used to destination
	int hTime = AntHocNetUtils::HOP_TIME;
	pheromone = pow( ((hops*hTime + simpleSINR) / 2) , -1);

	// add visited nodes history
	if (visitedNodesHist == NULL) {
		visitedNodesHist = (AntTimeEntry**)malloc(sizeof(AntTimeEntry*) * 100);
		sizeNodesHist_ = 0;
	}

	visitedNodesHist[sizeNodesHist_++] = new AntTimeEntry(entry->node(), entry->time());
	//fprintf(stdout, "AntBackPacket:: <%d : %d> (%d) sizeNodesHist_ %d\n", this->getSorceAddress(), this->getSeqNum(), sddr, sizeNodesHist_);

	// get next neighbor
	sizeNodes_--;
	entry = visitedNodes[sizeNodes_-1];

	//fprintf(stdout, "AntBackPacket:: <%d : %d> (%d) sizeNodes_ %d\n", this->getSorceAddress(), this->getSeqNum(), sddr, sizeNodes_);
	//fprintf(stdout, "AntBackPacket:: <%d : %d> (%d) entry->node() %d\n", this->getSorceAddress(), this->getSeqNum(), sddr, entry->node());

#ifdef DEBUG
	fprintf(stdout, "AntBackPacket::findNextHop - seqnum: %d:%d >> sddr (%d) == prev (%d) >> time (%f) -- pheromone (%f) -- vizited size %d next %d \n", this->getSorceAddress(), this->getSeqNum(),
			sddr, prevHop, prevSINR, pheromone, sizeNodes_, entry->node());

	for (int i=0; i< sizeNodes_; i++) {
		AntTimeEntry* entry = visitedNodes[i];
		fprintf(stdout, " ---- entry %d => time %d \n", entry->node(), entry->time());
	}
#endif //DEBUG

	return entry->node();
}

int AntBackPacket::size()
{
	int sz = AntBasicPacket::size();
	sz += sizeof(nsaddr_t);
	sz += sizeof(visitedNodesHist);
	sz += sizeof(int);
	sz += sizeof(int);
	sz += sizeof(double);
	sz += sizeof(double);
	return sz;
}

