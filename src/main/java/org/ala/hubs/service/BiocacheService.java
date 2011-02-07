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

import java.util.List;
import org.ala.hubs.dto.SearchRequestParams;
import org.ala.biocache.dto.SearchResultDTO;

/**
 * Service layer for accessing Biocache data
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public interface BiocacheService {

    public SearchResultDTO findByFulltextQuery(String query, String[] filterQuery, Integer startIndex, Integer pageSize, String sortField, String sortDirection);

    public List<String> getTestList();

    public SearchRequestParams getTestBean();

    public SearchResultDTO findByFulltextQuery(SearchRequestParams requestParams);
    
}
