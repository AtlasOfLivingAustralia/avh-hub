<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="facetWell" class="well well-small">
    <h3 class="visible-phone">
        <a href="#" id="toggleFacetDisplay"><i class="icon-chevron-down" id="facetIcon"></i>
            Refine results</a>
    </h3>
    <div class="sidebar hidden-phone">
        <h3 class="hidden-phone">Refine results</h3>
    </div>
    <div class="sidebar hidden-phone" style="clear:both;">
        <g:if test="${sr.query}">
            <g:set var="queryStr" value="${params.q ? params.q : searchRequestParams.q}"/>
            <g:set var="paramList" value=""/>
            <g:set var="queryParam" value="${sr.urlParameters.stripIndent(1)}" />
        </g:if>
        <g:if test="${sr.activeFacetMap}">
            <div id="currentFilter">
                <h4><span class="FieldName">Current filters</span></h4>
                <div class="subnavlist">
                    <ul id="refinedFacets">
                        <g:each var="item" in="${sr.activeFacetMap}">
                            <li><alatag:currentFilterItem item="${item}"/></li>
                        </g:each>
                    </ul>
                </div>
            </div>
        </g:if>
        <g:each var="facetResult" in="${sr.facetResults}">
            <g:if test="${facetResult.fieldResult.length() >= 1 && ! sr.activeFacetMap?.containsKey(facetResult.fieldName) }">
                <h4><span class="FieldName"><alatag:formatDynamicFacetName fieldName="${facetResult.fieldName}"/></span>
                </h4>
                <div class="subnavlist" style="clear:left">
                    <ul class="facets">
                        <g:set var="lastElement" value="${facetResult.fieldResult.get(facetResult.fieldResult.length()-1)}"/>
                        <g:if test="${lastElement && lastElement?.label == 'before' && lastElement?.count > 0}">
                            <li><g:set var="firstYear" value="${facetResult.fieldResult?.get(0)?.label?.substring(0, 4)}"/>
                                <a href="?${queryParam}&fq=${facetResult.fieldName}:[* TO ${facetResult.fieldResult?.get(0)?.label}]">Before ${firstYear}</a>
                                (<g:formatNumber number="${lastElement.count}" format="#,###,###"/>)
                            </li>
                        </g:if>
                        <g:each var="fieldResult" in="${facetResult.fieldResult}" status="vs"> <!-- ${facetResult.fieldName}:${fieldResult.label} || ${fieldResult.fq} -->
                            <g:if test="${fieldResult.count >= 0 && (vs + 1) < 4}">
                                <alatag:facetLinkItems fieldResult="${fieldResult}" facetResult="${facetResult}" queryParam="${queryParam}"/>
                            </g:if>
                        </g:each>
                    </ul>
                </div>
                <g:if test="${facetResult.fieldResult.length() > 1}">
                    <div class="showHide">
                        <a href="#multipleFacets" class="multipleFacetsLink" id="multi-${facetResult.fieldName}" data-displayname="${fieldDisplayName}"
                           title="See more options or refine with multiple values"><i class="icon-hand-right"></i> choose more...</a>
                    </div>
                </g:if>
            </g:if>
        </g:each>
    </div>
</div><!--end facets-->
<div style="display:none"><!-- fancybox popup div -->
    <div id="multipleFacets">
        <h3>Refine your search</h3>
        <div id="dynamic" class="tableContainer"></div>
        <div id='submitFacets'>
            <input type='submit' class='submit btn btn-small' id="include" value="INCLUDE selected items in search"/>
            &nbsp;
            <input type='submit' class='submit btn btn-small' id="exclude" value="EXCLUDE selected items from search"/>
        </div>
    </div>
</div>

<!--
${false && collectionCodes}
-->

