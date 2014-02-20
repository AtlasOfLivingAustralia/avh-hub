package au.org.ala.biocache.hubs

import grails.converters.JSON
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

    def show(String id) {
        JSONObject record = searchService.getRecord(id)
        JSONObject compareRecord = searchService.getCompareRecord(id)

        render view: 'show', model: [
                record: record,
                compareRecord: compareRecord,
                skin: grailsApplication.config.sitemesh.skin?:grailsApplication.config.ala.skin
        ]
    }

    // JSON webservices for debugging/testing

    def searchJson (SpatialSearchRequestParams requestParams) {
        render searchService.fullTextSearch(requestParams)
    }

    def showJson (String id) {
        def combined = [:]
        combined.record = searchService.getRecord(id)
        combined.compareRecord = searchService.getCompareRecord(id)
        render combined as JSON
    }
}
