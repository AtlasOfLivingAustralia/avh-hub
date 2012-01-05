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

import au.org.ala.biocache.BasisOfRecord;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import au.org.ala.biocache.QualityAssertion;
import org.ala.biocache.dto.*;
import au.org.ala.biocache.FullRecord;
import au.org.ala.biocache.SpeciesGroups;
import au.org.ala.biocache.TypeStatus;
import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.ala.biocache.dto.store.OccurrenceDTO;
import org.ala.biocache.util.CollectionsCache;
import org.ala.client.util.RestfulClient;
import org.ala.hubs.dto.AssertionDTO;
import org.ala.hubs.dto.FieldGuideDTO;
import org.ala.hubs.service.BieService;
import org.ala.hubs.service.BiocacheService;
import org.ala.hubs.service.CollectoryUidCache;
import org.ala.hubs.service.GazetteerCache;
import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;

import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.jasig.cas.client.util.AbstractCasFilter;
import org.jasig.cas.client.validation.Assertion;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestOperations;

/**
 * Occurrence record Controller
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("occurrenceController")
@RequestMapping(value = {"/occurrences","/occurrence"})
public class OccurrenceController {

	private final static Logger logger = Logger.getLogger(OccurrenceController.class);
	
	/** BiocacheService injected by IoC */
    @Inject
    private BiocacheService biocacheService;
    @Inject
    private BieService bieService;
