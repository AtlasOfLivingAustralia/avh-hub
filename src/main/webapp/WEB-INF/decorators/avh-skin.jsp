<%--
    Document   : avh-skin.jsp (sitemesh decorator file)
    Created on : 01/09/2010, 11:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<c:set var="avhUrl" value="http://avh-demo.ala.org.au/sp/"/>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
    <head><title><decorator:title default="AVH"/></title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/avh/favicon.ico" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/reset.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/screen.css" />
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
<!--	<script type="text/javascript" src="/avh/js/jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="/avh/js/jquery.avh.googleanalytics.js"></script>-->
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <script type="text/javascript">
        contextPath = "${pageContext.request.contextPath}";
    </script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-1.5.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ba-hashchange.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bieAutocomplete.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <decorator:head />
</head>

<body>
<div id="container">
	<div id="banner">
		<div id="logo">
			<a title="Australia's Virtual Herbarium (Home)" href="index.jsp">
				<img src="${pageContext.request.contextPath}/static/css/avh/images/AVHlogo_web.gif" alt="Australia&rsquo;s Virtual Herbarium logo" height="100" width="249" style="border:0px" />
			</a>
		</div>
        <div id="header">
<!--        <h1>
            Partners<br />
        </h1>-->
    </div>
    	<div id="mainmenu">
            <div><a href="${pageContext.request.contextPath}/">Home</a></div>
            <div><a href="${pageContext.request.contextPath}/query">Query AVH</a></div>
            <div><a href="${avhUrl}about.html">About AVH</a></div>
            <div><a href="${avhUrl}partners.html">Partners</a></div>
            <div><a href="${avhUrl}help.html">Help</a></div>
            <div><a href="${avhUrl}links.html">Links</a></div>
            <div class="float_right">
                <c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}"/>
                <c:choose>
                    <c:when test="${not empty userDisplayName}">
                        <a href="https://auth.ala.org.au/cas/logout?url=${returnUrlPath}">
                            Logged in as: ${userDisplayName} - log out
                        </a>
                    </c:when>
                   <c:otherwise>
                       <a href="https://auth.ala.org.au/cas/login?service=${returnUrlPath}">Login/Register</a>
                   </c:otherwise>
                </c:choose>
             </div>
        </div>
    </div>
	<div id="main_content" class="">
        <decorator:body />
    </div>
    <div id="footer">
        <div id="bottombanner">
            <div id="participants">
                <div>
                    <a href="http://www.dec.wa.gov.au/content/category/41/831/1821/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_WA.jpg" alt="Western Australian Herbarium, Department of Environment and Conservation" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.nt.gov.au/nreta/wildlife/plants/herbarium/index.html">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NT.jpg" alt="NT logo" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.environment.sa.gov.au/science/state-herbarium/overview.html">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_SA.jpg" alt="State Herbarium of South Australia, Plant Biodiversity Centre" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_BRI.jpg" alt="Queensland Herbarium, Environmental Protection Agency" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.rbgsyd.nsw.gov.au/science/Herbarium_and_resources">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NSW.jpg" alt="NSW logo" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.cpbr.gov.au/cpbr/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_CPBR.jpg" alt="Australian National Herbarium, Centre for Plant Biodiversity Research" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.rbg.vic.gov.au/science/information-and-resources/national-herbarium-of-victoria">
                        <img alt="National Herbarium of Victoria, Royal Botanic Gardens Melbourne"  src="${pageContext.request.contextPath}/static/css/avh/images/logo_MEL.jpg" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.tmag.tas.gov.au/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_TAS.jpg" width="80" height="100" alt="Tasmanian Herbarium, Tasmanian Museum and Art Gallery" />
                    </a>
                </div>
                <div>
                    <a href="http://www.ath.org.au/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_ATH.jpg" alt="ATH logo" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.environment.gov.au/biodiversity/abrs/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_ABRS.jpg" alt="Australian Biological Resources Study" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.virtualherbarium.org.nz/index.jsp">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NZVH.jpg" alt="DEH logo" width="80" height="100" />
                    </a>
                </div>
            </div>
            <div class="spacer">&nbsp;</div>
        </div>
        <div id="footer_left">
            <a href="${avhUrl}copyright.jsp">Copyright</a> |
            <a href="${avhUrl}disclaimer.jsp">Disclaimer</a> |
            <a href="${avhUrl}privacy.jsp">Privacy statement</a>
        </div>
        <div id="footer_right">Updated 17 December 2010 |
           <a href="mailto:webmaster@chah.gov.au">webmaster@chah.gov.au</a>
        </div>
    </div>
</div>
</body>
</html>
