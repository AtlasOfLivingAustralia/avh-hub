/* *************************************************************************
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

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.ala.biocache.dto.SearchResultDTO;
import org.ala.biocache.dto.SpatialSearchRequestParams;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.httpclient.params.HttpClientParams;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.jasig.cas.client.util.AbstractCasFilter;
import org.jasig.cas.client.validation.Assertion;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestOperations;
import org.springframework.web.servlet.HandlerMapping;

import java.io.*;
import java.util.*;

/**
 * Simple proxy controller to proxy requests to other ALA domains and thus overcome the
 * cross-domain restrictions of AJAX.
 * 
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Controller
@RequestMapping("/proxy")
public class ProxyController {
    /** Logger initialisation */
	private final static Logger logger = Logger.getLogger(ProxyController.class);
    /** Gazetteer URL */
    private final String SPATIAL_PORTAL_URL = "http://spatial.ala.org.au";
    /** WordPress URL */
    private final String WORDPRESS_URL = "http://www.ala.org.au/";

    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring

    @Value("${biocacheRestService.biocacheUriPrefix}")
    String biocacheUriPrefix = null;
    @Value("${biocacheRestService.apiKey}")
    String apiKey = null;
    @Value("${clubRoleForHub}")
    String clubRoleForHub = null;
    @Value("${bieRestService.bieUriPrefix}")
    String bieUriPrefix = null;

    /**
     * Proxy to WordPress site using page_id URI format
     *
     * @param query
     * @param layerName
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/gazetteer/search", method = RequestMethod.GET)
    public void getGazetteerContentforPageId(
            @RequestParam(value="q", required=true) String query,
            @RequestParam(value="layer", required=false) String layerName,
            HttpServletResponse response) throws Exception {

        StringBuilder urlString = new StringBuilder(SPATIAL_PORTAL_URL+"/ws/search?q="+query);

        if (layerName != null && !layerName.isEmpty()) {
            urlString.append("&layer=").append(layerName);
        }

        logger.info("proxy URI: "+urlString);

        try {
            String contentAsString = getUrlContentAsString(urlString.toString(), 10000);
            response.setContentType("text/xml;charset=UTF-8");
            response.getWriter().write(contentAsString);
        } catch (Exception ex) {
            // send a 500 so ajax client does not display WP not found page
            response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(ex.getMessage());
            logger.error("Proxy error: "+ex.getMessage(), ex);
        }
    }
    
    /**
     * Proxy to WordPress site using page_id URI format
     * 
     * @param pageId
     * @param contentOnly
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/wordpress", method = RequestMethod.GET)
    public void getWordPressContentforPageId(
            @RequestParam(value="page_id", required=true) String pageId,
            @RequestParam(value="content-only", required=false) String contentOnly,
            HttpServletResponse response) throws Exception {

        StringBuilder urlString = new StringBuilder(WORDPRESS_URL+"?page_id="+pageId);
        
        if (contentOnly != null && !contentOnly.isEmpty()) {
            urlString.append("&content-only=").append(contentOnly);
        }

        logger.info("proxy URI: "+urlString);

        try {
            String contentAsString = getUrlContentAsString(urlString.toString(), 10000);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(contentAsString);
        } catch (Exception ex) {
            // send a 500 so ajax client does not display WP not found page
            response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(ex.getMessage());
            logger.error("Proxy error: "+ex.getMessage(), ex);
        }
    }

    /**
     * Attempt at proxying the downloads from biocache-service
     * Does NOT currently work for zip files...
     *
     * @param path
     * @param file
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/download/{path}/**", method = RequestMethod.GET)
    public void proxyBiocacheDownloads(@PathVariable("path") String path,
                @RequestParam(value="file", required=true) String file,
                HttpServletRequest request, HttpServletResponse response) throws Exception {

        String restOfTheUrl = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE); // get bit matched by **
        
        if (StringUtils.isNotEmpty(restOfTheUrl)) {
            path = path + "/" + restOfTheUrl;
        }
        
        logger.debug("path = " + path);
        String biocacheServiceUrl = biocacheUriPrefix + "/occurrences/" + path + "?";
        List<String> paramList = new ArrayList<String>();
        
        //for (String paramName : (List<String>) request.getParameterNames()) {
        Enumeration enumeration = request.getParameterNames();
        while (enumeration.hasMoreElements()) {
            String paramName = (String) enumeration.nextElement();
            String[] paramValues = request.getParameterValues(paramName);
            
            for (String paramValue : paramValues) {
                paramList.add(paramName + "=" + paramValue);
            }
        }
        
        // check for club role...
        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));
        String userId = null;
        String url = biocacheServiceUrl + StringUtils.join(paramList, "&");

        if (assertion != null) {
            AttributePrincipal principal = assertion.getPrincipal();
            userId = principal.getName();
        }

        // Check if user has role to view "club" version of records
        if (userId != null && (request.isUserInRole(clubRoleForHub))) {
            url = url + "&apiKey=" + apiKey;
        }

        logger.info("trying URL: " + url);

        HttpConnectionManagerParams cmParams = new HttpConnectionManagerParams();
        cmParams.setSoTimeout(60000);
        cmParams.setConnectionTimeout(60000);
        HttpConnectionManager manager = new SimpleHttpConnectionManager();
        manager.setParams(cmParams);
        HttpClientParams params = new HttpClientParams();
        params.setContentCharset("UTF-8");
        HttpClient client = new HttpClient(params, manager);
        URI uri = new URI(url);
        GetMethod method = new GetMethod(uri.getEscapedURI());

        try {
            // Execute the method.
            int statusCode = client.executeMethod(method);

            if (statusCode != HttpStatus.SC_OK) {
                logger.error("Method failed: " + method.getStatusLine());
            }

            // Read the response body.
            DataInputStream stream = new DataInputStream(new BufferedInputStream(method.getResponseBodyAsStream()));

            String filename = (StringUtils.isNotBlank(file)) ? file : "data";
            String contentType = method.getResponseHeader("Content-Type").getValue(); // e.g. application/json;charset=UTF-8
            contentType = StringUtils.substringBefore(contentType, ";"); // e.g. application/json
            String ext = StringUtils.substringAfter(contentType, "/"); // e.g. json
            logger.debug("Content-Type value = " + contentType);
            response.setHeader("Content-Disposition", "attachment;filename=" + filename + "." + ext);
            response.setContentType(contentType);
            byte[] bytes = new byte[512];
            int read = -1;
            while ((read = stream.read(bytes)) != -1) {
                response.getOutputStream().write(bytes, 0, read);
                response.getOutputStream().flush();
            }

            response.getOutputStream().flush();
            response.getOutputStream().close();
            stream.close();
        } catch (HttpException e) {
            logger.error("Fatal protocol violation: " + e.getMessage());
            //e.printStackTrace();
        } catch (IOException e) {
            logger.error("Fatal transport error: " + e.getMessage());
            //e.printStackTrace();
        } finally {
            // Release the connection.
            method.releaseConnection();
        }
    }

    @RequestMapping(value = "/i18n/{messageSource:.+}*", method = RequestMethod.GET)
    public void proxyBiocacheMessages(@PathVariable("messageSource") String messageSource,
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        StringBuilder urlString = new StringBuilder(biocacheUriPrefix + "/facets/i18n");

        logger.info("proxy URI: "+urlString);

        try {
            String contentAsString = getUrlContentAsString(urlString.toString(), 10000);
            String[] lines = contentAsString.split(System.getProperty("line.separator"));
            StringBuilder trimmedContent = new StringBuilder();

            for (String line : lines) {
                if (!line.isEmpty()) {
                    trimmedContent.append(line).append(System.getProperty("line.separator"));
                }
            }

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(trimmedContent.toString());
        } catch (Exception ex) {
            // send a 500 so ajax client does not display WP not found page
            response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(ex.getMessage());
            logger.error("Proxy error: "+ex.getMessage(), ex);
        }
    }

    @RequestMapping(value = "/exploreGroupWithGallery", method = RequestMethod.GET)
    public @ResponseBody List<CustomTaxonDTO> exploreGroupWithGallery(
            @RequestParam(value="taxa", required=false, defaultValue = "") String taxa,
            @RequestParam(value="group", required=false, defaultValue = "ALL_SPECIES") String group,
            @RequestParam(value="common", required=false, defaultValue = "true") String common,
            SpatialSearchRequestParams requestParams,
            BindingResult result,
            HttpServletRequest request,
            Model model) {

        // First, grab a list of species for a given BC search
        List<CustomTaxonDTO> ctList = new ArrayList<CustomTaxonDTO>();
        String searchDTOListJson = "";
        List<Map<String, Object>> groupList = new ArrayList<Map<String, Object>>();
        String jsonUri = biocacheUriPrefix +"/explore/group/" + group + ".json?" +
                "q=" + requestParams.getQ() + "&fq=" + StringUtils.join(requestParams.getFq() , "&fq=")+ "&taxa=" + taxa +
                "&qc=" + requestParams.getQc() + "&pageSize=" + requestParams.getPageSize() + "&start=" + requestParams.getStart() +
                "&sort=" + requestParams.getSort() + "&common=" + common;

        try {
            logger.debug("Requesting groups via: " + jsonUri);
            groupList = restTemplate.getForObject(jsonUri, List.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }

        // Grab the guids and add them to a List
        List<String> guids = new ArrayList<String>();
        Map<String, CustomTaxonDTO> taxaMap = new HashMap<String, CustomTaxonDTO>();

        for (Map<String, Object> taxon : groupList) {
            if (taxon.containsKey("guid")) {
                logger.debug("taxon = " + taxon);
                String guid = (String) taxon.get("guid");
                guids.add(guid);
                // populate the Map as well
                CustomTaxonDTO ct = new CustomTaxonDTO(guid);
                ct.setScientificName((String) taxon.get("name"));
                ct.setCommonName((String) taxon.get("commonName"));
                try {
                    ct.setCount((Integer) taxon.get("count"));
                } catch (NumberFormatException e) {
                    logger.warn("Error converting count to Long: " + e.getMessage());
                }
                taxaMap.put(guid, ct);
            }
        }

        ObjectMapper objectMapper = new ObjectMapper();
        List<String> searchListOfGuids = new ArrayList<String>(); // so we can keep original order of 1st WS call
        String guidsJsonString = "";
        try {
            guidsJsonString = objectMapper.writeValueAsString(guids);
        } catch(Exception ex) {
            logger.error("ObjectMapper error: " + ex.getMessage(), ex);
        }

        try {
            final String bieJsonUri = bieUriPrefix+"/species/bulklookup.json"; // TODO get it from properties file
            searchDTOListJson = getPostUrlContentAsString(bieJsonUri, null, guidsJsonString);
            // unmarshall json
            Map<String, Object> sr = objectMapper.readValue(searchDTOListJson, Map.class);
            List<Object> searchDTOList = (List) sr.get("searchDTOList");
            logger.debug("searchDTOList = " + StringUtils.join(searchDTOList, "|"));

            for (Object taxaObj : searchDTOList) {
                Map<String, Object> taxon = (Map) taxaObj;
                String guid = (String) taxon.get("guid");
                searchListOfGuids.add(guid);

                if (taxaMap.containsKey(guid)) {
                    // populate the existing taxaMap with image info, etc.
                    CustomTaxonDTO ct = taxaMap.get(guid);

                    if (taxon.containsKey("smallImageUrl")) {
                        ct.setThumbnailUrl((String) taxon.get("smallImageUrl"));
                    }
                    if (taxon.containsKey("largeImageUrl")) {
                        ct.setLargeImageUrl((String) taxon.get("largeImageUrl"));
                    }
                    if (taxon.containsKey("rank")) {
                        ct.setRank((String) taxon.get("rank"));
                    }
                    if (taxon.containsKey("rankId")) {
                        ct.setRankId((Integer) taxon.get("rankId"));
                    }

                    taxaMap.put(guid, ct); // save it back

                } else {
                    logger.warn("Expected guid not found in taxaMap: " + guid);
                }
            }

        } catch (Exception ex) {
            logger.error("HttpClient error: " + ex.getMessage(), ex);
        }

        // convert Map to List (using order from first WS call)
        for (String guid : searchListOfGuids) {
            if (taxaMap.containsKey(guid)) {
                ctList.add(taxaMap.get(guid));
            } else {
                logger.warn("Expected guid not found in taxaMap: " + guid);
            }
        }

        return ctList;
    }

    /**
   * Retrieve content as String.
   *
   * @param url
   * @return
   * @throws Exception
   */
	public static String getUrlContentAsString(String url, int timeoutInMillisec) throws Exception {
		GetMethod gm = null;
        String content = null;

		try {
            HttpConnectionManagerParams cmParams = new HttpConnectionManagerParams();
		    cmParams.setSoTimeout(timeoutInMillisec);
		    cmParams.setConnectionTimeout(timeoutInMillisec);
		    HttpConnectionManager manager = new SimpleHttpConnectionManager();
		    manager.setParams(cmParams);
		    HttpClientParams params = new HttpClientParams();
            params.setContentCharset("UTF-8");
		    HttpClient client = new HttpClient(params, manager);
			gm = new GetMethod(url);
            gm.setFollowRedirects(true);
            client.executeMethod(gm);

            if (gm.getStatusCode() == 200) {
                logger.debug("Setting content from responseBody");
                content = gm.getResponseBodyAsString();
            } else {
                throw new Exception("HTTP request for "+url+" failed. Status code: "+gm.getStatusCode());
            }
        } catch (Exception ex) {
            logger.warn("HTTP connection error: "+ex.getMessage(), ex);
        } finally {
            if (gm != null) {
				logger.debug("Releasing connection");
				gm.releaseConnection();
			}
        }

		return content;
	}

    /**
     * Perform am HTTP POST on a URL and return the content as String
     *
     * @param url
     * @param params
     * @return
     * @throws Exception
     */
    public static String getPostUrlContentAsString(String url, Map<String, String> params, String jsonPostBody) throws Exception {
        String content = null;

        HttpClient httpClient = new HttpClient();
        PostMethod postMethod = new PostMethod(url);

        if (params != null) {
            for (String key : params.keySet()) {
                // set POST params
                postMethod.addParameter(key, params.get(key));
                //postMethod.addParameter("wkt", "POLYGON((140:-37,151:-37,151:-26,140.1310:-26,140:-37))");
            }

            postMethod.setRequestHeader("ContentType","application/x-www-form-urlencoded;charset=UTF-8");
            postMethod.setRequestHeader("Accept", "application/json;charset=UTF-8");
            logger.debug("Attempting POST to " + url + " with params: " + StringUtils.abbreviate(postMethod.getParameter("wkt").getValue(), 2048));
        }

        if (jsonPostBody != null) {
            // post.setEntity(new StringEntity(jsonBody))
            postMethod.setRequestEntity(new StringRequestEntity(jsonPostBody, "application/json", "UTF-8"));
            logger.debug("Attempting POST to " + url + " with body: " + StringUtils.abbreviate(jsonPostBody, 1024));
        }

        try {
            httpClient.executeMethod(postMethod);
            
            if (postMethod.getStatusCode() == HttpStatus.SC_OK) {
                content = postMethod.getResponseBodyAsString();
                logger.debug("content = " + content);
            } else {
                logger.error("POST to " + url + " returned status: " + postMethod.getStatusLine());
            }

        } catch (HttpException e) {
            logger.error("HttpException error: " + e.getMessage(), e);
        } catch (IOException e) {
            logger.error("IOException error: " + e.getMessage(), e);
        } finally {
            if (postMethod != null) {
				logger.debug("Releasing connection");
				postMethod.releaseConnection();
			}
        }

        return content;
    }

    /**
     * Inner DTO class for holding search-specific data on the taxa from that search
     */
    private class CustomTaxonDTO {
        protected String guid;
        protected String scientificName;
        protected String commonName;
        protected String rank;
        protected Integer rankId;
        protected Integer count;
        protected String thumbnailUrl;
        protected String largeImageUrl;

        public CustomTaxonDTO() {
            //
        }

        public CustomTaxonDTO(String guid) {
            this.guid = guid;
        }

        @Override
        public String toString() {
            return "CustomTaxonDTO{" +
                    "guid='" + guid + '\'' +
                    ", scientificName='" + scientificName + '\'' +
                    ", commonName='" + commonName + '\'' +
                    ", rank='" + rank + '\'' +
                    ", rankId=" + rankId +
                    ", count=" + count +
                    ", thumbnailUrl='" + thumbnailUrl + '\'' +
                    ", largeImageUrl='" + largeImageUrl + '\'' +
                    '}';
        }

        public String getGuid() {
            return guid;
        }

        public void setGuid(String guid) {
            this.guid = guid;
        }

        public String getScientificName() {
            return scientificName;
        }

        public void setScientificName(String scientificName) {
            this.scientificName = scientificName;
        }

        public String getCommonName() {
            return commonName;
        }

        public void setCommonName(String commonName) {
            this.commonName = commonName;
        }

        public String getRank() {
            return rank;
        }

        public void setRank(String rank) {
            this.rank = rank;
        }

        public Integer getRankId() {
            return rankId;
        }

        public void setRankId(Integer rankId) {
            this.rankId = rankId;
        }

        public Integer getCount() {
            return count;
        }

        public void setCount(Integer count) {
            this.count = count;
        }

        public String getThumbnailUrl() {
            return thumbnailUrl;
        }

        public void setThumbnailUrl(String thumbnailUrl) {
            this.thumbnailUrl = thumbnailUrl;
        }

        public String getLargeImageUrl() {
            return largeImageUrl;
        }

        public void setLargeImageUrl(String largeImageUrl) {
            this.largeImageUrl = largeImageUrl;
        }
    }
}
