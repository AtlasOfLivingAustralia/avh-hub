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

import java.util.HashMap;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.SearchRequestParams;
import au.org.ala.biocache.FullRecord;
import org.ala.biocache.dto.store.OccurrenceDTO;
import org.ala.client.util.RestfulClient;
import org.ala.hubs.service.BiocacheService;
import org.apache.commons.httpclient.HttpStatus;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Occurrence record Controller
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("occurrenceController")
public class OccurrenceController {

	private final static Logger logger = Logger.getLogger(OccurrenceController.class);
	
	/** BiocacheService injected by IoC */
    @Inject
    private BiocacheService biocacheService;
    @Inject
	protected RestfulClient restfulClient;
    /* View names */
	private final String RECORD_LIST = "occurrences/list";
    private final String RECORD_SHOW = "occurrences/show";
    private final String RECORD_MAP = "occurrences/map";

	protected String collectoryBaseUrl = "http://collections.ala.org.au";
    protected String summaryServiceUrl  = collectoryBaseUrl + "/lookup/summary";

    @RequestMapping(value = "/", method = RequestMethod.GET)
	public String homePage(){
       return "homePage";
    }

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
	@RequestMapping(value = {"/occurrence/search*","/occurrences/search*"}, method = RequestMethod.GET)
	public String search(SearchRequestParams requestParams, BindingResult result, Model model,
            HttpServletRequest request) throws Exception {
		
		if (StringUtils.isEmpty(requestParams.getQ())) {
			return RECORD_LIST;
		} else if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        //reverse the sort direction for the "score" field a normal sort should be descending while a reverse sort should be ascending
        //sortDirection = getSortDirection(sortField, sortDirection);
        
		requestParams.setDisplayString(requestParams.getQ()); // replace with sci name if a match is found
        SearchResultDTO searchResult = biocacheService.findByFulltextQuery(requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        
		return RECORD_LIST;
	}

    /**
     * Display records for a given taxon concept id
     *
     * @param requestParams
     * @param guid
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/occurrences/taxon/{guid:.+}*", method = RequestMethod.GET)
	public String occurrenceSearchByTaxon(
			SearchRequestParams requestParams,
            @PathVariable("guid") String guid,
            Model model) throws Exception {

        //requestParams.setQ("taxonConceptID:" + guid);
        requestParams.setDisplayString("taxonConcept: "+guid); // replace with sci name if a match is found
        SearchResultDTO searchResult = biocacheService.findByTaxonConcept(guid, requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        return RECORD_LIST;
    }

    /**
     * Display an occurrence record by retrieving via its uuid.
     *
     * @param uuid
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/occurrence/{uuid:.+}", method = RequestMethod.GET)
	public String getOccurrenceRecord(@PathVariable("uuid") String uuid,
            HttpServletRequest request, Model model) throws Exception {

        uuid = removeUriExtension(uuid);
        model.addAttribute("uuid", uuid);
        logger.debug("Retrieving occurrence record with guid: '"+uuid+"'");
        OccurrenceDTO record = biocacheService.getRecordByUuid(uuid);
        String collectionCodeUid = null;

        if (record != null && record.getProcessed() != null) { // .getAttribution().getCollectionCodeUid()
            FullRecord  pr = record.getProcessed();
            collectionCodeUid = pr.getAttribution().getCollectionUid();

            Object[] resp = restfulClient.restGet(summaryServiceUrl + "/" + collectionCodeUid);
            if ((Integer) resp[0] == HttpStatus.SC_OK) {
                String json = (String) resp[1];
                ObjectMapper mapper = new ObjectMapper();
                JsonNode rootNode;

                try {
                    rootNode = mapper.readValue(json, JsonNode.class);
                    String name = rootNode.path("name").getTextValue();
                    String logo = rootNode.path("institutionLogoUrl").getTextValue();
                    String institution = rootNode.path("institution").getTextValue();
                    model.addAttribute("collectionName", name);
                    model.addAttribute("collectionLogo", logo);
                    model.addAttribute("collectionInstitution", institution);
                } catch (Exception e) {
                    logger.error(e.toString(), e);
                }
            }

		}

        model.addAttribute("record", record);
		return RECORD_SHOW;
	}

    /**
     * Remove the URI extension from the input String
     * 
     * @param uuid
     * @return
     */
    protected String removeUriExtension(String uuid) {
        uuid = StringUtils.removeEndIgnoreCase(uuid, ".json");
        uuid = StringUtils.removeEndIgnoreCase(uuid, ".xml");
        uuid = StringUtils.removeEndIgnoreCase(uuid, ".html");
        return uuid;
    }

    /**
     * Testing and debugging method
     *
     * TODO: delete this when stable
     *
     * @param query
     * @param filterQuery
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String testRequest(
            @RequestParam(value = "q", required = false) String query,
            @RequestParam(value = "fq", required = false) String[] filterQuery,
            HttpServletRequest request,
            Model model)
            throws Exception {

        SearchRequestParams requestParams = new SearchRequestParams();
        StringBuilder debug = new StringBuilder("q = ").append(query).append("; ");
        debug.append("fq = ").append(StringUtils.join(filterQuery, "|"));
        requestParams.setDisplayString(debug.toString());
        model.addAttribute("requestParams", requestParams);

        String[] fqs = request.getParameterValues("fq");
        model.addAttribute("fqs", fqs);

        return RECORD_LIST;
    }

    /**
     * Create a HashMap for the filter queries
     *
     * @param filterQuery
     * @return
     */
    private HashMap<String, String> addFacetMap(String[] filterQuery) {
               HashMap<String, String> facetMap = new HashMap<String, String>();

        if (filterQuery != null && filterQuery.length > 0) {
            logger.debug("filterQuery = "+StringUtils.join(filterQuery, "|"));
            for (String fq : filterQuery) {
                if (fq != null && !fq.isEmpty()) {
                    String[] fqBits = StringUtils.split(fq, ":", 2);
                    logger.debug("bits = " + StringUtils.join(fqBits, "|"));
                    facetMap.put(fqBits[0], fqBits[1]);
                }
            }
        }
        return facetMap;
    }
    
    /**
     * Calculate the last page number for pagination
     * 
     * @param totalRecords
     * @param pageSize
     * @return
     */
    private Integer calculateLastPage(Long totalRecords, Integer pageSize) {
        Integer lastPage = 0;
        Integer lastRecordNum = totalRecords.intValue();
        
        if (pageSize > 0) {
            lastPage = (lastRecordNum / pageSize) + ((lastRecordNum % pageSize > 0) ? 1 : 0);
        }
        
        return lastPage;
    }

	@RequestMapping(value = "/occurrences/map", method = RequestMethod.GET)
	public String map(SearchRequestParams requestParams, BindingResult result, Model model,
            HttpServletRequest request) throws Exception {

		if (StringUtils.isEmpty(requestParams.getQ())) {
			return RECORD_MAP;
		} else if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        //reverse the sort direction for the "score" field a normal sort should be descending while a reverse sort should be ascending
        //sortDirection = getSortDirection(sortField, sortDirection);

		requestParams.setDisplayString(requestParams.getQ()); // replace with sci name if a match is found
        SearchResultDTO searchResult = biocacheService.findByFulltextQuery(requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));



        return RECORD_MAP;
    }
}
