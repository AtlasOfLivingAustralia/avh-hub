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
        <meta name="decorator" content="${skin}"/>
        <title><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayName"/> - ${type}: ${entityName}</title>
        <%-- <base href="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}${pageContext.request.contextPath}/" /> --%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/collection.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/public.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/charts.css" type="text/css" media="screen">
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
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
        </script>
        <style type="text/css">
            #site-header, #nav-site, #breadcrumb, footer, #nav-tabs {
                display:none;
            }

            #contentBox #header {
                background: none;
            }
        </style>
        ${scripts}
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty content}">
                ${content}
            </c:when>
            <c:otherwise>
                <h2>Not Found</h2>
                <div>The requested collection page "${uid}" could not be found.</div>
            </c:otherwise>
        </c:choose>
    </body>
</html>