<script type="text/javascript">
    
    String.prototype.hashCode = function(){
        var hash = 0;
        if (this.length == 0) return code;
        for (i = 0; i < this.length; i++) {
            var thisChar = this.charCodeAt(i);
            hash = 31*hash+thisChar;
            hash = hash & hash; // Convert to 32bit integer
        }
        return hash;
    }

    var facetNames = new Array();
    var facetLabels = new Array();
    var facetValues = new Array();
    var facetValueCounts = new Array();
    var dynamicFacets = new Array();
    <g:each in="${dynamicFacets}" var="dynamicFacet">
        dynamicFacets.push('${dynamicFacet.name}');
    </g:each>

    <g:each var="facetResult" in="${sr.facetResults}">
        /* JSTL vars setup
        <g:set var="frlabels" value="0"/>
        <g:set var="frlabelcount" value="${0}"/>
        <g:set var="ffl" value="" />
        <g:set var="ffv" value="" />
        <g:set var="ffc" value="" />

        <g:set var="lastElement" value="${facetResult.fieldResult.get(facetResult.fieldResult.length() - 1)}"/>
        <g:if test="${lastElement.label == 'before' && lastElement?.count > 0}">
            <g:set var="firstYear" value="${StringUtils.substring(facetResult.fieldResult[0].label, 0, 4)}"/>
            <g:set var="ffl">Before ${firstYear}</g:set>
            <g:set var="ffv">[* TO  ${facetResult.fieldResult[0].label}]</g:set>
            <g:set var="ffc" value="${lastElement?.count}" />
        </g:if>

        <g:each var="fieldResult" in="${facetResult.fieldResult}" status="vs">
            <g:set var="frlabels" value="${vs + 1}"/>
            <g:set var="frlabelcount" value="${fieldResult.count + frlabelcount}"/>
            <g:if test="${ffv && ! StringUtils.endsWith(fieldResult.label, 'before')}">
                <g:set var="ffl" value="${ffl}|" />
                <g:set var="ffv" value="${ffv}|" />
                <g:set var="ffc" value="${ffc}|" />
            </g:if>

            <g:set var="dateRangeTo"><g:if test="${vs == (facetResult.fieldResult.length() - 1 )|| facetResult.fieldResult[(vs + 1)].label=='before'}">*</g:if><g:else>${facetResult.fieldResult[vs + 1].label}</g:else></g:set>
            <g:set var="cffv" value="" />
            <g:set var="cffl" value="" />

            <g:if test="${StringUtils.containsIgnoreCase(facetResult.fieldName, 'occurrence_year') && StringUtils.endsWith(fieldResult.label, 'Z')}">
                <g:set var="startYear" value="${StringUtils.substring(fieldResult.label, 0, 4)}"/>
                <g:set var="cffv">[${fieldResult.label} TO ${dateRangeTo}]</g:set>
                <g:set var="cffl">${startYear} - ${startYear + 10}</g:set>
            </g:if>
            <g:elseif test="${StringUtils.containsIgnoreCase(facetResult.fieldName, 'data_resource_uid')}">
                <g:set var="cffv" value="${fieldResult.label}" />
                <g:set var="cffl" value="${dataResourceCodes?.get(fieldResult.label)}" />
            </g:elseif>
            <g:elseif test="${StringUtils.containsIgnoreCase(facetResult.fieldName, 'data_resource')}">
                <g:set var="cffv" value="${fieldResult.label}" />
                <g:set var="cffl"><g:message code="${StringUtils.replace(fieldResult.label, ' provider for OZCAM', '')}"/></g:set>
            </g:elseif>
            <g:elseif test="${StringUtils.containsIgnoreCase(facetResult.fieldName, 'institution_uid')}">
                <g:set var="cffv" value="${fieldResult.label}" />
                <g:set var="cffl" value="${institutionCodes?.get(fieldResult.label)}" />
            </g:elseif>
            <g:elseif test="${StringUtils.containsIgnoreCase(facetResult.fieldName, 'collection_uid')}">
                <g:set var="cffv" value="${fieldResult.label}" />
                <g:set var="cffl" value="${collectionCodes?.get(fieldResult.label)}" />
            </g:elseif>
            <g:elseif test="${StringUtils.endsWith(fieldResult.label, 'before')}"></g:elseif>
            <g:elseif test="${StringUtils.containsIgnoreCase(facetResult.fieldName, 'month')}">
                <g:set var="cffv" value="${fieldResult.label}" />
                <g:set var="cffl"><g:message code="month.${fieldResult.label ? fieldResult.label : 'unknown'}"/></g:set>
            </g:elseif>
            <g:elseif test="${StringUtils.endsWith(facetResult.fieldName, '_s')}">
                <g:set var="cffv">${fieldResult.label}</g:set>
                <g:set var="cffl">${StringUtils.replace(fieldResult.label, '_', ' ')}</g:set>
            </g:elseif>
            <g:else>
                <g:set var="cffv" value="${fieldResult.label}" />
                <g:set var="cffl"><g:message code="${fieldResult.label ? fieldResult.label : 'unknown'}"/></g:set>
            </g:else>

            <g:set var="ffl" value="${ffl}${cffl}" />
            <g:set var="ffv" value="${ffv}${cffv}" />
            <g:set var="ffc" value="${ffc}${fieldResult?.count}" />
        </g:each>
        <g:if test="${frlabelcount < sr.totalRecords && frlabels >= searchRequestParams.flimit}">
            <g:set var="ffl" value="${ffl}|Other" />
            <g:set var="ffv" value="${ffv}|" />
            <g:set var="ffc" value="${ffc}|${sr.totalRecords - frlabelcount}" />
        </g:if>
        */
            // add filter queries
            facetNames.push("${facetResult.fieldName}");
            facetLabels.push("${ffl.encodeAsHTML()}");
            facetValues.push("${ffv.encodeAsHTML()}");
            facetValueCounts.push("${ffc}");
            // console.log("facet labels", "${facetResult.fieldName}", "${frlabels}", "${searchRequestParams.flimit}");
    </g:each>
</script>
