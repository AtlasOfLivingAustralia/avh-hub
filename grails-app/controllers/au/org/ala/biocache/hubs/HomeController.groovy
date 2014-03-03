/*
 * Copyright (C) 2014 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */

package au.org.ala.biocache.hubs

class HomeController {

    def facetsCacheService

    def index() {
        log.debug "Home controller index page"
        addCommonModel()
    }

    def advancedSearch(AdvancedSearchParams requestParams) {
        log.debug "Home controller advancedSearch page"
        //redirect(controller: "occurrence", action:"search", params: requestParams.toParamMap())
        redirect(url: "/occurrences/search?${requestParams.toString()}")
    }
    
    private Map addCommonModel() {
        def model = [:]

        FacetsName.values().each { fn ->
            model.put(fn.fieldname, facetsCacheService.getFacetNamesFor(fn))
        }

//        model.put("collections", facetsCacheService.getCollections())
//        model.put("institutions", facetsCacheService.getInstitutions())
//        model.put("typeStatus", facetsCacheService.getTypeStatuses())
//        model.put("basisOfRecord", facetsCacheService.getBasisOfRecord())
//        model.put("speciesGroups", facetsCacheService.getSpeciesGroups())
//        model.put("loanDestinations", facetsCacheService.getLoanDestination())
//        model.put("cultivationStatus", facetsCacheService.getEstablishment_means())
//        model.put("stateConservations", facetsCacheService.getStateConservations())
//        model.put("states", facetsCacheService.getStates())
//        model.put("ibra", facetsCacheService.getIBRA())
//        model.put("imcra", facetsCacheService.getIMCRA())
//        model.put("imcraMeso", facetsCacheService.getIMCRA_MESO())
//        model.put("countries", facetsCacheService.getCountries())
//        model.put("lgas", facetsCacheService.getLGAs())

        model
    }
}
