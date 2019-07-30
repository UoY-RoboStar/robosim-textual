package circus.robocalc.robosim.textual

import circus.robocalc.robochart.Event
import circus.robocalc.robochart.Field
import circus.robocalc.robochart.RefExp
import circus.robocalc.robochart.Type
import circus.robocalc.robochart.Variable
import circus.robocalc.robochart.textual.RoboCalcTypeProvider
import circus.robocalc.robosim.CycleExp
import circus.robocalc.robosim.SimRefExp
import org.eclipse.emf.ecore.EObject

class RoboSimTypeProvider extends RoboCalcTypeProvider {

	def dispatch Type typeFor(SimRefExp e) {
		//val o = EcoreUtil2.resolve(e.element, e.eContainer.eResource.resourceSet)
		if (e.element instanceof Event) {
			getBooleanType(e)			
		} else if (e.element instanceof Variable) {
			if (e.exp === null) {
				(e.element as Variable).type	
			} else {
				if (e.exp instanceof RefExp && (e.exp as RefExp).ref instanceof Field) {
					val f = (e.exp as RefExp).ref as Field;
					return f.type;
				} else {
					return e.exp.typeFor	
				}
			}
				
		} else
			null
	}
	
	def dispatch Type typeFor(CycleExp e) {
		return getNatType(e)
	}
	
	def dispatch Type typeFor(EObject o) {
		super.typeFor(o)
	}
}