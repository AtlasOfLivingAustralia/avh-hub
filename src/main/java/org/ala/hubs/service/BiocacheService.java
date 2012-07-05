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

import org.ala.biocache.dto.SearchRequestParams;
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.SpatialSearchRequestParams;
import org.ala.biocache.dto.store.OccurrenceDTO;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Service layer interface for accessing Biocache data
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public interface BiocacheService {
    /**
     * Full text search for records
     *
     * @deprecated for findBySpatialFulltextQuery
     *
     * @param requestParams
     * @return
     */
    @Deprecated
    public SearchResultDTO findByFulltextQuery(SearchRequestParams requestParams);

    /**
     * Taxon concept search for records using unique identifier
     *
     * @param guid
     * @param requestParams
     * @return
     */
    public SearchResultDTO findByTaxonConcept(String guid, SearchRequestParams requestParams);

    /**
     * Collection/institution/dataset/data provider search for records using unique identifier
     *
     * @param uid
     * @param requestParams
     * @return
     */
    public SearchResultDTO findByCollection(String uid, SearchRequestParams requestParams);

    /**
     * Retrieve a record by its UUID
     *
     * @param uuid
     * @param apiKey
     * @return
     */
    public OccurrenceDTO getRecordByUuid(String uuid, String apiKey);
    
    /**
     * full text search with spatial restriction (lat/lon/radius)
     * 
     * @param requestParams
     * @return 
     */
    public SearchResultDTO findBySpatialFulltextQuery(SpatialSearchRequestParams requestParams);

    /**
     * Get a list of facet values for a given query & facet
     *
     * @param facets
     * @param flimit
     * @param requestParams
     * @return
     */
    public SearchResultDTO getFacetValues(SpatialSearchRequestParams requestParams);

    public List<ErrorCode> getErrorCodes();

    public List<ErrorCode> getUserCodes();

    public List<ErrorCode> getGeospatialCodes();

    public List<ErrorCode> getTaxonomicCodes();

    public List<ErrorCode> getTemporalCodes();

    public List<ErrorCode> getMiscellaneousCodes();

    public boolean addAssertion(String recordUuid, String code, String comment, String userId, String userDisplayName);

    public boolean deleteAssertion(String uuid, String assertionUuid);

    public QualityAssertion[] getUserAssertions(String recordUuid);

    public Map<String, Object> getCompareRecord(String uuid);

    public List<String> getDefaultFacets();

    public List<Map<String, Object>> getDefaultFacetsWithCategories();

    public boolean isReadOnly();
    
    public DuplicateRecordDetails getDuplicateRecordDetails(String uuid);
    
    public String getQueryContext();

}
