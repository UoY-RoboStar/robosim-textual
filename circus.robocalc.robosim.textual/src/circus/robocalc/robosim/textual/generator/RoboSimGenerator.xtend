/*
 * generated by Xtext 2.17.1
 */
package circus.robocalc.robosim.textual.generator

import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.ISafeRunnable
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.SafeRunner
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * This class searches for all robochart generators provided by plugins,
 * and executes them on each resource. It generates code from your
 * model files on save.
 * 
 * New generators can be implemented by contributing a subclass of
 * {@link AbstractRoboChartGenerator} to the extension point
 * {@code robosim.generator}.
 * 
 * @author Alvaro Miyazawa 
 * @version 2.0
 * @since 11.0
 * @see AbstractRoboChartGenerator
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class RoboSimGenerator extends AbstractGenerator {

	static val GEN_ID = "circus.robocalc.robosim.textual.robosim.generator"

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val config = Platform.extensionRegistry.getConfigurationElementsFor(GEN_ID);
		try {
			for (e : config) {
				val o = e.createExecutableExtension("class")
				if (o instanceof IAbstractRoboSimGenerator && o instanceof AbstractGenerator) {
					// executing generator
					val runnable = new ISafeRunnable() {
						override void handleException(Throwable e) {
							System.err.println(e.message)
						}

						override void run() throws Exception {
							(o as AbstractGenerator).doGenerate(resource, fsa, context)
						}
					}
					SafeRunner.run(runnable)
				}
			}
		} catch (CoreException ex) {
			System.err.println(ex.message)
		}
	}
}