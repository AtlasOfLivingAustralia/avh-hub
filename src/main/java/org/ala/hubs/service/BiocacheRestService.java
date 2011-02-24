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
@Component("biocacheRestService")
public class BiocacheRestService implements BiocacheService {
    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    /** biocache-service URL - may be overriden by properties file version */
    protected String biocacheUriPrefix = "http://localhost:8080/biocache-service";
    /** logging init */
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
        }

        return record;
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
