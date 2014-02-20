package au.org.ala.biocache.hubs

import org.codehaus.groovy.grails.web.json.JSONObject


class SearchService {

    def httpWebService, grailsApplication

    def JSONObject fullTextSearch(SpatialSearchRequestParams requestParams) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrences/search?${requestParams.getEncodedParams()}"
        httpWebService.getJson(url)
    }

    def resultsHaveImages(JSONObject searchResults) {
        Boolean hasImages = false
        searchResults.facetResults.each { fr ->
            if (fr.fieldName == "multimedia") {
                fr.fieldResult.each {
                    if (it.label =~ /(?i)image/) {
                        hasImages = true
                    }
                }
            }
        }
        hasImages
    }

    def JSONObject getRecord(String id) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrence/${id.encodeAsURL()}"
        httpWebService.getJson(url)
    }

    def JSONObject getCompareRecord(String id) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrence/compare?uuid=${id.encodeAsURL()}"
        httpWebService.getJson(url)
    }
}
