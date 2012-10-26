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
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Links </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>Links</h1>
    <h3>Floras</h3>
    <ul>
        <li><a href="http://www.environment.gov.au/biodiversity/abrs/online-resources/flora/main/">Flora of Australia</a></li>
        <li><a href="http://florabase.dec.wa.gov.au/">FloraBase – the Western Australian Flora</a></li>
        <li><a href="http://www.flora.sa.gov.au/">eFloraSA – Electronic Flora of South Australia</a></li>
        <li><a href="http://plantnet.rbgsyd.nsw.gov.au/">PlantNET – New South Wales Flora Online</a></li>
        <li><a href="http://www.tmag.tas.gov.au/FloraTasmania">Flora of Tasmania online</a></li>
    </ul>
    <h3>Checklists</h3>
    <ul>
        <li><a href="http://www.anbg.gov.au/apni/">Australian Plant Name Index (APNI)</a></li>
        <li><a href="http://www.chah.gov.au/apc/about-APC.html">Australian Plant Census (APC)</a></li>
        <li><a href="http://www.rbg.vic.gov.au/dbpages/cat/index.php/mosscatalogue">Catalogue of Australian Mosses (AusMoss)</a></li>
        <li><a href="http://www.anbg.gov.au/abrs/liverwortlist/liverworts_intro.html">Checklist of Australian Liverworts and Hornworts</a></li>
        <li><a href="http://www.rbg.vic.gov.au/dbpages/cat/index.php/fungicatalogue">Interactive Catalogue of Australian Fungi (ICAF)</a></li>
        <li><a href="http://www.anbg.gov.au/abrs/lichenlist/introduction.html">Checklist of the Lichens of Australia and its Island Territories</a></li>
        <li><a href="http://www.anbg.gov.au/amanisearch/servlet/amanisearch/">Australian Marine Name Algal Index (AMANI)</a></li>
    </ul>
    <h3>Other specimen databases</h3>
    <ul>
        <!--li><a href="http://202.27.243.4:8080/nzvh/">New Zealand's Virtual Herbarium (NZVH)</a></li-->
        <li><a href="http://www.ala.org.au/">Atlas of Living Australia (ALA)</a></li>
        <li><a href="http://data.gbif.org/welcome.htm">Global Biodiversity Information Facility (GBIF)</a></li>
        <li><a href="http://http//search.biocase.org/">BioCASE portal</a></li>
    </ul>
    <h3>Software</h3>
    <ul>
        <li><a href="http://www.biocase.org/products/provider_software/index.shtml/">BioCASe provider software</a></li>
    </ul>
</div>

</body>
</html> 