package au.org.ala.biocache.hubs

import grails.converters.JSON
import grails.plugin.cache.Cacheable
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONElement
import org.codehaus.groovy.grails.web.json.JSONObject


class WebServicesService {

    public static final String ENVIRONMENTAL = "Environmental"
    public static final String CONTEXTUAL = "Contextual"
    def grailsApplication

    @Cacheable('biocacheCache')
    def JSONObject fullTextSearch(SpatialSearchRequestParams requestParams) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrences/search?${requestParams.getEncodedParams()}"
        getJsonElements(url)
    }

    @Cacheable('biocacheCache')
    def JSONObject getRecord(String id) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrence/${id.encodeAsURL()}"
        getJsonElements(url)
    }

    @Cacheable('biocacheCache')
    def JSONObject getCompareRecord(String id) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrence/compare?uuid=${id.encodeAsURL()}"
        getJsonElements(url)
    }

    @Cacheable('biocacheCache')
    def JSONArray getUserAssertions(String id) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrences/${id.encodeAsURL()}/assertions"
        getJsonElements(url)
    }

    @Cacheable('biocacheCache')
    def JSONArray getQueryAssertions(String id) {
        def url = "${grailsApplication.config.biocacheServicesUrl}/occurrences/${id.encodeAsURL()}/assertionQueries"
        getJsonElements(url)
    }

    @Cacheable('collectoryCache')
    def JSONObject getCollectionInfo(String id) {
        def url = "${grailsApplication.config.collections.baseUrl}/lookup/summary/${id.encodeAsURL()}"
        getJsonElements(url)
    }

    @Cacheable('spatialCache')
    def Map getLayersMetaData() {
        Map layersMetaMap = [:]
        def url = "${grailsApplication.config.spatial.baseURL}/layers.json"
        def jsonArray = getJsonElements(url)

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

    /**
     * Perform HTTP GET on a JSON web service
     *
     * @param url
     * @return
     */
    private JSONElement getJsonElements(String url) {
        log.debug "(internal) getJson URL = " + url
        def conn = new URL(url).openConnection()
        //JSONObject.NULL.metaClass.asBoolean = {-> false}

        try {
            conn.setConnectTimeout(10000)
            conn.setReadTimeout(50000)
            def json = conn.content.text
            return JSON.parse(json)
        } catch (Exception e) {
            def error = "Failed to get json (array) from web service (${url}). ${e.getClass()} ${e.getMessage()}, ${e}"
            log.error error
            return null
        }

    }
}
