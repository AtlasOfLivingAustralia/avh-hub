<%-- 
    Document   : map.jsp
    Created on : Feb 16, 2011, 3:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OzCam Hub - Occurrence Map</title>
        <script type="text/javascript">
            contextPath = "${pageContext.request.contextPath}";
        </script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.metadata.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/getQueryParam.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ibutton.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/search.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/densityMap.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/config.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/map.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/wms.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/jquery.ibutton.css" type="text/css" media="all" />

    </head>
    <body>
        <c:if test="${searchResults.totalRecords > 0}">
            <div id="headingBar">
                <h1>Occurrence Map</h1>
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
                        Display Mode: <a href="${fn:replace(requestScope['javax.servlet.forward.request_uri'],"/map","/search")}?${pageContext.request.queryString}">List View</a>
                    </div>
                    <div id="resultsReturned"><strong>${searchResults.totalRecords}</strong> results
                        returned for <strong>${searchResults.query}</strong>
                    </div>
                    <div>
                        <a id="listLink"></a>
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
                    <div id="map-canvas" style="width: 640px; height: 480px">
                    <!-- <img id="wmsimg" src="http://localhost:8080/occurrences/wms?q=macropus" /> -->
                    </div>
                </div>
                
                <div id="busyIcon" style="display:none;"><img src="${pageContext.request.contextPath}/static/css/images/wait.gif" alt="busy/spinning icon" /></div>
                </c:if>
        </div>
    </body>
</html>
