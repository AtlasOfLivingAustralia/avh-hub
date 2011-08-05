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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.inject.Inject;
import org.ala.hubs.service.CollectoryUidCache;
import org.ala.hubs.service.GazetteerCache;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

    /** View name for home page */
    protected final String HOME_PAGE = "homePage";
    protected String homePage = ""; // injected via hubs.properties & can be different to HOME_PAGE
    /* Get the skin name form the hubs.properties file (via context:property-placeholder conf) */
    protected @Value("${sitemesh.skin}") String skin;

    /**
     * Site root - dummy Ozcam front page
     *
     * @return
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String ozcamPage(Model model) {
        //return "redirect:/index";
        String page = null;
        
        if ("ala".equalsIgnoreCase(skin)) {
            page = homePage(model);
        } else {
            page = homePage;
        }
        
        return page;
    }

    /**
     * Site root - dummy Ozcam front page
     *
     * @return
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String indexPage() {
        return homePage;
    }

    /**
     * Real root - search page
     *
     * @param model
     * @return
     */
    @RequestMapping(value = {"/home", "/advancedSearch"}, method = RequestMethod.GET)
    public String homePage(Model model) {
        logger.info("Home Page request.");
        
        List<String>inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        model.addAttribute("collections", collectionsCache.getCollections(inguids, coguids));
        model.addAttribute("institutions", collectionsCache.getInstitutions(inguids, coguids));
        model.addAttribute("typeStatus", TypeStatus.getStringList());
        model.addAttribute("basisOfRecord", BasisOfRecord.getStringList());
        model.addAttribute("states", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.STATE)); // extractTermsList(States.all())
        model.addAttribute("ibra", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.IBRA));
        model.addAttribute("imcra", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.IMCRA));
        model.addAttribute("speciesGroups", SpeciesGroups.getStringList());
        return HOME_PAGE;
    }

    public void setHomePage(String homePage) {
        this.homePage = homePage;
    }
}
