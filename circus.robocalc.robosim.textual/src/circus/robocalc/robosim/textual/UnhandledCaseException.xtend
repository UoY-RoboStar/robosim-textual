package circus.robocalc.robosim.textual

class UnhandledCaseException extends Exception {
	public new(Class<?> actual) {
		super('''Unhandled case for class «actual.name»''')
	}
	
}
