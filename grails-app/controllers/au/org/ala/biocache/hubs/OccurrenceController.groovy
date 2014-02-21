package au.org.ala.biocache.hubs

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

class OccurrenceController {

    def searchService, authService
    def ENVIRO_LAYER = "el"
    def CONTEXT_LAYER = "cl"

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

        if (record) {
            JSONObject compareRecord = searchService.getCompareRecord(id)
            JSONObject collectionInfo = searchService.getCollectionInfo(record.processed.attribution.collectionUid)
            Map layersMetaData = searchService.getLayersMetaData()
            layersMetaData.each { key, value ->
                log.debug "key: ${key}"
                log.debug "value: ${value}"
            }

            [
                    record: record,
                    compareRecord: compareRecord,
                    collectionName: collectionInfo?.name,
                    collectionLogo: collectionInfo?.institutionLogoUrl,
                    collectionInstitution: collectionInfo?.institution,
                    environmentalSampleInfo: getLayerSampleInfo(ENVIRO_LAYER, record, layersMetaData),
                    contextualSampleInfo: getLayerSampleInfo(CONTEXT_LAYER, record, layersMetaData),
                    skin: grailsApplication.config.sitemesh.skin?:grailsApplication.config.ala.skin
            ]
        } else {
            flash.message = "No record found for id: ${id}"
        }
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

    private List getLayerSampleInfo(String layerType, JSONObject record, Map layersMetaData) {
        def sampleInfo = []

        if (record.processed[layerType]) {
            record.processed[layerType].each {
                String key = it.key.trim()
                String value = it.value.trim()

                if (layersMetaData.containsKey(key)) {
                    Map metaMap = layersMetaData.get(key)
                    metaMap.value = value
                    sampleInfo.add(metaMap)
                }
            }
        }

        return sampleInfo.sort{a,b -> (a.classification1 <=> b.classification1 ?: a.layerDisplayName <=> b.layerDisplayName)}
    }
}
