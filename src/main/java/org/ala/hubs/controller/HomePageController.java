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
import org.ala.hubs.service.GazetteerCache;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Controller for the site's home page
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
    /** View name for home page */
    protected final String HOME_PAGE = "homePage";
    protected final String OZCAM_PAGE = "ozcamHome";

    /**
     * Site root - dummy Ozcam front page
     *
     * @return
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String ozcamPage() {
        return "redirect:/index";
    }

    /**
     * Site root - dummy Ozcam front page
     *
     * @return
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String indexPage() {
        return OZCAM_PAGE;
    }

    /**
     * Real root - search page
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/home", method = RequestMethod.GET)
    public String homePage(Model model) {
        logger.info("Home Page request.");
        model.addAttribute("collections", collectionsCache.getCollections());
        model.addAttribute("institutions", collectionsCache.getInstitutions());
        model.addAttribute("typeStatus", extractTermsList(TypeStatus.all()));
        model.addAttribute("basisOfRecord", extractTermsList(BasisOfRecord.all()));
        model.addAttribute("states", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.STATE)); // extractTermsList(States.all())
        model.addAttribute("ibra", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.IBRA));
        model.addAttribute("imcra", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.IMCRA));
        model.addAttribute("lga", gazetteerCache.getNamesForRegionType(GazetteerCache.RegionType.LGA));
        model.addAttribute("speciesGroups", extractSpeciesGroups(SpeciesGroups.groups()));
        return HOME_PAGE;
    }

    /**
     * Convert Scala List of SpeciesGroup's to a Java List<String>
     *
     * @param groups
     * @return
     */
    private List<String> extractSpeciesGroups(scala.collection.immutable.List<SpeciesGroup> groups) {
        List<String> output = new ArrayList<String>();

        scala.collection.Iterator<SpeciesGroup> it = groups.iterator();
        while (it.hasNext()) {
            String name =  it.next().name();
            logger.debug("SpeciesGroup = " + name);
            output.add(name);
        }
        
        Collections.sort(output); // force alphabetic order
        return output;
    }

    /**
     * Convert Scala List of term's to a Java List<String>
     *
     * @param groups
     * @return
     */
    private List<String> extractTermsList(scala.collection.immutable.Set<Term> terms) {
        List<String> output = new ArrayList<String>();
        scala.collection.Iterator<Term> it = terms.iterator();
        while (it.hasNext()) {
            String term =  it.next().canonical();
            logger.debug("Term = " + term);
            output.add(term);
        }
        
        Collections.sort(output); // force alphabetic order
        return output;
    }

}
