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

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.ala.biocache.dto.SearchRequestParams;
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.store.OccurrenceDTO;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.client.RestOperations;

import au.org.ala.biocache.ErrorCode;
import au.org.ala.biocache.QualityAssertion;

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
    /** URI prefix for biocache-service - may be overridden in properties file */
    protected String biocacheUriPrefix = "http://localhost:9999/biocache-service";
    
    private final static Logger logger = Logger.getLogger(BiocacheRestService.class);
    
    /**
     * @see org.ala.hubs.service.BiocacheService#findByFulltextQuery(SearchRequestParams)
     */
    @Override
    public SearchResultDTO findByFulltextQuery(SearchRequestParams requestParams) {
        Assert.notNull(requestParams.getQ(), "query must not be null");
        SearchResultDTO searchResults = new SearchResultDTO();
        
        try {
            final String jsonUri = biocacheUriPrefix + "/occurrences/search?" + requestParams.toString();
            logger.debug("Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
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
        SearchResultDTO searchResults = new SearchResultDTO();
        try {
            final String jsonUri = biocacheUriPrefix + occurrencesPath + uid + "?" + requestParams.toString();
            logger.debug("Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }
        return searchResults;
    }

    /**
     * @see org.ala.hubs.service.BiocacheService#getRecordByUuid(String)
     */
    @Override
    public OccurrenceDTO getRecordByUuid(String uuid) {
        Assert.notNull(uuid, "uuid must not be null");
        OccurrenceDTO record = new OccurrenceDTO();

        try {
            final String jsonUri = biocacheUriPrefix + "/occurrence/" + uuid;
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

        final String uri = biocacheUriPrefix + "/occurrences/"+recordUuid+"/assertions/add";
        HttpClient h = new HttpClient();
        PostMethod m = new PostMethod(uri);
        try {
            m.setParameter("code", code);
            m.setParameter("comment", comment);
            m.setParameter("userId", userId);
            m.setParameter("userDisplayName", userDisplayName);
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
        final String uri = biocacheUriPrefix + "/occurrences/"+recordUuid+"/assertions/delete";
        HttpClient h = new HttpClient();
        PostMethod m = new PostMethod(uri);
        try {
            m.setParameter("assertionUuid", assertionUuid);
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
        final String jsonUri = biocacheUriPrefix + "/occurrences/"+recordUuid+"/assertions/";
        logger.debug("Requesting: " + jsonUri);
        return restTemplate.getForObject(jsonUri, QualityAssertion[].class);
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
}
