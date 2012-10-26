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
    <h1 id="${shortName}_data">Partners</h1>
    <div>&nbsp;</div>
    <div class="row">
        <div class="column col1"><img alt="Western Australian Herbarium, Department of Environment and Conservation" src="${pageContext.request.contextPath}/static/images/help/logos_WA.jpg" height="40" width="40"/></div>
        <div class="column col2">The <a href="http://www.dec.wa.gov.au/content/category/41/831/1821/"><b>Western Australian Herbarium</b></a> (PERTH), <a href="http://www.dec.wa.gov.au/">Department of
            Environment and Conservation</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="Herbarium of the Northern Territory
				Parks &amp; Wildlife Commission NT" src="${pageContext.request.contextPath}/static/images/help/logos_NT.jpg" height="43" width="45"/>
        </div>
        <div class="column col2">The <a href="http://www.nretas.nt.gov.au/plants-and-animals/plants_herbarium"><b>Northern Territory Herbarium</b></a>, in Darwin (DNA)
            and Alice Springs (NT), <a href="http://www.nt.gov.au/nreta/">Northern Territory Department
                of Natural Resources, Environment, the Arts and Sport</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="State Herbarium of South Australia
				Plant Biodiversity Centre" src="${pageContext.request.contextPath}/static/images/help/logos_SA.jpg" height="52" width="62"/>
        </div>
        <div class="column col2">The <a href="http://www.environment.sa.gov.au/Knowledge_Bank/Science_research/State_Herbarium"><b>State Herbarium of South Australia</b></a> (AD), <a href="http://www.environment.sa.gov.au/">Department for Environment and Heritage</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="Queensland Herbarium
				Environmental Protection Agency" src="${pageContext.request.contextPath}/static/images/help/logos_BRI.jpg" height="43" width="47"/>
        </div>
        <div class="column col2">
            The <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/"><b>Queensland Herbarium</b></a> (BRI), <a href="http://www.epa.qld.gov.au/">Department of Environment and Resource Management</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="National Herbarium of New South Wales Royal Botanic Gardens Sydney" src="${pageContext.request.contextPath}/static/images/help/logos_NSW.jpg" height="43" width="41"/>
        </div>
        <div class="column col2">
            The <a href="http://www.rbgsyd.nsw.gov.au/science/Herbarium_and_resources"><b>National Herbarium of New South Wales</b></a> (NSW), <a href="http://www.rbgsyd.nsw.gov.au/">Botanic Gardens Trust</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="Australian National Herbarium Centre for Plant Biodiversity Research" src="${pageContext.request.contextPath}/static/images/help/logos_CPBR.jpg" height="43" width="43"/>
        </div>
        <div class="column col2">The <a href="http://www.cpbr.gov.au/cpbr/program/hc/index.html"><b>Australian National Herbarium</b></a> (CANB), <a href="http://www.cpbr.gov.au/cpbr">Centre for
            Plant Biodiversity Research</a>, <a href="http://www.pi.csiro.au/">CSIRO
            Plant Industry</a> and the <a href="http://www.anbg.gov.au/anbg/">Australian National Botanic Gardens</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="National Herbarium of Victoria
				Royal Botanic Gardens Melbourne" src="${pageContext.request.contextPath}/static/images/help/logos_MEL.jpg" height="43" width="37"/>
        </div>
        <div class="column col2">
            The <a href="http://www.rbg.vic.gov.au/science/information-and-resources/national-herbarium-of-victoria"><b>National Herbarium of Victoria</b></a> (MEL),
            <a href="http://www.rbg.vic.gov.au/">Royal Botanic Gardens Melbourne</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="Tasmanian Herbarium
				Tasmanian Museum and Art Gallery" src="${pageContext.request.contextPath}/static/images/help/logos_TAS.jpg" height="43" width="50"/>
        </div>
        <div class="column col2">
            The <a href="http://www.tmag.tas.gov.au/collections_and_research/tasmanian_herbarium2"><b>Tasmanian Herbarium</b></a> (HO), <a href="http://www.tmag.tas.gov.au/">Tasmanian Museum and Art Gallery</a>,
            <a href="http://www.development.tas.gov.au/">Department of Economic Development, Tourism and the Arts</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1">
            <img alt="Australian Tropical Herbarium" src="${pageContext.request.contextPath}/static/images/help/logos_ATH.jpg" height="50" width="62"/>
        </div>
        <div class="column col2">
            The <a href="http://www.ath.org.au/"><b>Australian Tropical Herbarium (CNS)</b></a>, a joint venture
            of <a href="http://www.pi.csiro.au/">CSIRO Plant Industry</a> and the
            <a href="http://www.environment.gov.au/parks/dnp.html">Director National Parks</a> (through the
            <a href="http://www.cpbr.gov.au/cpbr/">Australian National Herbarium</a>), the Queensland Government
            (through the <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/index.html">Queensland Herbarium</a> and the
            <a href="http://www.deedi.qld.gov.au/">Department of Employment, Economic Development and Innovation</a>)
            and <a href="http://www.jcu.edu.au/">James Cook University</a>
        </div>
    </div>
    <div class="row">
        <div class="column col1"><img alt="New Zealand Virtual Herbarium" src="${pageContext.request.contextPath}/static/images/help/logo_NZVH.jpg" height="43" width="35"/></div>
        <div class="column col2">The <a href="http://www.virtualherbarium.org.nz/home"><b>New Zealand Virtual Herbarium</b></a> (NZVH)
        </div>
    </div>
    <div class="row">
        <div class="column col1"><img alt="Australian Biological Resources Study" src="${pageContext.request.contextPath}/static/images/help/logos_ABRS.jpg" height="43" width="35"/></div>
        <div class="column col2">The <a href="http://www.environment.gov.au/biodiversity/abrs/"><b>Australian Biological
            Resources Study</b></a> (ABRS), Department of the Environment, Water, Heritage and the Arts
        </div>
    </div>
    <div class="row">
        <div class="column col1"><img src="${pageContext.request.contextPath}/static/images/help/logo_AUST-GOV.jpg" alt="augov" height="36" width="50"/></div>
        <div class="column col2">The Australian Government <a href="http://www.environment.gov.au/"><b>Department of the Environment, Water, Heritage and the Arts</b></a></div>
    </div>
</div>
</body>
</html> 