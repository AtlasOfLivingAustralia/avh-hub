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
import org.codehaus.groovy.grails.web.util.WebUtils

/**
 * Request parameters for the advanced search form (form backing bean)
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Validateable
@Log4j
class AvhAdvancedSearchParams extends AdvancedSearchParams {

    String nz_provinces = ""
    String nz_eco_regions = ""
    String nz_districts = ""
    String state_territory_province = ""

    /**
     * This custom toString method outputs a valid SOLR query (q param value).
     *
     * @return q
     */
    @Override
    public String toString() {
        Map allParams = super.toParamMap()
        StringBuilder q = new StringBuilder(allParams.q?:"")

        // build up q from the simple fields first...
        if (nz_provinces) q.append(" cl2117:").append(quoteText(nz_provinces))
        if (nz_eco_regions) q.append(" cl2115:").append(quoteText(nz_eco_regions))
        if (nz_districts) q.append(" cl2116:").append(quoteText(nz_districts))

        if (state_territory_province) {
            q.append(" (").append("state:").append(quoteText(state_territory_province))
            q.append(" OR cl2117:").append(quoteText(state_territory_province)).append(")")
        }

        String finalQuery = ""

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
