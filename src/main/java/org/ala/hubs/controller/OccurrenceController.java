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

import java.io.File;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import au.org.ala.biocache.QualityAssertion;
import org.ala.biocache.dto.*;
import au.org.ala.biocache.FullRecord;

import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.ala.biocache.dto.store.OccurrenceDTO;
import org.ala.biocache.util.CollectionsCache;
import org.ala.client.util.RestfulClient;
import org.ala.hubs.dto.ActiveFacet;
import org.ala.hubs.dto.AssertionDTO;
import org.ala.hubs.dto.FacetValueDTO;
import org.ala.hubs.dto.FieldGuideDTO;
import org.ala.hubs.service.*;
import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;

import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.FeatureSource;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.jasig.cas.client.util.AbstractCasFilter;
import org.jasig.cas.client.validation.Assertion;
import org.opengis.feature.simple.SimpleFeature;
import com.vividsolutions.jts.geom.Geometry;
import org.opengis.feature.simple.SimpleFeatureType;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestOperations;
import org.springframework.web.multipart.MultipartFile;

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
    @Inject
	protected RestfulClient restfulClient;
    @Inject
    protected CollectionsCache collectionsCache;
    @Inject
    protected GazetteerCache gazetteerCache;
    @Inject
    protected CollectoryUidCache collectoryUidCache;
    @Inject
    private AbstractMessageSource messageSource;
    @Inject
    protected LoggerService loggerService;

    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring

    // fields injected from properties file (via <context:property-placeholder... />)
    @Value("${sensitiveDataset.list}")
    String sensitiveDatasets = null;
    @Value("${facets.exclude}")
    String facetsExclude = null;
    @Value("${facets.include}")
    String facetsInclude = null;
    @Value("${facets.hide}")
    String facetsHide = null;
    @Value("${biocacheRestService.biocacheUriPrefix}")
    String biocacheUriPrefix = null;
    @Value("${downloads.extra}")
    String downloadExtraFields = null;
    
    /* View names */
    private final String RECORD_LIST = "occurrences/list";
    private final String RECORD_SHOW = "occurrences/show";
    private final String FIELDGUIDE_ERROR = "error/fieldguideGeneration";
    private final String RECORD_MAP = "occurrences/map";
    private final String ANNOTATE_EDITOR = "occurrences/annotationEditor";
    protected String collectoryBaseUrl = "http://collections.ala.org.au";
    protected String summaryServiceUrl  = collectoryBaseUrl + "/lookup/summary";
    protected String collectionContactsUrl = collectoryBaseUrl + "/ws/collection";

    protected static final Pattern TERM_PATTERN = Pattern.compile("([a-zA-z_]+?):((\".*?\")|(\\\\ |[^: \\)\\(])+)"); // matches foo:bar, foo:"bar bash" & foo:bar\ bash

    protected static LinkedHashMap<String, String> collectionMap = null;
    protected static LinkedHashMap<String, String> institutionMap = null;
    protected static LinkedHashMap<String, String> dataResourceMap = null;

    /**
     * Initialisation method to load some field values
     */
    @PostConstruct
    public void init() {
        List<String> inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        collectionMap = collectionsCache.getCollections(inguids, coguids);
        institutionMap = collectionsCache.getInstitutions(inguids, coguids);
        dataResourceMap = collectionsCache.getDataResources(inguids, coguids);
        //logger.info("institutionMap: " + StringUtils.join(institutionMap.keySet(), "|") + " => " + StringUtils.join(institutionMap.values(), "|"));
    }

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
        init(); // update LinkedHashMap cached versions
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
            SpatialSearchRequestParams requestParams,
            BindingResult result, 
            Model model,
            HttpServletRequest request) throws Exception {
        logger.debug("/search* TOP of method");
        logger.debug("requestParams.q = " + requestParams.getQ() + " || fq = " + StringUtils.join(requestParams.getFq(), "|"));
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
    @RequestMapping(value = "/search/taxa*", method = RequestMethod.POST)
    public String taxaSearch(@RequestParam(value="raw_taxon_guid", required=false) String[] rawNames,
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
     * Multi facet search via POST or GET
     *
     * @param multiFacets
     * @param requestParams
     * @param result
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/search/facets*")
    public String multiFacetSearch(
            @RequestParam(value="fqs", required=false) String[] multiFacets,
            SpatialSearchRequestParams requestParams,
            BindingResult result,
            Model model,
            HttpServletRequest request) throws Exception {

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (request.getParameter("sort") == null && request.getParameter("dir") == null ) {
            requestParams.setSort("last_load_date");
            requestParams.setDir("desc");
            model.addAttribute("sort","last_load_date");
            model.addAttribute("dir","desc");
        }
        
        if (multiFacets != null && multiFacets.length > 0) {
            String fqs = StringUtils.join(multiFacets, " OR ");
            //List<String> fqList =  Arrays.asList(requestParams.getFq()); // convert to List
            List<String> fqList = new ArrayList<String>();
            Collections.addAll(fqList, requestParams.getFq());
            fqList.add(fqs); // add fqs
            requestParams.setFq(fqList.toArray(new String[]{})); // shove back into requestParams
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
        addToModel(model, requestParams, searchResult);
        
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
        
        String[] tq = null;
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
        
		String[] tq = null;
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
        logger.debug("Retrieving occurrence record with guid: '" + uuid + "'");
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
     * Shape file upload - extract WKT from first feature in file and run search via biocache-service and then
     * reload search via the QID cached query parameter
     *
     * @param multipartFile
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/shapeUpload", method = RequestMethod.POST)
	public String uploadShapeSearch(
            HttpServletResponse response,
            HttpServletRequest request,
            @RequestParam("file") MultipartFile multipartFile,
            Model model) throws Exception {

        logger.debug("path = /occurrences/shapeUpload");
        
        if (!multipartFile.isEmpty()) {
            String originalName = multipartFile.getOriginalFilename();
            final String baseTempPath = "/data/cache"; //System.getProperty("java.io.tmpdir"); // use System temp directory
            String filePath = baseTempPath + File.separator + originalName;
            File dest = new File(filePath);

            try {
                multipartFile.transferTo(dest); // save the file
            } catch (Exception e) {
                logger.error("Error reading upload: " + e.getMessage(), e);
                //response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File uploaded failed: " + originalName);
            }

            if (dest.length() > 0) {
                String wkt = extractGeometryFromFile(dest); // remove spaces for URL

                if (wkt != null) {
                    String serverName = request.getSession().getServletContext().getInitParameter("serverName");
                    String contextPath = request.getSession().getServletContext().getInitParameter("contextPath");
                    String url = biocacheUriPrefix + "/webportal/params";
                    HashMap<String, String> params = new HashMap<String, String>();
                    params.put("wkt", changeSeparator(wkt));
                    String qid = ProxyController.getPostUrlContentAsString(url, params);

                    if (qid != null) {
                        response.sendRedirect(serverName + contextPath + "/occurrence/search?q=qid:" +
                                ""+qid);
                    } else {
                        model.addAttribute("errors", "Shape file upload failed.");
                    }
                } else {
                    logger.error("Error extracting WKT");
                    model.addAttribute("errors", "Error extracting WKT from shape file.");
                    //response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Extracting geometry from file failed: " + originalName);
                }
            }
        }

        return RECORD_LIST;
    }

    /**
     * JSON service to return a list of facet values for a given search query & facet.
     * Supports paging* and return both the code and display value for each value.
     *
     * *coming soon
     *
     * @return facetValues
     * @throws Exception
     */
    @RequestMapping(value = "/facet/values.json")
    public @ResponseBody List<FacetValueDTO> getFacetValues(
            SpatialSearchRequestParams requestParams,
            BindingResult result) throws Exception {

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        List<FacetValueDTO> facetValues = new ArrayList<FacetValueDTO>();
        String facet = requestParams.getFacets()[0]; // assumes only single facet requested
        // TODO: add ability to page through facets
        SearchResultDTO results = biocacheService.getFacetValues(requestParams);

        for (FacetResultDTO facetResults : results.getFacetResults()) {
            // check the facet is the one we're after
            if (StringUtils.contains(facetResults.getFieldName(), facet)) {
                // iterate over facet values (fieldResultsDTO)
                for (FieldResultDTO field : facetResults.getFieldResult()) {
                    FacetValueDTO fv = new FacetValueDTO(field.getFieldValue(), field.getCount());
                    facetValues.add(fv);
                }
            }
        }

        // Lookup displayLabel values for certain facet fields (collection_uid, species_guid, etc)
        facetValues = LookupDisplayValuesForFacet(facet, facetValues);

        return facetValues;
    }

    /**
     * Check facet against FacetsWithCodes enum and perform lookup for a displayLabel
     *
     * @param facet
     * @param facetValues
     */
    private List<FacetValueDTO> LookupDisplayValuesForFacet(String facet, List<FacetValueDTO> facetValues) {
        try {
            FacetsWithCodes fwc = FacetsWithCodes.valueOf(facet);
            //List<String> inGuids = collectoryUidCache.getInstitutions();
            //List<String> coGuids = collectoryUidCache.getCollections();

            switch(fwc) {
                case institution_uid:
                    //Map<String, String> instMap = collectionsCache.getInstitutions(inGuids, coGuids);
                    for (FacetValueDTO fv : facetValues) {
                        if (institutionMap.containsKey(fv.getLabel())) {
                            fv.setDisplayLabel(institutionMap.get(fv.getLabel()));
                        }
                    }
                    break;
                case collection_uid:
                    //Map<String, String> collMap = collectionsCache.getCollections(inGuids, coGuids);
                    for (FacetValueDTO fv : facetValues) {
                        if (collectionMap.containsKey(fv.getLabel())) {
                            fv.setDisplayLabel(collectionMap.get(fv.getLabel()));
                        }
                    }
                    break;
                case data_resource_uid:
                    //Map<String, String> drMap = collectionsCache.getDataResources(inGuids, coGuids);
                    for (FacetValueDTO fv : facetValues) {
                        if (dataResourceMap.containsKey(fv.getLabel())) {
                            fv.setDisplayLabel(dataResourceMap.get(fv.getLabel()));
                        }
                    }
                    break;
                case species_guid:
                    List<String> guids = new ArrayList<String>();
                    for (FacetValueDTO fv : facetValues) {
                        guids.add(fv.getLabel());
                    }
                    List<String> names = bieService.getNamesForGuids(guids); // lookup via BIE
                    int i = 0;
                    for (FacetValueDTO fv : facetValues) {
                        if (names.size() > i) {
                            if (names.get(i) == null) {
                                fv.setDisplayLabel("[scientific name not found]");
                            } else {
                                fv.setDisplayLabel("<i>" + names.get(i) + "</i>");
                            }
                        }
                        i++;
                    }
                    break;
                case month:
                    for (FacetValueDTO fv : facetValues) {
                        try {
                            int m = Integer.parseInt(fv.getLabel());
                            Month month = Month.get(m - 1); // 1 index months
                            fv.setDisplayLabel(month.name());
                        } catch (Exception e) {
                            // ignore
                        }
                    }
                    break;
                case year:
                    facetValues = formatYearFacets(facetValues);
                    break;
            }
        } catch (IllegalArgumentException e) {
            // do nothing - normal facet without code value
        }

        return facetValues;
    }

    /**
     * Process the "year" facet values to produce the decade fq link and display label
     *
     * @param facetValues
     * @return
     */
    protected List<FacetValueDTO> formatYearFacets(List<FacetValueDTO> facetValues) {
        Boolean hasBeforeLabel = false;
        Integer earliestYear = 2010;

        for (FacetValueDTO fv : facetValues) {
            String label = fv.getLabel();

            if (StringUtils.containsIgnoreCase(label, "before")) {
                hasBeforeLabel = true;
                fv.setDisplayLabel("Before " + earliestYear);
                fv.setLabel("[* TO " + (earliestYear - 1) + "-12-31T23:59:59Z]"); // create date range fq
            } else {
                String year = StringUtils.substringBefore(label, "-"); //  fv.getLabel();
                fv.setDisplayLabel(year); // in case parseInt fails
                try {
                    Integer yearInt = Integer.parseInt(year);
                    if (yearInt < earliestYear) {
                        earliestYear = yearInt;
                    }
                    fv.setDisplayLabel(yearInt + "-" + (yearInt + 9)); // TODO assumes decade
                } catch (NumberFormatException e) {
                    // ignore
                }
                String toDate = StringUtils.replace(label, "0-01-01T00:00:00Z","9-12-31T23:59:59Z"); // TODO assumes decade
                fv.setLabel("[" + label + " TO " + toDate + "]"); // create date range fq
            }
        }

        if (hasBeforeLabel) {
            // re-order the List so that the "before" value goes at the front
            List<FacetValueDTO> newFvs = new ArrayList<FacetValueDTO>();
            FacetValueDTO last = facetValues.get(facetValues.size() - 1); // get last element
            newFvs.add(last); // add last to the front of new list
            facetValues.remove(last); //  remove the last
            newFvs.addAll(facetValues); // add the rest
            facetValues = newFvs; // clobber with new copy
        }

        return facetValues;
    }

    /**
     * Enum for facets indexed with a "code" value vs String value (e.g. collection_uid)
     */
    protected enum FacetsWithCodes {
        institution_uid, collection_uid, data_resource_uid, species_guid, month, year;
    }

    /**
     * Enum for months lookup
     */
    protected enum Month {
        January, February, March, April, May, June, July, August, September, October, November, December;

        public static Month get(int i){
            return values()[i];
        }
    }

    /**
     * WKT format for SOLR spatial plugin requires spaces to be encoded as colon ":"
     * This method converts the String to the requiered format.
     *
     * @param wkt
     * @return
     */
    private static String changeSeparator(String wkt) {
        String encodedWkt = StringUtils.trimToEmpty(new String(wkt));
        encodedWkt = StringUtils.replace(encodedWkt, " (", "("); // "MULTIPOLYGON ((" to "MULTIPOLYGON(("
        encodedWkt = StringUtils.replace(encodedWkt, ", ", ","); // "140 -37, 151: -37" to "140 -37,151 -37"
        encodedWkt = StringUtils.replace(encodedWkt, " ", ":"); // "140 -37,151 -37" to "140:-37,151:-37"
        return encodedWkt;
    }

    /**
     * Read a shape file and get the WKT for the first feature in the file.
     *
     * @param file
     * @return
     */
    private String extractGeometryFromFile(File file) {
        String wkt = null;
        //file = new File("/data/cache/states.shp");
        //file = new File("/var/folders/No/NoP-toBNE2esClaNHW+R5U+++TI/-Tmp-/as.shp");

        try {
            logger.info("Reading shape file at: " + file.getAbsolutePath());
            Map<String,Serializable> connectParameters = new HashMap<String,Serializable>();
            connectParameters.put("url", file.toURI().toURL());
            connectParameters.put("create spatial index", true);
            DataStore dataStore = DataStoreFinder.getDataStore(connectParameters);
            // we are now connected
            String[] typeNames = dataStore.getTypeNames();
            String typeName = typeNames[0];
            FeatureSource<SimpleFeatureType, SimpleFeature> featureSource = dataStore.getFeatureSource(typeName);
            FeatureCollection collection = featureSource.getFeatures();
            FeatureIterator<SimpleFeature> iterator = collection.features();

            try {
                while (iterator.hasNext()) {
                    SimpleFeature feature = iterator.next();
                    logger.info("feature info: " + feature.toString());
                    Geometry geometry = (Geometry) feature.getDefaultGeometry();

                    if (geometry != null && geometry.isValid()) {
                        wkt = geometry.toText();
                        logger.info("WKT = " + StringUtils.abbreviate(wkt, 1024));
                        break;
                    }
                }
            } catch (Exception e) {
                logger.error("Error reading feature: " + e.getMessage(), e);
            } finally {
                iterator.close();
            }

        } catch (Throwable e) {
            logger.error("extractGeometryFromFile error: " + e.getMessage(), e);
        }

        return wkt;
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
     * Create a HashMap for the filter queries, using the first SOLR field as the key and subsequent
     * query string as the value.
     *
     * Refactor: now returns a Map<String, ActiveFacet> with an additional field "label" that is used to
     * provide a human readable version of the filter query.
     *
     * @param filterQuery
     * @return
     */
    protected Map<String, ActiveFacet> addFacetMap(String[] filterQuery) {
        Map<String, ActiveFacet> afs = new HashMap<String, ActiveFacet>();

        if (filterQuery != null && filterQuery.length > 0) {
            // iterate over the fq params
            for (String fq : filterQuery) {
                if (fq != null && !fq.isEmpty()) {
                    String[] fqBits = StringUtils.split(fq, ":", 2);
                    // extract key for map
                    if (fqBits.length  == 2) {
                        String key = fqBits[0];
                        String value = fqBits[1];
                        
                        if ("data_hub_uid".equals(key)) {
                            // exclude these...
                            continue;
                        }
                        
                        ActiveFacet af = new ActiveFacet(key, value);
                        logger.debug("1. fq = " + key + " => " + value);
                        // if there are internal Boolean operators, iterate over sub queries
                        String patternStr = "[ ]+(OR)[ ]+";
                        String[] tokens = fq.split(patternStr, -1);
                        List<String> labels = new ArrayList<String>(); // store sub-queries in this list

                        for (String token : tokens) {
                            logger.info("token: " + token);
                            String[] tokenBits = StringUtils.split(token, ":", 2);
                            if (tokenBits.length == 2) {
                                String fn = tokenBits[0];
                                String fv = tokenBits[1];
                                String i18n = messageSource.getMessage("facet."+fn, null, fn, null);

                                if (StringUtils.equals(fn, "species_guid")) {
                                    fv = substituteLsidsForNames(fv.replaceAll("\"",""));
                                } else if (StringUtils.equals(fn, "occurrence_year")) {
                                    fv = substituteYearsForDates(fv);
                                } else if (StringUtils.equals(fn, "month")) {
                                    fv = substituteMonthNamesForNums(fv);
                                } else if (StringUtils.equals(fn, "collector") && StringUtils.contains(fv, "@")) {
                                    fv = StringUtils.substringBefore(fv, "@"); // hide email addresses
                                } else {
                                    fv = substituteCollectoryNames(fv);
                                }

                                labels.add(i18n + ":" + fv);
                            }
                        }

                        String label = StringUtils.join(labels, " OR "); // join sub-queies back together
                        logger.info("label = " + label);
                        af.setLabel(label);

                        afs.put(key, af); // add to map
                    }
                }
            }
        }

        return afs;
    }

    /**
     * Convert month number to its name. E.g. 12 -> December
     *
     * @param fv
     * @return monthStr
     */
    private String substituteMonthNamesForNums(String fv) {
        String monthStr = new String(fv);
        try {
            int m = Integer.parseInt(monthStr);
            Month month = Month.get(m - 1); // 1 index months
            monthStr = month.name();
        } catch (Exception e) {
            // ignore
        }
        return monthStr;
    }

    /**
     * Turn SOLR date range into year range.
     * E.g. [1940-01-01T00:00:00Z TO 1949-12-31T00:00:00Z]
     * to
     * 1940-1949
     * 
     * @param fieldValue
     * @return
     */
    private String substituteYearsForDates(String fieldValue) {
        String dateRange = URLDecoder.decode(fieldValue);
        String formattedDate = StringUtils.replaceChars(dateRange, "[]", "");
        String[] dates =  formattedDate.split(" TO ");
        
        if (dates != null && dates.length > 1) {
            // grab just the year portions
            dateRange = StringUtils.substring(dates[0], 0, 4) + "-" + StringUtils.substring(dates[1], 0, 4);
        }

        return dateRange;
    }

    /**
     * Lookup a taxon name for a GUID
     *
     * @param fieldValue
     * @return
     */
    private String substituteLsidsForNames(String fieldValue) {
        String name = fieldValue;
        List<String> guids = new ArrayList<String>();
        guids.add(fieldValue);
        List<String> names = bieService.getNamesForGuids(guids);
        
        if (names != null && names.size() >= 1) {
            name = names.get(0);
        }

        return name;
    }

    /**
     * Lookup an institution/collection/data resource name via its collectory ID
     *
     * @param fieldValue
     * @return
     */
    private String substituteCollectoryNames(String fieldValue) {
        // substitute collectory names
        logger.debug("collectory maps: " + fieldValue);
        if (collectionMap.containsKey(fieldValue)) {
            fieldValue = collectionMap.get(fieldValue);
        } else if (institutionMap.containsKey(fieldValue)) {
            fieldValue = institutionMap.get(fieldValue);
        } else if (dataResourceMap.containsKey(fieldValue)) {
            fieldValue = dataResourceMap.get(fieldValue);
        }
        logger.debug("=> " + fieldValue);
        return fieldValue;
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
        if ("*:*".equals(searchResult.getQueryTitle())) {
            searchResult.setQueryTitle("[all records]");
        }

        if (StringUtils.isEmpty(searchResult.getQueryTitle())) {
            // if queryTitle is empty use the raw query (truncated)
            searchResult.setQueryTitle(StringUtils.abbreviate(searchResult.getQuery(), 2048));
        }

        if (requestParams.getDisplayString() == null || requestParams.getDisplayString().isEmpty()) {
            requestParams.setDisplayString(searchResult.getQueryTitle());
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
     * TODO: move static methods from HomePageController into utility class.
     *
     * @param model
     */
    private void addCommonDataToModel(Model model) {
        List<String> inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        model.addAttribute("collectionCodes", collectionMap);
        model.addAttribute("institutionCodes", institutionMap);
        model.addAttribute("dataResourceCodes", dataResourceMap);
        model.addAttribute("defaultFacets", filterFacets(biocacheService.getDefaultFacets()));
        model.addAttribute("downloadExtraFields", downloadExtraFields); // String[]
        model.addAttribute("LoggerSources", loggerService.getSources());
        model.addAttribute("LoggerReason", loggerService.getReasons());
    }

    /**
     * Filter facets by checking an exclude list specified in hubs.properties
     *
     * @param defaultFacets
     * @return facetsList
     */
    private LinkedHashMap<String, Boolean> filterFacets(List<String> defaultFacets) {
        LinkedHashMap<String, Boolean> facetsMap = new LinkedHashMap<String, Boolean>();
        ArrayList<String> allFacets = new ArrayList<String>(defaultFacets); // needed for addAll()
        String[] excludeArray = null;
        String[] hideArray = null;

        if (StringUtils.isNotEmpty(facetsInclude)) {
            // possible to get duplicates if added to default facets but hashmap should combine them back to one
            allFacets.addAll(Arrays.asList(StringUtils.split(facetsInclude, ",")));
        }

        if (StringUtils.isNotEmpty(facetsExclude)) {
            excludeArray = StringUtils.split(facetsExclude, ",");
        }

        if (StringUtils.isNotEmpty(facetsHide)) {
            hideArray = StringUtils.split(facetsHide, ",");
        }

        for (String facet : allFacets) {
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
        
        logger.info("hasMultimedia = " + hasMultimedia);
        
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
