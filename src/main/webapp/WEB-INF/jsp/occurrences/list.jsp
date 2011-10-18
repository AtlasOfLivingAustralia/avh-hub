<%-- 
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="biocacheServiceUrl" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>
<c:set var="spatialPortalUrl" scope="request"><ala:propertyLoader bundle="hubs" property="spatialPortalUrl"/></c:set>
<c:set var="bieWebappContext" scope="request"><ala:propertyLoader bundle="hubs" property="bieWebappContext"/></c:set>    
<c:set var="queryContext" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.queryContext"/></c:set>
<c:set var="hubDisplayName" scope="request"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="queryDisplay">
    <c:choose>
        <c:when test="${fn:contains(searchRequestParams.displayString,'matchedTaxon')}">${searchRequestParams.displayString}</c:when>
        <c:when test="${not empty searchResults.queryTitle}">${searchResults.queryTitle}</c:when>
        <c:otherwise>${searchRequestParams.displayString}</c:otherwise></c:choose>
</c:set>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="${skin}"/>
        <title>Occurrence search results | ${hubDisplayName}</title>
        <script type="text/javascript">
            // single global var for app conf settings
            var BC_CONF = {
                contextPath: "${pageContext.request.contextPath}",
                searchString: '${searchResults.urlParameters}', // keep as single quotes as JSTL var can contain double quotes
                bieWebappUrl: "${bieWebappContext}",
                biocacheServiceUrl: "${biocacheServiceUrl}"
            };
        </script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/getQueryParam.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.oneshowhide.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-ui-1.8.10.core.slider.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ui.position.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.cookie.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/search.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/envlayers.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/config.js"></script>
<!--        <script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.3&sensor=false"></script>-->
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="http://jquery-jsonp.googlecode.com/files/jquery.jsonp-2.1.4.min.js"></script>
        <script type="text/javascript" src="http://collections.ala.org.au/js/charts.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/map.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/wms.js"></script>
        <script type="text/javascript">
            // Conf for map JS (Ajay)
            Config.setupUrls("${biocacheServiceUrl}", "${queryContext}");
            
            google.load('maps','3.3',{ other_params: "sensor=false" });
            google.load("visualization", "1", {packages:["corechart"]});
            
        </script>
        <script src="http://cdn.jquerytools.org/1.2.6/all/jquery.tools.min.js"></script>
        <script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/tags/keydragzoom/2.0.5/src/keydragzoom.js"></script>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/tabs-no-images.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/button.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/map.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/redmond/jquery.ui.redmond.css" type="text/css" media="screen" />
    </head>
    <body>
        <input type="hidden" id="userId" value="${userId}">
        <div id="headingBar">
            <h1>Occurrence Records<a name="resultsTop">&nbsp;</a></h1>
            <div id="searchBox">
                <form action="${pageContext.request.contextPath}/occurrences/search" id="solrSearchForm">
                    <span id="advancedSearchLink"><a href="${pageContext.request.contextPath}/home#advanced">Advanced Search</a></span>
                    <span id="#searchLabel">Search:</span>
                    <input type="text" id="taxaQuery" name="taxa" value="<c:out value='${param.taxa}'/>">
                    <input type="submit" id="solrSubmit" value="Search"/>
                </form>
            </div>
           <input type="hidden" id="lsid" value="${param.lsid}"/>
        </div>
        <div style="clear: both;"></div>
        <c:if test="${searchResults.totalRecords > 0}">
            <jsp:include page="facetsDiv.jsp"/>
        </c:if>
        <div id="content2">
            <c:if test="${not empty errors}">
                <h2 style="padding-left: 15px;">Error</h2>
                <p>${errors}</p>
            </c:if>
            <c:if test="${searchResults.totalRecords == 0 && empty errors}">
                <p>No records found for <span id="queryDisplay">${queryDisplay}</span></p>
            </c:if>
            <c:if test="${searchResults.totalRecords > 0 && empty errors}">
                <a name="map" class="jumpTo"></a><a name="list" class="jumpTo"></a>
                <div>
