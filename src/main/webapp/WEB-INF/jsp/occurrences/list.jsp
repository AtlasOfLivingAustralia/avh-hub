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
        <title>OzCam Hub Prototype</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <ul>
            <c:forEach var="item" items="${items}">
                <li>${item}</li>
            </c:forEach>
        </ul>
        <c:if test="${not empty bean}">
          <h4>Bean detected with query:</h4>
          <p><code style="font-size: 12px;">${bean}</code></p>
        </c:if>
    </body>
</html>
