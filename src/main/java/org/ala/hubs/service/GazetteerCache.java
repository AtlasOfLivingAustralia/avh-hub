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

package org.ala.hubs.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

/**
 * Provides access to the various region names from the Gazetteer.
 * Cache is automatically updated after a configurable timeout period.
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Component("gazetteerCache")
public class GazetteerCache {
    protected static Map<String, List<String>> regionsMap = new HashMap<String, List<String>>();
    protected Date lastUpdated = new Date();
    protected Long timeout = 3600000L; // in millseconds (1 hour)
    protected String gazetteerUriPrefix = "http://spatial.ala.org.au/gazetteer/";

    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    /** Log4J logger */
    private final static Logger logger = Logger.getLogger(GazetteerCache.class);
    protected boolean disabled = false; // set to true to turn cache off (states, etc will be blank)

    /*
     * Initialise regionMap from RegionType enum
     */
    static {
        for (RegionType regionType : RegionType.values()) {
            regionsMap.put(regionType.getType(), new ArrayList<String>());
        }
    }

    /**
     * Get a list of region names for a given region type
     *
     * @param regionType
     * @return
     */
    public List<String> getNamesForRegionType(RegionType regionType) {
        checkCacheAge(regionType);
        return regionsMap.get(regionType.getType());
    }
    
    /**
     * Check age of cache and retrieve new values from Gazetteer web services if needed.
     */
    protected void checkCacheAge(RegionType regionType) {
        Date currentDate = new Date();
        Long timeSinceUpdate = currentDate.getTime() - lastUpdated.getTime();
        List<String> names = regionsMap.get(regionType.getType());
        logger.debug("timeSinceUpdate = " + timeSinceUpdate);
        
        if (timeSinceUpdate > this.timeout || names.size() < 1) {
            updateCache(regionType);
            lastUpdated = new Date(); // update timestamp
        }
    }

    /**
     * Update the region types 
     */
    protected void updateCache(RegionType regionType) {
        logger.info("Updating gazetteer cache...");
        if(!disabled){
	        List<String> names = getAllNames(regionType);
    	    regionsMap.put(regionType.getType(), names);
    	}
    }

    /**
     * Do the web services call. Uses RestTemplate.
     *
     * @param region
     * @return
     */
    protected List<String> getAllNames(RegionType region) {
        List<String> allNames = null;

        try {
            // grab cached values (map) in case WS is not available 
            allNames = regionsMap.get(region.getType());
            logger.debug("checking list size: " + allNames.size());
        } catch (Exception ex) {
            logger.error("Java reflection error: " + ex.getMessage(), ex);
        }

        try {
            allNames = new ArrayList<String>(); // reset now we're inside the try
            List<String> tempNames = new ArrayList<String>();
            final String jsonUri = gazetteerUriPrefix + region.getType() + "/features.json";
            logger.debug("Requesting: " + jsonUri);
            Map<String, List<String>> entities = restTemplate.getForObject(jsonUri, Map.class);
            logger.debug("number of entities = " + entities.size());

            for (String entity : entities.keySet()) {
                //allNames.put(entity.get("uid"), entity.get("name"));
                if (entity.equalsIgnoreCase("features")) {
                    // get list of features
                    tempNames = entities.get(entity);
                }
                logger.debug("mapKey = " + entity + " & mapValue = " + entities.get(entity));
            }

            // clean-up values (remove name space URI prefixes)
            for (String name : tempNames) {
                name = name.replaceFirst(gazetteerUriPrefix + region.getType() + "/", "");
                name = name.replaceAll("\\.json$", ""); // remove the .json ending
                name = name.replaceAll("_", " "); // spaces for underscores
                name = name.replaceAll("\\s*\\(.*?\\)\\s*", ""); // remove state portion of LGA names, e.g. foo (New South Wales)
                if (!name.startsWith("Unknown")) {
                    // don't add the states called unknown_1, etc
                    allNames.add(name);
                }
            }
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        Collections.sort(allNames); // alphabetical ordering
        return allNames;
    }
    
    /**
     * Inner enum class
     */
    public enum RegionType {
        STATE("state"),
        IBRA("ibra"),
        IMCRA("imcra"),
        LGA("lga");

        private String type;

        RegionType(String type) {
            this.type = type;
        }

        public String getType() {
            return type;
        }
    }

    /*
     * Getter and setters
     */

    public String getGazetteerUriPrefix() {
        return gazetteerUriPrefix;
    }

    public void setGazetteerUriPrefix(String gazetteerUriPrefix) {
        this.gazetteerUriPrefix = gazetteerUriPrefix;
    }

    public Long getTimeout() {
        return timeout;
    }

    public void setTimeout(Long timeout) {
        this.timeout = timeout;
    }

    public static Map<String, List<String>> getRegionsMap() {
        return regionsMap;
    }

    public static void setRegionsMap(Map<String, List<String>> regionsMap) {
        GazetteerCache.regionsMap = regionsMap;
    }

}
