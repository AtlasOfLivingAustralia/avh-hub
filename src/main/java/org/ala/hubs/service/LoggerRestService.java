/**************************************************************************
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
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Implementation of @see org.ala.hubs.service.loggerRestService that
 * performs lookup via HTTP GET to webservice. Values from WS are cached
 * via Spring-EHCache.
 *
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
@Component("loggerRestService")
public class LoggerRestService implements LoggerService {
    private final static Logger logger = Logger.getLogger(LoggerRestService.class);
    protected String loggerUriPrefix = "http://logger.ala.org.au/service/logger/";
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring

    @Override
    @Cacheable(cacheName = "loggerCache")
    public List<Map<String,Object>> getReasons() {
        return getEntities(LoggerType.reasons);
    }

    @Override
    @Cacheable(cacheName = "loggerCache")
    public List<Map<String,Object>> getSources() {
        return getEntities(LoggerType.sources);
    }

    /**
     * Get a list of entities for the given LoggerType
     *
     * @param type
     * @return
     */
    protected List<Map<String,Object>> getEntities(LoggerType type) {
        List<Map<String,Object>> entities = new ArrayList<Map<String,Object>>();

        try {
            final String jsonUri = loggerUriPrefix + type.name();
            logger.info("Requesting " + type.name() + " via: " + jsonUri);
            entities = restTemplate.getForObject(jsonUri, List.class);
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }

        return entities;
    }

    /**
     * Enum for logger entity types
     */
    protected enum LoggerType {
        reasons, sources;
    }
}
