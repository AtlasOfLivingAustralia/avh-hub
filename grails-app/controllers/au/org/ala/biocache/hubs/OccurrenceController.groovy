package au.org.ala.biocache.hubs

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

/**
 * Controller for occurrence searches and records
 */
class OccurrenceController {

    def webServicesService, authService
    def ENVIRO_LAYER = "el"
    def CONTEXT_LAYER = "cl"

    def index() {
        redirect action: "search"
    }

    /**
     * Perform a full text search
     *
     * @param requestParams
     * @return
     */
    def search(SpatialSearchRequestParams requestParams) {
        if (!params.pageSize) {
            requestParams.pageSize = 20
        }

        if (!params.sort && !params.dir) {
            requestParams.sort = "first_loaded_date"
            requestParams.dir = "desc"
        }

        JSONObject searchResults = webServicesService.fullTextSearch(requestParams)
        // log.info "searchResults = ${searchResults.toString(2)}"
        log.info "userid = ${authService.getUserId()}"

        render view: "list", model: [
                sr: searchResults,
                searchRequestParams: requestParams,
                hasImages: webServicesService.resultsHaveImages(searchResults),
                sort: requestParams.sort,
                dir: requestParams.dir,
                userId: authService.getUserId(),
                userEmail: authService.getEmail()
        ]
    }

    /**
     * Display an occurrence record
     *
     * @param id
     * @return
     */
    def show(String id) {

        JSONObject record = webServicesService.getRecord(id)

        if (record) {
            JSONObject compareRecord = webServicesService.getCompareRecord(id)
            JSONObject collectionInfo = webServicesService.getCollectionInfo(record.processed.attribution.collectionUid)
            Map layersMetaData = webServicesService.getLayersMetaData()

            [
                    record: record,
                    uuid: id,
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

    /**
     * Create combined asssertions JSON web service from the user and quality assertion services
     * on biocahce-service.
     * Note: mapped to URL: /assertions/$id to avoid CAS cookie check
     *
     * @param id
     * @return
     */
    def assertions(String id) {
        JSONArray userAssertions = webServicesService.getUserAssertions(id)
        JSONArray qualityAssertions = webServicesService.getQueryAssertions(id)
        Map combined = [userAssertions: userAssertions?:[], assertionQueries: qualityAssertions?:[]]

        render combined as JSON
    }

    /*
     * JSON webservices for debugging/testing
     */
    def searchJson (SpatialSearchRequestParams requestParams) {
        render webServicesService.fullTextSearch(requestParams)
    }

    def showJson (String id) {
        def combined = [:]
        combined.record = webServicesService.getRecord(id)
        combined.compareRecord = webServicesService.getCompareRecord(id)
        render combined as JSON
    }

    /*
     * Private utility methods
     */
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
