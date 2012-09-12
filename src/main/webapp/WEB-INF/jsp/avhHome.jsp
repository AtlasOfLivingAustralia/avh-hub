<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0023)http://chah.gov.au/avh/ -->
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%--<script type="text/javascript" async="" src="ga.js"></script>--%>

    <title>Australia's Virtual Herbarium</title>
    <link rel="shortcut icon" href="http://chah.gov.au/avh/images/favicon.ico">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/screen.css">
    <link href="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.1" rel="schema.AGLS">
    <meta name="DC.Title" content="Home page" lang="en">
    <meta name="DC.Function" content="Public information">
    <meta name="DC.Description"
          content="Australia&#39;s Virtual Herbarium (AVH) is an online resource that provides immediate access to the wealth of plant specimen information held by Australian herbaria. AVH is a collaborative project of the state, Commonwealth and territory herbaria, developed under the auspices of the Council of Heads of Australasian Herbaria (CHAH), representing the major Australian collections.">
    <meta name="DC.Creator"
          content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria">
    <meta name="DC.Publisher"
          content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria">
    <meta name="DC.Type.Category" content="document">
    <meta name="DC.Format" content="text/html">
    <meta name="DC.Language" content="en_AU" scheme="RFC3066">
    <meta name="DC.Coverage.Jurisdiction" content="Australian Government Departmental Consortium">
    <meta name="DC.Coverage.PlaceName" content="Australia, world">
    <meta name="DC.Audience"
          content="Botanists, horticulturalists, biologists, ecologists, environmentalists, conservationists, land managers, educators, students, historians, general public">
    <meta name="DC.Availability"
          content="Freely available. Some parts of this resource are username and password restricted">
    <meta name="DC.Rights" content="(c) Council of Heads of Australasian Herbaria, 2010">
    <meta name="DC.Rights"
          content="Unless other stated, Intellectual Property associated with this resource resides with the Council of Heads of Australasian Herbaria and individual herbaria. Applications, source code and data are freely available for research, non-commercial and public good purposes">

    <script type="text/javascript" src="jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="jquery.avh.googleanalytics.js"></script>
</head>

