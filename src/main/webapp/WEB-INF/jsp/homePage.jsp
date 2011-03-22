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
        <title>Occurrence Search | OZCAM</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/charts.css" type="text/css" media="screen">
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/charts.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/advancedSearch.js"></script>
        <script type="text/javascript">
            
            /************************************************************\
            * Fire chart loading
            \************************************************************/
            google.load("visualization", "1", {packages:["corechart"]});
            google.setOnLoadCallback(hubChartsOnLoadCallback);

        </script>
    </head>
    <body>
        <div id="headingBar">
            <h1>Search for records in OZCAM</h1>
            <div id="solrSearchForm">
                <form action="${pageContext.request.contextPath}/occurrences/search" id="homepageSearchForm">
                    <input name="q" value="<c:out value='${param.q}'/>" id="solrQuery" style="width:720px; height:20px; font-size:12px;"/>&nbsp;
                    <input type="submit" value="Search" id="solrSubmit" style="font-size:14px;"/>
                    <input type="hidden" id="lsid" value=""/>
                    <span id="advancedSearchLink"><a href="#advanced_search">Advanced Search</a></span>
                </form>
            </div>
            <jsp:include page="advancedSearchDiv.jsp"/>
            <br/><br/>
            <jsp:include page="chartDiv.jsp"/>
        </div>
    </body>
</html>