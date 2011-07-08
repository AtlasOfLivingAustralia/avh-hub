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

//import au.org.ala.biocache.*;
//import static org.ala.biocache.util.HttpUtils.reconstructURL;

import com.maxmind.geoip.Location;
import com.maxmind.geoip.LookupService;
import org.ala.biocache.util.TaxaGroup;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;

/**
 * Occurrence record Controller
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
@Controller("regionController")
@RequestMapping(value = "/region")
public class RegionController {

	private final static Logger logger = Logger.getLogger(RegionController.class);

    /** Name of view for site home page */
    private String MY_AREA = "regions/myArea";
    private String speciesPageUrl = "http://bie.ala.org.au/species/";
    private static final String GEOIP_DATABASE = "/data/geoip/GeoLiteCity.dat"; // get from http://www.maxmind.com/app/geolitecity
    private final String DEFAULT_LOCATION = "Parliament House, ACT";
    private static LookupService lookupService = null;  // loaded in static bock below
    /** Mapping of radius in km to OpenLayers zoom level */
    public final static HashMap<Float, Integer> radiusToZoomLevelMap = new HashMap<Float, Integer>();
    static {
        radiusToZoomLevelMap.put(1f, 14);
        radiusToZoomLevelMap.put(5f, 12);
        radiusToZoomLevelMap.put(10f, 11);
        radiusToZoomLevelMap.put(50f, 9);
        try {
            lookupService = new LookupService(GEOIP_DATABASE, LookupService.GEOIP_INDEX_CACHE);
        } catch (IOException ex) {
            logger.error("Failed to load GeoIP database: " + ex.getMessage(), ex);
        }
    }

    @RequestMapping(value = "/my-area*", method = RequestMethod.GET)
    public String yourAreaView(
            @RequestParam(value="radius", required=false, defaultValue="5f") Float radius,
            @RequestParam(value="latitude", required=false, defaultValue="-35.27412f") Float latitude,
            @RequestParam(value="longitude", required=false, defaultValue="149.11288f") Float longitude,
            @RequestParam(value="address", required=false, defaultValue=DEFAULT_LOCATION) String address,
            @RequestParam(value="location", required=false, defaultValue="") String location,
            HttpServletRequest request,
            Model model) throws Exception {
        
        //logger.info("CALL: "+ reconstructURL(request));
        // Determine lat/long for client's IP address
        String clientIP = request.getRemoteAddr(); // request.getRemoteAddr() || request.getLocalAddr()
        logger.debug("client (remote) IP address = "+ clientIP);
        logger.debug("client (local) IP address = "+ request.getLocalAddr());

        if (lookupService != null && location == null) {
            Location loc = lookupService.getLocation(clientIP);
            if (loc != null) {
                logger.info(clientIP + " has location: " + loc.postalCode + ", " + loc.city + ", " + loc.region + ". Coords: " + loc.latitude + ", " + loc.longitude);
                latitude = loc.latitude;
                longitude = loc.longitude;
                address = ""; // blank out address so Google Maps API can reverse geocode it
            }
        }

        model.addAttribute("latitude", latitude);
        model.addAttribute("longitude", longitude);
        model.addAttribute("location", location); // TDOD delete if not used in JSP
        //model.addAttribute("address", address); // TDOD delete if not used in JSP
        model.addAttribute("radius", radius);
        model.addAttribute("zoom", radiusToZoomLevelMap.get(radius));
        model.addAttribute("taxaGroups", TaxaGroup.values());

        // TODO: get from properties file or load via Spring
        model.addAttribute("speciesPageUrl", speciesPageUrl);

        return MY_AREA;
    }
}
