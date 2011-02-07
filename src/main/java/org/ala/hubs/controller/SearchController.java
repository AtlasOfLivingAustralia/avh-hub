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

import java.util.ArrayList;
import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.UselessBean;
import org.ala.hubs.dto.SearchRequestParams;
import org.ala.hubs.service.BiocacheService;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Search controller for occurrence record searching
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("searchController")
public class SearchController {

	private final static Logger logger = Logger.getLogger(SearchController.class);
	
	/** Name of views */
	private final String SEARCH_LIST = "occurrences/list"; 
    @Inject
    private BiocacheService biocacheService;    
    
	
	/**
     * Performs a search for occurrence records via Biocache web services
     * 
     * @param requestParams
     * @param result
     * @param model
     * @param request
     * @return view
     * @throws Exception 
     */
	@RequestMapping(value = "/search*", method = RequestMethod.GET)
	public String search(SearchRequestParams requestParams, BindingResult result, Model model,
            HttpServletRequest request) throws Exception {
		
		if (StringUtils.isEmpty(requestParams.getQ())) {
			return SEARCH_LIST;
		}
		        
        //SearchRequestParams requestParams = setRequestParams(request.getParameterMap());

        //reverse the sort direction for the "score" field a normal sort should be descending while a reverse sort should be ascending
        //sortDirection = getSortDirection(sortField, sortDirection);
        
		String view = SEARCH_LIST;
        SearchResultDTO searchResult = biocacheService.findByFulltextQuery(requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchResults", searchResult);

        logger.debug("Selected view: "+view);
        
		return view;
	}

    @RequestMapping(value = "/test", method = RequestMethod.GET)
	public String test(Model model) {
        List<String> items = new ArrayList<String>();
        items.add("This");
        items.add("is");
        items.add("just");
        items.add("a");
        items.add("list");
        model.addAttribute("items", items);
        return SEARCH_LIST;
    }
    
    @RequestMapping(value = "/test2", method = RequestMethod.GET)
	public @ResponseBody List test2(Model model) {
        List<String> items = new ArrayList<String>();
        items.add("This");
        items.add("is");
        items.add("just");
        items.add("a");
        items.add("list");
        model.addAttribute("items", items);
        logger.debug("test2 has list of size: " + items.size());
        return items;
    }
	
    @RequestMapping(value = "/test/client2", method = RequestMethod.GET)
	public String testClient2(Model model) {
        
        List<String> list = biocacheService.getTestList();
        model.addAttribute("items", list);
        return SEARCH_LIST;
    }
    
    @RequestMapping(value = "/test/client3", method = RequestMethod.GET)
	public String testClient3(Model model) {
        SearchRequestParams srp = biocacheService.getTestBean();
        model.addAttribute("bean", srp);
        return SEARCH_LIST;
    }
    
    @RequestMapping(value = "/test/client4", method = RequestMethod.GET)
	public String testClient4(Model model) {
        SearchResultDTO searchResult = biocacheService.findByFulltextQuery("foo", null, 0, 10, "score", "asc");
        model.addAttribute("bean", searchResult);
        return SEARCH_LIST;
    }
}
