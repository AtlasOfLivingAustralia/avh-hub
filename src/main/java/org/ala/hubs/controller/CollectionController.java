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

package org.ala.hubs.controller;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Collections Controller - effectively proxies to http://collections.ala.org.au/ and displays
 * collection and institution pages
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("collectionController")
public class CollectionController {

    private final static Logger logger = Logger.getLogger(CollectionController.class);
    /* View names */
	private final String SHOW_COLLECTION = "collections/show";
    /* Constant String fields */
    private final String COLLECTION_PREFIX = "co";
    private final String INSTITUTION_PREFIX = "in";
    private final String SHOW_PATH_PREFIX = "/public/show/";
    //private final String BIOCACHE_PATH_PREFIX = "biocache.ala.org.au";
    private final String BIOCACHE_PATH_PREFIX = "http://biocache.ala.org.au/occurrences/searchForUID?q=";
    private final String COLLECTORY_PUBLIC_URL = "/public/";
    private final String COLLECTORY_MAPS_URL = "/images/map";
    private final String SEARCH_ALL = "$searchAll";
    private final String COLLECTION = "collection/";
    private final String INSTITUTION = "institution/";
    /** URI for collection page fragments- possibly overriden by properties overrides */
    private String collectory = "http://collections.ala.org.au";
    private String collectionsFragContext = "/ws/fragment/";

    /**
     * Display a collection page.
     *
     * @param uid
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/collection/{uid:.+}", method = RequestMethod.GET)
	public String showCollection(@PathVariable("uid") String uid,
            HttpServletRequest request, Model model) throws Exception {

        model.addAttribute("uid", uid);
        model.addAttribute("type", "Collection");
        // get the HTML fragment from the collection WS
        Document doc = Jsoup.connect(collectory + SHOW_PATH_PREFIX + uid).get();
        model.addAttribute("entityName", getNameFromTitle(doc));

        // Modify (internal) links to institutions
        manipulateLinks(doc.getElementsByTag("a"), request);
        // Modify src to images
        manipulateImageSources(doc.getElementsByTag("img"), request);
        // Modify inline script tags
        manipulateScripts(doc.getElementsByTag("script"), request);
        // get body and add to Model
        model.addAttribute("content", doc.select("body").first().html());
        return SHOW_COLLECTION;
    }

    /**
     * Display an institution page.
     *
     * @param uid
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/institution/{uid:.+}", method = RequestMethod.GET)
	public String showInstitution(@PathVariable("uid") String uid,
            HttpServletRequest request, Model model) throws Exception {

        model.addAttribute("uid", uid);
        model.addAttribute("type", "Institution");
        // get the HTML fragment from the collection WS
        logger.debug("URL: " + collectory + SHOW_PATH_PREFIX + uid);
        Document doc = Jsoup.connect(collectory + SHOW_PATH_PREFIX + uid).get();
        model.addAttribute("entityName", getNameFromTitle(doc));
        // Modify (internal) links to institutions
        manipulateLinks(doc.getElementsByTag("a"), request);
        // Modify src to images
        manipulateImageSources(doc.getElementsByTag("img"), request);
        // Modify inline script tags
        manipulateScripts(doc.getElementsByTag("script"), request);
        // get body and add to Model
        model.addAttribute("content", doc.select("body").first().html());
        model.addAttribute("scripts", doc.select("head > script").toString());
        return SHOW_COLLECTION;
    }

    /**
     * Iterate over links (a tags) and change paths from Collectory to hubs.
     *
     * @param links
     * @param request
     */
    protected void manipulateLinks(Elements links, HttpServletRequest request) {
        for (Element link : links) {
            String href = link.attr("href");

            if (href.startsWith(SHOW_PATH_PREFIX + COLLECTION_PREFIX)) {
                String newHref = StringUtils.replace(href, SHOW_PATH_PREFIX + COLLECTION_PREFIX, request.getContextPath() + "/collection/co");
                link.attr("href", newHref);
            } else if (href.startsWith(SHOW_PATH_PREFIX + INSTITUTION_PREFIX)) {
                String newHref = StringUtils.replace(href, SHOW_PATH_PREFIX + INSTITUTION_PREFIX, request.getContextPath() + "/institution/in");
                link.attr("href", newHref);
            } else if (href.contains(BIOCACHE_PATH_PREFIX + COLLECTION_PREFIX)) {
                String newHref = StringUtils.replace(href, BIOCACHE_PATH_PREFIX + COLLECTION_PREFIX,
                        request.getContextPath() + "/occurrences/search?q=*:*&fq=collection_uid:co");
                link.attr("href", newHref);
            } else if (href.contains(BIOCACHE_PATH_PREFIX + INSTITUTION_PREFIX)) {
                String newHref = StringUtils.replace(href, BIOCACHE_PATH_PREFIX + INSTITUTION_PREFIX,
                        request.getContextPath() + "/occurrences/search?q=*:*&fq=institution_uid:in");
                link.attr("href", newHref);
            } else if (href.contains(SEARCH_ALL)) {
                String newHref = StringUtils.replace(href, SEARCH_ALL,
                        request.getContextPath() + "/occurrences/search?q=*:*");
                link.attr("href", newHref);
            }
        }
    }

    /**
     * Iterate over images (img tags) and change src from Collectory to hubs.
     *
     * @param imgs
     * @param request
     */
    protected void manipulateImageSources(Elements imgs, HttpServletRequest request) {
        for (Element img : imgs) {
            String src = img.attr("src");

            if (src.startsWith("/images")) {
                String newSrc = StringUtils.replace(src, "/images", request.getContextPath() + "/static/images");
                img.attr("src", newSrc);
            }
        }
    }

    /**
     * Modify with the in-line script CDATA to fix URLs
     *
     * @param scripts
     * @param request
     */
    private void manipulateScripts(Elements scripts, HttpServletRequest request) {
        for (Element script : scripts) {
            Node dataNode = script.childNode(0);
            String data = dataNode.attr("data");

            if (data.contains(COLLECTORY_MAPS_URL)) {
                data = StringUtils.replace(data, COLLECTORY_MAPS_URL, collectory + "/images/map");
                logger.debug("Found and changed: " + COLLECTORY_MAPS_URL);
            }
            if (data.contains(COLLECTORY_PUBLIC_URL)) {
                data = StringUtils.replace(data, COLLECTORY_PUBLIC_URL, collectory + "/public/");
                logger.debug("Found and changed: " + COLLECTORY_PUBLIC_URL);
            }
            if (data.contains("/images")) {
                data = StringUtils.replace(data, "/images", request.getContextPath() + "/static/images");
                logger.debug("Found and changed: " + "/images");
            }

            dataNode.attr("data", data); // push modified JS back into the node
        }
    }

    /**
     * Extract the institution/collection name from the head > title tag
     *
     * @param doc
     * @return
     */
    protected String getNameFromTitle(Document doc) {
        // extract the collection name from the title element
        String title = doc.select("head > title").first().text();
        String[] titleElements = StringUtils.split(title, "|");
        return (titleElements.length > 0) ? titleElements[0].trim() : "";
    }

    /**
     * 
     * @return
     */
    public String getCollectionsFragContext() {
        return collectory + collectionsFragContext;
    }

    /**
     *
     * @param collectionsFragContext
     */
    public void setCollectionsFragContext(String collectionsFragContext) {
        this.collectionsFragContext = collectionsFragContext;
    }

    /**
     *
     * @return
     */
    public String getCollectory() {
        return collectory;
    }

    /**
     *
     * @param collectory
     */
    public void setCollectory(String collectory) {
        this.collectory = collectory;
    }
}
