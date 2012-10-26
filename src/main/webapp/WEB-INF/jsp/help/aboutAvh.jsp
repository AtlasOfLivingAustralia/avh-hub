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
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - About ${shortName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>About ${shortName}</h1>

    <br/>

    <p>Australia's Virtual Herbarium (AVH) is an online resource that provides dynamic access to the
        wealth of plant specimen data held by Australian herbaria. AVH is a collaborative project of the
        Commonwealth, state and territory herbaria, under the auspices of the Council of Heads of Australasian Herbaria (CHAH).</p>
    <img src="${pageContext.request.contextPath}/static/images/help/AVH_map_small.jpg" alt="map" width="532" height="405" style="margin-left: 84px;"/>
    <p>Australia's major herbaria house over six million specimens of plants, algae and fungi.
        These specimens provide a permanent record of the occurrence of a species at a particular place
        and time, and are the primary resource for research on the classification and distribution of the Australian flora.</p>

    <p>Herbarium specimens are accompanied by information on where and when they were collected, by whom,
        their current identification, and information on habitat and associated species. So far, approximately 75 per cent of the specimens housed in Australian herbaria have been databased. This data forms a valuable resource for a wide range of stakeholders, including:</p>
    <ul>
        <li>State and Commonwealth conservation agencies</li>
        <li>universities and schools</li>
        <li>the scientific community</li>
        <li>biodiversity networks and conservation groups</li>
        <li>natural resource, agriculture and forestry agencies</li>
        <li>environmental consultants</li>
        <li>Australian and international herbaria and botanic gardens.</li>
    </ul>

    <p>The combined specimen data from each herbarium's collection provides the most complete picture of the
        distribution of Australia's flora to date. Data obtained via the AVH can be used for many different purposes, including:</p>
    <ul>
        <li>mapping plant, algae and fungi distributions</li>
        <li>planning revegetation work</li>
        <li>tracking the distribution of invasive species</li>
        <li>bioprospecting</li>
        <li>conservation planning</li>
        <li>prioritising resources for plant collecting and biodiversity surveys</li>
        <li>historical research.</li>
    </ul>

    <p>AVH is a dynamic resource. New specimen records are added as herbaria continue to database their ever-growing
        collections, and existing records are updated to reflect name changes and data validation work.</p>

    <div class="gototop"><a href="#top">[Go to top]</a></div></div>

</div>

</body>
</html> 