<%--
    Document   : avh-skin.jsp (sitemesh decorator file)
    Created on : 01/09/2010, 11:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<c:set var="avhUrl" value="http://avh.ala.org.au/sp/"/>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">    
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link href="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.1" rel="schema.AGLS" />
	<meta name="DC.Title" content="Partners" lang="en" />	<meta name="DC.Function" content="Public information" />
	<meta name="DC.Description" content="Australia's Virtual Herbarium (AVH) is an online resource that provides immediate access to the wealth of plant specimen information held by Australian herbaria. AVH is a collaborative project of the state, Commonwealth and territory herbaria, developed under the auspices of the Council of Heads of Australasian Herbaria (CHAH), representing the major Australian collections." />
	<meta name="DC.Creator" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
	<meta name="DC.Publisher" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
	<meta name="DC.Type.Category" content="document" />
	<meta name="DC.Format" content="text/html" />
	<meta name="DC.Language" content="en_AU" scheme="RFC3066" />
	<meta name="DC.Coverage.Jurisdiction" content="Australian Government Departmental Consortium" />
	<meta name="DC.Coverage.PlaceName" content="Australia, world" />
	<meta name="DC.Audience" content="Botanists, horticulturalists, biologists, ecologists, environmentalists, conservationists, land managers, educators, students, historians, general public" />
	<meta name="DC.Availability" content="Freely available. Some parts of this resource are username and password restricted" />
	<meta name="DC.Rights" content="(c) Council of Heads of Australasian Herbaria, 2010" />
	<meta name="DC.Rights" content="Unless other stated, Intellectual Property associated with this resource resides with the Council of Heads of Australasian Herbaria and individual herbaria. Applications, source code and data are freely available for research, non-commercial and public good purposes" />

    <title><decorator:title default="AVH"/></title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/avh2012/favicon.ico" />
    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.request.contextPath}/static/css/avh2012/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    
    <%@ include file="commonJS.jspf" %>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <!-- CIRCLE PLAYER -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/circle.skin/circle.player.css" type="text/css" media="screen" />

    <decorator:head />
</head>

<body>
    <div class="wrapper">
        <!--Header-->
        <div id="navigation">
            <div id="nav-inside">
                <ul id="nav_start">
                    <li></li>
                </ul>
                <ul id="nav">
                    <li class="page_item page-item-1"><a href="${pageContext.request.contextPath}/" title="Home">Home</a></li>
                    <li class="page_item page-item-3"><a href="${pageContext.request.contextPath}/help/about.html" title="About AVH">About AVH</a></li>
                    <li class="page_item page-item-7"><a href="${pageContext.request.contextPath}/help/termsOfUse.html" title="Terms of use">Terms of use</a></li>
                    <li class="page_item page-item-4"><a href="${pageContext.request.contextPath}/help/help.html" title="Help">Help</a></li>
                    <li class="page_item page-item-2"><a href="${pageContext.request.contextPath}/search" title="Search">Search</a></li>
                    <li class="page_item page-item-5"><a href="http://www.rbg.vic.gov.au/avh/news/" title="News">News</a></li>
                    <!--li class="page_item page-item-6"><a href="http://www.ozcam.org.au/contact-us/" title="Links">Links</a></li-->
                </ul>
            </div>
        </div>
        <div id="header">
            <div id="feature">
                <div id="LogoBox">
                    <div id="Logo"></div>
                </div>
                <div class="rightMenu">
                    <%--<a href="http://www.ala.org.au/my-profile/"><div id='loginId'>Logged in as niels.klazenga@rbg.vic.gov.au</div></a>--%>
                        <c:set var="loginId"><ala:loggedInUserId/></c:set>
                        <a href="http://www.ala.org.au/my-profile/">${loginId}</a>
                        <c:if test="${not empty loginId}">|</c:if>
                        <c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}"/>
                        <ala:loginLogoutLink returnUrlPath="${returnUrlPath}"/>
            </div>
            </div>
        </div>
        <div id="contentBox" style="margin-top: 20px;">
            <decorator:body />
            <div class="push"></div>
        </div>
        <div class="footer">
            <div id="footer">
                <span class="footer_item_1">
                    <a href="http://ala.org.au"><img src="http://avh.ala.org.au/static/images/atlas-poweredby_rgb-lightbg.png" alt=""/></a>
                </span>
                <span class="footer_item_2">
                    AVH is an initiative of the Council of Heads of Australasian Herbaria (CHAH)
                </span>
                <span class="footer_item_3">
                    <a href="mailto:avh@chah.org.au">avh@chah.org.au</a>
                </span>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
        var pageTracker = _gat._getTracker("UA-4355440-1");
        pageTracker._initData();
        pageTracker._trackPageview();
    </script>
</body>
</html>
