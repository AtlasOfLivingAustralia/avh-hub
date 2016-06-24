package au.org.ala.biocache.hubs.avh

import au.org.ala.biocache.hubs.AvhAdvancedSearchParams

/**
 * Home controller for AVH
 */
class HomeController extends au.org.ala.biocache.hubs.HomeController {

    def advancedSearch(AvhAdvancedSearchParams requestParams) {
        HomeController.log.debug "AVH Home controller advancedSearch page"
        //flash.message = "Advanced search for: ${requestParams.toString()}"
        redirect(controller: "occurrences", action:"search", params: requestParams.toParamMap())
    }
}
