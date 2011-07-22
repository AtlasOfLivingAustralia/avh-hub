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
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Collection;
import java.util.HashMap;
import java.util.logging.Level;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import au.org.ala.biocache.QualityAssertion;
import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.SearchRequestParams;
import au.org.ala.biocache.FullRecord;
import au.org.ala.biocache.SpeciesGroups;
import au.org.ala.biocache.TypeStatus;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import org.ala.biocache.dto.SpatialSearchRequestParams;
import org.ala.biocache.dto.store.OccurrenceDTO;
import org.ala.biocache.util.CollectionsCache;
import org.ala.client.util.RestfulClient;
import org.ala.hubs.dto.AssertionDTO;
import org.ala.hubs.service.BiocacheService;
import org.ala.hubs.service.CollectoryUidCache;
import org.ala.hubs.service.GazetteerCache;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.lang.StringEscapeUtils;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.jasig.cas.client.util.AbstractCasFilter;
import org.jasig.cas.client.validation.Assertion;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestOperations;

/**
 * Occurrence record Controller
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("occurrenceController")
@RequestMapping(value = "/occurrences")
public class OccurrenceController {

	private final static Logger logger = Logger.getLogger(OccurrenceController.class);
	
	/** BiocacheService injected by IoC */
    @Inject
    private BiocacheService biocacheService;
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
    /* View names */
    private final String RECORD_LIST = "occurrences/list";
    private final String RECORD_SHOW = "occurrences/show";
    private final String RECORD_MAP = "occurrences/map";
    private final String ANNOTATE_EDITOR = "occurrences/annotationEditor";
    protected String collectoryBaseUrl = "http://collections.ala.org.au";
    protected String summaryServiceUrl  = collectoryBaseUrl + "/lookup/summary";
    private String collectionContactsUrl = collectoryBaseUrl + "/ws/collection";

    /**
     * Sets up state variables and calls the annotation editor jsp.
     * @param uuid
     * @param result
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/annotate/{uuid:.+}", method = RequestMethod.GET)
    public String annotate(@PathVariable("uuid") String uuid, Model model, HttpServletRequest request) throws Exception{

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));
        String userId = null;
        if (assertion != null) {
            AttributePrincipal principal = assertion.getPrincipal();
            model.addAttribute("userId", principal.getName());
            userId = principal.getName();

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
     * @param query
     * @param filterQuery
     * @param startIndex
     * @param pageSize
     * @param sortField
     * @param sortDirection
     * @param radius
     * @param latitude
     * @param longitude
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/searchByArea*", method = RequestMethod.GET)
	public String occurrenceSearchByArea(
			SpatialSearchRequestParams requestParams,
            BindingResult result,
            HttpServletRequest request,
			Model model) throws Exception {
        logger.info("/searchByArea* TOP");
        if (requestParams.getQ() == null || requestParams.getQ().isEmpty()) {
			return RECORD_LIST;
		}

		// SearchQuery searchQuery = new SearchQuery(query, "spatial", filterQuery);
        //        searchUtils.updateQueryDetails(searchQuery);
		//searchUtils.updateTaxonConceptSearchString(searchQuery);

		if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }
        
        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }
        
        String query = requestParams.getQ();
        logger.info("searchByArea - requestParams = " + requestParams);

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
                logger.info("new query: "+query);
            }

            requestParams.setLat(Float.parseFloat(queryParts[1]));
            requestParams.setLon(Float.parseFloat(queryParts[2]));
            requestParams.setRadius(Float.parseFloat(queryParts[3]));
        }

		//SearchResultDTO searchResult = new SearchResultDTO();
//		String queryJsEscaped = StringEscapeUtils.escapeJavaScript(query);
        StringBuilder displayQuery = new StringBuilder(StringUtils.substringAfter(query, ":").replace("*", "(all taxa)"));
        displayQuery.append(" - within "+requestParams.getRadius()+" km of point ("+requestParams.getLat()+", "+requestParams.getLon()+")");
		requestParams.setDisplayString(displayQuery.toString());
//        model.addAttribute("entityQuery", displayQuery.toString());
//		model.addAttribute("query", query);
//		model.addAttribute("queryJsEscaped", queryJsEscaped);
//		model.addAttribute("facetQuery", requestParams.getFq());
//        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("latitude", requestParams.getLat());
        model.addAttribute("longitude", requestParams.getLon());
        model.addAttribute("radius", requestParams.getRadius());
        String[] userFacets = getFacetsFromCookie(request);
        logger.info("userFacets = "+userFacets);
        if (userFacets.length > 0) requestParams.setFacets(userFacets);
        //searchResult = searchDAO.findByFulltextSpatialQuery(query, searchQuery.getFilterQuery(), latitude, longitude, radius, startIndex, pageSize, sortField, sortDirection);
        SearchResultDTO searchResult = biocacheService.findBySpatialFulltextQuery(requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchRequestParams", requestParams);
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        addCommonDataToModel(model);
		//model.addAttribute("lastPage", calculateLastPage(totalRecords, requestParams.getPageSize()));

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
    public String search(SearchRequestParams requestParams, BindingResult result, Model model,
            HttpServletRequest request) throws Exception {
        logger.info("/search* TOP");
        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));

        // *****
        String userId = null;
        if (assertion != null) {
            AttributePrincipal principal = assertion.getPrincipal();
            model.addAttribute("userId", principal.getName());
            userId = principal.getName();

            String fullName = "";
            if (principal.getAttributes().get("firstname") != null && principal.getAttributes().get("lastname") != null) {
                fullName = principal.getAttributes().get("firstname").toString() + " " + principal.getAttributes().get("lastname").toString();
            }
            model.addAttribute("userDisplayName", fullName);
        }

        model.addAttribute("errorCodes", biocacheService.getUserCodes());
        // *****

        if (request.getParameter("pageSize") == null) {
            requestParams.setPageSize(20);
        }

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        //reverse the sort direction for the "score" field a normal sort should be descending while a reverse sort should be ascending
        //sortDirection = getSortDirection(sortField, sortDirection);
        String[] userFacets = getFacetsFromCookie(request);
        if (userFacets.length > 0) requestParams.setFacets(userFacets);
        requestParams.setDisplayString(requestParams.getQ()); // replace with sci name if a match is found
        
        SearchResultDTO searchResult = biocacheService.findByFulltextQuery(requestParams);
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        addCommonDataToModel(model);
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
			SearchRequestParams requestParams,
            @PathVariable("guid") String guid,
            HttpServletRequest request,
            Model model) throws Exception {

        //requestParams.setQ("taxonConceptID:" + guid);
        requestParams.setDisplayString("taxonConcept: "+guid); // replace with sci name if a match is found
        String[] userFacets = getFacetsFromCookie(request);
        if (userFacets.length > 0) requestParams.setFacets(userFacets);
        SearchResultDTO searchResult = biocacheService.findByTaxonConcept(guid, requestParams);
        logger.debug("searchResult: " + searchResult.getTotalRecords());
        model.addAttribute("searchResults", searchResult);
        model.addAttribute("facetMap", addFacetMap(requestParams.getFq()));
        model.addAttribute("lastPage", calculateLastPage(searchResult.getTotalRecords(), requestParams.getPageSize()));
        addCommonDataToModel(model);
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
            model.addAttribute("userId", principal.getName());
            userId = principal.getName();

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

        String collectionUid = null;

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
            
            Collection<AssertionDTO> grouped = null;
            if (userId != null && record.getUserAssertions() != null) {
                grouped = AssertionUtils.groupAssertions(record.getUserAssertions().toArray(new QualityAssertion[0]), userId);
            }
            model.addAttribute("groupedAssertions", grouped);
            model.addAttribute("record", record);
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
     * Test for bug in Spring with commas in parameter.
     *
     * @param requestParams
     * @param result
     * @param response
     * @throws IOException
     */
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public void test(SearchRequestParams requestParams, BindingResult result, HttpServletResponse response) throws IOException {
        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("text/plain");
        String msg = "fq = " + StringUtils.join(requestParams.getFq(), "|");
        response.getWriter().println(msg);
        logger.debug(msg);
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
     * Add "common" data structures required for search pages (list.jsp).
     *
     * TODO: move static methods from HomePAgeController into utility class.
     *
     * @param model
     */
    private void addCommonDataToModel(Model model) {
        List<String>inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        model.addAttribute("collectionCodes", collectionsCache.getCollections(inguids, coguids));
        model.addAttribute("institutionCodes", collectionsCache.getInstitutions(inguids, coguids));
        model.addAttribute("collections", collectionsCache.getCollections(inguids, coguids));
        model.addAttribute("institutions", collectionsCache.getInstitutions(inguids, coguids));
        model.addAttribute("typeStatus", HomePageController.extractTermsList(TypeStatus.all()));
        model.addAttribute("basisOfRecord", HomePageController.extractTermsList(BasisOfRecord.all()));
        model.addAttribute("states", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.STATE)); // extractTermsList(States.all())
        model.addAttribute("ibra", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.IBRA));
        model.addAttribute("imcra", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.IMCRA));
//        model.addAttribute("lga", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.LGA));
        model.addAttribute("speciesGroups", HomePageController.extractSpeciesGroups(SpeciesGroups.groups()));
        model.addAttribute("defaultFacets", new SearchRequestParams().getFacets());
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
        String[] facets = {};
        String rawCookie = getCookieValue(request.getCookies(), "user_facets", null);
        
        if (rawCookie != null) {
            try {
                userFacets = URLDecoder.decode(rawCookie, "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                logger.error(ex.getMessage(), ex);
            }
            
            if (userFacets != null) {
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
        for (int i = 0; i < cookies.length; i++) {
            Cookie cookie = cookies[i];
            if (cookieName.equals(cookie.getName())) {
                return (cookie.getValue());
            }
        }
        return (defaultValue);
    }
}
