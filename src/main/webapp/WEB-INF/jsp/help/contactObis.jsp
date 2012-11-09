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
    <h1>OBIS Australia Contacts</h1>
    <div>&nbsp;</div>
    <div class="plain">
        <P>Please address all enquiries about OBIS Australia to the Node Manager: <BR><BR>Tony Rees<BR>CSIRO Marine and
            Atmospheric Research<BR>GPO Box&nbsp;1538 <BR>Hobart Tasmania 7001, Australia <BR><BR>Telephone <BR>+61 3
            6232 5318 (international) <BR>(03) 6232 5318 (within Australia) <BR><BR>Facsimile <BR>+61 3 6232 5000
            (international) <BR>(03) 6232 5000 (within Australia) <BR><BR>Email <BR><A href="mailto:Tony.Rees@csiro.au">Tony.Rees@csiro.au</A>
        </P>
    </div>
</div>
</body>
</html> 