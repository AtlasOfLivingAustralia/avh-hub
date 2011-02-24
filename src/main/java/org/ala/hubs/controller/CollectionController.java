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
    private final String COLLECTION_PATH_PREFIX = "/Collectory/public/show/co";
    private final String INSTITUTION_PATH_PREFIX = "/Collectory/data/show/in";
    private final String COLLECTORY_PUBLIC_URL = "/Collectory/public/";
    private final String COLLECTORY_MAPS_URL = "/Collectory/images/map";
    private final String COLLECTION = "collection/";
    private final String INSTITUTION = "institution/";
    /* mutable fields - possibly overriden by properties overrides*/
    private String collectionsFragUrl = "http://152.83.199.223:8080/Collectory/ws/fragment/";

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
        Document doc = Jsoup.connect(collectionsFragUrl + COLLECTION + uid).get();
        model.addAttribute("entityName", GetNameFromTitle(doc));

        // Modify (interal) links to institutions
        manipulateLinks(doc.getElementsByTag("a"), request);
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
        Document doc = Jsoup.connect(collectionsFragUrl + INSTITUTION + uid).get();
        model.addAttribute("entityName", GetNameFromTitle(doc));
        // Modify (interal) links to institutions
        manipulateLinks(doc.getElementsByTag("a"), request);
        // Modify inline script tags
        manipulateScripts(doc.getElementsByTag("script"), request);
        // get body and add to Model
        model.addAttribute("content", doc.select("body").first().html());
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
            
            if (href.startsWith(COLLECTION_PATH_PREFIX)) {
                String newHref = StringUtils.replace(href, COLLECTION_PATH_PREFIX, request.getContextPath() + "/collection/co");
                link.attr("href", newHref);
            } else if (href.startsWith(INSTITUTION_PATH_PREFIX)) {
                String newHref = StringUtils.replace(href, INSTITUTION_PATH_PREFIX, request.getContextPath() + "/institution/in");
                link.attr("href", newHref);
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

            if (StringUtils.hasText(COLLECTORY_MAPS_URL)) {
                data = StringUtils.replace(data, COLLECTORY_MAPS_URL, "http://collections.ala.org.au/images/map");
                logger.debug("Found and changed: " + COLLECTORY_MAPS_URL);
            }
            if (StringUtils.hasText(COLLECTORY_PUBLIC_URL)) {
                data = StringUtils.replace(data, COLLECTORY_PUBLIC_URL, "http://collections.ala.org.au/public/");
                logger.debug("Found and changed: " + COLLECTORY_PUBLIC_URL);
            }

            dataNode.attr("data", data); // push modified JS back into the node
        }
    }

    /**
     * Extract the institution/collection name form the head > title tag
     *
     * @param doc
     * @return
     */
    protected String GetNameFromTitle(Document doc) {
        // extract the collection name from the title element
        String title = doc.select("head > title").first().text();
        String[] titleElements = StringUtils.split(title, "|");
        String name = (titleElements.length > 0) ? titleElements[0].trim() : "";
        return name;
    }

    /**
     * 
     * @return
     */
    public String getCollectionsFragUrl() {
        return collectionsFragUrl;
    }

    /**
     *
     * @param collectionsFragUrl
     */
    public void setCollectionsFragUrl(String collectionsFragUrl) {
        this.collectionsFragUrl = collectionsFragUrl;
    }

}
