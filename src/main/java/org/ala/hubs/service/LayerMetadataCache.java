package org.ala.hubs.service;

import org.ala.biocache.dto.FacetResultDTO;
import org.ala.biocache.dto.FieldResultDTO;
import org.ala.biocache.dto.SearchRequestParams;
import org.ala.biocache.dto.SearchResultDTO;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

import javax.inject.Inject;
import java.lang.reflect.Field;
import java.net.URL;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Component("layerMetadataCache")
public class LayerMetadataCache {

    /** Spring injected RestTemplate object */
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    /** Log4J logger */
    private final static Logger logger = Logger.getLogger(CollectoryUidCache.class);

    protected Date lastUpdated = new Date();
    protected Long timeout = 3600000L; // in millseconds (1 hour)

    private List<Map<String,Object>> layersMetadata;
    private Map<String, Map<String,Object>> layerMetadataLookup = new LinkedHashMap<String,Map<String,Object>>();
    private boolean init = false;

    /**
     * Check age of cache and retrieve new values from biocache webservices if needed.
     */
    protected void checkCacheAge() {
        Date currentDate = new Date();
        Long timeSinceUpdate = currentDate.getTime() - lastUpdated.getTime();
        logger.debug("timeSinceUpdate = " + timeSinceUpdate);

        if (timeSinceUpdate > this.timeout) {
            updateCache();
            lastUpdated = new Date(); // update timestamp
        }
    }

    /**
     * Update the entity types (fields)
     */
    public void updateCache() {
        try {
            String layersJson = "http://spatial.ala.org.au/layers.json";
            ObjectMapper mapper = new ObjectMapper();
            this.layersMetadata = mapper.readValue(new URL(layersJson), List.class);
            this.layerMetadataLookup.clear();
            for(Map<String,Object> layerMetadata : layersMetadata){
                String uid = (String) layerMetadata.get("uid");
                String type = (String) layerMetadata.get("type");
                if("Environmental".equalsIgnoreCase(type)){
                    layerMetadataLookup.put("el" + uid, layerMetadata);
                } else if("Contextual".equalsIgnoreCase(type)){
                    layerMetadataLookup.put("cl" + uid, layerMetadata);
                } else {
                    layerMetadataLookup.put(uid, layerMetadata);
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    public Long getTimeout() {
        return timeout;
    }

    public void setTimeout(Long timeout) {
        this.timeout = timeout;
    }

    public Map<String, Map<String, Object>> getLayerMetadataLookup() {
        if(!init){
            updateCache();
            init = true;
        }
        return layerMetadataLookup;
    }

    public static void main(String[] args){
        LayerMetadataCache l = new LayerMetadataCache();
        l.updateCache();
    }
}
