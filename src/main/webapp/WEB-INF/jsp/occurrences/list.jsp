<%-- 
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OzCam Hub - Occurrence Search Results</title>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/getQueryParam.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/search.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search.css" type="text/css" media="screen" />
    </head>
    <body>
        <c:if test="${searchResults.totalRecords > 0}">
            <div id="headingBar">
                <h1>Occurrence Records</h1>
            </div>
<!--            <div id="searchBox">search box goes here</div>-->
            <div id="SidebarBox">
                <div class="sidebar">
                    <h3>Refine Results</h3>
                </div>
                <div class="sidebar">
                    <c:if test="${not empty searchResults.query}">
                        <c:set var="queryParam">q=<c:out value="${param['q']}" escapeXml="true"/><c:if test="${not empty param.fq}">&fq=${fn:join(paramValues.fq, "&fq=")}</c:if>
                        </c:set>
                    </c:if>
                    <c:if test="${not empty facetMap}">
                        <h4><span class="FieldName">Current Filters</span></h4>
                        <div id="subnavlist">
                            <ul>
                                <c:forEach var="item" items="${facetMap}">
                                    <li>
                                        <c:set var="closeLink">&nbsp;[<b><a href="#" onClick="removeFacet('${item.key}:${item.value}'); return false;" class="removeLink" title="remove">X</a></b>]</c:set>
                                        <fmt:message key="facet.${item.key}"/>:
                                        <c:choose>
                                            <c:when test="${fn:containsIgnoreCase(item.key, 'month')}">
                                                <b><fmt:message key="month.${item.value}"/></b>${closeLink}
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(item.key, 'occurrence_date') && fn:startsWith(item.value, '[*')}">
                                                <c:set var="endYear" value="${fn:substring(item.value, 6, 10)}"/><b>Before ${endYear}</b>${closeLink}
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(item.key, 'occurrence_date') && fn:endsWith(item.value, '*]')}">
                                                <c:set var="startYear" value="${fn:substring(item.value, 1, 5)}"/><b>After ${startYear}</b>${closeLink}
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(item.key, 'occurrence_date') && fn:endsWith(item.value, 'Z]')}">
                                                <c:set var="startYear" value="${fn:substring(item.value, 1, 5)}"/><b>${startYear} - ${startYear + 10}</b>${closeLink}
                                            </c:when>
                                            <c:otherwise>
                                                <b><fmt:message key="${item.value}"/></b>${closeLink}
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    <c:forEach var="facetResult" items="${searchResults.facetResults}">
                        <c:if test="${fn:length(facetResult.fieldResult) > 1 && empty facetMap[facetResult.fieldName]}"> <%-- || not empty facetMap[facetResult.fieldName] --%>
                            <h4><span class="FieldName"><fmt:message key="facet.${facetResult.fieldName}"/></span></h4>
                            <div id="subnavlist">
                                <ul>
                                    <c:set var="lastElement" value="${facetResult.fieldResult[fn:length(facetResult.fieldResult)-1]}"/>
                                    <c:if test="${lastElement.label eq 'before' && lastElement.count > 0}">
                                        <li><c:set var="firstYear" value="${fn:substring(facetResult.fieldResult[0].label, 0, 4)}"/>
                                            <a href="?${queryParam}&fq=${facetResult.fieldName}:[* TO ${facetResult.fieldResult[0].label}]">Before ${firstYear}</a>
                                            (<fmt:formatNumber value="${lastElement.count}" pattern="#,###,###"/>)
                                        </li>
                                    </c:if>
                                    <c:forEach var="fieldResult" items="${facetResult.fieldResult}" varStatus="vs"> <!-- ${facetResult.fieldName} -->
                                        <c:if test="${fieldResult.count > 0}">
                                            <c:set var="dateRangeTo"><c:choose><c:when test="${vs.last || facetResult.fieldResult[vs.count].label=='before'}">*</c:when><c:otherwise>${facetResult.fieldResult[vs.count].label}</c:otherwise></c:choose></c:set>
                                            <c:choose>
                                                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'occurrence_date') && fn:endsWith(fieldResult.label, 'Z')}">
                                                    <li><c:set var="startYear" value="${fn:substring(fieldResult.label, 0, 4)}"/>
                                                        <a href="?${queryParam}&fq=${facetResult.fieldName}:[${fieldResult.label} TO ${dateRangeTo}]">${startYear} - ${startYear + 10}</a>
                                                        (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                                </c:when>
                                                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'data_resource')}">
                                                    <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="${fn:replace(fieldResult.label, ' provider for OZCAM', '')}"/></a>
                                                    (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                                </c:when>
                                                <c:when test="${fn:endsWith(fieldResult.label, 'before')}"><%-- skip, otherwise gets inserted at bottom, not top of list --%></c:when>
                                                <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'month')}">
                                                    <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="month.${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                                    (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="${not empty fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
                                                    (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div><!--facets-->
            
        </c:if>
        <div id="content">
            <c:if test="${searchResults.totalRecords == 0}">
                <p>No records found for ${searchResults.query}</p>
            </c:if>
            <c:if test="${searchResults.totalRecords > 0}">
                <p id="resultsReturned"><strong>${searchResults.totalRecords}</strong> results
                    returned for <strong>${searchResults.query}</strong></p>
                <div class="solrResults">
                    <div id="dropdowns">
                        <div id="resultsStats">
                            Results per page
                            <select id="per-page" name="per-page">
                                <c:set var="pageSizeVar">
                                    <c:choose>
                                        <c:when test="${not empty param.pageSize}">${param.pageSize}</c:when>
                                        <c:otherwise>20</c:otherwise>
                                    </c:choose>
                                </c:set>
                                <option value="10" <c:if test="${pageSizeVar eq '10'}">selected</c:if>>10</option>
                                <option value="20" <c:if test="${pageSizeVar eq '20'}">selected</c:if>>20</option>
                                <option value="50" <c:if test="${pageSizeVar eq '50'}">selected</c:if>>50</option>
                                <option value="100" <c:if test="${pageSizeVar eq '100'}">selected</c:if>>100</option>
                            </select>
                        </div>
                        <div id="sortWidget">
                            Sort by
                            <select id="sort" name="sort">
                                <option value="score" <c:if test="${param.sort eq 'score'}">selected</c:if>>best match</option>
                                <option value="taxon_name" <c:if test="${param.sort eq 'taxon_name'}">selected</c:if>>scientific name</option>
                                <option value="common_name" <c:if test="${param.sort eq 'common_name'}">selected</c:if>>common name</option>
                                <!--                            <option value="rank">rank</option>-->
                                <option value="occurrence_date" <c:if test="${param.sort eq 'occurrence_date'}">selected</c:if>>record date</option>
                                <option value="record_type" <c:if test="${param.sort eq 'record_type'}">selected</c:if>>record type</option>
                            </select>
                            Sort order
                            <select id="dir" name="dir">
                                <option value="asc" <c:if test="${param.dir eq 'asc'}">selected</c:if>>normal</option>
                                <option value="desc" <c:if test="${param.dir eq 'desc'}">selected</c:if>>reverse</option>
                            </select>

                        </div><!--sortWidget-->
                    </div><!--drop downs-->
                    <div id="results">
                        <c:forEach var="occurrence" items="${searchResults.occurrences}">
                            <p class="rowA">Record: <a href="<c:url value="/occurrence/${occurrence.uuid}"/>" class="occurrenceLink" style="font-size: 100%; color: #005A8E;">${occurrence.raw_collectionCode} ${occurrence.raw_catalogNumber}</a> &mdash;
                                <span style="text-transform: capitalize">${occurrence.taxonRank}</span>: <span class="occurrenceNames"><alatag:formatSciName rankId="6000" name="${occurrence.scientificName}"/></span>
                                <c:if test="${not empty occurrence.vernacularName}"> | <span class="occurrenceNames">${occurrence.vernacularName}</span></c:if>
                            </p>
                            <p class="rowB">
                                <c:if test="${not empty occurrence.dataResourceName}"><span style="text-transform: capitalize;"><strong class="resultsLabel">Dataset:</strong> ${fn:replace(occurrence.dataResourceName, ' provider for OZCAM', '')}</span></c:if>
                                <c:if test="${not empty occurrence.basisOfRecord}"><span style="text-transform: capitalize;"><strong class="resultsLabel">Record type:</strong> ${occurrence.basisOfRecord}</span></c:if>
                                <c:if test="${not empty occurrence.eventDate}"><span style="text-transform: capitalize;"><strong class="resultsLabel">Record date:</strong> <fmt:formatDate value="${occurrence.eventDate}" pattern="yyyy-MM-dd"/></span></c:if>
                                <c:if test="${not empty occurrence.stateProvince}"><span style="text-transform: capitalize;"><strong class="resultsLabel">State:</strong> <fmt:message key="region.${occurrence.stateProvince}"/></span></c:if>
                            </p>
                        </c:forEach>
                    </div><!--close results-->
                    <div id="searchNavBar">
                        <alatag:searchNavigationLinks totalRecords="${searchResults.totalRecords}" startIndex="${searchResults.startIndex}"
                             lastPage="${lastPage}" pageSize="${searchResults.pageSize}"/>
                    </div>
                </div><!--solrResults-->
                <div id="pointsMap"></div>
                <div id="busyIcon" style="display:none;"><img src="${pageContext.request.contextPath}/static/css/images/wait.gif" alt="busy/spinning icon" /></div>

            </c:if>
        </div>
    </body>
</html>
