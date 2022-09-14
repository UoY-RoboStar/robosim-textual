/*
 * generated by Xtext 2.17.1
 */
package circus.robocalc.robosim.textual.scoping

import circus.robocalc.robochart.RefExp
import circus.robocalc.robochart.Transition
import circus.robocalc.robochart.Variable
import circus.robocalc.robosim.SimMachineDef
import circus.robocalc.robosim.SimModule
import circus.robocalc.robosim.SimRefExp
import circus.robocalc.robosim.textual.RoboSimTypeProvider
import com.google.inject.Inject
import java.util.Collections
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes

import static circus.robocalc.robochart.RoboChartPackage.Literals.*
import static circus.robocalc.robosim.RoboSimPackage.Literals.*
import circus.robocalc.robochart.StateMachineDef
import circus.robocalc.robosim.SimContext
import circus.robocalc.robosim.SimOperationDef
import circus.robocalc.robosim.OutputCommunication
import circus.robocalc.robochart.Communication
import circus.robocalc.robochart.RCPackage
import circus.robocalc.robochart.Event
import java.util.ArrayList
import circus.robocalc.robosim.ExecTrigger
import circus.robocalc.robosim.ExecStatement
import circus.robocalc.robosim.SimVarRef
import circus.robocalc.robochart.OperationDef
import circus.robocalc.robosim.SimCall

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class RoboSimScopeProvider extends AbstractRoboSimScopeProvider {
	@Inject extension RoboSimTypeProvider
	override getScope(EObject context, EReference reference) {
		if (context instanceof SimRefExp) {
			switch(reference) {
				case SIM_REF_EXP__ELEMENT : System.out.println("element")
				case SIM_REF_EXP__PREDICATE: System.out.println("predicate")
				case SIM_REF_EXP__EXP: System.out.println("exp")
				case SIM_REF_EXP__VARIABLE: System.out.println("variable")
			}
		}else if( context instanceof SimCall){
			if (reference === CALL__OPERATION) {
				//changed the parent scope to avoid accepting OperationDefs being in the scope for Calls
				val s = delegateGetScope(context, reference) //IScope::NULLSCOPE
				return context.getOutputOperationsDeclared(s)
			}
		} 
		
		val scope = context.resolveScope(reference)
 		//val scope = super.getScope(context,reference)
		return scope
	}
	
	
	def dispatch IScope getOutputOperationsDeclared(EObject cont, IScope parent) {
		val container = cont.eContainer
		if (container !== null)
			container.getOutputOperationsDeclared(parent)
		else
			parent
	}

	def dispatch IScope resolveScope(RefExp context, EReference reference) {
		if (context.eContainer instanceof SimRefExp && reference == REF_EXP__REF) {
			val parent = context.eContainer as SimRefExp
			if (parent.exp == context && parent.element instanceof Variable) {
				val type = (parent.element as Variable).type
				return getSelectionScope(type)
			}
		}
		return super.getScope(context,reference)
	}

	def dispatch IScope nodesDeclared(EObject context, IScope result) {
		return result
	}

	def dispatch IScope nodesDeclared(SimModule context, IScope result) {
		Scopes::scopeFor(context.nodes, result)
	}

	def IScope scopesFor(IScope p, Iterable<? extends EObject>... iterables) {
		var r = p
		for (iter : iterables) {
			r = Scopes::scopeFor(iter, r)
		}
		return r
	}

	def dispatch IScope eventsDeclared(SimMachineDef n, IScope p) {
		getEventsDeclared(n as SimContext, p)
	}
	
	def dispatch IScope eventsDeclared(SimOperationDef n, IScope p) {
		getEventsDeclared(n as SimContext, p)
	}
		
	def IScope getEventsDeclared(SimContext n, IScope p) {
		var finalScope = n.inputEventsDeclared(p)
		finalScope = n.outputEventsDeclared(finalScope)
		finalScope.scopesFor(
			n.RInterfaces.map[it.events].flatten,
			n.interfaces.map[it.events].flatten
		)
		return finalScope
      }
	
	
	def dispatch IScope getOutputOperationsDeclared(SimContext n, IScope p) {
		var finalScope = n.outputOperationsDeclared(p)
//		@author: Pedro
//		NOTE: Commented out to include, in addition to this scope, that
//			  already calculated by the RoboChartScopeProvider for
// 			  operations. I believe a similar approach needs to be
// 			  adopted for all other RoboSim elements.
		finalScope.scopesFor(
			n.interfaces.map[it.operations].flatten,
			n.RInterfaces.map[it.operations].flatten
		)
		//return super.operationsDeclared(n as StateMachineDef, finalScope)
	    return finalScope
	}

	def dispatch IScope inputEventsDeclared(EObject n, IScope p) {
		if (n.eContainer !== null) {
			return n.eContainer.inputEventsDeclared(p)
		}
		return p
	}

	def dispatch IScope inputEventsDeclared(SimMachineDef n, IScope p) {
		getinputEventsDeclared(n as SimContext, p)
	}
	
	def dispatch IScope inputEventsDeclared(SimOperationDef n, IScope p) {
		getinputEventsDeclared(n as SimContext, p)
	}
	
	def dispatch IScope getinputEventsDeclared(SimContext n, IScope p) {
		if (n.inputContext === null) {
			return p
		}
		p.scopesFor(
			n.inputContext.events,
			n.inputContext.interfaces.map[it.events].flatten
		)
	}
	

	def dispatch IScope outputEventsDeclared(EObject n, IScope p) {
		if (n.eContainer !== null) {
			return n.eContainer.outputEventsDeclared(p)
		}
		return p
	}

	def dispatch IScope outputEventsDeclared(SimMachineDef n, IScope p) {
		getoutputEventsDeclared(n as SimContext, p)
	}
	
	def dispatch IScope outputEventsDeclared(SimOperationDef n, IScope p) {
		getoutputEventsDeclared(n as SimContext, p)
	}

	def dispatch IScope getoutputEventsDeclared(SimContext n, IScope p) {
		if (n.outputContext === null) {
			return p
		}
		p.scopesFor(
			n.outputContext.events,
			n.outputContext.interfaces.map[it.events].flatten,
			n.outputContext.RInterfaces.map[it.events].flatten
		)
	}

	def dispatch IScope outputOperationsDeclared(EObject n, IScope p) {
		if (n.eContainer !== null) {
			return n.eContainer.outputOperationsDeclared(p)
		}
		return p
	}

	def dispatch IScope outputOperationsDeclared(SimMachineDef n, IScope p) {
		getoutputOperationsDeclared(n as SimContext, p)
	}
	
	def dispatch IScope outputOperationsDeclared(SimOperationDef n, IScope p) {
		getoutputOperationsDeclared(n as SimContext, p)
	}

	def dispatch IScope getoutputOperationsDeclared(SimContext n, IScope p) {
		if (n.outputContext === null) {
			return p
		}		
		p.scopesFor(
			n.outputContext.operations,
			n.outputContext.interfaces.map[it.operations].flatten,
			n.outputContext.RInterfaces.map[it.operations].flatten
		)
	}
	
//	def dispatch IScope resolveScope(InputCommunication context, EReference reference) {
//		val result = super.getScope(context, reference)
//		if (reference == INPUT_COMMUNICATION__EVENT) {
//			return context.eContainer.inputEventsDeclared(result)
//		} else if (reference == INPUT_COMMUNICATION__VARIABLE) {
//			return context.eContainer.variablesDeclared(result)
//		}
//		return result
//	}
//
//	def dispatch IScope resolveScope(OperationCall context, EReference reference) {
//		val result = delegateGetScope(context, reference)
//		if (reference == OPERATION_CALL__OPERATION) {
//			return context.eContainer.outputOperationsDeclared(result)
//		}
//		return result
//	}
//	
	def dispatch IScope resolveScope(OutputCommunication context, EReference reference) {
		val result = delegateGetScope(context, reference)
		//if (reference == COMMAND_EVENT_CALL__EVENT) {
		//	return context.eContainer.outputEventsDeclared(result)
		//}
		if (reference == OUTPUT_COMMUNICATION__EVENT) {
			return context.eContainer.outputEventsDeclared(result)
		}
		return result
	}

	def dispatch IScope declaredNodes(SimMachineDef context, IScope scope) {
		return Scopes::scopeFor(context.nodes, scope)
	}

	def dispatch IScope declaredNodes(EObject context, IScope scope) {
		return scope
	}

	def dispatch IScope resolveScope(Transition context, EReference reference) {
		val result = super.getScope(context, reference)
		if (reference == TRANSITION__SOURCE || reference == TRANSITION__TARGET) {
			return context.eContainer.declaredNodes(result)
		}
		return result
	}
	
	def dispatch IScope resolveScope(SimRefExp context, EReference reference) {
		val result = IScope::NULLSCOPE//super.getScope(context,reference)
		if (reference == SIM_REF_EXP__EXP) {
			if (context.element instanceof Variable) {
				val s = getSelectionScope(context.element.typeFor)
				return s	
			} else if (context.element instanceof Event) {
				var s = inputEventsDeclared(context.element, result)
				return s
			}
		} else if (reference == SIM_REF_EXP__ELEMENT) {
			var s = inputVariablesDeclared(context, result)
			s = eventsDeclared(context,s)
			return s
		} else if (reference == SIM_REF_EXP__VARIABLE) {
			var s = variablesDeclared(context, result)
			return s
		}
		return result
	}

	def dispatch IScope clocksDeclared(SimMachineDef cont) {
		Scopes::scopeFor(cont.clocks)
	}
	
//	def dispatch IScope variablesDeclared(SimModule cont, IScope p) {
//		var s = super.variablesDeclared(cont,p);
//		var constCol = new HashSet<Variable>();
//		val c = cont.const
//		constCol.add(c)
//		s = Scopes::scopeFor(constCol, s);
//		return s
//	}
//	
//	def dispatch IScope variablesDeclared(SimControllerDef cont, IScope p) {
//		var s = super.variablesDeclared(cont,p);
//		var constCol = new HashSet<Variable>();
//		val c = cont.const
//		constCol.add(c)
//		s = Scopes::scopeFor(constCol, s);
//		return s
//	}

	def dispatch IScope outputVariablesDeclared(EObject cont, IScope p) {
		if (cont === null || cont.eContainer === null)
			return p
		else
			return cont.eContainer.outputVariablesDeclared(p)
	}

	def dispatch IScope outputVariablesDeclared(SimMachineDef n, IScope p) {
		getoutputVariablesDeclared(n as SimContext, p)
	}
	
	def dispatch IScope outputVariablesDeclared(SimOperationDef n, IScope p) {
		getoutputVariablesDeclared(n as SimContext, p)
	}

	def dispatch IScope getoutputVariablesDeclared(SimContext n, IScope p) {
		if (n.outputContext === null) {
			return p
		}		
		p.scopesFor(
			n.outputContext.variableList.map[it.vars].flatten,
			n.outputContext.interfaces.map[it.variableList.map[it.vars].flatten].flatten,
			n.outputContext.RInterfaces.map[it.variableList.map[it.vars].flatten].flatten
		)
	}

	def dispatch IScope inputVariablesDeclared(EObject cont, IScope p) {
		if (cont === null || cont.eContainer === null)
			return p
		else
			return cont.eContainer.inputVariablesDeclared(p)
	}
	
	def dispatch IScope inputVariablesDeclared(SimMachineDef n, IScope p) {
		getinputVariablesDeclared(n as SimContext, p)
	}
	
	def dispatch IScope inputVariablesDeclared(SimOperationDef n, IScope p) {
		getinputVariablesDeclared(n as SimContext, p)
	}

	def dispatch IScope getinputVariablesDeclared(SimContext n, IScope p) {
		if (n.inputContext === null) {
			return p
		}		
		p.scopesFor(
			n.inputContext.variableList.map[it.vars].flatten,
			n.inputContext.interfaces.map[it.variableList.map[it.vars].flatten].flatten,
			n.inputContext.RInterfaces.map[it.variableList.map[it.vars].flatten].flatten
		)
	}

	def dispatch IScope variablesDeclared(SimMachineDef cont, IScope p) {
		getvariablesDeclared(cont as SimContext,p)
	}
	
	def dispatch IScope variablesDeclared(SimOperationDef cont, IScope p) {
		var s = getvariablesDeclared(cont as SimContext,p)
		return Scopes::scopeFor(cont.parameters, s)
	}

	def dispatch IScope getvariablesDeclared(SimContext cont, IScope p) {
//		var s = cont.eContainer.variablesDeclared(p)
//		val outputContextVariables = if (cont.outputContext === null) {
//				Collections.emptyList
//			} else {
//				cont.outputContext.RInterfaces.map[it.variableList].flatten.map[it.vars].flatten
//			}
//		var constCol = new HashSet<Variable>();
//		val c = cont.const
//		constCol.add(c)
		return p.scopesFor(
			//constCol,
			cont.variableList.map[it.vars].flatten,
			cont.RInterfaces.map[it.variableList].flatten.map[it.vars].flatten,
			cont.interfaces.map[it.variableList].flatten.map[it.vars].flatten
		)
	}
	
	def getExecScope(EObject context) {
		val resources = context.eResource.resourceSet.resources
		var events = new ArrayList<Event>()
		
		for (r : resources) {
			if ((r.URI.toString).endsWith("/score.rst") 
				&& r.contents.size() > 0 
				&& r.contents.get(0) instanceof RCPackage 
				&& r.contents.get(0) !== context
				&& (r.contents.get(0) as RCPackage).name.equals("robosim__core")
			) {
				val rpkg = r.contents.get(0) as RCPackage
				for (i : rpkg.interfaces) {
					events.addAll(i.events)
				}
			}
		}
		
		//val execScope = Scopes.scopeFor(events, outScope)
		return Scopes::scopeFor(events)
	}
	
	def dispatch IScope resolveScope(Communication context, EReference reference) {
		return getExecScope(context)
	}
	
	def dispatch IScope resolveScope(SimVarRef context, EReference reference) {
		val result = delegateGetScope(context, reference)
		val r = context.outputVariablesDeclared(result)
		r
	}
	
	def dispatch IScope resolveScope(EObject context, EReference reference) {
		return super.getScope(context, reference)
	}
}
