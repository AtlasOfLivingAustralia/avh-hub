<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="hostName" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}"/>
<c:set var="fullName"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader bundle="hubs" property="site.displayNameShort"/></c:set>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="decorator" content="${skin}"/>
    <meta name="section" content="help"/>
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Partners </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>${shortName} Contacts</h1>
    <div>&nbsp;</div>
    <div class="plain">
        Museum of New Zealand Te Papa Tongarewa<br/>
        55 Cable Street, PO Box 467<br/>
        Wellington 6011, New Zealand<br/>
        <br/>
        Phone: +64 (0) 4 381 7000<br/>
        Fax: +64 (0) 4 381 7070<br/>
        Email: <a href="mailto:mail@tepapa.govt.nz">mail@tepapa.govt.nz</a>

    </div>
</div>
</body>
</html> 