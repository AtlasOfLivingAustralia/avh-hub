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

package org.ala.hubs.controller;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.inject.Inject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestOperations;

/**
 * Species (Taxon) Page Controller. 
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Controller("taxonController")
@RequestMapping(value = "/taxa")
public class TaxonController {
    private final static Logger logger = Logger.getLogger(TaxonController.class);
    @Inject
    private RestOperations restTemplate; // NB MappingJacksonHttpMessageConverter() injected by Spring
    private final String BIE_URL = "http://bie.ala.org.au";
    private final String BHL_ROOT_URL = "http://bhl.ala.org.au/page/";
    private final String BIE_TAXA_PATH = "/species/";
    private final String TAXON_SHOW = "taxa/show";

    /**
     * Show a taxon page
     *
     * @param guid
     * @param model
     * @return
     */
    @RequestMapping(value = {"/{guid:.+}", "/{guid:.+}.json"}, method = RequestMethod.GET)
    public String getOccurrenceRecord(@PathVariable("guid") String guid, Model model) {
        model.addAttribute("guid", guid);
        model.addAttribute("taxon", getMiniTaxon(guid));
        return TAXON_SHOW;
    }

    /**
     * create and populate a TaxonMini oblject via JSON web services call to BIE service
     *
     * @param guid
     * @return
     */
    private TaxonMini getMiniTaxon(String guid) {
        TaxonMini taxon = new TaxonMini(guid);
        try {
            final String jsonUri = BIE_URL + BIE_TAXA_PATH + guid + ".json";
            logger.debug("Requesting: " + jsonUri);
            Map<String, Object> etc = restTemplate.getForObject(jsonUri, Map.class);
            logger.debug("number of entities = " + etc.size() + " - " + etc);
            
            if (etc.size() > 0) {
                //Map<String, Object> etc = entities;
                //logger.debug("etc: " + etc);
                int maxDescriptionBlocks = 5; 
                
                
                for (String key : etc.keySet()) {
                    logger.debug("mapKey = " + key + " & mapValue = " + etc.get(key));
                    if (key.contentEquals("taxonConcept")) {
                        Map<String, Object> tc = (Map<String, Object>) etc.get("taxonConcept");
                        taxon.setScientificName((String) tc.get("nameString"));
                        taxon.setAuthor((String) tc.get("author"));
                        taxon.setRank((String) tc.get("rankString"));
                        taxon.setRankId((Integer) tc.get("rankID"));
                    } else if (key.contentEquals("commonNames")) {
                        List<Map<String, Object>> commonNames = (List<Map<String, Object>>) etc.get("commonNames");
                        Set<String> names = new LinkedHashSet<String>(); // avoid duplicates
                        for (Map<String, Object> cn : commonNames) {
                            String theName = (String) cn.get("nameString");
                            names.add(theName.trim());
                        }
                        taxon.setCommonNames(names);
                    } else if (key.contentEquals("images")) {
                        List<Map<String, String>> images = (List<Map<String, String>>) etc.get("images");
                        taxon.setImages(images);
                    } else if (key.contentEquals("isAustralian")) {
                        taxon.setIsAustralian((Boolean) etc.get("isAustralian"));
                    } else if (key.contentEquals("classification")) {
                        taxon.setClassification(buildClassification((Map<String, Object>) etc.get("classification")));
                    } else if (key.contentEquals("simpleProperties")) {
                        List<Map<String, Object>> props = (List<Map<String, Object>>) etc.get("simpleProperties");
                        StringBuilder description = new StringBuilder();
                        int n = 0;
                        for (Map<String, Object> prop : props) {
                            if (prop.containsKey("name")) {
                                String val = (String) prop.get("name");
                                if (val.endsWith("hasDescriptiveText") && n < maxDescriptionBlocks) {
                                    String content = "<p>" + (String) prop.get("value") + " [Source: ";
                                    content += "<a href='" + (String) prop.get("identifier") + "' target='_blank'>";
                                    content += (String) prop.get("infoSourceName") + "</a>]</p>";
                                    description.append(content);
                                    n++;
                                }
                            }
                        }
                        taxon.setDescription(description.toString());
                    } else if (key.contentEquals("earliestReference")) {
                        Map<String, Object> ref = (Map<String, Object>) etc.get("earliestReference");
                        List<String> refList = taxon.getReferences();

                        if (refList == null) {
                            refList = new ArrayList<String>();
                        }

                        refList.add(formatReference(ref));
                        taxon.setReferences(refList);
                    } else if (key.contentEquals("references")) {
                        List<Map<String, Object>> refs = (List<Map<String, Object>>) etc.get("references");
                        List<String> refList = taxon.getReferences();
                        
                        if (refList == null) {
                            refList = new ArrayList<String>();
                        }
                        
                        for (Map<String, Object> ref : refs) {
                            refList.add(formatReference(ref));
                        }

                        taxon.setReferences(refList);
                    }
                }
                logger.debug("miniTaxon: " + taxon.toString());
            }
        } catch (Exception ex) {
            logger.error("RestTemplate error: " + ex.getMessage(), ex);
        }

        return taxon;
    }

    /**
     * Build an HTML string for the classification tree for the taxon
     *
     * @param map
     * @return
     */
    private String buildClassification(Map<String, Object> map) {
        String content = "";
        String[] levels = {"kingdom", "phylum", "clazz", "order", "family", "genus", "species", "subspecies"};
        String listOpen = "<ul><li>";
        String closeList = "</ul>";
        int listCount = 0;
        String rank = (map.containsKey("rank")) ? (String) map.get("rank") : null;

        for (String cf : levels) {
            if (map.containsKey(cf) && map.get(cf) != null && map.containsKey(cf+"Guid")) {
                String label = ("clazz".equals(cf)) ? "class" : cf;
                content += listOpen + label + ": <a href='" + (String) map.get(cf+"Guid") + "'/>" + (String) map.get(cf) + "</a></li>";
                listCount++;

                if (StringUtils.containsIgnoreCase(rank, cf)) {
                    // current classifcation level for taxon, so jump out of loop
                    continue;
                }
            }
        }

        for (int i = 0; i < listCount; i++) {
            // add closing tags for nested unordered lists
            content += closeList;
        }

        return content;
    }

    /**
     * Format the reference into an HTML string
     *
     * @param refMap
     * @return
     */
    private String formatReference(Map<String, Object> refMap) {
        String output = "Scientific name: " + getStringValue(refMap, "scientificName") + ". ";
        output += getStringValue(refMap, "title") + " ";
        output += (!getStringValue(refMap, "year").isEmpty()) ? ("(" + getStringValue(refMap, "year") + ") ") : "";
        output += (!getStringValue(refMap, "volume").isEmpty()) ? ("Volume: " + getStringValue(refMap, "volume") + ". ") : "";

        if (refMap.containsKey("pageIdentifiers") && refMap.get("pageIdentifiers") != null) {
            List<String> pageNos = (List<String>) refMap.get("pageIdentifiers");
            if (pageNos != null && !pageNos.isEmpty()) {
                output += "<a href='" + BHL_ROOT_URL + pageNos.get(0);
                output += "' title='view original publication' target='_blank'>Biodiversity Heritage Library</a>";
            }
        }
        return output;
    }

    /**
     * Get a string value from the JSON derived Map<String, Object> and return empty string if null
     *
     * @param map
     * @param key
     * @return
     */
    private String getStringValue(Map<String, Object> map, String key) {
        String value = "";

        if (key != null && map.containsKey(key)) {
            String temp = (String) map.get(key);
            if (temp != null || StringUtils.containsIgnoreCase(temp, "null")) {
                // If the JSON value is null, then the String gets a value of null (type)
                value = temp;
            }
        }

        return value;
    }
    
    /**
     * Inner Class - mini taxon bean
     */
    public class TaxonMini {
        String guid;
        String scientificName;
        String author;
        String rank;
        Integer rankId;
        Set<String> commonNames;
        Boolean isAustralian;
        String description;
        String classification;
        List<String> references;
        List<Map<String, String>> images;

        public TaxonMini() {}

        public TaxonMini(String guid) {
            this.guid = guid;
        }

        public String getAuthor() {
            return author;
        }

        public void setAuthor(String author) {
            this.author = author;
        }

        public Set<String> getCommonNames() {
            return commonNames;
        }

        public void setCommonNames(Set<String> commonNames) {
            this.commonNames = commonNames;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getClassification() {
            return classification;
        }

        public void setClassification(String classification) {
            this.classification = classification;
        }

        public String getGuid() {
            return guid;
        }

        public void setGuid(String guid) {
            this.guid = guid;
        }

        public List<Map<String, String>> getImages() {
            return images;
        }

        public void setImages(List<Map<String, String>> images) {
            this.images = images;
        }

        public Boolean getIsAustralian() {
            return isAustralian;
        }

        public void setIsAustralian(Boolean isAustralian) {
            this.isAustralian = isAustralian;
        }

        public String getRank() {
            return rank;
        }

        public void setRank(String rank) {
            this.rank = rank;
        }

        public Integer getRankId() {
            return rankId;
        }

        public void setRankId(Integer rankId) {
            this.rankId = rankId;
        }

        public String getScientificName() {
            return scientificName;
        }

        public void setScientificName(String scientificName) {
            this.scientificName = scientificName;
        }

        public String getAllCommonNames() {
            return StringUtils.join(this.commonNames, ", ");
        }

        public List<String> getReferences() {
            return references;
        }

        public void setReferences(List<String> references) {
            this.references = references;
        }

        @Override
        public String toString() {
            return "TaxonMini{" + "guid=" + guid + "; scientificName=" + scientificName + "; author="
                    + author + "; rank=" + rank + "; rankId=" + rankId + "; commonNames=" + commonNames
                    + "; isAustralian=" + isAustralian + "; description=" + description + "; images="
                    + images + '}';
        }
        
    }
}
