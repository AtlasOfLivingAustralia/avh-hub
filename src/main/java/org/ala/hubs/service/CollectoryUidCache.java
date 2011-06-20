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

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import org.ala.biocache.dto.FacetResultDTO;
import org.ala.biocache.dto.FieldResultDTO;
import org.ala.biocache.dto.SearchRequestParams;
import org.ala.biocache.dto.SearchResultDTO;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

/**
 * Provides access to the uids based on the query context.  These cached
 * list of uids are used to initialise the collectory cache with values
 * that are correct for the query context.
 *
 * @author "Natasha Carter <Natasha.Carter@csiro.au>"
 */
@Component("collectoryUidCache")
public class CollectoryUidCache {

    @Inject
    private BiocacheService biocacheService;
    protected List<String> institution_uid = new ArrayList<String>();
    protected List<String> collection_uid = new ArrayList<String>();
    protected List<String> data_resource_uid = new ArrayList<String>();
    protected List<String> data_provider_uid = new ArrayList<String>();
    
    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    /** Log4J logger */
    private final static Logger logger = Logger.getLogger(GazetteerCache.class);

    protected Date lastUpdated = new Date();
    protected Long timeout = 3600000L; // in millseconds (1 hour)


    public List<String> getInstitutions(){
        checkCacheAge();
        return institution_uid;
    }

    public List<String> getCollections(){
        checkCacheAge();
        return collection_uid;
    }

    public List<String> getDataResources(){
        checkCacheAge();
        return data_resource_uid;
    }
    public List<String> getDataProviders(){
        checkCacheAge();
        return data_provider_uid;
    }


      /**
     * Check age of cache and retrieve new values from biocache webservices if needed.
     */
    protected void checkCacheAge() {
        Date currentDate = new Date();
        Long timeSinceUpdate = currentDate.getTime() - lastUpdated.getTime();
        logger.debug("timeSinceUpdate = " + timeSinceUpdate);

        if (timeSinceUpdate > this.timeout || (institution_uid.size() < 1 && collection_uid.size() < 1
                && data_resource_uid.size()<1 && data_provider_uid.size()<1)) {
            updateCache();
            lastUpdated = new Date(); // update timestamp
        }
    }

    /**
     * Update the entity types (fields)
     */
    protected void updateCache() {
        logger.info("Updating collection uid cache...");
        SearchRequestParams srp = new SearchRequestParams();
        srp.setFacets(new String[]{"institution_uid","collection_uid","data_resource_uid", "data_provider_uid"});
        srp.setQ("*:*");
        srp.setPageSize(0);
        SearchResultDTO result =biocacheService.findByFulltextQuery(srp);
        //now update the cache with the facet names
        for(FacetResultDTO res : result.getFacetResults()){
            List<String>list = null;
           // grab cached values (map) in case WS is not available (uses reflection)
            try{
                Field f = CollectoryUidCache.class.getDeclaredField(res.getFieldName()); // field is plural form
                list = (List<String>) f.get(this);
                //now add all the values
                for(FieldResultDTO fieldResult :res.getFieldResult()){
                    list.add(fieldResult.getLabel());
                }
            }
            catch(Exception e){
                logger.error("Unable to load cache for " + res.getFieldName());
            }
        }

        
    }

    public Long getTimeout() {
        return timeout;
    }

    public void setTimeout(Long timeout) {
        this.timeout = timeout;
    }

}
