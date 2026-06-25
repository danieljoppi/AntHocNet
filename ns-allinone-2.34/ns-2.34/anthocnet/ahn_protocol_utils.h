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
		// constexpr is required for in-class initialization of non-integral
		// static members; plain `const static float` is ill-formed and is
		// rejected as a hard error by modern compilers (g++ >= ~6).
		static constexpr float ALFA = 0.7;
		static constexpr int BETA = 1;
		static constexpr float GAMA = 0.7;

		static constexpr int HOP_TIME = 50; //millisecond

		static constexpr int PROACTIVE = 1;
		static constexpr int REACTIVE = 2;
		static constexpr int REPAIR = 3;

		static constexpr double MIN_PHEROMONE = 0.00001;
};

#endif /* _ahn_protocol_utils_ */