//    @Inject
//    protected SearchUtils searchUtils;
    @Inject
	protected RestfulClient restfulClient;
    @Inject
    protected CollectionsCache collectionsCache;
    @Inject
    protected GazetteerCache gazetteerCache;
    @Inject
    protected CollectoryUidCache collectoryUidCache;

    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring

    // fields injected from properties file
    @Value("${sensitiveDataset.list}")
    String sensitiveDatasets = null;
    @Value("${facets.exclude}")
    String facetsExclude = null;
    @Value("${facets.hide}")
    String facetsHide = null;
    
    /* View names */
    private final String RECORD_LIST = "occurrences/list";
    private final String RECORD_SHOW = "occurrences/show";
    private final String FIELDGUIDE_ERROR = "error/fieldguideGeneration";
    private final String RECORD_MAP = "occurrences/map";
    private final String ANNOTATE_EDITOR = "occurrences/annotationEditor";
    protected String collectoryBaseUrl = "http://collections.ala.org.au";
    protected String summaryServiceUrl  = collectoryBaseUrl + "/lookup/summary";
    protected String collectionContactsUrl = collectoryBaseUrl + "/ws/collection";

    /**
     * Expects a request body in JSON
     *
     * @return
     */
    @RequestMapping(value="/", method = RequestMethod.GET)
    public void home(HttpServletResponse response) throws Exception {
        response.sendRedirect("search");
    }

    /**
     * Expects a request body in JSON
     *
     * @return
     */
    @RequestMapping(value="/refreshUidCache", method = RequestMethod.GET)
    public String refreshCaches() throws Exception {
        collectoryUidCache.updateCache();
        collectionsCache.updateCache();
        return null;
    }

    /**
     * Sets up state variables and calls the annotation editor jsp.
     * @param uuid
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/annotate/{uuid:.+}", method = RequestMethod.GET)
    public String annotate(@PathVariable("uuid") String uuid, Model model, HttpServletRequest request) throws Exception{

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));
        if (assertion != null) {
        	
            AttributePrincipal principal = assertion.getPrincipal();
            model.addAttribute("userId", principal.getName());

            String fullName = "";
            if (principal.getAttributes().get("firstname") != null && principal.getAttributes().get("lastname") != null) {
                fullName = principal.getAttributes().get("firstname").toString() + " " + principal.getAttributes().get("lastname").toString();
            }
            model.addAttribute("userDisplayName", fullName);
        }

        model.addAttribute("errorCodes", biocacheService.getUserCodes());
        model.addAttribute("uuid", uuid);

        return ANNOTATE_EDITOR;
    }
    
    /**
     * Spatial search for either a taxon name or full text text search
     *
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/searchByArea*", method = RequestMethod.GET)
	public String occurrenceSearchByArea(
			@RequestParam(value="taxa", required=false) String[] taxaQuery,
            SpatialSearchRequestParams requestParams,
            BindingResult result,
            HttpServletRequest request,
			Model model) throws Exception {
        logger.debug("/searchByArea* TOP");
        
        if (requestParams.getQ() == null || requestParams.getQ().isEmpty()) {
			return RECORD_LIST;
		}

		if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20); // default is 10
        }
        
        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }
        
        String query = requestParams.getQ();
        logger.debug("searchByArea - requestParams = " + requestParams);

        if (requestParams.getLat() == null && requestParams.getLon() == null && requestParams.getRadius() == null && query.contains("|")) {
            // check for lat/long/rad encoded in q param, delimited by |
            // order is query, latitude, longitude, radius
            String[] queryParts = StringUtils.split(query, "|", 4);
            query = queryParts[0];
            logger.info("(spatial) query: "+query);

            if (query.contains("%%")) {
                // mulitple parts (%% separated) need to be OR'ed (yes a hack for now)
                String prefix = StringUtils.substringBefore(query, ":");
                String suffix = StringUtils.substringAfter(query, ":");
                String[] chunks = StringUtils.split(suffix, "%%");
                ArrayList<String> formatted = new ArrayList<String>();

                for (String s : chunks) {
                    formatted.add(prefix+":"+s);
                }

                query = StringUtils.join(formatted, " OR ");
                logger.debug("new query: "+query);
            }

            requestParams.setLat(Float.parseFloat(queryParts[1]));
            requestParams.setLon(Float.parseFloat(queryParts[2]));
            requestParams.setRadius(Float.parseFloat(queryParts[3]));
        }

		StringBuilder displayQuery = new StringBuilder(StringUtils.substringAfter(query, ":").replace("*", "(all taxa)"));
        displayQuery.append(" - within "+requestParams.getRadius()+" km of point ("+requestParams.getLat()+", "+requestParams.getLon()+")");
		requestParams.setDisplayString(displayQuery.toString());
        // perform the search
        doFullTextSearch(taxaQuery, model, requestParams, request);

		return RECORD_LIST;
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
    @RequestMapping(value = "/dataResource/{dataResourceUid}/search*", method = RequestMethod.GET)
    public String search(
            @RequestParam(value="taxa", required=false) String[] taxaQuery,
            @PathVariable String dataResourceUid,
            SearchRequestParams requestParams,
            BindingResult result,
            Model model,
            HttpServletRequest request) throws Exception {
        logger.debug("/search* TOP");


        String[] filterQueries = requestParams.getFq();
        if(filterQueries!=null){
            String[] filterQueriesWithDR = new String[filterQueries.length+1];
            ArrayUtils.addAll(filterQueries, filterQueriesWithDR);
            filterQueriesWithDR[filterQueriesWithDR.length -1] = "data_resource_uid:" + dataResourceUid;
            requestParams.setFq(filterQueriesWithDR);
        } else {
            requestParams.setFq(new String[]{"data_resource_uid:" + dataResourceUid});
        }

        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        doFullTextSearch(taxaQuery, model, requestParams, request);

        return RECORD_LIST;
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
    @RequestMapping(value = "/search*", method = RequestMethod.GET)
    public String search(
            @RequestParam(value="taxa", required=false) String[] taxaQuery,
            SearchRequestParams requestParams, 
            BindingResult result, 
            Model model,
            HttpServletRequest request) throws Exception {
        logger.debug("/search* TOP");
        logger.info("requestParams.q = " + requestParams.getQ() + " || fq = " + StringUtils.join(requestParams.getFq(), "|"));
        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        if (request.getParameter("sort") == null && request.getParameter("dir") == null ) {
            requestParams.setSort("last_load_date");
            requestParams.setDir("desc");
            model.addAttribute("sort","last_load_date");
            model.addAttribute("dir","desc");
        }
        
		doFullTextSearch(taxaQuery, model, requestParams, request);
        
        return RECORD_LIST;
    }

    /**
     * POST version of occurrence search
     *
     * @param rawNames
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/search*", method = RequestMethod.POST)
    public String search(@RequestParam(value="raw_taxon_guid", required=false) String[] rawNames,
            Model model,
            HttpServletRequest request) throws Exception {
        
        logger.info("raw_taxon_guid list: " + StringUtils.join(rawNames, "|"));
        String queryString = "raw_taxon_name:\"" + StringUtils.join(rawNames, "\" OR raw_taxon_name:\"") + "\"";
        
        SearchRequestParams requestParams = new SearchRequestParams();
        requestParams.setQ(queryString);
        
        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (request.getParameter("sort") == null && request.getParameter("dir") == null ) {
            requestParams.setSort("last_load_date");
            requestParams.setDir("desc");
            model.addAttribute("sort","last_load_date");
            model.addAttribute("dir","desc");
        }

        doFullTextSearch((String) null, model, requestParams, request);

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
    @RequestMapping(value = "/taxa/{guid:.+}*", method = RequestMethod.GET)
	public String occurrenceSearchByTaxon(
			@RequestParam(value="taxa", required=false) String[] taxaQuery,
            SearchRequestParams requestParams,
            @PathVariable("guid") String guid,
            HttpServletRequest request,
            Model model) throws Exception {

        //requestParams.setQ("taxonConceptID:" + guid);
        requestParams.setDisplayString("taxonConcept: "+guid); // replace with sci name if a match is found
        String[] userFacets = getFacetsFromCookie(request);
        if (userFacets != null && userFacets.length > 0) requestParams.setFacets(userFacets);
        SearchResultDTO searchResult = biocacheService.findByTaxonConcept(guid, requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("searchRequestParams", requestParams);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        addCommonDataToModel(model);
        return RECORD_LIST;
    }

    /**
     * Display records for a given taxon concept id (with request param)
     * 
     * @param requestParams
     * @param result
     * @param model
     * @param request
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/searchByTaxon*", method = RequestMethod.GET)
    public String searchByTaxon(
            SearchRequestParams requestParams, 
            BindingResult result, 
            Model model,
            HttpServletRequest request) throws Exception {
        logger.debug("/searchByTaxon TOP");
        
        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }
        
        String query = requestParams.getQ();
        
        if (!query.startsWith("lsid")) {
            requestParams.setQ("lsid:" + query);
        } 
        
        String[] tq = {""};
        doFullTextSearch(tq, model, requestParams, request);
        
        return RECORD_LIST;
    }

    /**
     * Display records for a given taxon concept id (with request param)
     *
     * @param requestParams
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/fieldguide/download", method = RequestMethod.GET)
    public String downloadFieldGuide(
            @RequestParam(value="maxSpecies", required=false, defaultValue = "150") Integer maxSpecies,
            SearchRequestParams requestParams,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        logger.debug("Field guide download starting");
        requestParams.setFlimit(maxSpecies);
        SearchResultDTO dto = biocacheService.findByFulltextQuery(requestParams);
        Collection<FacetResultDTO> facets = dto.getFacetResults();

        if(facets == null || facets.isEmpty()) {
            logger.error("Problem generating the field guide. Facet query result was empty.");
            return FIELDGUIDE_ERROR;
        }

        //retrieve the first facet
        FacetResultDTO facet = facets.iterator().next();
        List<FieldResultDTO> results = facet.getFieldResult();
        FieldGuideDTO fg = new FieldGuideDTO();

        //add the GUIDs to add to the field guide
        for(FieldResultDTO fr : results){
            fg.getGuids().add(fr.getLabel());
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd MMMMM yyyy");
        //set the properties of the query
        fg.setTitle("This document was generated on "+ sdf.format(new Date()));

        String serverName = request.getSession().getServletContext().getInitParameter("serverName");
        String contextPath = request.getSession().getServletContext().getInitParameter("contextPath");
        if(contextPath == null){
            contextPath = "";
        }
        fg.setLink(serverName + contextPath + "/occurrences/search?" + request.getQueryString());

        logger.debug(fg.getLink());

        //send the request to the fieldguide webservice
        HttpClient httpClient = new HttpClient();
        PostMethod post = new PostMethod("http://fieldguide.ala.org.au/generate");
        ObjectMapper om = new ObjectMapper();
        String jsonRequest = om.writeValueAsString(fg);
        logger.debug("Sending body: " + jsonRequest);
        post.setRequestBody(jsonRequest);
        httpClient.executeMethod(post);

        Header fileIdHeader = post.getResponseHeader("Fileid");
        if(fileIdHeader!=null){
            //happy days, redirect to the fieldguide
            String fileID = fileIdHeader.getValue();
            response.sendRedirect("http://fieldguide.ala.org.au/guide/"+fileID);
        } else {
            //send an error response
            return FIELDGUIDE_ERROR;
        }
        return null;
    }

    /**
     * UID search for links via collectory
     * 
     * @param requestParams
     * @param result
     * @param model
     * @param request
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/searchForUID*", method = RequestMethod.GET)
    public String searchForUid(
            SearchRequestParams requestParams, 
            BindingResult result, 
            Model model,
            HttpServletRequest request) throws Exception {
        logger.debug("/searchForUID TOP");
        
        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }
        
        String query = requestParams.getQ();
        
        if (query.startsWith("in")) {
            requestParams.setQ("institution_uid:" + query);
        } else if (query.startsWith("co")) {
            requestParams.setQ("collection_uid:" + query);
        }
        
		String[] tq = {""};
        doFullTextSearch(tq, model, requestParams, request);
        
        return RECORD_LIST;
    }

    /**
     * Occurrence search for a given collection, institution, data_resource or data_provider.
     *
     * @param requestParams The search parameters
     * @param  uid The uid for collection, institution, data_resource or data_provider
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"/collections/{uid}", "/institutions/{uid}", "/data-resources/{uid}", "/data-providers/{uid}"}, method = RequestMethod.GET)
    public String occurrenceSearchForCollection(
            SearchRequestParams requestParams,
            @PathVariable("uid") String uid,
            Model model)
            throws Exception {
        // no query so exit method
        if (StringUtils.isEmpty(uid)) {
            return RECORD_LIST;
        }

		logger.debug("solr query: " + requestParams);
		SearchResultDTO searchResult = biocacheService.findByCollection(uid, requestParams);
		model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        addCommonDataToModel(model);
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
    @RequestMapping(value = {"/{uuid:.+}", "/fragment/{uuid:.+}"}, method = RequestMethod.GET)
	public String getOccurrenceRecord(@PathVariable("uuid") String uuid,
            HttpServletRequest request, Model model) throws Exception {

        logger.debug("User prinicipal: " + request.getUserPrincipal());

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));

        String userId = null;

        if(assertion!=null){
            AttributePrincipal principal = assertion.getPrincipal();
            userId = principal.getName();
            model.addAttribute("userId", userId);
            String fullName = "";
            if (principal.getAttributes().get("firstname")!=null &&  principal.getAttributes().get("lastname")!=null) {
                fullName = principal.getAttributes().get("firstname").toString() + " " + principal.getAttributes().get("lastname").toString();
            }
            model.addAttribute("userDisplayName", fullName);
        }

        uuid = removeUriExtension(uuid);
        model.addAttribute("uuid", uuid);
        logger.debug("Retrieving occurrence record with guid: '"+uuid+"'");
        OccurrenceDTO record = biocacheService.getRecordByUuid(uuid);
        model.addAttribute("errorCodes", biocacheService.getUserCodes());
        model.addAttribute("isReadOnly", biocacheService.isReadOnly());

        String collectionUid = null;
        String rowKey = (record != null && record.getRaw() != null)? record.getRaw().getRowKey() : uuid;
        // add the rowKey for the record.
        model.addAttribute("rowKey", rowKey);

        if (record != null && record.getProcessed() != null) { // .getAttribution().getCollectionCodeUid()
            FullRecord  pr = record.getProcessed();
            collectionUid = pr.getAttribution().getCollectionUid();

            Object[] resp = restfulClient.restGet(summaryServiceUrl + "/" + collectionUid);
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

            // Check is user has role: ROLE_COLLECTION_EDITOR or ROLE_COLLECTION_ADMIN
            // and then call Collections WS to see if they are a member of the current collection uid

            if (userId != null && collectionUid != null && (request.isUserInRole("ROLE_ADMIN") || request.isUserInRole("ROLE_COLLECTION_ADMIN") || request.isUserInRole("ROLE_COLLECTION_EDITOR"))) {
                logger.info("User has appropriate ROLE...");
                try {
                    final String jsonUri = collectionContactsUrl + "/" + collectionUid + "/contacts.json";
                    logger.debug("Requesting: " + jsonUri);
                    List<Map<String, Object>> contacts = restTemplate.getForObject(jsonUri, List.class);
                    logger.debug("number of contacts = " + contacts.size());

                    for (Map<String, Object> contact : contacts) {
                        Map<String, String> details = (Map<String, String>) contact.get("contact");
                        String email = details.get("email");
                        logger.debug("email = " + email);
                        if (userId.equalsIgnoreCase(email)) {
                            logger.info("Logged in user has collection admin rights: " + email);
                            model.addAttribute("isCollectionAdmin", true);
                        } else if (request.isUserInRole("ROLE_ADMIN")) {
                            model.addAttribute("isCollectionAdmin", true);
                        }
                    }
                } catch (Exception ex) {
                    logger.error("RestTemplate error: " + ex.getMessage(), ex);
                }
            }
            
            if (record.getUserAssertions() != null) {
            	Collection<AssertionDTO> grouped = AssertionUtils.groupAssertions(record.getUserAssertions().toArray(new QualityAssertion[0]), userId);
                model.addAttribute("groupedAssertions", grouped);
            }
            
            model.addAttribute("record", record);
            model.addAttribute("sensitiveDatasets", StringUtils.split(sensitiveDatasets,","));
            // Get the simplified/flattened compare version of the record for "Raw vs. Processed" table
            Map<String, Object> compareRecord = biocacheService.getCompareRecord(rowKey);
            model.addAttribute("compareRecord", compareRecord);
		}
        
		return RECORD_SHOW;
	}

    /**
     * Requests for mapping functions
     *
     * @param requestParams
     * @param result
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/map", method = RequestMethod.GET)
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
     * Common search code for full text searches
     * 
     * @param taxaQuery
     * @param model
     * @param requestParams
     * @param request 
     */
    protected void doFullTextSearch(String taxaQuery, Model model, SearchRequestParams requestParams, HttpServletRequest request) {
        String[] taxaQueryList = null;

        if (taxaQuery != null && !taxaQuery.isEmpty()) {
            taxaQueryList[0] = taxaQuery;
        }

        doFullTextSearch(taxaQueryList,  model, requestParams, request);
    }

    /**
     * Common search code for full text searches
     * 
     * @param taxaQuery
     * @param model
     * @param requestParams
     * @param request 
     */
    protected void doFullTextSearch(String[] taxaQuery, Model model, SearchRequestParams requestParams, HttpServletRequest request) {
        // Prepare request obj
        prepareSearchRequest(taxaQuery, request, requestParams);
        // Perform search via webservice
        try {
            SearchResultDTO searchResult = biocacheService.findByFulltextQuery(requestParams);
            logger.info("searchResult: " + searchResult.getTotalRecords());
            addToModel(model, requestParams, searchResult);
            String displayQuery = searchResult.getQueryTitle();
            
            if (taxaQuery != null) {
                for (String tq : taxaQuery) {
                    if (!tq.isEmpty() && displayQuery != null) {
                        // attempt to add the mathced name/common name to displayQuery
                        Pattern exp = Pattern.compile("<span>(.*)</span>");
                        Matcher matcher = exp.matcher(displayQuery);
                        if (matcher.find()) {
                            logger.info("Generator: "+matcher.group(1));
                            requestParams.setDisplayString(requestParams.getDisplayString() + " <span id='matchedTaxon'>" + matcher.group(1) + "</span>");
                        }
                    }
                }
            }
        } catch (Exception ex) {
        	logger.error(ex.getMessage(),ex);
            model.addAttribute("errors", "Search Service unavailable<br/>" + ex.getMessage());
        }
    }
    
    /**
     * Common search code for spatial full text searches
     * 
     * @param model
     * @param requestParams
     * @param request 
     */
    protected void doFullTextSearch(String[] taxaQuery, Model model, SpatialSearchRequestParams requestParams, HttpServletRequest request) {
        // Prepare request obj
        prepareSearchRequest(taxaQuery, request, requestParams);
        // Perform search via webservice
        try {
            SearchResultDTO searchResult = biocacheService.findBySpatialFulltextQuery(requestParams);
            model.addAttribute("latitude", requestParams.getLat());
            model.addAttribute("longitude", requestParams.getLon());
            model.addAttribute("radius", requestParams.getRadius());
            logger.debug("searchResult: " + searchResult.getTotalRecords());
            addToModel(model, requestParams, searchResult);
        } catch (Exception ex) {
        	logger.error(ex.getMessage(),ex);
            model.addAttribute("errors", "Search Service unavailable<br/>" + ex.getMessage());
        }
    }

    /**
     * Common code to check for facets cookie and manipulate query, etc
     * 
     * @param request
     * @param requestParams 
     */
    protected void prepareSearchRequest(String[] taxaQuery, HttpServletRequest request, SearchRequestParams requestParams) {
        // check for user facets via cookie
        String[] userFacets = getFacetsFromCookie(request);
        logger.info("userFacets = " + StringUtils.join(userFacets, "|"));
        if (userFacets != null && userFacets.length > 0) requestParams.setFacets(userFacets);

        requestParams.setFacets(filterFacets(requestParams.getFacets()));

        List<String> displayString = new ArrayList<String>();
        List<String> query = new ArrayList<String>();
        
        if (taxaQuery != null) {
            for (String tq : taxaQuery) {
                if (!tq.isEmpty()) {
                    String guid = bieService.getGuidForName(tq.replaceAll("\"", ""));
                    logger.info("GUID for " + tq + " = " + guid);

                    if (guid != null && !guid.isEmpty()) {
                        // gota GUID match so perform a lsid search
                        //query.append("lsid:").append(guid);
                        query.add("lsid:" + guid);
                        tq = tq + " <span id='queryGuid'>" + guid + "</span>";
                        //requestParams.setDisplayString(tq);
                        displayString.add(tq);
                        // add raw_scientificName facet so we can show breakdown of taxa contributing to search
                        List<String> facets = new ArrayList<String>(Arrays.asList(requestParams.getFacets()));    
                        if (!facets.contains("raw_taxon_name")) {
                            facets.add("raw_taxon_name");
                            requestParams.setFacets(facets.toArray(new String[0]));
                        } 

                    } else {
                        // no GUID atch so do full-text search
                        query.add(tq); 
                        //requestParams.setDisplayString(tq);
                        displayString.add(tq);
                    }


                } 
            }
            
            StringBuilder queryString = new StringBuilder();
            
            if (requestParams.getQ() != null && !requestParams.getQ().isEmpty()) {
                //combine any other search inputs from advanced form
                queryString.append(requestParams.getQ()).append(" AND ");
            }
            
            // if more than one taxa query, add braces so we get correct Boolean precedence
            String[] braces = {"",""};
            if (query.size() > 1) {
                braces[0] = "(";
                braces[1] = ")";
            }
            
            queryString.append(braces[0]).append(StringUtils.join(query, " OR ")).append(braces[1]); // taxa terms should be OR'ed
            logger.info("query = " + queryString);

            if (queryString.length() == 0) {
                // empty taxaQuery - so show all records
                queryString.append("*:*");
            }

            requestParams.setQ(URLDecoder.decode(queryString.toString().trim()));
            requestParams.setDisplayString(StringUtils.join(displayString, " OR ")); // join up mulitple taxa queries
            
        } else if (requestParams.getQ().isEmpty())  {
            requestParams.setQ("*:*"); // assume search for everything
        } else {
            // unescape URI encoded query
            requestParams.setQ(URLDecoder.decode(requestParams.getQ()));
        }
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
    
    /**
     * Common code to add stuff to the MVC model (for search methods)
     * 
     * @param model
     * @param requestParams
     * @param searchResult 
     */
    protected void addToModel(Model model, SearchRequestParams requestParams, SearchResultDTO searchResult) {
        if (requestParams.getDisplayString() == null || requestParams.getDisplayString().isEmpty()) {
            requestParams.setDisplayString(searchResult.getQueryTitle());
        }
        
        if ("*:*".equals(searchResult.getQueryTitle())) {
            searchResult.setQueryTitle("[all records]");
        }
        
        model.addAttribute("searchRequestParams", requestParams);
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        model.addAttribute("hasMultimedia", resultsHaveMultimedia(searchResult));
        addCommonDataToModel(model);
    }

    /**
     * Add "common" data structures required for search pages (list.jsp).
     *
     * TODO: move static methods from HomePAgeController into utility class.
     *
     * @param model
     */
    private void addCommonDataToModel(Model model) {
        List<String> inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        model.addAttribute("collectionCodes", collectionsCache.getCollections(inguids, coguids));
        model.addAttribute("institutionCodes", collectionsCache.getInstitutions(inguids, coguids));
        model.addAttribute("dataResourceCodes", collectionsCache.getDataResources(inguids, coguids));
        model.addAttribute("defaultFacets", filterFacets(biocacheService.getDefaultFacets()));
    }

    /**
     * Filter facets by checking an exclude list specified in hubs.properties
     *
     * @param defaultFacets
     * @return facetsList
     */
    private LinkedHashMap<String, Boolean> filterFacets(List<String> defaultFacets) {
        LinkedHashMap<String, Boolean> facetsMap = new LinkedHashMap<String, Boolean>();
        String[] excludeArray = null;
        String[] hideArray = null;

        if (StringUtils.isNotEmpty(facetsExclude)) {
            excludeArray = StringUtils.split(facetsExclude, ",");
        }

        if (StringUtils.isNotEmpty(facetsHide)) {
            hideArray = StringUtils.split(facetsHide, ",");
        }

        for (String facet : defaultFacets) {
            if (StringUtils.indexOfAny(facet, excludeArray) < 0) {
                // add facet if its not in exclude list (match >= 0 && null or no match = -1)
                //facetsList.add(facet);
                facetsMap.put(facet, (StringUtils.indexOfAny(facet, hideArray) < 0));
                logger.debug("facetsMap = "+facet+" - " + (StringUtils.indexOfAny(facet, hideArray) < 0));
            }
        }
        logger.debug("facetsMap = " + StringUtils.join(facetsMap.keySet(), "|"));
        return facetsMap;
    }

    /**
     * Filter facets by checking an exclude list specified in hubs.properties
     *
     * @param defaultFacets
     * @return
     */
    protected String[] filterFacets(String[] defaultFacets) {
        logger.debug("defaultFacets = " + StringUtils.join(defaultFacets, "|"));
        LinkedHashMap<String, Boolean> finalFacetsMap = filterFacets(Arrays.asList(defaultFacets));
        logger.debug("finalFacetsMap = " + StringUtils.join(finalFacetsMap.keySet(), "|"));
        List<String> finalFacets = new ArrayList<String>(finalFacetsMap.keySet());
        String[] filteredFacets = finalFacets.toArray(new String[finalFacets.size()]);
        return filteredFacets;
    }

    /**
     * Check search results for multimedia facets values
     * 
     * @param searchResult
     * @return 
     */
    private Boolean resultsHaveMultimedia(SearchResultDTO searchResult) {
        Boolean hasMultimedia = false;
        String facetName = "multimedia"; // fieldResult label is Multimedia
        Collection facets = searchResult.getFacetResults();
        
        if (facets != null) {
            List<FacetResultDTO> facetResults = new ArrayList(facets); // convert to ArrayList
        
            for (FacetResultDTO facetResult : facetResults) {
                if (facetName.equals(facetResult.getFieldName())) {
                    List<FieldResultDTO> fieldResults = facetResult.getFieldResult();

                    for (FieldResultDTO fieldResult : fieldResults) {
                        if (facetName.equalsIgnoreCase(fieldResult.getLabel())) {
                             hasMultimedia = true;
                        }
                    }

                    break;
                }
            }
        }
        
        logger.debug("hasMultimedia = " + hasMultimedia);
        
        return hasMultimedia;
    }

    /**
     * Get an array of facets from the cookie "user_facets". 
     * Note: the cookie is a simple String so the list is encoded as a common-separated list.
     * 
     * @param request
     * @return facets
     */
    private String[] getFacetsFromCookie(HttpServletRequest request) {
        String userFacets = null;
        String[] facets = null;
        String rawCookie = getCookieValue(request.getCookies(), "user_facets", null);
        
        if (rawCookie != null) {
            try {
                userFacets = URLDecoder.decode(rawCookie, "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                logger.error(ex.getMessage(), ex);
            }
            
            if (!StringUtils.isBlank(userFacets)) {
                facets = userFacets.split(",");
            }
        }
        
        return facets;
    }
    
    /**
     * Utility for getting a named cookie value from the HttpServletRepsonse cookies array
     * 
     * @param cookies
     * @param cookieName
     * @param defaultValue
     * @return 
     */
    public static String getCookieValue(Cookie[] cookies, String cookieName, String defaultValue) {
    	if(cookies!=null){
	        for (int i = 0; i < cookies.length; i++) {
	            Cookie cookie = cookies[i];
	            if (cookieName.equals(cookie.getName())) {
	                return (cookie.getValue());
	            }
	        }
    	}
        return (defaultValue);
    }
}
