/* *************************************************************************
 *  Copyright (C) 2013 Atlas of Living Australia
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
import com.googlecode.ehcache.annotations.TriggersRemove;
import org.ala.hubs.dto.OutageBanner;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;

/**
 * Implementation of Outage message service that uses a simple JSON file on disk (/tmp)
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Component("tempFileOutageService")
public class TempFileOutageService implements OutageService {
    private final static Logger logger = Logger.getLogger(TempFileOutageService.class);
    private final static String FILE_NAME = "hubsWebappOutage.json";
    private final static String TMP_PATH = System.getProperty("java.io.tmpdir");
    private final static String FILE_PATH = TMP_PATH + File.separator + FILE_NAME;

    @Override
    @Cacheable(cacheName = "outageCache")
    public OutageBanner getOutageBanner() {
        OutageBanner outageBanner = new OutageBanner();
        ObjectMapper mapper = new ObjectMapper();
        logger.debug("get FILE_PATH = " + FILE_PATH);

        try {
            outageBanner = mapper.readValue(new File(FILE_PATH), OutageBanner.class);
        } catch (IOException e) {
            logger.error("Failed to read outage JSON: " + e.getMessage(), e);
        }

        return outageBanner;
    }

    @Override
    public void setOutageBanner(OutageBanner outageBanner) {
        ObjectMapper mapper = new ObjectMapper();
        logger.debug("set FILE_PATH = " + FILE_PATH);

        try {
            mapper.writeValue(new File(FILE_PATH), outageBanner);
        } catch (IOException e) {
            logger.error("Failed to write outage JSON: " + e.getMessage(), e);
        }
    }

    @Override
    @TriggersRemove(cacheName="outageCache", removeAll=true)
    public void clearOutageCache() {
        logger.info("Clearing outage banner cache");
    }

}
