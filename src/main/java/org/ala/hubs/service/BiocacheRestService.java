/* *************************************************************************
 *  Copyright (C) 2011 Atlas of Living Australia
 *  All Rights Reserved.
 * 
 *  The contents of this file are subject to the Mozilla Public
 *  License Version 1.1 (the "License"); you may not use this file
 *  except in compliance with the License. You may obtain a copy of
 *  the License at http://www.mozilla.org/MPL/
 * 
 *  Software distributed under the License is distributed on an "AS
 *  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 *  implied. See the License for the specific language governing
 *  rights and limitations under the License.
 ***************************************************************************/

package org.ala.hubs.service;

import au.org.ala.biocache.ErrorCode;
import au.org.ala.biocache.QualityAssertion;
import au.org.ala.util.DuplicateRecordDetails;

import com.googlecode.ehcache.annotations.Cacheable;
import org.ala.biocache.dto.SearchRequestParams;
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.SpatialSearchRequestParams;
import org.ala.biocache.dto.store.OccurrenceDTO;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.client.RestOperations;

import javax.inject.Inject;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Implementation of BiocacheService.java that calls the biocache-service application
 * via JSON REST web services.
 * 
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Component("biocacheRestService")
public class BiocacheRestService implements BiocacheService {
	
    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    /** URI prefix for biocache-service - should be overridden in properties file */
    protected String biocacheUriPrefix = "http://localhost:9999/biocache-service";
    /** A comma separated list of context to apply to the query - may be overridden in the properties file */
    protected String queryContext ="";
    /** The API key to use to add and delete assertions */
    protected String apiKey ="";
    
    private final static Logger logger = Logger.getLogger(BiocacheRestService.class);
    //The pattern to handle the case where a jsinURI contaisn {}
    protected Pattern restVariableSubPattern= Pattern.compile("\\{.*?\\}");
    
    /**
     * @see org.ala.hubs.service.BiocacheService#findByFulltextQuery(SearchRequestParams)
     */
    @Override
    @Deprecated
    public SearchResultDTO findByFulltextQuery(SearchRequestParams requestParams) {
        Assert.notNull(requestParams.getQ(), "query must not be null");
        addQueryContext(requestParams);
        SearchResultDTO searchResults = new SearchResultDTO();
 
        try {
            final String jsonUri = biocacheUriPrefix + "/occurrences/search?" + requestParams.toString();
            logger.info("Requesting: " + jsonUri);
            Matcher matcher = restVariableSubPattern.matcher(jsonUri);
            //Get a list of all the items that are surrounded by {} so that they can be added as parameters when getting the object
            List<String> variables = new ArrayList<String>();
            while(matcher.find()){
                variables.add(matcher.group());
            }            
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class,variables.toArray());
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }

