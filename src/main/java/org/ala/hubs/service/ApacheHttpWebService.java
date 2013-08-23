/**************************************************************************
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
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Apache HTTP Client implementation of {@link org.ala.hubs.service.WebService WebService}
 *
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
@Component
public class ApacheHttpWebService implements WebService {
    private static final Logger logger = Logger.getLogger(ApacheHttpWebService.class);

    /**
     * HTTP GET for a url
     *
     * @param url
     * @return
     */
    @Override
    @Cacheable(cacheName = "webServiceCache")
    public String getForUrl(String url) {
        String getContent = "";

        try {
            logger.debug("trying GET for: " + url);
            HttpGet request = new HttpGet(url);
            HttpClient httpClient = new DefaultHttpClient();
            HttpResponse response = httpClient.execute(request);
            HttpEntity entity = response.getEntity();
            getContent = EntityUtils.toString(entity);
            //logger.debug("content: " + getContent);
        } catch (IOException e) {
            logger.error("Error performing HTTP GET: " + e.getMessage(), e);
        }

        return getContent;
    }

    /**
     * HTTP {POST} for a url
     *
     * @param url
     * @return
     */
    @Override
    public String postForUrl(String url) {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }
}
