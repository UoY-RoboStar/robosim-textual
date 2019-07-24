package circus.robocalc.robosim.textual

import circus.robocalc.robochart.Event
import circus.robocalc.robochart.Type
import circus.robocalc.robochart.Variable
import circus.robocalc.robochart.textual.RoboCalcTypeProvider
import circus.robocalc.robosim.CycleExp
import circus.robocalc.robosim.SimRefExp
import org.eclipse.xtext.EcoreUtil2

class RoboSimTypeProvider extends RoboCalcTypeProvider {

	def dispatch Type typeFor(SimRefExp e) {
		val o = EcoreUtil2.resolve(e.element, e.eContainer.eResource.resourceSet)
		if (e.element instanceof Event) {
			getBooleanType(e)			
		} else if (e.element instanceof Variable) {
			(e.element as Variable).type	
		} else
			null
	}
	
	def dispatch Type typeFor(CycleExp e) {
		return getNatType(e)
	}
}