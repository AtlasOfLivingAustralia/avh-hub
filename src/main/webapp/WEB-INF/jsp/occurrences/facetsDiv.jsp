<%-- 
    Document   : facetsDiv
    Created on : Feb 24, 2011, 11:39:45 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ include file="/common/taglibs.jsp" %>
<div id="SidebarBox" class="facets">
    <div class="sidebar">
        <%--<h3 style="display: inline-block;float:left;">Refine Results</h3>--%>
        <div id="customiseFacets"><a href="#" title="customise which categories are displayed below">Refine results</a></div>
        <div id="facetOptions">
            <h4 style="padding-top: 8px;">Select the filter categories that you want to appear in the &quot;Refine results&quot; column</h4>
            <%-- <form:checkboxes path="facets" items="${defaultFacets}" itemValue="key" itemLabel="value" /> --%>
            <div id="facetCheckboxes">
                Select: <a href="#" id="selectAll">All</a> | <a href="#" id="selectNone">None</a><br/>
                <div class="facetsColumn">
                    <c:forEach var="facet" items="${defaultFacets}" varStatus="status">
                        <c:if test="${status.index > 0 && status.index % 18 == 0}">
                            </div><div class="facetsColumn">
                        </c:if>
                        <input type="checkbox" name="facets" class="facetOpts" value="${facet.key}"
                               ${(facet.value) ? 'checked="checked"' : ''}>&nbsp;<fmt:message key="facet.${facet.key}"/><br>
                    </c:forEach>
                </div>
            </div>
            <div style="clear:both;"></div>
            <input type="button" id="updateFacetOptions" value="Update"/>
        </div>
    </div>
    <div class="sidebar" style="clear:both;">
        <c:if test="${not empty searchResults.query}">
            <c:set var="queryStr" value="${param.q ? param.q : searchRequestParams.q}"/>
            <c:set var="queryParam"><c:choose><c:when test="${not empty param.taxa}">taxa=<c:out escapeXml="true" value="${fn:join(paramValues.taxa, '&taxa=')}"/></c:when><c:otherwise>q=<c:out escapeXml="true" value="${queryStr}"/></c:otherwise></c:choose><c:if
                    test="${not empty param.fq}">&fq=<c:out escapeXml="true" value="${fn:join(paramValues.fq, '&fq=')}"/></c:if><c:if
                    test="${not empty param.lat}">&lat=${param.lat}</c:if><c:if 
                    test="${not empty param.lon}">&lon=${param.lon}</c:if><c:if 
                    test="${not empty param.radius}">&radius=${param.radius}</c:if></c:set>
        </c:if>
        <c:if test="${not empty facetMap}">
            <div id="currentFilter">
                <h4><span class="FieldName">Current filters</span></h4>
                <div class="subnavlist">
                    <ul id="refinedFacets">
                        <c:forEach var="item" items="${facetMap}">
                            <li>
                                <c:set var="closeLink">&nbsp;[<b><a href="#" onClick="removeFacet('${item.key}:<alatag:uriEscapeParamValue input="${item.value.value}"/><%--<c:out escapeXml="true" value="${item.value.value}"/>--%>'); return false;" class="removeLink" title="remove filter">X</a></b>]</c:set>

                                <c:set var="filterLabel"><c:choose>
                                    <c:when test="${fn:endsWith(item.value.label, '_s')}">${fn:replace(item.value.label, '_s','')}</c:when>
                                    <c:otherwise><fmt:message key="${item.value.label}"/></c:otherwise>
                                    </c:choose></c:set>

                                <c:set var="fqLabel">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(filterLabel,'-')}"><span class="red">[exclude]</span> ${fn:substring(filterLabel, 1, -1)}</c:when>
                                        <c:otherwise>${filterLabel}</c:otherwise>
                                    </c:choose>
                                </c:set>
                                <span class="activeFq"><fmt:message key="${fqLabel}"/></span>${closeLink}
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </c:if>
        <c:forEach var="facetResult" items="${searchResults.facetResults}">
            <c:if test="${fn:length(facetResult.fieldResult) >= 1 && empty facetMap[facetResult.fieldName]}"> <%-- || not empty facetMap[facetResult.fieldName] --%>
                <c:set var="fieldDisplayName"><c:choose>
                    <c:when test="${fn:endsWith(facetResult.fieldName, '_s')}">
                        ${fn:replace(facetResult.fieldName, "_s", "")}
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="facet.${facetResult.fieldName}"/>
                    </c:otherwise>
                </c:choose></c:set>
                <h4><span class="FieldName">${fieldDisplayName}</span>
                    <c:if test="${false && fn:length(facetResult.fieldResult) > 1}">
                        <a href="#multipleFacets" class="multipleFacetsLink" id="multi-${facetResult.fieldName}" data-displayname="${fieldDisplayName}"
                           title="Refine with multiple values"><img src="${pageContext.request.contextPath}/static/images/options_icon.jpg" class="optionsIcon"/></a>
                    </c:if>
                </h4>
                <div class="subnavlist" style="clear:left">
                    <ul class="facets">
                        <c:set var="lastElement" value="${facetResult.fieldResult[fn:length(facetResult.fieldResult)-1]}"/>
                        <c:if test="${lastElement.label eq 'before' && lastElement.count > 0}">
                            <li><c:set var="firstYear" value="${fn:substring(facetResult.fieldResult[0].label, 0, 4)}"/>
                                <a href="?${queryParam}&fq=${facetResult.fieldName}:[* TO ${facetResult.fieldResult[0].label}]">Before ${firstYear}</a>
                                (<fmt:formatNumber value="${lastElement.count}" pattern="#,###,###"/>)
                            </li>
                        </c:if>
                        <c:forEach var="fieldResult" items="${facetResult.fieldResult}" varStatus="vs"> <!-- ${facetResult.fieldName}:${fieldResult.label} -->
                            <c:if test="${fieldResult.count >= 0 && vs.count < 4}">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'occurrence_') && fn:endsWith(fieldResult.label, 'Z')}">
                                        <li><c:set var="startYear" value="${fn:substring(fieldResult.label, 0, 4)}"/>
                                            <c:set var="endYear" value="${fn:replace(fieldResult.label,'0-01-01','9-12-31')}"/><%-- assumes decade gaps --%>
                                            <a href="?${queryParam}&fq=${facetResult.fieldName}:[${fieldResult.label} TO ${endYear}]">${startYear}<i>s</i></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'data_resource_uid')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}">${dataResourceCodes[fieldResult.label]}</a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'data_provider_uid')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}">${dataProviderCodes[fieldResult.label]}</a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'data_resource')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="${fn:replace(fieldResult.label, ' provider for OZCAM', '')}"/></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'institution_uid')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}">${institutionCodes[fieldResult.label]}</a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'state')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:&#034;${fieldResult.label}&#034;">${fieldResult.label}</a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'collection_uid')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}">${collectionCodes[fieldResult.label]}</a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:endsWith(fieldResult.label, 'before')}"><!-- skipping --> <%-- skip, otherwise gets inserted at bottom, not top of list --%></c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'month')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="month.${not empty fieldResult.label ? fieldResult.label : 'unknown'}" /></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'species_guid')}">
                                        <c:set var="lsidLength" value="${fn:length(fieldResult.label)}"/>
                                        <li class="species_guid" id="${fieldResult.label}"><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message 
                                            key="${lsidLength > 30 ? fn:substring(fieldResult.label,0,20) : fieldResult.label}..${lsidLength > 30 ? fn:substring(fieldResult.label, (lsidLength - 10), lsidLength) : fieldResult.label}"/></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'genus_guid')}">
                                        <c:set var="lsidLength" value="${fn:length(fieldResult.label)}"/>
                                        <li class="genus_guid" id="${fieldResult.label}"><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message
                                                key="${lsidLength > 30 ? fn:substring(fieldResult.label,0,20) : fieldResult.label}..${lsidLength > 30 ? fn:substring(fieldResult.label, (lsidLength - 10), lsidLength) : fieldResult.label}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'subspecies_name')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}">
                                                <fmt:message key="${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'geospatial_kosher')}">
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="geospatial_kosher.${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'collector')}">
                                        <c:set var="fqValue"><alatag:uriEscapeParamValue input="${fieldResult.label}"/></c:set><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:%22<c:out escapeXml='true' value='${fqValue}'/>%22"><fmt:message key="${(fn:contains(fieldResult.label,'@')) ? fn:substringBefore(fieldResult.label,'@') : fieldResult.label}"/></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'outlier_layer')}">
                                        <c:set var="fqValue" value="${fn:replace(fieldResult.label, '\"','%22')}"/><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:<c:out escapeXml='true' value='${fqValue}'/>">
                                            <fmt:message key="layer.${fieldResult.label}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'duplicate_status')}">
                                        <c:set var="fqValue" value="${fn:replace(fieldResult.label, '\"','%22')}"/><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:<c:out escapeXml='true' value='${fqValue}'/>">
                                            <fmt:message key="duplicate.${fieldResult.label}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'raw_taxon_name')}">
                                        <c:set var="fqValue"><alatag:uriEscapeParamValue input="${fieldResult.label}"/></c:set><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22"><fmt:message key="${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'user_assertions')}">
                                        <c:set var="fqValue"><alatag:uriEscapeParamValue input="${fieldResult.label}"/></c:set><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22"><fmt:message key="user_assertions.${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'duplicate_type')}">
                                        <c:set var="fqValue"><alatag:uriEscapeParamValue input="${fieldResult.label}"/></c:set><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22"><fmt:message key="duplication.${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'assertion_user_id')}">
                                        <c:set var="fqValue"><alatag:uriEscapeParamValue input="${fieldResult.label}"/></c:set><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22">${fn:substringBefore(fieldResult.label, '@')}</a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="fqValue"><alatag:uriEscapeParamValue input="${fieldResult.label}"/></c:set><!-- fqValue = ${fqValue} -->
                                        <li><a href="?${queryParam}&fq=${facetResult.fieldName}:<c:out escapeXml='true' value='${fn:replace(fqValue," ","%20")}'/>"><fmt:message key="${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
                <c:if test="${fn:length(facetResult.fieldResult) > 1}">
                    <div class="showHide">
                        <a href="#multipleFacets" class="multipleFacetsLink" id="multi-${facetResult.fieldName}" data-displayname="${fieldDisplayName}"
                           title="See more options or refine with multiple values">choose more...</a>
                    </div>
                </c:if>
            </c:if>
        </c:forEach>
    </div>