        return searchResults;
    }

    /**
     * @see org.ala.hubs.service.BiocacheService#findByTaxonConcept(String, SearchRequestParams)
     */
    @Override
    public SearchResultDTO findByTaxonConcept(String guid, SearchRequestParams requestParams) {
        Assert.notNull(guid, "guid must not be null");
        //requestParams.setQ("taxonConceptID:" + guid);
        SearchResultDTO searchResults = new SearchResultDTO();

        return getSearchResultsForEntity(guid, requestParams, "/occurrences/taxon/");
    }

    /**
     * @see org.ala.hubs.service.BiocacheService#findByCollection(String, SearchRequestParams)
     */
    @Override
    public SearchResultDTO findByCollection(String uid, SearchRequestParams requestParams) {
        Assert.notNull(uid, "uid must not be null");

        return getSearchResultsForEntity(uid, requestParams, "/occurrences/collection/");
    }

    /**
     * Perform a webservice request for a ssearch for taxon, collection, institution, etc.
     *
     * @param uid
     * @param requestParams
     * @param occurrencesPath
     * @return
     */
    protected SearchResultDTO getSearchResultsForEntity(String uid, SearchRequestParams requestParams, String occurrencesPath) {
        addQueryContext(requestParams);
        SearchResultDTO searchResults = new SearchResultDTO();
        try {
            final URI jsonUri = new URI(biocacheUriPrefix + occurrencesPath + uid + "?" + requestParams.getEncodedParams());
            logger.debug("Entity Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }
        return searchResults;
    }

    protected void addQueryContext(SearchRequestParams requestParams){
        if(requestParams != null){
            requestParams.setQc(queryContext);
        }
    }
    
    /**
     * @see org.ala.hubs.service.BiocacheService#getRecordByUuid(String, String)
     */
    @Override
    public OccurrenceDTO getRecordByUuid(String uuid, String apiKey) {
        Assert.notNull(uuid, "uuid must not be null");
        OccurrenceDTO record = new OccurrenceDTO();
        String apiKeyParam = "";
        
        if (StringUtils.isNotBlank(apiKey)) {
            apiKeyParam = "?apiKey=" + apiKey;
        }

        try {
            final String jsonUri = biocacheUriPrefix + "/occurrence/" + uuid + apiKeyParam;
            logger.debug("Requesting: " + jsonUri);
            record = restTemplate.getForObject(jsonUri, OccurrenceDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }

        return record;
    }

    @Override
    public List<ErrorCode> getErrorCodes() {
        final String jsonUri = biocacheUriPrefix + "/assertions/codes";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, (new ArrayList<ErrorCode>()).getClass());
    }

    @Override
    public List<ErrorCode> getGeospatialCodes() {
        final String jsonUri = biocacheUriPrefix + "/assertions/geospatial/codes";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, (new ArrayList<ErrorCode>()).getClass());
    }

    @Override
    public List<ErrorCode> getTaxonomicCodes() {
        final String jsonUri = biocacheUriPrefix + "/assertions/taxonomic/codes";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, (new ArrayList<ErrorCode>()).getClass());
    }

    @Override
    public List<ErrorCode> getTemporalCodes() {
        final String jsonUri = biocacheUriPrefix + "/assertions/temporal/codes";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, (new ArrayList<ErrorCode>()).getClass());
    }

    @Override
    public List<ErrorCode> getMiscellaneousCodes() {
        final String jsonUri = biocacheUriPrefix + "/assertions/miscellaneous/codes";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, (new ArrayList<ErrorCode>()).getClass());
    }

    @Override
    public List<ErrorCode> getUserCodes() {
        final String jsonUri = biocacheUriPrefix + "/assertions/user/codes";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, (new ArrayList<ErrorCode>()).getClass());
    }

    @Override
    public boolean addAssertion(String recordUuid, String code, String comment, String userId, String userDisplayName) {

//        final String jsonUri = biocacheUriPrefix + "/occurrences/"+recordUuid+"/assertions/add";
//        logger.debug("Posting to: " + jsonUri);
//        restTemplate.postForLocation(jsonUri,qualityAssertion);       //, new HashMap<String, String>());

        final String uri = biocacheUriPrefix + "/occurrences/assertions/add";
        HttpClient h = new HttpClient();
        PostMethod m = new PostMethod(uri);
        try {
            m.setParameter("recordUuid", recordUuid);
            m.setParameter("code", code);
            m.setParameter("comment", comment);
            m.setParameter("userId", userId);
            m.setParameter("userDisplayName", userDisplayName);
            m.setParameter("apiKey", apiKey);
            int status = h.executeMethod(m);
            logger.debug("STATUS: " + status);
            if(status == 201){
                return true;
            } else {
                return false;
            }
        } catch (Exception e){
            logger.error(e.getMessage(), e);
            return false;
        }
    }

    @Override
    public boolean deleteAssertion(String recordUuid, String assertionUuid) {
        final String uri = biocacheUriPrefix + "/occurrences/assertions/delete";
        HttpClient h = new HttpClient();
        PostMethod m = new PostMethod(uri);
        try {
            m.setParameter("recordUuid", recordUuid);
            m.setParameter("assertionUuid", assertionUuid);
            m.setParameter("apiKey", apiKey);
            int status = h.executeMethod(m);
            logger.debug("STATUS: " + status);
            if(status == 201){
                return true;
            } else {
                return false;
            }
        } catch (Exception e){
            logger.error(e.getMessage(), e);
            return false;
        }
    }

    @Override
    public QualityAssertion[] getUserAssertions(String recordUuid) {
        //occurrences/0352f657-98fa-436e-81c8-28e54fe06d8c/assertions/
        final String jsonUri = biocacheUriPrefix + "/occurrences/assertions?recordUuid="+recordUuid;
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, QualityAssertion[].class);
    }

    /**
     * @see org.ala.hubs.service.BiocacheService#findBySpatialFulltextQuery(org.ala.biocache.dto.SpatialSearchRequestParams) 
     * 
     * @param requestParams
     * @return 
     */
    @Override
    public SearchResultDTO findBySpatialFulltextQuery(SpatialSearchRequestParams requestParams) {
        Assert.notNull(requestParams.getQ(), "query must not be null");
        addQueryContext(requestParams);
        SearchResultDTO searchResults = new SearchResultDTO();
        String uriString = biocacheUriPrefix + "/occurrences/searchByArea?" + requestParams.getEncodedParams();
        logger.debug("uriString = " + uriString);
 
        try {
            final URI jsonUri = new URI(uriString);
            logger.info("Requesting: " + jsonUri + " (" + uriString + ")");
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
        } catch (URISyntaxException e) {
            logger.error("URI error: " + e.getMessage(), e);
            searchResults = restTemplate.getForObject(uriString, SearchResultDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }

        return searchResults;
    }

    /**
     * @see org.ala.hubs.service.BiocacheService#getFacetValues(SpatialSearchRequestParams)
     *
     * @param requestParams
     * @return
     */
    @Override
    public SearchResultDTO getFacetValues(SpatialSearchRequestParams requestParams) {

        Assert.notNull(requestParams.getQ(), "query must not be null");
        addQueryContext(requestParams);
        requestParams.setPageSize(0);
        //requestParams.setFacets(facets);
        //requestParams.setFlimit(flimit);
        SearchResultDTO searchResults = new SearchResultDTO();

        try {
            final URI jsonUri = new URI(biocacheUriPrefix + "/occurrences/search?" + requestParams.getEncodedParams());
            logger.debug("Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }

        return searchResults;
    }

    @Override
    public Map<String, Object> getCompareRecord(String uuid) {
        Assert.notNull(uuid, "UUID must not be null");
        Map<String, Object> compareRecord = null;
        
        try {
            final String jsonUri = biocacheUriPrefix + "/occurrence/compare?uuid=" + uuid;            
            logger.debug("Requesting: " + jsonUri);
            compareRecord = restTemplate.getForObject(jsonUri, Map.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            //searchResults.setStatus("Error: " + ex.getMessage());
        }
        
        return compareRecord;
    }

    @Override
    @Cacheable(cacheName = "facetsCache")
    public List<String> getDefaultFacets() {
        List<String> facets = null;
        
        try {
            final String jsonUri = biocacheUriPrefix + "/search/facets";            
            logger.debug("Requesting facets via: " + jsonUri);
            facets = restTemplate.getForObject(jsonUri, List.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        
        return facets;
    }

    @Override
    @Cacheable(cacheName = "facetsCache")
    public List<Map<String, Object>> getDefaultFacetsWithCategories() {
        List<Map<String, Object>> facets = null;

        try {
            final String jsonUri = biocacheUriPrefix + "/search/grouped/facets";
            logger.debug("Requesting facets via: " + jsonUri);
            facets = restTemplate.getForObject(jsonUri, List.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }

        return facets;
    }

    @Override
    public boolean isReadOnly() {
        try {
            final String jsonUri = biocacheUriPrefix + "/admin/isReadOnly";
            logger.debug("Requesting facets via: " + jsonUri);
            String isReadOnlyAsString = restTemplate.getForObject(jsonUri, String.class);
            return Boolean.parseBoolean(isReadOnlyAsString);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        return false;
    }
    @Override
    public DuplicateRecordDetails getDuplicateRecordDetails(String uuid){
        DuplicateRecordDetails details=null;
        try{
            final String jsonUri = biocacheUriPrefix + "/duplicates/"+uuid;
            logger.debug("Attempting to get the duplicates from : " + jsonUri);
            details = restTemplate.getForObject(jsonUri, DuplicateRecordDetails.class); 
        }
        catch (Exception ex) {
            ex.printStackTrace();
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        return details;
    }

    /**
     * Get the biocacheUriPrefix
     *
     * @return biocacheUriPrefix
     */
    public String getBiocacheUriPrefix() {
        return biocacheUriPrefix;
    }

    /**
     * Set the biocacheUriPrefix
     *
     * @param biocacheUriPrefix to set
     */
    public void setBiocacheUriPrefix(String biocacheUriPrefix) {
        this.biocacheUriPrefix = biocacheUriPrefix;
    }

    public String getQueryContext() {
        return queryContext;
    }

    public void setQueryContext(String queryContext) {
        this.queryContext = queryContext;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }
}
