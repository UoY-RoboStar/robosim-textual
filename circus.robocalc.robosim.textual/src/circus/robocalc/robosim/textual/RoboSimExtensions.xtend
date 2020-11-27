package circus.robocalc.robosim.textual

import circus.robocalc.robochart.Action
import circus.robocalc.robochart.Controller
import circus.robocalc.robochart.ControllerDef
import circus.robocalc.robochart.ControllerRef
import circus.robocalc.robochart.Event
import circus.robocalc.robochart.Junction
import circus.robocalc.robochart.OperationSig
import circus.robocalc.robochart.RCModule
import circus.robocalc.robochart.State
import circus.robocalc.robochart.StateMachine
import circus.robocalc.robochart.StateMachineBody
import circus.robocalc.robochart.StateMachineDef
import circus.robocalc.robochart.StateMachineRef
import circus.robocalc.robochart.Statement
import circus.robocalc.robochart.Transition
import circus.robocalc.robosim.SimControllerDef
import circus.robocalc.robosim.SimMachineDef
import circus.robocalc.robosim.SimModule
import java.util.function.Function
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import circus.robocalc.robosim.SimContext

class RoboSimExtensions {
	/*
	def static Interface resolvedInterface(SimMachineInterface smIntf) {
		if (smIntf.interface !== null) {
			return smIntf.interface
		}
		if (smIntf.ref !== null) {
			return smIntf.ref;
		}
		return null
	}
	*  
	*/
	def dispatch StateMachineDef stateMachine(EObject context) {
		throw new UnhandledCaseException(context.class)
	} 
	def dispatch StateMachineDef stateMachine(Action context) {
		context.eContainer.stateMachine
	} 
	def dispatch StateMachineDef stateMachine(StateMachineDef stateMachine) {
		stateMachine
	}
	def dispatch StateMachineDef stateMachine(StateMachineRef context) {
		context.ref.stateMachine
	}
	def dispatch StateMachineDef stateMachine(StateMachineBody context) {
		context.eContainer.stateMachine
	}
	def dispatch StateMachineDef stateMachine(Junction context) {
		context.eContainer.stateMachine
	}
	def dispatch StateMachineDef stateMachine(State context) {
		context.eContainer.stateMachine
	}
	def dispatch StateMachineDef stateMachine(Statement context) {
		context.eContainer.stateMachine
	}
	def dispatch StateMachineDef stateMachine(Transition context) {
		context.eContainer.stateMachine
	}
	def static <T1, T2, R> castSafe(T1 el, Class<T2> c, Function<T2, R> f) {
		if (c.isAssignableFrom(el.class)) {
			f.apply(el as T2)
		} else null
	}
	
	def static <T,R> nullSafe(T el, Function<T,R> f) {
		if (el === null) {
			null
		} else {
			f.apply(el)
		}
	}
	
	def static <T,R> nullSafe(T el, Function<T,R> f, R defR) {
		if (el === null) {
			defR
		} else {
			f.apply(el)
		}
	}
	
	def dispatch EList<Event> declaredInputEvents(RCModule context) {
		val EList<Event> evs = new BasicEList<Event>();
		context.nodes.filter(Controller).forEach[evs.addAll(it.declaredInputEvents)]
		return evs
	}
	
	def dispatch EList<Event> declaredInputEvents(EObject context) {
		throw new UnhandledCaseException(context.class)
	}
	
	def dispatch EList<Event> declaredInputEvents(Transition context) {
		context.stateMachine.declaredInputEvents
	}
	
	def dispatch EList<Event> declaredInputEvents(State context) {
		context.stateMachine.declaredInputEvents
	}
	
	def dispatch EList<Event> declaredInputEvents(Junction context) {
		context.stateMachine.declaredInputEvents
	}

	def dispatch EList<Event> declaredInputEvents(ControllerDef context) {
		val EList<Event> evs = new BasicEList<Event>();
		context.machines.forEach[evs.addAll(it.declaredInputEvents)];
		return evs;		
	}
	
	def dispatch EList<Event> declaredInputEvents(SimControllerDef context) {
		val EList<Event> evs = new BasicEList<Event>();
		context.machines.forEach[evs.addAll(it.declaredInputEvents)];
		return evs;		
	}
	
	def dispatch EList<Event> declaredInputEvents(ControllerRef context) {
		context.ref.declaredInputEvents
	}
	

	def dispatch EList<Event> declaredInputEvents(StateMachineRef context) {
		context.ref.declaredInputEvents
	}
	def dispatch EList<Event> declaredInputEvents(SimMachineDef context) {
		val evs = new BasicEList<Event>();
		evs.addAll(context.inputContext.events)
		context.inputContext.interfaces.forEach[evs.addAll(it.events)]
		return evs;
	}
	
	def dispatch EList<Event> declaredOutputEvents(StateMachineRef context) {
		context.ref.declaredOutputEvents
	}
	def dispatch EList<Event> declaredOutputEvents(SimMachineDef context) {
		val evs = new BasicEList<Event>();
		evs.addAll(context.outputContext.events)
		context.outputContext.interfaces.forEach[evs.addAll(it.events)]
		return evs;
	}
	
