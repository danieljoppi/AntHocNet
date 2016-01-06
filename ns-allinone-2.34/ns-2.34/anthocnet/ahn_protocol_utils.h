/**
 * @author Daniel Henrique Joppi 03/01/2009
 */

#ifndef _ahn_protocol_utils_
#define _ahn_protocol_utils_

/**
 * This class represents pheromone value corresponding to a neighbor node
 *
 * @author Daniel Henrique Joppi 12/01/2009
 */
class AntHocNetUtils
{
	public:
		const static float ALFA = 0.7;
		const static int BETA = 1;
		const static float GAMA = 0.7;

		const static int HOP_TIME = 50; //millisecond

		const static int PROACTIVE = 1;
		const static int REACTIVE = 2;
		const static int REPAIR = 3;

		const static double MIN_PHEROMONE = 0.00001;
};

#endif /* _ahn_protocol_utils_ */
