<%--
    Document   : pageNotFound
    Created on : Apr 7, 2010, 12:26:36 PM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<% response.setStatus( 500 ); %>
<%@ include file="/common/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="<ala:propertyLoader bundle="hubs" property="sitemesh.skin"/>"/>
        <title>Field Guide GenerationError</title>
    </head>
    <body>
        <div id="column-one" class="full-width">
            <div class="section">
                <h1>There was a problem generating the field guide...</h1>
                <p>An unexpected error has occurred. If this error persists, you might like to let us
                    know <a href="mailto:webmaster@ala.org.au?subject=${pageContext.request.serverName} Error">via email</a>.</p>
                <br/>
            </div>
        </div>
    </body>
</html>
