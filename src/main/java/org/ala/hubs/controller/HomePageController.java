/**************************************************************************
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

import org.ala.biocache.util.CollectionsCache;
import au.org.ala.biocache.BasisOfRecord;
import au.org.ala.biocache.SpeciesGroup;
import au.org.ala.biocache.SpeciesGroups;
import au.org.ala.biocache.Term;
import au.org.ala.biocache.TypeStatus;
import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.ala.hubs.dto.AdvancedSearchParams;
import org.ala.hubs.service.CollectoryUidCache;
import org.ala.hubs.service.GazetteerCache;
import org.ala.hubs.service.ServiceCache;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Controller for the site's home page/s
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Controller("homePageController")
public class HomePageController {
    /** logger */
    private final static Logger logger = Logger.getLogger(HomePageController.class);
    /** Cache for the collections & institutions codes -> names */
    @Inject
    protected CollectionsCache collectionsCache;
    @Inject
    protected GazetteerCache gazetteerCache;
    @Inject
    protected CollectoryUidCache collectoryUidCache;
    @Inject
    protected ServiceCache serviceCache;

    /** View name for home page */
    protected String homePage = "homePage"; // injected via hubs.properties & can be different to HOME_PAGE

    protected String searchPage = "homePage"; // injected via hubs.properties & can be different to HOME_PAGE

    /**
     * Site root - dummy Ozcam front page
     *
     * @return
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String homePage(Model model) {
        addLookupToModel(model);
        return homePage;
    }

    /**
     * Site root - dummy Ozcam front page
     *
     * @return
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String indexPage(Model model) {
        addLookupToModel(model);
        return homePage;
    }

    /**
     * Real root - search page
     *
     * @param model
     * @return
     */
    @RequestMapping(value = {"/home", "/advancedSearch", "/search", "/query"}, method = RequestMethod.GET)
    public String search(Model model) {
        logger.debug("Home Page request.");
        addLookupToModel(model);
        return searchPage;
    }

    private void addLookupToModel(Model model) {
        List<String> inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        model.addAttribute("collections", collectionsCache.getCollections(inguids, coguids));
        model.addAttribute("institutions", collectionsCache.getInstitutions(inguids, coguids));
        model.addAttribute("typeStatus", serviceCache.getTypeStatuses());
        model.addAttribute("basisOfRecord", serviceCache.getBasisOfRecord());
        model.addAttribute("speciesGroups", serviceCache.getSpeciesGroups());
        model.addAttribute("states", serviceCache.getStates()); // extractTermsList(States.all())
        model.addAttribute("ibra", serviceCache.getIBRA());
        model.addAttribute("imcra", serviceCache.getIMCRA());
        model.addAttribute("countries", serviceCache.getCountries());
    }

    /**
     * Advanced search - POST 
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/advancedSearch", method = RequestMethod.POST)
    public String homePagePost(AdvancedSearchParams requestParams, BindingResult result, Model model) {
        logger.debug("Advanced search POST: " + requestParams.toString());
        
        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }
        // Note: AdvancedSearchParams.toString() contains the logic for building query
        return "redirect:/occurrences/search?q=" + requestParams.toString();
    }

    public void setHomePage(String homePage) {
        this.homePage = homePage;
    }

    public void setCollectionsCache(CollectionsCache collectionsCache) {
        this.collectionsCache = collectionsCache;
    }

    public void setGazetteerCache(GazetteerCache gazetteerCache) {
        this.gazetteerCache = gazetteerCache;
    }

    public void setCollectoryUidCache(CollectoryUidCache collectoryUidCache) {
        this.collectoryUidCache = collectoryUidCache;
    }

    public void setServiceCache(ServiceCache serviceCache) {
        this.serviceCache = serviceCache;
    }

    public void setSearchPage(String searchPage) {
        this.searchPage = searchPage;
    }
}