<!--                    <div id="listMapToggle" class="row" >
                        <button class="rounded" id="listMapButton">
                            <span id="listMapLink">Map</span>
                        </button>
                    </div>-->
                    <div id="resultsReturned"><strong><fmt:formatNumber value="${searchResults.totalRecords}" pattern="#,###,###"/></strong> results
                        for <span id="queryDisplay">${queryDisplay}</span>
<!--                        (<a href="#download" title="Download all <fmt:formatNumber value="${searchResults.totalRecords}" pattern="#,###,###"/> records as a tab-delimited file" id="downloadLink">Download all records</a>)-->
                    </div>
                    
                    <div style="display:none">
                        <jsp:include page="downloadDiv.jsp"/>
                    </div>
                </div>
                <ul class="css-tabs">
                    <li><a id="t1" href="#recordsView">Records</a></li>
                    <li><a id="t2" href="#mapView">Map</a></li>
                    <li><a id="t3" href="#chartsView">Charts</a></li>
                </ul>
                <div class="css-panes">
                    <div class="paneDiv solrResults">
                        <div id="searchControls">
                            <div id="downloads">
                                <a href="#download" id="downloadLink" title="Download all <fmt:formatNumber value="${searchResults.totalRecords}" pattern="#,###,###"/> records OR species checklist">Downloads</a>
                            </div>
                            <div id="sortWidgets">
                                Results per page:
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
                                <c:set var="useDefault" value="${empty param.sort && empty param.dir ? true : false }"/>
                                Sort by:
                                <select id="sort" name="sort">
                                    <option value="score" <c:if test="${param.sort eq 'score'}">selected</c:if>>best match</option>
                                    <option value="taxon_name" <c:if test="${param.sort eq 'taxon_name'}">selected</c:if>>scientific name</option>
                                    <option value="common_name" <c:if test="${param.sort eq 'common_name'}">selected</c:if>>common name</option>
                                    <!--                            <option value="rank">rank</option>-->
                                    <option value="occurrence_date" <c:if test="${useDefault || param.sort eq 'occurrence_date'}">selected</c:if>>record date</option>
                                    <option value="record_type" <c:if test="${param.sort eq 'record_type'}">selected</c:if>>record type</option>
                                </select>
                                Sort order:
                                <select id="dir" name="dir">
                                    <option value="asc" <c:if test="${param.dir eq 'asc'}">selected</c:if>>normal</option>
                                    <option value="desc" <c:if test="${useDefault || param.dir eq 'desc'}">selected</c:if>>reverse</option>
                                </select>
                            </div><!-- sortWidget -->
                        </div><!-- searchControls -->
                        <div id="results">
                            <c:forEach var="occurrence" items="${searchResults.occurrences}">
                                <p class="rowA">
                                    <c:set var="rawScientificName">
                                        <c:choose>
                                            <c:when test="${not empty occurrence.raw_scientificName}">${occurrence.raw_scientificName}</c:when>
                                            <c:when test="${not empty occurrence.species}">${occurrence.species}</c:when>
                                            <c:when test="${not empty occurrence.genus}">${occurrence.genus}</c:when>
                                            <c:when test="${not empty occurrence.family}">${occurrence.family}</c:when>
                                            <c:when test="${not empty occurrence.order}">${occurrence.order}</c:when>
                                            <c:when test="${not empty occurrence.phylum}">${occurrence.phylum}</c:when>
                                            <c:when test="${not empty occurrence.kingdom}">${occurrence.kingdom}</c:when>
                                            <c:otherwise>No name supplied</c:otherwise>
                                        </c:choose>
                                    </c:set>
                                    <span style="text-transform: capitalize">${occurrence.taxonRank}</span>:&nbsp;<span class="occurrenceNames"><alatag:formatSciName rankId="6000" name="${rawScientificName}"/></span>
                                    <c:if test="${not empty occurrence.vernacularName}">&nbsp;|&nbsp;<span class="occurrenceNames">${occurrence.vernacularName}</span></c:if>
                                    <span style="margin-left: 8px;">
                                    <c:if test="${not empty occurrence.eventDate}">
                                        <span style="text-transform: capitalize;"><strong class="resultsLabel">Date:</strong>&nbsp;<fmt:formatDate value="${occurrence.eventDate}" pattern="yyyy-MM-dd"/></span>
                                    </c:if>
                                    <c:if test="${not empty occurrence.stateProvince}">
                                        <span style="text-transform: capitalize;"><strong class="resultsLabel">State:</strong>&nbsp;<fmt:message key="region.${occurrence.stateProvince}"/></span>
                                    </c:if>
                                    </span>
                                </p>
                                <p class="rowB">
                                    <c:if test="${not empty occurrence.institutionName}">
                                        <span style="text-transform: capitalize;"><strong class="resultsLabel">Institution:</strong>&nbsp;${occurrence.institutionName}</span>
                                    </c:if>
                                    <c:if test="${not empty occurrence.collectionName}">
                                        <span style="text-transform: capitalize;"><strong class="resultsLabel">Collection:</strong>&nbsp;${occurrence.collectionName}</span>
                                    </c:if>
                                    <c:if test="${empty occurrence.collectionName && not empty occurrence.dataResourceName}">
                                        <span style="text-transform: capitalize;"><strong class="resultsLabel">Data&nbsp;Resource:</strong>&nbsp;${occurrence.dataResourceName}</span>
                                    </c:if>
                                    <c:if test="${not empty occurrence.basisOfRecord}">
                                        <span style="text-transform: capitalize;"><strong class="resultsLabel">Basis&nbsp;of&nbsp;record:</strong>&nbsp;${occurrence.basisOfRecord}</span>
                                    </c:if>
                                    <c:if test="${occurrence.raw_catalogNumber!= null && not empty occurrence.raw_catalogNumber}">
                                        <strong class="resultsLabel">Catalog&nbsp;number:</strong>&nbsp;${occurrence.raw_collectionCode}:${occurrence.raw_catalogNumber}
                                    </c:if>
                                    <a href="<c:url value="/occurrences/${occurrence.uuid}"/>" class="occurrenceLink" style="margin-left: 15px;">View record</a>
                                </p>
                            </c:forEach>
                        </div><!--close results-->
                        <div id="searchNavBar">
                            <alatag:searchNavigationLinks totalRecords="${searchResults.totalRecords}" startIndex="${searchResults.startIndex}"
                                                          lastPage="${lastPage}" pageSize="${searchResults.pageSize}"/>
                        </div>
                    </div><!--end solrResults-->
                    <div id="mapwrapper" class="paneDiv">
                        <table id="mapLayerControls">
                            <tr>
                                <td>
                                    <label for="colourFacets">Colour by:&nbsp;</label>
                                    <div class="layerControls">
                                        <select name="colourFacets" id="colourFacets">
                                            <option value=""> None </option>
                                            <c:forEach var="facetResult" items="${searchResults.facetResults}">
                                                <c:if test="${fn:length(facetResult.fieldResult) > 1 && empty facetMap[facetResult.fieldName]}">
                                                    <option value="${facetResult.fieldName}"><fmt:message key="facet.${facetResult.fieldName}"/></option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <label for="sizeslider">Size:</label>
                                    <div class="layerControls">
                                        <span id="sizeslider-val">4</span>
                                        <div id="sizeslider"></div>
                                    </div>
                                </td>
                                <td>
                                    <c:set var='spatialPortalLink'>${fn:replace(searchResults.urlParameters, "\"", "&#034;") }</c:set>
                                    <a id="spatialPortalLink" href="${spatialPortalUrl}${spatialPortalLink}">View in spatial portal</a>
                                </td>
                            </tr>
                        </table>
                        <div id="maploading">Loading...</div>
                        <div id="mapcanvas"></div>
                        <div id="legend" title="Toggle layers/legend display">                            
                            <div class="title">Legend<span>&nabla;</span></div>
                            <div id="layerlist">
                                <div id="toggleAll">Toggle All</div>
                                <div id="legendContent"></div>
                            </div>
                        </div>
                    </div><!--end mapwrapper-->
                    <div id="chartsWrapper" class="paneDiv">
                        <div id="charts"></div>
                    </div><!--end chartsWrapper-->
                </div>
            </c:if>
        </div>
  </body>
</html>