<body>
<div id="container">

    <div id="banner">

        <div id="logo">
            <a title="Australia&#39;s Virtual Herbarium (Home)" href="http://chah.gov.au/avh/index.jsp">
                <img src="${pageContext.request.contextPath}/static/css/avh/images/AVHlogo_web.gif" alt="Australia�s Virtual Herbarium logo" height="100"
                     width="249" style="border:0px">
            </a>
        </div>
        <div id="searchBox" style="float:right;margin-top:65px;width:400px;text-align:right;display:none;">
            <form action="${pageContext.request.contextPath}/occurrences/search" id="solrSearchForm">
                <%--<span id="advancedSearchLink"><a href="${pageContext.request.contextPath}/home#advanced">Advanced Search</a></span>
                <span id="#searchLabel">Search:</span>--%>
                <input type="text" id="taxaQuery" name="taxa" value="<c:out value='${param.taxa}'/>" style="width:250px;">
                <input type="submit" id="solrSubmit" value="Search"/>
            </form>
        </div>

        <div id="mainmenu">
            <div class="rightMenu" style="display:none">
                <c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}"/>
                <ala:loginLogoutLink returnUrlPath="${returnUrlPath}"/>
            </div>
            <c:if test="${not empty clubView}">
                <div class="rightMenu" id="clubView" style="display:none"><span>Club View</span></div>
            </c:if>
            <div class="rightMenu" style="display:none">
                <a href="http://www.ala.org.au/my-profile/"><ala:loggedInUserId/></a>
            </div>
        </div>
    </div>


    <div id="main_content"><!-- This holds the page content -->

        <div id="index_bground">
            <div id="index_text">
                <div style="font-size: 16px; color: #ff0000; font-weight: bold;
                         padding-bottom: 0px;"> Please note </div>

                <div>This is a <strong>new version of AVH</strong>, which has been developed by, and is part of,
                    the <a href="http://www.ala.org.au/" target="_blank">Atlas of Living Australia</a> (ALA).
                    This new site will be formally launched later in the year. In the meantime, we are still
                    adding more content and working on a few bug fixes, but we hope that you will find it a
                    great improvement on the previous version. We welcome your feedback on the new site via
                    the 'AVH feedback' link at the bottom of the page, or at
                    <strong><a href="mailto:avh@ala.org.au" target="_blank">avh@ala.org.au</a></strong>. Please read the
                    <strong><a href="/sp/help.html">Help</a></strong> and
                    <strong><a href="/sp/avh_data.html">AVH data</a></strong> pages for more
                    information.
                </div>

            </div>
            <div id="index_menu">
                <div><a href="/search">Search</a></div>
                <div><a href="/sp/about.html">About AVH</a></div>
                <div><a href="/sp/help.html">Help</a></div>
                <div><a href="/sp/avh_data.html">AVH data</a></div>
            </div>
        </div>

    </div>
    <!-- end of page content -->

    <div id="footer">
        <div id="bottombanner">

            <div id="participants">
                <div>
                    <a href="http://www.dec.wa.gov.au/content/category/41/831/1821/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_WA.jpg"
                             alt="Western Australian Herbarium, Department of Environment and Conservation" width="80"
                             height="100">
                    </a>
                </div>
                <div>
                    <a href="http://www.nt.gov.au/nreta/wildlife/plants/herbarium/index.html">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NT.jpg" alt="NT logo" height="100" width="80">
                    </a>
                </div>
                <div>
                    <a href="http://www.environment.sa.gov.au/science/state-herbarium/overview.html">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_SA.jpg"
                             alt="State Herbarium of South Australia, Plant Biodiversity Centre" width="80"
                             height="100">
                    </a>
                </div>
                <div>
                    <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_BRI.jpg"
                             alt="Queensland Herbarium, Environmental Protection Agency" height="100" width="80">
                    </a>
                </div>
                <div>
                    <a href="http://www.rbgsyd.nsw.gov.au/science/Herbarium_and_resources">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NSW.jpg" alt="NSW logo" height="100" width="80">
                    </a>
                </div>
                <div>
                    <a href="http://www.cpbr.gov.au/cpbr/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_CPBR.jpg"
                             alt="Australian National Herbarium, Centre for Plant Biodiversity Research" height="100"
                             width="80">
                    </a>
                </div>
                <div>
                    <a href="http://www.rbg.vic.gov.au/science/information-and-resources/national-herbarium-of-victoria">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_MEL.jpg"
                             alt="National Herbarium of Victoria, Royal Botanic Gardens Melbourne"
                             height="100" width="80">
                    </a>
                </div>
                <div>
                    <a href="http://www.tmag.tas.gov.au/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_TAS.jpg" width="80" height="100"
                             alt="Tasmanian Herbarium, Tasmanian Museum and Art Gallery">
                    </a>
                </div>
                <div>
                    <a href="http://www.ath.org.au/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_ATH.jpg" alt="ATH logo" width="80" height="100">
                    </a>
                </div>
                <div>
                    <a href="http://www.environment.gov.au/biodiversity/abrs/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_ABRS.jpg" alt="Australian Biological Resources Study"
                             width="80" height="100">
                    </a>
                </div>
                <div>
                    <a href="http://www.virtualherbarium.org.nz/index.jsp">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NZVH.jpg" alt="DEH logo" width="80" height="100">
                    </a>
                </div>
            </div>
            <div class="spacer">&nbsp;</div>
        </div>
        <div id="footer_left">
            <a href="/sp/credits.html">Credits</a> |
            <a href="/sp/sponsors.html">Sponsors</a> |
            <a href="/sp/termsofuse.html">Terms of Use</a>
        </div>

        <div id="footer_right">
            <a href="mailto:avh@ala.org.au">avh@ala.org.au</a>
        </div>
    </div>

</div>
</body>
</html>