	def dispatch EList<Event> declaredOutputEvents(EObject context) {
		null
	}
	
	def dispatch EList<Event> declaredOutputEvents(RCModule context) {
		val EList<Event> evs = new BasicEList<Event>();
		context.nodes.filter(Controller).forEach[evs.addAll(it.declaredOutputEvents)]
		return evs
	}
	
	def dispatch EList<Event> declaredOutputEvents(ControllerRef context) {
		context.ref.declaredOutputEvents
	}
	def dispatch EList<Event> declaredOutputEvents(ControllerDef context) {
		val EList<Event> evs = new BasicEList<Event>();
		context.machines.forEach[evs.addAll(it.declaredOutputEvents)];
		return evs;		
	}
	
	def dispatch EList<Event> declaredOutputEvents(SimControllerDef context) {
		val EList<Event> evs = new BasicEList<Event>();
		context.machines.forEach[evs.addAll(it.declaredOutputEvents)];
		return evs;		
	}
	
	def dispatch EList<OperationSig> declaredOutputOperations(EObject context) {
		null
	}
	def dispatch EList<OperationSig> declaredOutputOperations(RCModule context) {
		val EList<OperationSig> ops = new BasicEList<OperationSig>();
		context.nodes.filter(Controller).forEach[ops.addAll(it.declaredOutputOperations)]
		return ops
	}
	
	def dispatch EList<OperationSig> declaredOutputOperations(ControllerRef context) {
		context.ref.declaredOutputOperations
	}
	def dispatch EList<OperationSig> declaredOutputOperations(ControllerDef context) {
		val EList<OperationSig> ops = new BasicEList<OperationSig>();
		context.machines.forEach[ops.addAll(it.declaredOutputOperations)];
		return ops;		
	}
	def dispatch EList<OperationSig> declaredOutputOperations(StateMachineRef context) {
		context.ref.declaredOutputOperations
	}
	def dispatch EList<OperationSig> declaredOutputOperations(SimMachineDef context) {
		val ops = new BasicEList<OperationSig>();
		ops.addAll(context.outputContext.operations);
		context.outputContext.interfaces.forEach[ops.addAll(it.operations)]
		context.outputContext.RInterfaces.forEach[ops.addAll(it.operations)]
		return ops;
	}
	
	
	//MSCF
	
	/*
	 * return 
	 */
	def dispatch EList<String> inputEvents(SimContext context) {
		//val EList<String> resInpEvs = new BasicEList<String>();
		
		//val names = new ArrayList<String>();
		val names = new BasicEList<String>();
		val evs = new BasicEList<Event>();
		evs.addAll(context.inputContext.events)
		context.inputContext.interfaces.forEach[evs.addAll(it.events)]
		for (ev : evs) {
			//var nm = context.name + "_";
			var nm = ev.name;
			names.add(nm);
		}
		
		//resInpEvs.addAll(names);
		return names;
	}
	
	def dispatch EList<String> inputEventsRS(SimContext context) {
		//val EList<String> resInpEvs = new BasicEList<String>();
		
		//val names = new ArrayList<String>();
		val names = new BasicEList<String>();
		val evs = new BasicEList<Event>();
		evs.addAll(context.inputContext.events)
		context.inputContext.interfaces.forEach[evs.addAll(it.events)]
		for (ev : evs) {
			//var nm = context.name + "_";
			var nm = ev.name;
			names.add(nm);
		}
		
		//resInpEvs.addAll(names);
		return names;
	}
	
	def dispatch EList<String> outputEventsRS(SimContext context) {
		//val EList<String> resInpEvs = new BasicEList<String>();
		
		//val names = new ArrayList<String>();
		val names = new BasicEList<String>();
		val evs = new BasicEList<Event>();
		evs.addAll(context.outputContext.events)
		context.outputContext.interfaces.forEach[evs.addAll(it.events)]
		for (ev : evs) {
			//var nm = context.name + "_";
			var nm = ev.name;
			names.add(nm);
		}
		
		//resInpEvs.addAll(names);
		return names;
	}
	
	def dispatch EList<String> outputEvents(SimContext context) {
		//val EList<String> resInpEvs = new BasicEList<String>();
		
		//val names = new ArrayList<String>();
		val names = new BasicEList<String>();
		val evs = new BasicEList<Event>();
		evs.addAll(context.outputContext.events)
		context.outputContext.interfaces.forEach[evs.addAll(it.events)]
		for (ev : evs) {
			//var nm = context.name + "_";
			var nm = ev.name;
			names.add(nm);
		}
		
		//resInpEvs.addAll(names);
		return names;
	}
	
