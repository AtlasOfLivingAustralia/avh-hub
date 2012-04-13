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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpClientParams;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.HandlerMapping;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

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

    @Value("${biocacheRestService.biocacheUriPrefix}")
    String biocacheUriPrefix = null;

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

        StringBuilder urlString = new StringBuilder(SPATIAL_PORTAL_URL+"/gazetteer/search?q="+query);

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

        String url = biocacheServiceUrl + StringUtils.join(paramList, "&");
        logger.debug("trying URL: " + url);
        // Create an instance of HttpClient.
        //HttpClient client = new HttpClient();
        // Create a method instance.
        //GetMethod method = new GetMethod(url);
        // Provide custom retry handler is necessary
        //method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
        //        new DefaultHttpMethodRetryHandler(3, false));


        HttpConnectionManagerParams cmParams = new HttpConnectionManagerParams();
        cmParams.setSoTimeout(5000);
        cmParams.setConnectionTimeout(5000);
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
            //BufferedReader in = new BufferedReader(new InputStreamReader(method.getResponseBodyAsStream()));
            DataInputStream stream = new DataInputStream(new BufferedInputStream(method.getResponseBodyAsStream()));

            String filename = (StringUtils.isNotBlank(file)) ? file : "data";
            String contentType = method.getResponseHeader("Content-Type").getValue(); // e.g. application/json;charset=UTF-8
            contentType = StringUtils.substringBefore(contentType, ";"); // e.g. application/json
            String ext = StringUtils.substringAfter(contentType, "/"); // e.g. json
            logger.debug("Content-Type value = " + contentType);
            response.setHeader("Content-Disposition", "attachment;filename=" + filename + "." + ext);
            response.setContentType(contentType);
            byte[] bytes = new byte[512];

            while ((stream.read(bytes)) != -1) {
                response.getOutputStream().write(bytes);
                response.getOutputStream().flush();
            }

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

//        URL url = new URL(biocacheServiceUrl + StringUtils.join(paramList, "&"));
//        logger.info("trying URL: " + url.toString());
//        URLConnection urlConnection = url.openConnection();
//        logger.info("URL contentType = " + urlConnection.getContentType());
//        BufferedReader in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
//        String inputLine;
//
//        while ((inputLine = in.readLine()) != null)
//            response.getWriter().write(inputLine);
//        in.close();
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
    public static String getPostUrlContentAsString(String url, Map<String, String> params) throws Exception {
        String content = null;

        HttpClient httpClient = new HttpClient();
        PostMethod postMethod = new PostMethod(url);

        for (String key : params.keySet()) {
            // set POST params
            postMethod.addParameter(key, params.get(key));
            //postMethod.addParameter("wkt", "POLYGON((140:-37,151:-37,151:-26,140.1310:-26,140:-37))");
        }

        postMethod.setRequestHeader("ContentType","application/x-www-form-urlencoded;charset=UTF-8");
        postMethod.setRequestHeader("Accept", "application/json;charset=UTF-8");
        //postMethod.setFollowRedirects(true);

        logger.debug("Attempting POST to " + url + " with params: " + StringUtils.abbreviate(postMethod.getParameter("wkt").getValue(), 2048));

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
}
