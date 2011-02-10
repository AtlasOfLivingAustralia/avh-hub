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
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.SearchRequestParams;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.client.RestOperations;

/**
 * Implementation of BiocacheService.java that calls the biocache-service application
 * via JSON REST web services.
 * 
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Component
public class BiocacheRestService implements BiocacheService {
    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    //@Inject
    //private XPathOperations xpathTemplate
    
    protected final String biocacheUriPrefix = "http://bee-be.local:8088/biocache-service";
    protected final String requestParams = "q={query}&fq={filterQuery}&start={startIndex}&pageSize={pageSize}&sort={sortField}&dir={sortDirection}";
    protected final String rq2 = "q={qury}&foo={bar}";
    private final static Logger logger = Logger.getLogger(BiocacheRestService.class);
    
    @Override
    public SearchResultDTO findByFulltextQuery(String query, String[] filterQuery, Integer startIndex,
            Integer pageSize, String sortField, String sortDirection) {

        SearchResultDTO searchResults = new SearchResultDTO();
        Assert.notNull(query, "query must not be null");
        
        try {
            
            final String jsonUri = biocacheUriPrefix + "/search.json?" + requestParams;
            logger.debug("Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class, query, 
                    "", startIndex, pageSize, sortField, sortDirection);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }

        return searchResults;
    }

    @Override
    public List<String> getTestList() {
        List<String> testList = new ArrayList<String>();
        try {
            final String jsonUri = "http://bee-be.local:8888/hubs-webapp/test2.json";
            logger.debug("Requesting: " + jsonUri);
            testList = restTemplate.getForObject(jsonUri, List.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        return testList;
    }

    @Override
    public SearchRequestParams getTestBean() {
        SearchRequestParams srp = new SearchRequestParams();
        try {
            final String jsonUri = biocacheUriPrefix + "/test3.json?" + rq2;
            logger.debug("Requesting: " + jsonUri);
            srp = restTemplate.getForObject(jsonUri, SearchRequestParams.class, "bar", "bash");
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        return srp;
    }

    @Override
    public SearchResultDTO findByFulltextQuery(SearchRequestParams requestParams) {
        Assert.notNull(requestParams.getQ(), "query must not be null");
        SearchResultDTO searchResults = new SearchResultDTO();
        
        try {
            final String jsonUri = biocacheUriPrefix + "/search.json?" + requestParams.toString();
            logger.debug("Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }

        return searchResults;
    }
    
}
