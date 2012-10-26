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
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Credits </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>Credits</h1>
    <br/>
    <h3>Home page design</h3>
    <ul>
        <li>Siobhan Duffy, Centre for Plant Biodiversity Research (CPBR), Canberra</li>
    </ul>

    <h3>Home page photos</h3>
    <ul>
        <li><i>Eucalyptus caesia</i> – Ilma Dunn, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li><i>Parallela</i> sp. – Tim Entwisle, &copy; Tim Entwisle, 2009</li>
        <li><i>Pseudocyphellaria</i> sp. – Niels Klazenga, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li><i>Oxylobium arborescens</i> – Niels Klazenga, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li><i>Marasmiellus</i> sp. – Tom May, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li><i>Banksia ericifolia</i> subsp. <i>macrantha</i> – Niels Klazenga, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li>Cool temperate rainforest – Niels Klazenga, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li>Desert storm – Geoff Lay, &copy; Geoff Lay, 2009</li>
        <li><i>Epacris obtusifolia</i> – Ilma Dunn, &copy; Royal Botanic Gardens Melbourne, 2009</li>
        <li><i>Leucobryum aduncum</i> var. <i>scalare</i> – Niels Klazenga, &copy; Royal Botanic Gardens Melbourne, 2009</li>
    </ul>
</div>
</div>
</body>
</html> 