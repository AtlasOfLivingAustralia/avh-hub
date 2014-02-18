package au.org.ala.biocache.hubs

import org.codehaus.groovy.grails.web.json.JSONObject

class OccurrenceController {

    def searchService, authService

    def index() {
        redirect action: "search"
    }

    def search(SpatialSearchRequestParams requestParams) {
        if (!params.pageSize) {
            requestParams.pageSize = 20
        }

        if (!params.sort && !params.dir) {
            requestParams.sort = "first_loaded_date"
            requestParams.dir = "desc"
        }

        JSONObject searchResults = searchService.fullTextSearch(requestParams)
        // log.info "searchResults = ${searchResults.toString(2)}"
        log.info "userid = ${authService.getUserId()}"

        render view: "list", model: [
                sr: searchResults,
                searchRequestParams: requestParams,
                hasImages: searchService.resultsHaveImages(searchResults),
                sort: requestParams.sort,
                dir: requestParams.dir,
                userId: authService.getUserId(),
                userEmail: authService.getEmail()
        ]
    }

    def searchJson (SpatialSearchRequestParams requestParams) {
        render searchService.fullTextSearch(requestParams)
    }
}
