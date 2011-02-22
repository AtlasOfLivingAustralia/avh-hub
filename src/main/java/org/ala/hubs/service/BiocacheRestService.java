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
import org.ala.biocache.dto.store.OccurrenceDTO;
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
    
    //protected final String biocacheUriPrefix = "http://limb-yf.nexus.csiro.au:9999/biocache-service";
    protected final String biocacheUriPrefix = "http://localhost:8080/biocache-service";
    protected final String requestParams = "q={query}&fq={filterQuery}&start={startIndex}&pageSize={pageSize}&sort={sortField}&dir={sortDirection}";
    protected final String rq2 = "q={qury}&foo={bar}";
    private final static Logger logger = Logger.getLogger(BiocacheRestService.class);

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

    @Override
    public SearchResultDTO findByTaxonConcept(String guid, SearchRequestParams requestParams) {
        Assert.notNull(guid, "guid must not be null");
        //requestParams.setQ("taxonConceptID:" + guid);
        SearchResultDTO searchResults = new SearchResultDTO();

        try {
            final String jsonUri = biocacheUriPrefix + "/occurrences/taxon/" + guid + "?" + requestParams.toString();
            logger.debug("Requesting: " + jsonUri);
            searchResults = restTemplate.getForObject(jsonUri, SearchResultDTO.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
            searchResults.setStatus("Error: " + ex.getMessage());
        }

        return searchResults;
    }

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
            //record.setStatus("Error: " + ex.getMessage());
        }

        return record;
    }
    
}
