package au.org.ala.biocache.hubs.avh

import au.org.ala.biocache.hubs.AvhAdvancedSearchParams

/**
 * Home controller for AVH
 */
class HomeController extends au.org.ala.biocache.hubs.HomeController {
    def webServicesService

    def index() throws Exception {
        log.debug "Home controller index page"
        addCommonModel()
    }

    def advancedSearch(AvhAdvancedSearchParams requestParams) {
        HomeController.log.debug "AVH Home controller advancedSearch page"
        //flash.message = "Advanced search for: ${requestParams.toString()}"
        redirect(controller: "occurrences", action:"search", params: requestParams.toParamMap())
    }

    private Map addCommonModel() {
        def model = [:]
        List allStates = []

        facetsCacheService.facetsList.each { fn ->
            log.debug "Getting facet: ${fn}"
            model.put(fn, facetsCacheService.getFacetNamesFor(fn))
        }

        loadStateValues().each { String key, Map value ->
            log.debug "Getting state: ${key} | ${value}"
            model.put(key, value)
            allStates << value.keySet() as ArrayList
        }

        model.put("skipStates", allStates.flatten()) // allStates is a nested list - we want a flat list

        model
    }

    /**
     * Get list of states for AU and NZ (used by AVH)
     */
    Map loadStateValues() {
       def (Map facetsMap, Map statesMapAu, Map statesMapNZ) = [[:],[:],[:]]

        // massage into same format as facet values (above)
        webServicesService.getStates("Australia").each {
            statesMapAu.put(it, it)
        }
        webServicesService.getStates("New Zealand").each {
            statesMapNZ.put(it, it)
        }

        facetsMap.put("statesAU", statesMapAu)
        facetsMap.put("statesNZ", statesMapNZ)

        facetsMap
    }
}
