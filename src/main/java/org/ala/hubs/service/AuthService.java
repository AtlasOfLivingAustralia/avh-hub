/* *************************************************************************
 *  Copyright (C) 2012 Atlas of Living Australia
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

import com.googlecode.ehcache.annotations.Cacheable;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import java.util.HashMap;
import java.util.Map;

/**
 * Service to lookup and cache user details from auth.ala.org.au (CAS)
 *
 * User: dos009
 * Date: 21/11/12
 * Time: 10:38 AM
 */
@Component("authService")
public class AuthService {
    private final static Logger logger = Logger.getLogger(AuthService.class);
    @Inject
    protected RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    @Value("${auth.userDetailsUrl}")
    protected String userDetailsUrl = null;
    @Value("${auth.userNamesForIdPath}")
    protected String userNamesForIdPath = null;
    @Value("${auth.userNamesForNumericIdPath}")
    protected String userNamesForNumericIdPath = null;
    // Keep a reference to the output Map in case subsequent web service lookups fail
    protected Map<String, String> userNamesById = new HashMap<String, String>();
    protected Map<String, String> userNamesByNumericIds = new HashMap<String, String>();

    
    public AuthService() {
        logger.info("Instantiating AuthService: " + this);
    }
    
    //@Cacheable(cacheName = "authCache")
    public Map<String, String> getMapOfAllUserNamesById() {
        return userNamesById;
    }

    protected void loadMapOfAllUserNamesById() {
        try {
            final String jsonUri = userDetailsUrl + userNamesForIdPath;
            logger.debug("authCache requesting: " + jsonUri);
            userNamesById = restTemplate.postForObject(jsonUri, null, Map.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        //logger.debug("userNamesById = " + StringUtils.join(userNamesById.keySet(), "|"));
    }

    //@Cacheable(cacheName = "authCache")
    public Map<String, String> getMapOfAllUserNamesByNumericId() {
        return userNamesByNumericIds;
    }

    public void loadMapOfAllUserNamesByNumericId() {
        try {
            final String jsonUri = userDetailsUrl + userNamesForNumericIdPath;
            logger.debug("authCache requesting: " + jsonUri);
            userNamesByNumericIds = restTemplate.postForObject(jsonUri, null, Map.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }
        //logger.debug("userNamesByIds = " + StringUtils.join(userNamesByNumericIds.keySet(), "|"));
    }

    //@PostConstruct
    @Scheduled(fixedRate = 600000) // schedule to run every 10 min
    @Async
    public void reloadCaches() {
        logger.info("Triggering reload of auth user names for " + this);
        loadMapOfAllUserNamesById();
        loadMapOfAllUserNamesByNumericId();
    }

    @Scheduled(fixedRate = 60000) // schedule to run every 1 min
    public void checkMemoryUsage() {
        int mb = 1024*1024;
        Runtime runtime = Runtime.getRuntime();
        logger.info("Memory usage: " + (runtime.totalMemory() - runtime.freeMemory()) / mb + " MB");

    }
}