	def dispatch EList<String> inputEvents(SimControllerDef context) {
		//val EList<String> resInpEvs = new BasicEList<String>();
		
		//val names = new ArrayList<String>();
		val names = new BasicEList<String>();
		val evs = new BasicEList<Event>();
		evs.addAll(context.declaredInputEvents)
		//context.inputContext.interfaces.forEach[evs.addAll(it.events)]
		for (ev : evs) {
			//var nm = context.name + "_";
			var nm = ev.name;
			names.add(nm);
		}
		
		//resInpEvs.addAll(names);
		return names;
	}
	
	
	def dispatch EList<String> datatypeInputsNames(SimMachineDef context) {
		val EList<String> inpEvs = inputEvents(context);
		val EList<String> res = new BasicEList<String>();
		
		for (ev : inpEvs) {
			//System.out.println(ev)
			val first = ev.substring(0,1)
			val sec = ev.substring(1,2).toUpperCase
			//System.out.println(first + "+" + sec)
			res.add(first + sec +"_"+context.name)
		
		}return res
	}
	
	def dispatch EList<String> datatypeInputsNames(SimControllerDef context) {
		//val EList<String> inpEvs = inputEvents(context);
		
		val EList<Event> evs = new BasicEList<Event>();
		context.machines.forEach[evs.addAll(it.declaredInputEvents)];
		val EList<String> res = new BasicEList<String>();
		
		for (ev : evs) {
			//System.out.println(ev)
			val first = ev.name.substring(0,1)
			val sec = ev.name.substring(1,2).toUpperCase
			//System.out.println(first + "+" + sec)
			res.add(first + sec+"_"+context.name)
		
		}return res
	}
	
	def dispatch EList<String> datatypeInputsNamesSched(SimControllerDef context) {
		//val EList<String> inpEvs = inputEvents(context);
		
		val EList<Event> evs = new BasicEList<Event>();
		context.machines.forEach[evs.addAll(it.declaredInputEvents)];
		val EList<String> res = new BasicEList<String>();
		
		for (ev : evs) {
			//System.out.println(ev)
			val first = ev.name.substring(0,1)
			val sec = ev.name.substring(1,2).toUpperCase
			//System.out.println(first + "+" + sec)
			res.add(first + sec)
		
		}return res
	}
	
		def dispatch EList<String> datatypeInputsNames(SimModule context) {
		
		val EList<Event> evs =  declaredInputEvents(context);
		
		val EList<String> res = new BasicEList<String>();
		
		for (ev : evs) {
			//System.out.println(ev)
			val first = ev.name.substring(0,1)
			val sec = ev.name.substring(1,2).toUpperCase
			//System.out.println(first + "+" + sec)
			res.add(first + sec)
		
		}return res
	}
	
	
      def dispatch EList<String> declaredOutputsEventsOperations(SimMachineDef context) {
		val EList<String> res = new BasicEList<String>();
		val EList<Event> outEvs = new BasicEList<Event>();
		val ops = new BasicEList<OperationSig>();
		
	    //get outputEvents
		outEvs.addAll(context.declaredOutputEvents);
		
		for (ev : outEvs) {
			var nm = context.name + "_" + ev.name  +".out";
			res.add(nm);
		}
		
		//get operations
		ops.addAll(context.declaredOutputOperations)
		
		//check if is necessary
		//context.nodes.filter(SimMachineDef).forEach[stm | stm.outputContext.interfaces.forEach[ops.addAll(it.operations)]]
		//context.nodes.filter(SimMachineDef).forEach[stm | stm.outputContext.RInterfaces.forEach[ops.addAll(it.operations)]]
		

		for (op : ops) {
			res.add(op.name+"Call");
		}
		
		return res;
	}
	
	     def dispatch EList<String> declaredOutputsEventsOperations(SimControllerDef context) {
		val EList<String> res = new BasicEList<String>();
		val EList<Event> outEvs = new BasicEList<Event>();
		val ops = new BasicEList<OperationSig>();
		
	    //get outputEvents
		outEvs.addAll(context.declaredOutputEvents);
		
		for (ev : outEvs) {
			var nm = context.name + "_" + ev.name  +".out";
			res.add(nm);
		}
		
		//get operations
		ops.addAll(context.declaredOutputOperations)
		
		//check if is necessary
		//context.nodes.filter(SimMachineDef).forEach[stm | stm.outputContext.interfaces.forEach[ops.addAll(it.operations)]]
		//context.nodes.filter(SimMachineDef).forEach[stm | stm.outputContext.RInterfaces.forEach[ops.addAll(it.operations)]]
		

		for (op : ops) {
			res.add(op.name+"Call");
		}
		
		return res;
	}
	
	
	  def dispatch EList<String> declaredOutputsEventsOperations(SimModule context) {
		val EList<String> res = new BasicEList<String>();
		val EList<Event> outEvs = new BasicEList<Event>();
		val ops = new BasicEList<OperationSig>();
		
	    //get outputEvents
		outEvs.addAll(context.declaredOutputEvents);
		
		for (ev : outEvs) {
			var nm = context.name + "_" + ev.name  +".out";
			res.add(nm);
		}
		
		//get operations
		ops.addAll(context.declaredOutputOperations)
		
		//check if is necessary
		//context.nodes.filter(SimMachineDef).forEach[stm | stm.outputContext.interfaces.forEach[ops.addAll(it.operations)]]
		//context.nodes.filter(SimMachineDef).forEach[stm | stm.outputContext.RInterfaces.forEach[ops.addAll(it.operations)]]
		

		for (op : ops) {
			res.add(op.name+"Call");
		}
		
		return res;
	}
	

}