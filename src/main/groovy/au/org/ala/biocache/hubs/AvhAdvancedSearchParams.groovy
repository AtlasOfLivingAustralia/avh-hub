/*
 * Copyright (C) 2014 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */
package au.org.ala.biocache.hubs

import grails.validation.Validateable
import groovy.util.logging.Log4j
import org.apache.commons.httpclient.URIException
import org.apache.commons.httpclient.util.URIUtil
import org.grails.web.util.WebUtils
import au.org.ala.biocache.hubs.AdvancedSearchParams

/**
 * Request parameters for the advanced search form (form backing bean)
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
//@Validateable
@Log4j
class AvhAdvancedSearchParams extends AdvancedSearchParams implements Validateable {

    String nz_provinces = ""
    String nz_eco_regions = ""
    String nz_districts = ""
    String state_territory_province = ""

    /**
     * This custom toString method outputs a valid SOLR query (q param value).
     *
     * @return q
     */
    //@Override
    public String toString2() {
        Map allParams = super.toParamMap()
        StringBuilder q = new StringBuilder(allParams.q?:"")
        log.debug "[pre] q = ${q} || allParams = ${allParams}"
        // build up q from the simple fields first...
        List queryTermsList = [] // we'll "join" elements before adding to (super) q

        if (nz_provinces)   queryTermsList.add("cl2117:" + quoteText(nz_provinces))
        if (nz_eco_regions) queryTermsList.add("cl2115:" + quoteText(nz_eco_regions))
        if (nz_districts)   queryTermsList.add("cl2116:" + quoteText(nz_districts))
        if (state_territory_province) {
            queryTermsList.add("(state:" + quoteText(state_territory_province)   // AU states
                    + " OR cl2117:" + quoteText(state_territory_province) + ")") // NZ provinces
        }

        if (queryTermsList) {
            if (q) q.append(" AND ") // there is an existing query from AdvancedSearchParams
            q.append(queryTermsList.join(" AND "))
        }

        String finalQuery

        if (taxa) {
            String query = URLEncoder.encode(q.toString().replace("?", ""), "UTF-8")
            finalQuery = "taxa=" + taxa + "&q=" + query
        } else {
            try {
                finalQuery = "q=" + URIUtil.encodeWithinQuery(q.toString().trim())  //URLEncoder.encode(q.toString().trim()); // TODO: use non-deprecated version with UTF-8
            } catch (URIException ex) {
                log.error("URIUtil error: " + ex.getMessage(), ex)
                finalQuery = "q=" + q.toString().trim(); // fall back
            }
        }
        log.debug("query: " + finalQuery)
        return finalQuery
    }

    @Override
    public Map toParamMap() {
        WebUtils.fromQueryString(this.toString2())
    }

}
