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

import org.ala.biocache.util.TaxaGroup;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;

/**
 * Controller for Explore your area tool
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("regionController")
public class RegionController {

	private final static Logger logger = Logger.getLogger(RegionController.class);
    @Inject
    protected org.ala.biocache.service.LoggerService loggerService;
    @Value("${downloads.extra}")
    String downloadExtraFields = null;
    /** Name of view for site home page */
    private String MY_AREA = "regions/myArea";
    private String speciesPageUrl = "http://bie.ala.org.au/species/";
    private final String DEFAULT_LOCATION = "Parliament House, ACT";
    /** Mapping of radius in km to OpenLayers zoom level */
    public final static HashMap<Float, Integer> radiusToZoomLevelMap = new HashMap<Float, Integer>();
    static {
        radiusToZoomLevelMap.put(1f, 14);
        radiusToZoomLevelMap.put(5f, 12);
        radiusToZoomLevelMap.put(10f, 11);
        radiusToZoomLevelMap.put(50f, 9);
    }

    @RequestMapping(value = {"/region/my-area*","explore/your-area*"}, method = RequestMethod.GET)
    public String yourAreaView(
            @RequestParam(value="radius", required=false, defaultValue="5f") Float radius,
            @RequestParam(value="latitude", required=false, defaultValue="-35.27412f") Float latitude,
            @RequestParam(value="longitude", required=false, defaultValue="149.11288f") Float longitude,
            @RequestParam(value="address", required=false, defaultValue=DEFAULT_LOCATION) String address,
            @RequestParam(value="location", required=false, defaultValue="") String location,
            HttpServletRequest request,
            Model model) throws Exception {

        model.addAttribute("latitude", latitude);
        model.addAttribute("longitude", longitude);
        model.addAttribute("location", location); // TODO delete if not used in JSP
        model.addAttribute("radius", radius);
        model.addAttribute("zoom", radiusToZoomLevelMap.get(radius));
        model.addAttribute("taxaGroups", TaxaGroup.values());
        // Downloads deps
        model.addAttribute("LoggerSources", loggerService.getSources());
        model.addAttribute("LoggerReason", loggerService.getReasons());
        model.addAttribute("downloadExtraFields", downloadExtraFields);
        // TODO: get from properties file or load via Spring
        model.addAttribute("speciesPageUrl", speciesPageUrl);
        return MY_AREA;
    }
}
