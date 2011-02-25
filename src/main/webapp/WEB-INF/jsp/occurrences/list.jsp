<%-- 
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="biocacheServiceUrl" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OzCam Hub - Occurrence Search Results</title>
        <script type="text/javascript">
            contextPath = "${pageContext.request.contextPath}";
        </script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.metadata.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/getQueryParam.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ibutton.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.simplemodal.1.4.1.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/search.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/simpleModal.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/jquery.ibutton.css" type="text/css" media="all" />

    </head>
    <body>
        <c:if test="${searchResults.totalRecords > 0}">
            <div id="headingBar">
                <h1>Occurrence Records</h1>
            </div>
<!--            <div id="searchBox">search box goes here</div>-->
            <jsp:include page="facetsDiv.jsp"/>
        </c:if>
        <div id="content">
            <c:if test="${searchResults.totalRecords == 0}">
                <p>No records found for <b>${searchRequestParams.displayString}</b></p>
            </c:if>
            <c:if test="${searchResults.totalRecords > 0}">
                <div>
                    <div id="listMapToggle" class="row" >
                        Display Mode: <a href="${fn:replace(requestScope['javax.servlet.forward.request_uri'],"/search","/map")}?${pageContext.request.queryString}">Map View</a>
                        <span id="downloadLink"><a href="#download" title="Download all ${searchResults.totalRecords} results as XLS (tab-delimited) file">Download</a></span>
                    </div>
                    <div id="resultsReturned"><strong>${searchResults.totalRecords}</strong> results
                        returned for <strong>${searchResults.query}</strong>
                    </div>
                    <jsp:include page="downloadDiv.jsp"/>
                </div>
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
                            <p class="rowA">Record: <a href="<c:url value="/occurrence/${occurrence.uuid}"/>" class="occurrenceLink" style="font-size: 100%; color: #005A8E;">${occurrence.raw_collectionCode}:${occurrence.raw_catalogNumber}</a> &mdash;
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
                <div id="densityMap"></div>
                <div id="busyIcon" style="display:none;"><img src="${pageContext.request.contextPath}/static/css/images/wait.gif" alt="busy/spinning icon" /></div>
            </c:if>
        </div>
    </body>
</html>
