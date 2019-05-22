package circus.robocalc.robosim.textual

import circus.robocalc.robochart.Type
import circus.robocalc.robochart.textual.RoboCalcTypeProvider
import circus.robocalc.robosim.EventExp

class RoboSimTypeProvider extends RoboCalcTypeProvider {

	def dispatch Type typeFor(EventExp e) {
		getBooleanType(e)	 
	}
}