<%-- 
    Document   : collection
    Created on : Feb 22, 2011, 11:49:55 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="hostName" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OzCam Hub - Taxa Page: </title>
        <%-- <base href="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}${pageContext.request.contextPath}/" /> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/collection.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/public.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/charts.css" type="text/css" media="screen"> 
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="http://collections.ala.org.au/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.1.pack.js"></script>
        <link rel="stylesheet" type="text/css" href="http://collections.ala.org.au/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.1.css" media="screen" />
        <script type="text/javascript" language="javascript" src="http://collections.ala.org.au/js/collectory.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/charts.js"></script>
        <script type="text/javascript">
          $(document).ready(function() {
            //$('#nav-tabs > ul').tabs();
            //greyInitialValues();
            $("a#lsid").fancybox({
                    'hideOnContentClick' : false,
                    'titleShow' : false,
                    'autoDimensions' : false,
                    'width' : 600,
                    'height' : 180
            });
            $("a.current").fancybox({
                    'hideOnContentClick' : false,
                    'titleShow' : false,
                    'titlePosition' : 'inside',
                    'autoDimensions' : true,
                    'width' : 300
            });
          });
        </script> --%>
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty taxon}">
                <div id="headingBar" class="fullWidthHeader">
                    <h1>${taxon.rank}: <span id="taxonName"><alatag:formatSciName rankId="${taxon.rankId}" name="${taxon.scientificName}"/> ${taxon.author}</span></h1>
                    <h2>${taxon.allCommonNames}</h2>
                </div>
                <div id="SidebarBox">
                    <div class="sidebar">
<!--                        <div style="width: 220px;">-->
                            <c:forEach var="image" items="${taxon.images}">
                                <div class="imageThumb">
                                    <a href="${image.identifier}"><img src="${image.thumbnail}" alt="${image.title}"/></a>
                                </div>
                            </c:forEach>
<!--                        </div>-->
                    </div>
                </div><!-- end div#SidebarBox --> 
                <div id="content">
                    <div>${taxon.description}</div>
                </div>
            </c:when>
            <c:otherwise>
                <h2>Not Found</h2>
                <div>The requested taxon page "${guid}" could not be found.</div>
            </c:otherwise>
        </c:choose>
    </body>
</html>
