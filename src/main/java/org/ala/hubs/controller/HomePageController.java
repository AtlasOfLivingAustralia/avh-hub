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

import au.org.ala.biocache.SpeciesGroups;
import au.org.ala.biocache.States;
import au.org.ala.biocache.TypeStatus;
import javax.inject.Inject;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Controller("homePageController")
public class HomePageController {
    private final static Logger logger = Logger.getLogger(HomePageController.class);

    @Inject
    protected CollectionsCache collectionsCache;

    protected final String HOME_PAGE = "homePage";

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String homePage(Model model) {
        logger.info("Home Page request.");
        model.addAttribute("collections", collectionsCache.getCollections());
        model.addAttribute("institutions", collectionsCache.getInstitutions());
        model.addAttribute("typeStatus", TypeStatus.all());
        model.addAttribute("states", States.all());
        model.addAttribute("speciesGroups", SpeciesGroups.groups());
        return HOME_PAGE;
    }
}
