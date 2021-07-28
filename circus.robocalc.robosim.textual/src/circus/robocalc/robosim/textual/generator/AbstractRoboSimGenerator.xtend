package circus.robocalc.robosim.textual.generator

import org.eclipse.xtext.generator.AbstractGenerator

abstract class AbstractRoboSimGenerator extends AbstractGenerator implements IAbstractRoboSimGenerator {
	override String getID();
}
