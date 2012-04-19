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
package org.ala.hubs.util;

import org.codehaus.jackson.map.DeserializationConfig;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;

import javax.annotation.PostConstruct;

/**
 * Custom version of {@link org.springframework.http.converter.json.MappingJacksonHttpMessageConverter MappingJacksonHttpMessageConverter}
 * with option to not fail on unknown properties (requires wiring via Spring).
 *
 * @see org.springframework.http.converter.json.MappingJacksonHttpMessageConverter
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
public class CustomMappingJacksonHttpMessageConverter extends MappingJacksonHttpMessageConverter {
    @PostConstruct
    public void init() {
        logger.info("@PostConstruct");
        //ObjectMapper objectMapper = super.getObjectMapper(); // TODO: revert when biocache-service is using Spring 3.1.0
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationConfig.Feature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        setObjectMapper(objectMapper);
    }
}
