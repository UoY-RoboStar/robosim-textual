package circus.robocalc.robosim.textual.scoping

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import circus.robocalc.robochart.textual.scoping.RoboChartImportedNamespaceAwareLocalScopeProvider

class RoboSimImportedNamespaceAwareLocalScopeProvider extends RoboChartImportedNamespaceAwareLocalScopeProvider {
	override getImplicitImports(boolean ignoreCase) {
		var alist = super.getImplicitImports(ignoreCase)
		alist.add(new ImportNormalizer(
			QualifiedName.create("robosim__core"),
			true,
			ignoreCase
		))
		return alist
	}
}