/*
 * generated by Xtext 2.17.1
 */
package circus.robocalc.robosim.textual


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class RoboSimStandaloneSetup extends RoboSimStandaloneSetupGenerated {

	def static void doSetup() {
		new RoboSimStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
