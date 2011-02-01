/**************************************************************************
 *  Copyright (C) 2010 Atlas of Living Australia
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

package org.ala.hubs.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Search controller for occurrence record searching
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("searchController")
public class SearchController {

	private final static Logger logger = Logger.getLogger(SearchController.class);
	
	/** Name of view for list of taxa */
	private final String SEARCH_LIST = "search/list"; // "species/list" || "search/species"
	private final String SEARCH = "search"; //default view when empty query submitted
    
    private final String WP_SOLR_URL = "http://alaprodweb1-cbr.vm.csiro.au/solr/select/?wt=json&q=";
	
	/**
	 * Performs a search for occurrence records via Biocache web services
	 * 
	 * @param query
	 * @param filterQuery
	 * @param startIndex
	 * @param pageSize
	 * @param sortField
	 * @param sortDirection
	 * @param title
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/search*", method = RequestMethod.GET)
	public String search(
			@RequestParam(value="q", required=false) String query,
			@RequestParam(value="fq", required=false) String[] filterQuery,
			@RequestParam(value="start", required=false, defaultValue="0") Integer startIndex,
			@RequestParam(value="pageSize", required=false, defaultValue ="10") Integer pageSize,
			@RequestParam(value="sort", required=false, defaultValue="score") String sortField,
			@RequestParam(value="dir", required=false, defaultValue ="asc") String sortDirection,
			@RequestParam(value="title", required=false, defaultValue ="Search Results") String title,
		    Model model,
            HttpServletRequest request) throws Exception {
		
		if (StringUtils.isEmpty(query)) {
			return SEARCH;
		}
		
        // if params are set but empty (e.g. foo=&bar=) then provide sensible defaults
        if (filterQuery != null && filterQuery.length == 0) {
            filterQuery = null;
        }
        if (startIndex == null) {
            startIndex = 0;
        }
        if (pageSize == null) {
            pageSize = 20;
        }
        if (sortField.isEmpty()) {
            sortField = "score";
        }
        if (sortDirection.isEmpty()) {
            sortDirection = "asc";
        }

        //reverse the sort direction for the "score" field a normal sort should be descending while a reverse sort should be ascending
        //sortDirection = getSortDirection(sortField, sortDirection);
        
		String view = SEARCH_LIST;

        model.addAttribute("searchResults", null);
        model.addAttribute("totalRecords", null);
        model.addAttribute("lastPage", null);

        logger.debug("Selected view: "+view);
        
		return view;
	}
	

}
