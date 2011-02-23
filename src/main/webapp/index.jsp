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
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.metadata.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/getQueryParam.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ibutton.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/search.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/densityMap.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/jquery.ibutton.css" type="text/css" media="all" />
    </head>
    <body>
        <div id="headingBar">
            <h1>Search for records in OZCAM</h1>
            <form action="${pageContext.request.contextPath}/occurrences/search">
                <input name="q" value="Victoria" style="width:600px; height:20px; font-size:16px;"/><br/>
                <input type="submit" value="Submit" />
            </form>
        </div>
    </body>
</html>