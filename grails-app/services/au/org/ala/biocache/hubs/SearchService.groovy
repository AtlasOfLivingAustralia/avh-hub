package au.org.ala.biocache.hubs

import grails.converters.JSON
import grails.plugin.cache.Cacheable
import org.codehaus.groovy.grails.web.converters.exceptions.ConverterException
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject


class SearchService {

    public static final String ENVIRONMENTAL = "Environmental"
    public static final String CONTEXTUAL = "Contextual"
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

    @Cacheable('collectoryCache')
    def JSONObject getCollectionInfo(String id) {
        def url = "${grailsApplication.config.collections.baseUrl}/lookup/summary/${id.encodeAsURL()}"
        httpWebService.getJson(url)
    }

    @Cacheable('spatialCache')
    def Map getLayersMetaData() {
        Map layersMetaMap = [:]
        def url = "${grailsApplication.config.spatial.baseURL}/layers.json"
        def jsonArray = getJsonArray(url)

        jsonArray.each {
            def subset = [:]
            subset.layerID = it.uid
            subset.layerName = it.name
            subset.layerDisplayName = it.displayname
            subset.value = null
            subset.classification1 = it.classification1
            subset.units = it.environmentalvalueunits

            if (it.type == ENVIRONMENTAL) {
                layersMetaMap.put("el" + it.uid.trim(), subset)
            } else if (it.type == CONTEXTUAL) {
                layersMetaMap.put("cl" + it.uid.trim(), subset)
            }
        }

        return layersMetaMap
    }

    private JSONArray getJsonArray(String url) {
        log.debug "(internal) getJson URL = " + url
        def conn = new URL(url).openConnection()
        //JSONObject.NULL.metaClass.asBoolean = {-> false}

        try {
            conn.setConnectTimeout(10000)
            conn.setReadTimeout(50000)
            def json = conn.content.text
            return JSON.parse(json)
        } catch (Exception e) {
            def error = "{'error': 'Failed to get json (array) from web service. ${e.getClass()} ${e.getMessage()} URL= ${url}.', 'exception': '${e}'}"
            log.error error
            return new JSONArray()
        }

    }
}
