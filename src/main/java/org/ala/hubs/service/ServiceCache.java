package org.ala.hubs.service;

import org.ala.biocache.dto.*;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

import javax.inject.Inject;
import java.lang.reflect.Field;
import java.util.*;

@Component("serviceCache")
public class ServiceCache {

    @Inject
    private BiocacheService biocacheService;
    protected List<String> basis_of_record = new ArrayList<String>();
    protected List<String> type_status = new ArrayList<String>();
    protected List<String> country = new ArrayList<String>();
    protected List<String> kingdom = new ArrayList<String>();
    protected List<String> state = new ArrayList<String>();
    protected List<String> species_group = new ArrayList<String>();
    protected List<String> ibra = new ArrayList<String>();
    protected List<String> imcra = new ArrayList<String>();
    protected List<String> cl966 = new ArrayList<String>();
    protected List<String> cl959 = new ArrayList<String>();
    protected List<String> loan_destination = new ArrayList<String>();
    protected List<String> establishment_means = new ArrayList<String>();

    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    /** Log4J logger */
    private final static Logger logger = Logger.getLogger(CollectoryUidCache.class);

    protected Date lastUpdated = new Date();
    protected Long timeout = 3600000L; // in millseconds (1 hour)


    public List<String> getTypeStatuses(){
        checkCacheAge();
        return type_status;
    }

    public List<String> getBasisOfRecord(){
        checkCacheAge();
        return basis_of_record;
    }

    public List<String> getSpeciesGroups(){
        checkCacheAge();
        return species_group;
    }

    public List<String> getKingdoms(){
        checkCacheAge();
        return kingdom;
    }

    public List<String> getStates(){
        checkCacheAge();
        return state;
    }

    public List<String> getCountries(){
        checkCacheAge();
        return country;
    }

    public List<String> getIBRA(){
        checkCacheAge();
        return ibra;
    }

    public List<String> getIMCRA(){
        checkCacheAge();
        return imcra;
    }

    public List<String> getIMCRA_MESO(){
        checkCacheAge();
        return cl966;
    }

    public List<String> getLGAs(){
        checkCacheAge();
        return cl959;
    }

    public List<String> getLoanDestination(){
        checkCacheAge();
        return loan_destination;
    }

    public List<String> getEstablishment_means(){
        checkCacheAge();
        return establishment_means;
    }

      /**
     * Check age of cache and retrieve new values from biocache webservices if needed.
     */
    protected void checkCacheAge() {
        Date currentDate = new Date();
        Long timeSinceUpdate = currentDate.getTime() - lastUpdated.getTime();
        logger.debug("timeSinceUpdate = " + timeSinceUpdate);

        if (timeSinceUpdate > this.timeout || species_group.isEmpty()) {
            updateCache();
            lastUpdated = new Date(); // update timestamp
        }
    }

    /**
     * Update the entity types (fields)
     */
    public void updateCache() {

        logger.info("Updating collection uid cache...");
        SpatialSearchRequestParams srp = new SpatialSearchRequestParams();
        srp.setFacets(new String[]{"basis_of_record","type_status","country", "kingdom","species_group", "state", "ibra", "imcra", "cl966", "loan_destination","establishment_means", "cl959"});
        srp.setFlimit(-1);
        srp.setQ("*:*");
        srp.setPageSize(0);
        SearchResultDTO result = biocacheService.findBySpatialFulltextQuery(srp);

        if(result != null && result.getFacetResults() !=null){
            //now update the cache with the facet names
            for(FacetResultDTO res : result.getFacetResults()){
                List<String> list = null;
               // grab cached values (map) in case WS is not available (uses reflection)
                try{
                    Field f = this.getClass().getDeclaredField(res.getFieldName()); // field is plural form
                    list = (List<String>) f.get(this);
                    list.clear(); //reset this list
                    //now add all the values
                    for(FieldResultDTO fieldResult :res.getFieldResult()){
                        list.add(fieldResult.getLabel());
                    }

                    Collections.sort(list);
                }
                catch(Exception e){
                    logger.error("Unable to load cache for " + res.getFieldName());
                }
            }
        } else {
             logger.warn("No results for  facet query");
        }
    }

    public Long getTimeout() {
        return timeout;
    }

    public void setTimeout(Long timeout) {
        this.timeout = timeout;
    }
}
