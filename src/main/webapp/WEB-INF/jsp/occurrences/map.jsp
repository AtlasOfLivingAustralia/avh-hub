<%-- 
    Document   : map.jsp
    Created on : Feb 16, 2011, 3:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="biocacheServiceUrl" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>
<c:set var="queryContext" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.queryContext"/></c:set>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Occurrence Map</title>
        <script type="text/javascript">
            contextPath = "${pageContext.request.contextPath}";
        </script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/getQueryParam.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.simplemodal.1.4.1.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/search.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/config.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
        <script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/tags/keydragzoom/1.0/src/keydragzoom.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/map.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/wms.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/simpleModal.css" type="text/css" media="screen" />
        <!--[if lt IE 7]>
            <link type='text/css' href='${pageContext.request.contextPath}/static/css/simpleModal_ie.css' rel='stylesheet' media='screen' />
        <![endif]-->

    </head>
    <body>
        <c:if test="${searchResults.totalRecords > 0}">
            <div id="headingBar">
                <h1>Occurrence Map<a name="resultsTop">&nbsp;</a></h1>
            </div>
            <!-- <div id="searchBox">search box goes here</div>-->
            <jsp:include page="facetsDiv.jsp"/>
        </c:if>
        <div id="content">
            <c:if test="${searchResults.totalRecords == 0}">
                <p>No records found for
                    <b>${not empty searchRequestParams.displayString ? searchRequestParams.displayString : ' this search.'}</b>
                </p>
            </c:if>
            <c:if test="${searchResults.totalRecords > 0}">
                <div>
                    <div id="listMapToggle" class="row" >
                        Display Mode: <a href="${fn:replace(requestScope['javax.servlet.forward.request_uri'],"/map","/search")}?${pageContext.request.queryString}#resultsTop">List View</a>
                        <span id="downloadLink"><a href="#download" title="Download all ${searchResults.totalRecords} results as XLS (tab-delimited) file">Download</a></span>
                    </div>
                    <jsp:include page="downloadDiv.jsp"/>
                    <div id="resultsReturned"><strong>${searchResults.totalRecords}</strong> results
                        returned for <strong>${searchResults.query}</strong>
                    </div>
                    <div id="colourBy">
                        <a id="listLink"></a>
                        Colour by: 
                        <select name="colourFacets" id="colourFacets">
                            <option value=""> -- Select an option -- </option>
                            <c:forEach var="facetResult" items="${searchResults.facetResults}">
                                <c:if test="${fn:length(facetResult.fieldResult) > 1 && empty facetMap[facetResult.fieldName]}">
                                    <option value="${facetResult.fieldName}"><fmt:message key="facet.${facetResult.fieldName}"/></option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                </div>


                <div id="mapwrapper">
                    <div id="mapcanvas" style="width: 730px; height: 540px">
                    <!-- <img id="wmsimg" src="http://localhost:8080/occurrences/wms?q=macropus" /> -->
                    </div>
                </div>
                
                <div id="busyIcon" style="display:none;"><img src="${pageContext.request.contextPath}/static/css/images/wait.gif" alt="busy/spinning icon" /></div>
                </c:if>
                <script type="text/javascript">
                    Config.BIOCACHE_SERVICE_URL = "${biocacheServiceUrl}";
                    Config.QUERY_CONTEXT = "${queryContext}"
                </script>
        </div>
    </body>
</html>