</div><!--end facets-->
<div style="display:none"><!-- fancybox popup div -->
    <div id="multipleFacets">
        <h3>Refine your search</h3>
        <div id="dynamic" class="tableContainer"></div>
        <div id='submitFacets'>
            <input type='submit' class='submit' id="include" value="INCLUDE selected items in search"/>
            &nbsp;
            <input type='submit' class='submit' id="exclude" value="EXCLUDE selected items from search"/>
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
    <c:forEach var="facetResult" items="${searchResults.facetResults}">
        <c:set var="frlabels" value="0"/>
        <c:set var="frlabelcount" value="0"/>
        <c:set var="ffl" value="" />
        <c:set var="ffv" value="" />
        <c:set var="ffc" value="" />

        <c:set var="lastElement" value="${facetResult.fieldResult[fn:length(facetResult.fieldResult)-1]}"/>
        <c:if test="${lastElement.label eq 'before' && lastElement.count > 0}">
            <c:set var="firstYear" value="${fn:substring(facetResult.fieldResult[0].label, 0, 4)}"/>
            <c:set var="ffl" value="Before ${firstYear}" />
            <c:set var="ffv" value="[* TO ${facetResult.fieldResult[0].label}]" />
            <c:set var="ffc" value="${lastElement.count}" />
        </c:if>

        <c:forEach var="fieldResult" items="${facetResult.fieldResult}" varStatus="vs">
            <c:set var="frlabels" value="${vs.count}"/>
            <c:set var="frlabelcount" value="${fieldResult.count + frlabelcount}"/>
            <c:if test="${!empty ffv && not fn:endsWith(fieldResult.label, 'before')}">
                <c:set var="ffl" value="${ffl}|" />
                <c:set var="ffv" value="${ffv}|" />
                <c:set var="ffc" value="${ffc}|" />
            </c:if>

            <c:set var="dateRangeTo"><c:choose><c:when test="${vs.last || facetResult.fieldResult[vs.count].label=='before'}">*</c:when><c:otherwise>${facetResult.fieldResult[vs.count].label}</c:otherwise></c:choose></c:set>
            <c:set var="cffv" value="" />
            <c:set var="cffl" value="" />
            <c:choose>
                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'occurrence_year') && fn:endsWith(fieldResult.label, 'Z')}">
                    <c:set var="startYear" value="${fn:substring(fieldResult.label, 0, 4)}"/>
                    <c:set var="cffv" value="[${fieldResult.label} TO ${dateRangeTo}]" />
                    <c:set var="cffl" value="${startYear} - ${startYear + 10}" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'data_resource_uid')}">
                    <c:set var="cffv" value="${fieldResult.label}" />
                    <c:set var="cffl" value="${dataResourceCodes[fieldResult.label]}" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'data_resource')}">
                    <c:set var="cffv" value="${fieldResult.label}" />
                    <c:set var="cffl"><fmt:message key="${fn:replace(fieldResult.label, ' provider for OZCAM', '')}"/></c:set>
                </c:when>
                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'institution_uid')}">
                    <c:set var="cffv" value="${fieldResult.label}" />
                    <c:set var="cffl" value="${institutionCodes[fieldResult.label]}" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'collection_uid')}">
                    <c:set var="cffv" value="${fieldResult.label}" />
                    <c:set var="cffl" value="${collectionCodes[fieldResult.label]}" />
                </c:when>
                <c:when test="${fn:endsWith(fieldResult.label, 'before')}"><%-- skip, otherwise gets inserted at bottom, not top of list --%></c:when>
                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'month')}">
                    <c:set var="cffv" value="${fieldResult.label}" />
                    <c:set var="cffl"><fmt:message key="month.${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></c:set>
                </c:when>
                <c:when test="${fn:endsWith(facetResult.fieldName, '_s')}">
                    <c:set var="cffv" value="${fn:replace(facetResult.fieldName, '_s','')}" />
                    <c:set var="cffl">${fieldResult.label}</c:set>
                </c:when>
                <c:otherwise>
                    <c:set var="cffv" value="${fieldResult.label}" />
                    <c:set var="cffl"><fmt:message key="${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></c:set>
                </c:otherwise>
            </c:choose>
            <c:set var="ffl" value="${ffl}${cffl}" />
            <c:set var="ffv" value="${ffv}${cffv}" />
            <c:set var="ffc" value="${ffc}${fieldResult.count}" />
        </c:forEach>
        <c:if test="${frlabelcount < searchResults.totalRecords && frlabels >= searchRequestParams.flimit}">
            <c:set var="ffl" value="${ffl}|Other" />
            <c:set var="ffv" value="${ffv}|" />
            <c:set var="ffc" value="${ffc}|${searchResults.totalRecords - frlabelcount}" />
        </c:if>
            // add filter queries
            facetNames.push("${facetResult.fieldName}");
            facetLabels.push("<c:out escapeXml='true' value='${ffl}'/>");
            facetValues.push("<c:out escapeXml='true' value='${ffv}'/>");
            facetValueCounts.push("${ffc}");
            // console.log("facet labels", "${facetResult.fieldName}", "${frlabels}", "${searchRequestParams.flimit}");
    </c:forEach>
</script>