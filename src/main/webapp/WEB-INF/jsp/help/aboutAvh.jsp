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

    <p>&nbsp;</p>
	
    <h1>Partners</h1>
    <div id="partners">
        <div class="row">
                <div class="column col1"><img alt="Western Australian Herbarium, Department of Environment and Conservation" src="${pageContext.request.contextPath}/static/images/avh2012/logo_PERTH.jpg"/></div>
                <div class="column col2">The <a href="http://www.dec.wa.gov.au/our-environment/science-and-research/wa-herbarium.html"><b>Western Australian Herbarium</b></a> (PERTH), <a href="http://www.dec.wa.gov.au/">Department of Environment and Conservation</a></div>
        </div>
        <div class="row">
                <div class="column col1"><img alt="Herbarium of the Northern Territory Parks &amp; Wildlife Commission NT" src="${pageContext.request.contextPath}/static/images/avh2012/logo_DNA.jpg"/></div>
                <div class="column col2">The <a href="http://lrm.nt.gov.au/herbarium#.UJb3jLLib1A"><b>Northern Territory Herbarium</b></a>, in Darwin (DNA) and Alice Springs (NT), <a href="http://lrm.nt.gov.au/">Department of Land Resource Management</a></div>
        </div>
        <div class="row">
                <div class="column col1">
                        <img alt="State Herbarium of South Australia Plant Biodiversity Centre" src="${pageContext.request.contextPath}/static/images/avh2012/logo_AD.jpg"/>
                </div>
                <div class="column col2">The <a href="http://www.environment.sa.gov.au/Knowledge_Bank/Science_research/State_Herbarium"><b>State Herbarium of South Australia</b></a> (AD), <a href="http://www.environment.sa.gov.au/">Department of Environment, Water and Natural Resources</a></div>
        </div>
        <div class="row">
        <div class="column col1">
                <img alt="Queensland Herbarium Environmental Protection Agency" src="${pageContext.request.contextPath}/static/images/avh2012/logo_BRI.jpg"/>
        </div>
        <div class="column col2">The <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/"><b>Queensland Herbarium</b></a> (BRI), <a href="http://www.qld.gov.au/dsitia/">Department of Science, Information Technology, Innovation and the Arts (DSITIA)</a></div>
        </div>
        <div class="row">
                <div class="column col1">
                        <img alt="National Herbarium of New South Wales Royal Botanic Gardens Sydney" src="${pageContext.request.contextPath}/static/images/avh2012/logo_NSW.jpg"/>
                </div>
                <div class="column col2">The <a href="http://www.rbgsyd.nsw.gov.au/science/Herbarium_and_resources"><b>National Herbarium of New South Wales</b></a> (NSW), <a href="http://www.rbgsyd.nsw.gov.au/">Botanic Gardens Trust</a></div>
        </div>
        <div class="row">
                <div class="column col1">
                        <img alt="Australian National Herbarium Centre for Plant Biodiversity Research" src="${pageContext.request.contextPath}/static/images/avh2012/logo_CANB.jpg"/>
                </div>
                <div class="column col2">The <a href="http://www.cpbr.gov.au/cpbr/program/hc/index.html"><b>Australian National Herbarium</b></a> (CANB), <a href="http://www.cpbr.gov.au/cpbr">Centre for Plant Biodiversity Research</a>, <a href="http://www.csiro.au/pi/">CSIRO Plant Industry</a> and the <a href="http://www.anbg.gov.au/anbg/">Australian National Botanic Gardens</a></div>
        </div>
        <div class="row">
                <div class="column col1">
                        <img alt="National Herbarium of Victoria Royal Botanic Gardens Melbourne" src="${pageContext.request.contextPath}/static/images/avh2012/logo_MEL.jpg"/>
                </div>
                <div class="column col2">The <a href="http://www.rbg.vic.gov.au/science/information-and-resources/national-herbarium-of-victoria"><b>National Herbarium of Victoria</b></a> (MEL), <a href="http://www.rbg.vic.gov.au/">Royal Botanic Gardens Melbourne</a></div>
        </div>
        <div class="row">
                <div class="column col1">
                        <img alt="Tasmanian Herbarium Tasmanian Museum and Art Gallery" src="${pageContext.request.contextPath}/static/images/avh2012/logo_HO.jpg"/>
                </div>
                <div class="column col2">The <a href="http://www.tmag.tas.gov.au/collections_and_research/tasmanian_herbarium2"><b>Tasmanian Herbarium</b></a> (HO), <a href="http://www.tmag.tas.gov.au/">Tasmanian Museum and Art Gallery</a>,<br />
                        <a href="http://www.development.tas.gov.au/">Department of Economic Development, Tourism and the Arts</a></div>
        </div>
        <div class="row">
                <div class="column col1">
                        <img alt="Australian Tropical Herbarium" src="${pageContext.request.contextPath}/static/images/avh2012/logo_ATH.jpg"/>
                </div>
                <div class="column col2">The <a href="http://www.ath.org.au/"><b>Australian Tropical Herbarium (CNS)</b></a>, a joint venture of <a href="http://www.csiro.au/pi/">CSIRO Plant Industry</a> and the <a href="http://www.environment.gov.au/parks/dnp.html">Director National Parks</a> (through the <a href="http://www.cpbr.gov.au/cpbr/herbarium/">Australian National Herbarium</a>), the Queensland Government (through the <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/index.html">Queensland Herbarium</a> and the <a href="http://www.qld.gov.au/dsitia/">Department of Science, Information Technology, Innovation and the Arts (DSITIA)</a>) and <a href="http://www.jcu.edu.au/">James Cook University</a></div>
        </div>
        <div class="row">
                <div class="column col1"><img alt="New Zealand Virtual Herbarium" src="${pageContext.request.contextPath}/static/images/avh2012/logo_NZVH.jpg"/></div>
                <div class="column col2">The <a href="http://www.virtualherbarium.org.nz/home"><b>New Zealand Virtual Herbarium</b></a> (NZVH)</div>
        </div>
        <div class="row">
                <div class="column col1"><img alt="Australian Biological Resources Study" src="${pageContext.request.contextPath}/static/images/avh2012/logo_ABRS.jpg"/></div>
                <div class="column col2">The <a href="http://www.environment.gov.au/biodiversity/abrs/"><b>Australian Biological Resources Study</b></a> (ABRS), Department of the Environment, Water, Heritage and the Arts</div>
        </div>
    </div>
</div>

</body>
</html> 