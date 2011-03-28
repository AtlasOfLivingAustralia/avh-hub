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
    private final String BIE_TAXA_PATH = "/species/";
    private final String EXTENDED_TAXON_CONCEPTDTO = "extendedTaxonConceptDTO";
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
            Map<String, Map<String, Object>> entities = restTemplate.getForObject(jsonUri, Map.class);
            logger.debug("number of entities = " + entities.size());
            
            if (entities.containsKey(EXTENDED_TAXON_CONCEPTDTO)) {
                Map<String, Object> etc = entities.get(EXTENDED_TAXON_CONCEPTDTO);
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

        @Override
        public String toString() {
            return "TaxonMini{" + "guid=" + guid + "; scientificName=" + scientificName + "; author="
                    + author + "; rank=" + rank + "; rankId=" + rankId + "; commonNames=" + commonNames
                    + "; isAustralian=" + isAustralian + "; description=" + description + "; images="
                    + images + '}';
        }
        
    }
}
