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

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

/**
 * Controller for occurrence searches and records
 */
class OccurrenceController {

    def webServicesService, postProcessingService, authService
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

        if (!params.q) {
            requestParams.q= "*:*"
        }

        Map defaultFacets = postProcessingService.getAllFacets(webServicesService.getDefaultFacets())
        String[] userFacets = postProcessingService.getFacetsFromCookie(request)
        String[] filteredFacets = postProcessingService.getFilteredFacets(defaultFacets)
        requestParams.facets = userFacets ?: filteredFacets

        JSONObject searchResults = webServicesService.fullTextSearch(requestParams)

        // log.info "searchResults = ${searchResults.toString(2)}"
        log.info "userid = ${authService.getUserId()}"

        render view: "list", model: [
                sr: searchResults,
                searchRequestParams: requestParams,
                defaultFacets: defaultFacets,
                groupedFacets: webServicesService.getGroupedFacets(),
                hasImages: postProcessingService.resultsHaveImages(searchResults),
                showSpeciesImages: false,
                sort: requestParams.sort,
                dir: requestParams.dir,
                userId: authService.getUserId(),
                userEmail: authService.getEmail()
        ]
    }

    def legend(){
       def legend = webServicesService.getText(grailsApplication.config.biocacheServicesUrl + "/webportal/legend?" + request.queryString)
       response.setContentType("application/json")
       render legend
    }

    /**
     * Display an occurrence record
     *
     * @param id
     * @return
     */
    def show(String id) {

        JSONObject record = webServicesService.getRecord(id)
        String userId = authService.getUserId()

        if (record) {
            JSONObject compareRecord = webServicesService.getCompareRecord(id)

            JSONObject collectionInfo = null
            if(record.processed.attribution.collectionUid){
                collectionInfo = webServicesService.getCollectionInfo(record.processed.attribution.collectionUid)
            }

            List groupedAssertions = postProcessingService.getGroupedAssertions(webServicesService.getUserAssertions(id), webServicesService.getQueryAssertions(id), userId)
            Map layersMetaData = webServicesService.getLayersMetaData()

            [
                    record: record,
                    uuid: id,
                    compareRecord: compareRecord,
                    groupedAssertions: groupedAssertions,
                    formattedImageSizes: postProcessingService.getImageFileSizeInMb(record.images),
                    collectionName: collectionInfo?.name,
                    collectionLogo: collectionInfo?.institutionLogoUrl,
                    collectionInstitution: collectionInfo?.institution,
                    environmentalSampleInfo: postProcessingService.getLayerSampleInfo(ENVIRO_LAYER, record, layersMetaData),
                    contextualSampleInfo: postProcessingService.getLayerSampleInfo(CONTEXT_LAYER, record, layersMetaData),
                    skin: grailsApplication.config.sitemesh.skin?:grailsApplication.config.ala.skin
            ]
        } else {
            flash.message = "No record found for id: ${id}"
        }
    }

    /**
     * Create combined assertions JSON web service from the user and quality assertion services
     * on biocache-service.
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
        render webServicesService.fullTextSearch(requestParams) as JSON
    }

    def showJson (String id) {
        def combined = [:]
        combined.record = webServicesService.getRecord(id)
        combined.compareRecord = webServicesService.getCompareRecord(id)
        render combined as JSON
    }
}
