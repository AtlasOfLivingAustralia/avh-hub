<%--
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="queryContext" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.queryContext"/></c:set>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="<ala:propertyLoader bundle="hubs" property="sitemesh.skin"/>"/>
        <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Advanced Search</title>
        <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/charts.css" type="text/css" media="screen">
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/charts.js"></script> --%>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/advancedSearch.js"></script>
        <script type="text/javascript">
            
            /************************************************************\
            * Fire chart loading
            \************************************************************/
            //google.load("visualization", "1", {packages:["corechart"]});
            //google.setOnLoadCallback(hubChartsOnLoadCallback);
            
            $(document).ready(function() {
                $("#advancedSearch").show();
            });

        </script>
    </head>
    <body>
        <div id="headingBar">
            <h1 style="width:100%;">Search for records in <ala:propertyLoader bundle="hubs" property="site.displayName"/></h1>
            
            <jsp:include page="advancedSearchDiv.jsp"/>
            <br/><br/>
            <%-- <jsp:include page="chartDiv.jsp"/> --%>
        </div>
    </body>
</html>