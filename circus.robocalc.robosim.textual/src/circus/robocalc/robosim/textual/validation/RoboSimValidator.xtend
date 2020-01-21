/*
 * generated by Xtext 2.17.1
 */
package circus.robocalc.robosim.textual.validation

import circus.robocalc.robochart.Assignment
import circus.robocalc.robochart.Connection
import circus.robocalc.robochart.Context
import circus.robocalc.robochart.Controller
import circus.robocalc.robochart.ControllerDef
import circus.robocalc.robochart.ControllerRef
import circus.robocalc.robochart.Div
import circus.robocalc.robochart.Equals
import circus.robocalc.robochart.Event
import circus.robocalc.robochart.Expression
import circus.robocalc.robochart.FloatExp
import circus.robocalc.robochart.GreaterOrEqual
import circus.robocalc.robochart.GreaterThan
import circus.robocalc.robochart.IntegerExp
import circus.robocalc.robochart.Interface
import circus.robocalc.robochart.LessOrEqual
import circus.robocalc.robochart.LessThan
import circus.robocalc.robochart.Minus
import circus.robocalc.robochart.NamedElement
import circus.robocalc.robochart.Neg
import circus.robocalc.robochart.Node
import circus.robocalc.robochart.Plus
import circus.robocalc.robochart.RoboChartPackage
import circus.robocalc.robochart.RoboticPlatform
import circus.robocalc.robochart.StateMachine
import circus.robocalc.robochart.StateMachineRef
import circus.robocalc.robochart.Transition
import circus.robocalc.robochart.Variable
import circus.robocalc.robosim.RoboSimPackage
import circus.robocalc.robosim.SimControllerDef
import circus.robocalc.robosim.SimMachineDef
import circus.robocalc.robosim.SimModule
import circus.robocalc.robosim.textual.RoboSimExtensions
import circus.robocalc.robosim.textual.RoboSimTypeProvider
import com.google.inject.Inject
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.ArrayList
import java.util.Comparator
import java.util.HashSet
import java.util.List
import java.util.TreeSet
import java.util.function.Consumer
import java.util.function.Function
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.resource.IResourceDescriptions
import org.eclipse.xtext.validation.Check
import java.util.LinkedList
import circus.robocalc.robochart.ConnectionNode
import circus.robocalc.robochart.RCModule
import circus.robocalc.robochart.RoboticPlatformDef
import circus.robocalc.robochart.RoboticPlatformRef
import circus.robocalc.robosim.InputContext

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class RoboSimValidator extends AbstractRoboSimValidator {
	public final static String INPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS = "inputInterfaceMustHaveOnlyEvents"
	public final static String OUTPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS_AND_OPERATIONS = "outputInterfaceMustHaveOnlyEventAndOperations"
	public final static String MISSING_REQUIRED_INTERFACE = "missingRequiredInterface"
	public final static String MISSING_DECLARED_INTERFACE = "missingDeclaredInterface"
	public final static String REQUIRED_INTERFACE_MUST_HAVE_ONLY_INPUTS_OUTPUTS = "requiredInterfaceMustHaveOnlyInputsOutputs"
	public final static String INCORRECT_CONNECTION_DIRECTION = "incorrectConnectionDirection"
	public final static String PERIOD_MUST_BE_GREATER_THAN_ZERO = "periodMustBeGreaterThanZero"
	public final static String CYCLE_MUST_BE_BOOLEAN_EXPRESSION = "cycleMustBeBooleanExpression"
	public final static String CONST_CYCLE_MUST_BE_NAME_CYCLE = "constCycleMustBeNameCycle"
	public final static String CONST_CYCLE_MUST_BE_BOOLEAN = "constCycleMustBeBoolean"

	@Inject extension RoboSimTypeProvider

	@Inject IResourceDescriptions rds;
	@Inject IQualifiedNameProvider qnp
	
	@Inject extension RoboSimExtensions
	
	var List<Variable> consts = new ArrayList<Variable>();


	def checkUniquenessInProject(NamedElement o) {
		val project = o.eResource.URI.segment(1)
		val c = rds.allResourceDescriptions.filter[rd|rd.URI.segment(1) == project].map [ rd |
			rd.getExportedObjects(o.eClass, qnp.getFullyQualifiedName(o), false).toSet
		].reduce[p1, p2|p1.addAll(p2); return p1]
		val s = c.size
		if (s > 1) {
			warning(
				'''There is more than one element with name '«qnp.getFullyQualifiedName(o)»'.''',
				RoboChartPackage.Literals.NAMED_ELEMENT__NAME,
				'UniqueQualifiedName'
			)
		}
	}

	def checkUniquenessWithoutProject(NamedElement o) {
		val c = rds.allResourceDescriptions.map [ rd |
			rd.getExportedObjects(o.eClass, qnp.getFullyQualifiedName(o), false).toSet
		].reduce[p1, p2|p1.addAll(p2); return p1]
		val s = c.size
		if (s > 1) {
			warning(
				'''There is more than one element with name '«qnp.getFullyQualifiedName(o)»'.''',
				RoboChartPackage.Literals.NAMED_ELEMENT__NAME,
				'UniqueQualifiedName'
			)
		}
	}

	override def assignmentWellTyped(Assignment a) {
		val t2 = a.left.typeFor
		val t1 = a.right.typeFor
		if (!typeCompatible(t1, t2)) { // && t1 !==	null) { I had to remove this otherwise an badly typed expression would not yield an error
			val msg = '''Variable «a.left.print» expects type «a.left.typeFor.printType», but «IF t1 === null»expression cannot be typed.«ELSE»expression has type «t1.printType»«ENDIF» '''
			error(
				msg,
				RoboChartPackage.Literals.ASSIGNMENT__LEFT,
				'AssignmentTypeError'
			)
		}
	}

	override def checkUniqueness(NamedElement o) {
		val eResource = o.eResource
		if (o.eResource.URI.segmentCount > 1) {
			o.checkUniquenessInProject
		} else {
			o.checkUniquenessWithoutProject
		}
	}

	def dispatch sizeOfTargetTo(SimMachineDef context, Node node) {
		context.transitions.filter[t|t.target == node].size
	}

	def dispatch sizeOfSourceFrom(SimMachineDef context, Node node) {
		context.transitions.filter[t|t.source == node].size
	}

	def dispatch EList<Interface> mountInterfaces(SimMachineDef sm, Function<Context, EList<Interface>> f) {
		val comparator = new Comparator<Interface>() {
			override compare(Interface a, Interface b) {
				a.name.compareTo(b.name)
			}
		}
		val interfaces = new TreeSet<Interface>(comparator)
		interfaces.addAll(f.apply(sm))
		if (sm.inputContext !== null) {
			interfaces.addAll(f.apply(sm.inputContext))
		}
		if (sm.outputContext !== null) {
			interfaces.addAll(f.apply(sm.outputContext))
		}
		val r = new BasicEList<Interface>()
		r.addAll(interfaces)
		r
	}

	def dispatch EList<Interface> mountInterfaces(StateMachineRef sm, Function<Context, EList<Interface>> f) {
		sm.ref.mountInterfaces(f)
	}

	def dispatch EList<Interface> requiredInterfaces(StateMachineRef sm) {
		return (sm.ref as SimMachineDef).requiredInterfaces
	}

	def dispatch EList<Interface> requiredInterfaces(SimMachineDef sm) {
		mountInterfaces(sm, [it.RInterfaces])
	}

	def dispatch EList<Interface> declaredInterfaces(StateMachineRef sm) {
		return (sm.ref as SimMachineDef).requiredInterfaces
	}

	def dispatch EList<Interface> declaredInterfaces(SimMachineDef sm) {
		mountInterfaces(sm, [it.interfaces])
	}

	def dispatch BigDecimal evaluate(FloatExp v) {
		return new BigDecimal(v.value.toString())
	}

	def dispatch BigDecimal evaluate(IntegerExp v) {
		return new BigDecimal(v.value.toString())
	}

	def dispatch BigDecimal evaluate(Plus exp) {
		return exp.left.evaluate.add(exp.right.evaluate)
	}

	def dispatch BigDecimal evaluate(Minus exp) {
		return exp.left.evaluate.subtract(exp.right.evaluate)
	}

	def dispatch BigDecimal evaluate(Div exp) {
		return exp.left.evaluate.divide(exp.right.evaluate, RoundingMode.HALF_UP);
	}

	def dispatch BigDecimal evaluate(Neg exp) {
		return exp.exp.evaluate.negate
	}
	

	
//	@Check
//	def cycleValueMustBeBooleanExpression(SimControllerDef sc) {
//
//     //   val nameCycle = sc.const.n
//   
//
//		val bool = getBooleanType(sc.cycleDef)
//		val tcycle = sc.cycleDef?.typeFor
//		if (sc.cycleDef === null || !typeCompatible(tcycle, bool)
//		){
//			error('''Controller «sc.name» cycle must be a boolean expression.''',
//				RoboSimPackage.Literals.SIM_CONTROLLER_DEF__CYCLE_DEF, 
//				CYCLE_MUST_BE_BOOLEAN_EXPRESSION)
//		}
//	}
//	
//
//	@Check
//	def cycleValueMustBeBooleanExpression(SimModule sm) {
//		
//		val bool = getBooleanType(sm.cycleDef)
//		val tcycle = sm.cycleDef?.typeFor
//		if (sm.cycleDef === null  || !(typeCompatible(tcycle, bool))
//		){
//			error('''The constant cycleDef in Module «sm.name» must be a boolean expression.''',
//				RoboSimPackage.Literals.SIM_MODULE__CYCLE_DEF, 
//				CYCLE_MUST_BE_BOOLEAN_EXPRESSION)
//		}
//	}
	
	def missingInterfaces(ControllerDef c, Function<Context, EList<Interface>> f,
		Consumer<EList<Interface>> callOnMissing) {
		val machinesInterfaces = c.machines.map[it.mountInterfaces(f)].flatten
		val missingInterfaces = new HashSet<Interface>()
		val controllerInterfaces = f.apply(c)
		machinesInterfaces.forEach [
			if (!controllerInterfaces.contains(it)) {
				missingInterfaces.add(it)
			}
		]

		if (!missingInterfaces.empty) {
			callOnMissing.accept(new BasicEList(missingInterfaces))
		}
	}

//	@Check
//	def missingRequiredInterface(ControllerDef c) {
//		c.missingInterfaces([it.RInterfaces], [
//			error(
//				'''The controller «c.name» is missing the required interfaces: «it.map[it.name].join(", ")».''',
//				RoboChartPackage.Literals.CONTEXT__RINTERFACES,
//				MISSING_REQUIRED_INTERFACE
//			)
//		])
//	}

	@Check
	def missingDeclaredInterface(ControllerDef c) {
		c.missingInterfaces([it.interfaces], [
			error(
				'''The controller «c.name» is missing the declared interfaces: «it.map[it.name].join(", ")».''',
				RoboChartPackage.Literals.CONTEXT__INTERFACES,
				MISSING_DECLARED_INTERFACE
			)
		])
	}

	@Check
	def outputInterfaceMustHaveOnlyEventsAndOperations(SimMachineDef sm) {
		sm.outputContext.interfaces.forEach [
			if (it.variableList.size > 0) {
				error('''Output interface «it.name» of SimMachine «sm.name» must have only events and operations.''',
					RoboSimPackage.Literals.SIM_MACHINE_DEF__OUTPUT_CONTEXT,
					OUTPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS_AND_OPERATIONS)
					return
				}
			]
		}
		
		
		
	

		@Check
		def inputInterfaceMustHaveOnlyEvents(SimMachineDef sm) {
			sm.inputContext.interfaces.forEach [
				if (it.variableList.size > 0 || it.operations.size > 0) {
					error('''Input interface «it.name» of SimMachine «sm.name» must have only events.''',
						RoboSimPackage.Literals.SIM_MACHINE_DEF__INPUT_CONTEXT, INPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS)
					return
				}
			]
		}


//      @Check
//		def requiredInterfacesHaveOnlyInputsOutputs(SimMachineDef sm) {
////			sm.RVars.forEach[
////				if (it.v){
////					error('''Required variables can be inputs or outputs «it.name» of SimMachine «sm.name» must have only events.''',
////						RoboSimPackage.Literals.SIM_MACHINE_DEF__INPUT_CONTEXT, INPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS)
////					return
////				}
////			]
//			sm.RInterfaces.forEach [
//				if (it.variableList.size > 0){
//					error('''Required variables must be an input or output. «it.name» of SimMachine «sm.name» .''',
//						//RoboSimPackage.Literals.REQUIRED_VARIABLE__VARIABLE, INPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS)
//						RoboChartPackage.Literals.CONTEXT__RINTERFACES, INPUT_INTERFACE_MUST_HAVE_ONLY_EVENTS)
//					return
//				}
//			]
//			
//			
//		}

		@Check
		override def transitionWellTyped(Transition t) {
			val bool = getBooleanType(t)
			// The typeFor is an injected method and is required in RoboSim for condition with the Feedback Expression
			// If this method is removed, or its superclass method is called, the typeFor won't use RoboSim's injected typeFor.
			val tcond = t.condition?.typeFor
			if (t.condition != null && !typeCompatible(tcond, bool)) {
				val msg = 'Transition condition should have type boolean, but ' + (if (tcond == null)
					'actual type could not be computed'
				else
					'actual type is ' )
				error(
					msg,
					RoboChartPackage.Literals.TRANSITION__CONDITION,
					'TransitionConditionTypeError'
				)
			}
		}

		def directionsError(Connection conn, EReference r) {
			error(
				'''Connection from «conn.from.name» on «conn.efrom.name» to «conn.to.name» on «conn.eto.name» should be in the opposite direction.''',
				r,
				INCORRECT_CONNECTION_DIRECTION
			)
		}

		def dispatch void checkConnectionDirection(Connection conn, Controller from, Event efrom, StateMachine to,
			Event eto) {
			if (!to.declaredInputEvents.contains(eto)) {
				conn.directionsError(RoboChartPackage.Literals.CONNECTION__ETO)
			}
		}

		def dispatch void checkConnectionDirection(Connection conn, RoboticPlatform from, Event efrom, ControllerDef to,
			Event eto) {
			val conns = to.connections.filter[it.from.equals(to) && it.efrom.equals(eto)]
			conns.forEach[it.checkConnectionDirection(it.from, it.efrom, it.to, it.eto)]
		}

		def dispatch void checkConnectionDirection(Connection conn, RoboticPlatform from, Event efrom, ControllerRef to,
			Event eto) {
			conn.checkConnectionDirection(from, efrom, to.ref, eto)
		}

		def dispatch void checkConnectionDirection(Connection conn, StateMachine from, Event efrom, Controller to,
			Event eto) {
			if (!from.declaredOutputEvents.contains(efrom)) {
				conn.directionsError(RoboChartPackage.Literals.CONNECTION__EFROM)
			}
		}

		def dispatch void checkConnectionDirection(Connection conn, ControllerDef from, Event efrom, RoboticPlatform to,
			Event eto) {
			val conns = from.connections.filter[it.to.equals(from) && it.eto.equals(efrom)]
			conns.forEach[it.checkConnectionDirection(it.from, it.efrom, it.to, it.eto)]
		}

		def dispatch void checkConnectionDirection(Connection conn, ControllerRef from, Event efrom, RoboticPlatform to,
			Event eto) {
			conn.checkConnectionDirection(from.ref, efrom, to, eto)
		}

		@Check
		def checkConnectionDirection(Connection conn) {
			conn.checkConnectionDirection(conn.from, conn.efrom, conn.to, conn.eto)
		}
		
		
//		 static class StateMachineExtensions {
//	    def name(StateMachine machine) {
//	    	(machine as SimMachineDef).name
//	    }
//	    
//	    def variables(StateMachine machine) {
//	    	(machine as SimMachineDef).variableList
//	    }
//	    
//	    def constantes(StateMachine machine) {
//	    	(machine as SimMachineDef).const
//	    }
//    
//    
//	    def transitions(StateMachine machine) {
//	    	(machine as SimMachineDef).transitions
//	    }
//    
//	    def nodes(StateMachine machine) {
//	    	(machine as SimMachineDef).nodes
//	    }
//    }

	override checkClockExpWellTyped(Expression e) {
		val nat = getNatType(e)
		val real = getRealType(e)

		if (e.eContainer !== null && e.eContainer instanceof Expression) {
			var parent = e.eContainer
			var isTypeCompatible = false

			switch parent {
				LessThan: {
					isTypeCompatible = if (parent.left === e) {
						var compareType = parent.right.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					} else {
						var compareType = parent.left.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					}
				}
				LessOrEqual: {
					isTypeCompatible = if (parent.left === e) {
						var compareType = parent.right.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					} else {
						var compareType = parent.left.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					}
				}
				GreaterThan: {
					isTypeCompatible = if (parent.left === e) {
						var compareType = parent.right.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					} else {
						var compareType = parent.left.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					}
				}
				GreaterOrEqual: {
					isTypeCompatible = if (parent.left === e) {
						var compareType = parent.right.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					} else {
						var compareType = parent.left.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					}
				}
				Equals: {
					isTypeCompatible = if (parent.left === e) {
						var compareType = parent.right.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					} else {
						var compareType = parent.left.typeFor
						if (compareType !== null)
							typeCompatible(compareType, nat) || typeCompatible(compareType, real)
						else
							false
					}
				}
				default:
					error('Unsupported use of timed expression', null, 'TimeExpressionNotSupported', 'timed')
			}
			if (!isTypeCompatible) {
				error('Timed expression being compared should be of type nat or real', null, 'TimeExpressionTypeError',
					'timed')
			}
		} else {
			error('Unsupported use of timed expression', null, 'TimeExpressionNotSupported', 'timed')
		}
	}
	
	override variableInitWellTyped(Variable v) {
		if (v.initial !== null) {
			val t1 = v.initial.typeFor
			val t2 = v.type
			if (!typeCompatible(t1, t2)) {
				val parent = if (v.eContainer.eContainer instanceof NamedElement)
						(v.eContainer.eContainer as NamedElement).
							name
					else
						null
				val msg = '''Variable «v.name» «(if(parent !== null) 'in ' + parent else '')» expects type «v.type.printType», but «IF t1 === null»expression cannot be typed.«ELSE»expression has type «t1.printType»«ENDIF»'''

				error(
					msg,
					RoboChartPackage.Literals.VARIABLE__INITIAL,
					'VarInitType'
				)
			}
		}
	}
	
	
	//mscf added
	override Context getContext(ConnectionNode cn) {
		if (cn instanceof SimMachineDef)
			return cn as SimMachineDef
		else if (cn instanceof SimControllerDef)
			return cn as SimControllerDef
		else if (cn instanceof RoboticPlatformDef)
			return cn as RoboticPlatformDef
		else if (cn instanceof StateMachineRef)
			return cn.ref
		else if (cn instanceof ControllerRef)
			return cn.ref
		else if (cn instanceof RoboticPlatformRef)
			return cn.ref
	}
	
	

	override wfcCn_EventsFromSameContext(Connection c) {
		var cont = c.eContainer
		/* Cn1 (approximation via to/from) */
		if (cont instanceof RCModule) {
			if (!(cont.nodes.contains(c.to) && cont.nodes.contains(c.from))) {
				error('Cn1: Connections of a module must associate only its robotic platform and its controllers',
					RoboChartPackage.Literals.CONNECTION__EFROM, 
					'NodesNotFromSameModule')
			}
		}
			
		/* Cn3 (approximation via to/from) */
		if (cont instanceof ControllerDef) {
			var nodes = new LinkedList<ConnectionNode>
			nodes.add(cont) 
			nodes.addAll(cont.machines)
			if (!(nodes.contains(c.to) && nodes.contains(c.from))) {
				error('Cn3: Connections of a controller must associate only itself and its state machines',
					RoboChartPackage.Literals.CONNECTION__EFROM, 
					'NodesNotFromSameController')
			}
		}
		 
		/* Cn10 */
		// identify context and collect set of events of this context for to/from
		val toEvents = new LinkedList<Event>()
		toEvents.addAll(getContext(c.to).events)
		getContext(c.to).interfaces.forEach[i | toEvents.addAll(i.events)]
		// check whether eto is in this list
		
		if (getContext(c.to) instanceof SimMachineDef) {
			toEvents.addAll((getContext(c.to) as SimMachineDef).inputContext.events)
			toEvents.addAll((getContext(c.to) as SimMachineDef).outputContext.events)
			(getContext(c.to) as SimMachineDef).inputContext.interfaces.forEach[i | toEvents.addAll(i.events)]
		    (getContext(c.to) as SimMachineDef).outputContext.interfaces.forEach[i | toEvents.addAll(i.events)]
		}
		
		if (!toEvents.contains(c.eto)) {
			error('Cn10: The eto-event of a connection must be an event of its to-node',
				RoboChartPackage.Literals.CONNECTION__ETO, 
				'ToEventFromForeignContext')
		}
		val fromEvents = new LinkedList<Event>()
		fromEvents.addAll(getContext(c.from).events)
		getContext(c.from).interfaces.forEach[i | fromEvents.addAll(i.events)]
		// check whether efrom is in this list
		if (getContext(c.from) instanceof SimMachineDef) {
			fromEvents.addAll((getContext(c.from) as SimMachineDef).inputContext.events)
			fromEvents.addAll((getContext(c.from) as SimMachineDef).outputContext.events)
			(getContext(c.from) as SimMachineDef).inputContext.interfaces.forEach[i | fromEvents.addAll(i.events)]
		    (getContext(c.from) as SimMachineDef).outputContext.interfaces.forEach[i | fromEvents.addAll(i.events)]
		}
		
		if (!fromEvents.contains(c.efrom)) {
			error('Cn10: The efrom-event of a connection must be an event of its from-node',
				RoboChartPackage.Literals.CONNECTION__EFROM, 
				'FromEventFromForeignContext')
		}
	}
	
}
