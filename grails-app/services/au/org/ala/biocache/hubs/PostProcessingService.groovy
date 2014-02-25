package au.org.ala.biocache.hubs

import grails.transaction.Transactional
import org.apache.commons.httpclient.HttpClient
import org.apache.commons.httpclient.methods.HeadMethod
import org.apache.commons.io.FileUtils
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

class PostProcessingService {
    def webServicesService

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

    /**
     * Get the assertions grouped by assertion code.
     *
     *  @see <a href="http://code.google.com/p/ala-hubs/source/browse/trunk/hubs-webapp/src/main/java/org/ala/hubs/util/AssertionUtils.java">
     *      http://code.google.com/p/ala-hubs/source/browse/trunk/hubs-webapp/src/main/java/org/ala/hubs/util/AssertionUtils.java
     *  </a>
     *
     * @param id
     * @param record
     * @param currentUserId
     * @return
     */
    def List getGroupedAssertions(JSONArray userAssertions, JSONArray queryAssertions, String currentUserId) {
        Map grouped = [:]

        // Closure to call for both user and query assertions
        def withEachAssertion = { qa ->
            if (!(qa.containsKey('code') || qa.containsKey('assertionType'))) {
                log.error "Assertion is missing required fields/keys: code || assertionType: ${qa}"
                return false
            }
            log.debug "assertion (qa) = ${qa}"
            def a = grouped.get(qa.code ?: qa.assertionType) // multiple assertions with same same code are added as a list to the map via its code

            if (!a) {
                a = qa
                a.name = qa.name ?: qa.assertionType
                a.users = []
                grouped.put(qa.code ?: qa.assertionType, a)
            }

            //add the extra users who have made the same assertion
            Map u = [:]
            u.email = qa.userId ?: qa.userEmail
            u.displayname = qa.userDisplayName ?: qa.userName
            a.users.add(u) // add to list of users for this assertion

            if (currentUserId && currentUserId == qa.userId) {
                a.assertionByUser = true
                a.usersAssertionUuid = qa.uuid
            }
        }

        userAssertions.each {
            withEachAssertion(it)
        }

        queryAssertions.each {
            withEachAssertion(it)
        }

        List groupedValues = []
        groupedValues.addAll(grouped.values())
        groupedValues.sort { a, b ->
            a.name <=> b.name
        }

        //log.debug "groupedValues = ${groupedValues}"
        return groupedValues
    }

    /**
     *
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

    /**
     * Generate a Map of image url (key) with image file size (like ls -h) (value)
     *
     * @param images
     * @return
     */
    def Map getImageFileSizeInMb(JSONArray images) {
        Map imageSizes = [:]

        images.each { image ->
            //log.debug "image = ${image}"
            String originalImageUrl = image.alternativeFormats?.imageUrl
            if (originalImageUrl) {
                Long imageSizeInBytes = getImageSizeInBytes(originalImageUrl)
                String formattedImageSize = FileUtils.byteCountToDisplaySize(imageSizeInBytes)
                imageSizes.put(originalImageUrl, formattedImageSize)
            }
        }

        imageSizes
    }

    /**
     * Use HTTP HEAD to determine the file size of a URL (image)
     *
     * @param imageURL
     * @return
     * @throws Exception
     */
    private Long getImageSizeInBytes(String imageURL) throws Exception {
        HttpClient httpClient = new HttpClient()
        HeadMethod headMethod = new HeadMethod(imageURL)
        httpClient.executeMethod(headMethod)
        String lengthString = headMethod.getResponseHeader("Content-Length").getValue()
        return Long.parseLong(lengthString)
    }
}
