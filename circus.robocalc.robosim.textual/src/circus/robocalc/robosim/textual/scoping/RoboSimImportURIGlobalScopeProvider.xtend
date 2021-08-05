/********************************************************************************
 * Copyright (c) 2019 University of York and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Alvaro Miyazawa - initial definition
 ********************************************************************************/

package circus.robocalc.robosim.textual.scoping

import com.google.common.base.Predicate
import com.google.inject.Inject
import java.util.LinkedHashSet
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.DefaultGlobalScopeProvider
import org.eclipse.xtext.scoping.impl.ImportUriGlobalScopeProvider
import org.eclipse.xtext.scoping.impl.SimpleScope
import circus.robocalc.robochart.textual.scoping.RoboChartImportURIGlobalScopeProvider

class RoboSimImportURIGlobalScopeProvider extends RoboChartImportURIGlobalScopeProvider {
	public static final URI SCORE_URI = URI.createURI("platform:/plugin/circus.robocalc.robosim.textual/lib/robosim/score.rst");
	
	@Inject DefaultGlobalScopeProvider dgsp;
	
	override protected LinkedHashSet<URI> getImportedUris(Resource resource) {
		val importedURIs = super.getImportedUris(resource);
		importedURIs.add(SCORE_URI);
		return importedURIs;
	}
	
    override IScope getScope( Resource resource, EReference reference, Predicate<IEObjectDescription> filter ) {
        val s1 = super.getScope(resource, reference, filter)
        val s2 = dgsp.getScope(resource, reference, filter)
        return new SimpleScope(s1, s2.allElements)
        
    }
}