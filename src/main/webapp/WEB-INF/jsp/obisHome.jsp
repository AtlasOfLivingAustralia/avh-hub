<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="fullName"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayNameShort"/></c:set>
<!DOCTYPE HTML>

<html dir="ltr" lang="en-US">
<head>
    <title>Welcome to OBIS Australia</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
    <link id="responsiveCss" rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/bootstrap-responsive.css">
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/amrin.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/buttons.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/obis/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/bootstrapAdditions.css" type="text/css" media="screen,projection" />


    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min-1.7.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bieAutocomplete.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.js"></script>
    <!--[if lt IE 9]>
    <script type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/html5.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/respond.min.js"></script>
    <![endif]-->

    <!-- Start vslider -->
    <script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/s3slider.js"></script>
    <script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/vslider.js"></script>
    <script type="text/javascript">
        /*** vslider Init ***/
        jQuery.noConflict();
        jQuery(document).ready(function(){
            jQuery('ul#sliderbody').innerfade({
                animationtype: 'fade',
                speed: 1000,
                timeout: 4000,
                type: 'sequence'
            });
        });
    </script>
    <!-- End vslider -->

</head>

<body class="home">

<nav>
    <div class="container">
        <ul id="nav-site">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="${(section=='search')?'selected':''}"><a href="${pageContext.request.contextPath}/search">Search</a></li>
            <li class="${(section!='search' && section!='yourArea')?'selected':''}"><a href="${pageContext.request.contextPath}/occurrences/search">Records</a></li>
            <li class="${(section=='yourArea')?'selected':''}"><a href="${pageContext.request.contextPath}/explore/your-area">Your Area</a></li>
        </ul>
        <ul id="nav-user">
            <li><a href="http://www.ala.org.au/my-profile/" title="My profile">My profile</a></li>
            <c:set var="returnUrlPath" value="${serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}"/>
            <li class="last"><ala:loginLogoutLink returnUrlPath="${returnUrlPath}"/></li>
        </ul>
    </div>
</nav>
<header id="site-header" class="">
    <div class="container">
        <div class="row-fluid">
            <div class="span3">
                <h1 title="${shortName}"><a href=""><img src="${pageContext.request.contextPath}/static/images/obis/logo.png"  /></a></h1>
            </div>
            <div class="span9" style="margin-top: 30px;">
                <div id="search" class="">
                    <form name="siteSearchForm" id="siteSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                        <label for="search">Quick search</label>
                        <input id="taxaQuery" title="Search" type="text" name="taxa" placeholder="Quick search" class="name_autocomplete freetext" /><button value="Search" type="submit">Search</button>
                    </form>
                </div>
                <p><strong>More options</strong>: <a href="${pageContext.request.contextPath}/search#advancedSearch">Advanced search</a>, <a href="${pageContext.request.contextPath}/search#taxaUpload">Batch name search</a>, <a href="${pageContext.request.contextPath}/search#catalogUpload">Batch catalogue no. search</a>, <a href="${pageContext.request.contextPath}/search#shapeFileUpload">Shapefile search</a></p>
            </div>
        </div>
    </div>
</header>
<div class="inner two-col" class="">
    <div class="container">
        <div class="row-fluid">
            <div class="span7">
                <h2 style="padding-top: 10px;">Welcome to ${shortName}</h2>
                <p>The Ocean Biogeographic Information System (OBIS) is an international&nbsp;federation of organisations and people&nbsp;sharing a vision to
                    make marine biogeographic data, from all over the world, freely available over the internet. It functions as a web-based provider of
                    global geo-referenced information on marine species. It provides a single entry point to query expert databases on species and habitats
                    and provides a variety of tools for visualising relationships&nbsp;between marine species and their environment. OBIS is also the information
                    component of the <span class="link-external"><span class="link-external"><a href="http://www.coml.org/">Census of Marine Life
                        Program</a></span>.</span></p>
                <p><span class="link-external"></span><a href="http://www.obis.org.au/aboutUs/index.html">OBIS Australia</a> seeks to advance the
                    goals of OBIS in the <a href="http://www.obis.org.au/faq/index.html#4">Australian region</a>, as one of a growing network of
                    Regional OBIS Nodes. Specifically, the aims of OBIS Australia are:</p>
                <ul style="margin-left: 15px;">
                    <li>to encourage the <a href="${pageContext.request.contextPath}/help/contributing"><strong>sharing</strong></a> of marine species data from the Australian region into the OBIS international data network</li>
                    <li>to enable users to <a href="${pageContext.request.contextPath}/search"><strong>search</strong></a> for marine data from the international OBIS network users. </li>
                </ul>
                <p>From <a href="${pageContext.request.contextPath}/help/faq">here</a> you can&nbsp;find out more information about OBIS Australia and the OBIS program in
                    general. Please use the links in the navigation panel to the left to access these functions and the other parts of the OBIS Australia site. </p>
            </div>
            <div class="span5 last gallery" style="top: -50px;">
                <ul id="sliderbody">
                    <li class="pic-1"><img src="${pageContext.request.contextPath}/static/images/obis/crust-1.jpg" alt="crust"å /></li>
                    <li class="pic-2"><img src="${pageContext.request.contextPath}/static/images/obis/echino-1.jpg" alt="echino" /></li>
                    <li class="pic-3"><img src="${pageContext.request.contextPath}/static/images/obis/fish-1.jpg" alt="fish" /></li>
                    <li class="pic-4"><img src="${pageContext.request.contextPath}/static/images/obis/fish-2.jpg" alt="fish" /></li>
                    <li class="pic-5"><img src="${pageContext.request.contextPath}/static/images/obis/fish-3.jpg" alt="fish" /></li>
                    <li class="pic-6"><img src="${pageContext.request.contextPath}/static/images/obis/holo-1.jpg" alt="holo" /></li>
                    <li class="pic-7"><img src="${pageContext.request.contextPath}/static/images/obis/holo-2.jpg" alt="holo" /></li>
                    <li class="pic-8"><img src="${pageContext.request.contextPath}/static/images/obis/pycno-1.jpg" alt="pycno" /></li>
                   </ul>
            </div>

        </div>
    </div>
</div>
<footer class="">
    <div class="container" style="border: none;">
        <section class="copyright">
            <div class="img-left"><a href="http://creativecommons.org/licenses/by/3.0/au/"
                                     title="External link to Creative Commons"><img
                    src="http://www.ala.org.au/wp-content/themes/ala2011/images/creativecommons.png" width="88"
                    height="31" alt=""/></a></div>
            <p><a href="${pageContext.request.contextPath}/help/termsOfUse" title="Terms of Use">Terms of Use</a> |
                <a href="${pageContext.request.contextPath}/help/contactObis">Contact</a><br/>This site is licensed
                under a <a href="http://creativecommons.org/licenses/by/3.0/au/"
                           title="External link to Creative Commons" class="external">Creative Commons Attribution
                    3.0 Australia License</a>.</p>

            <div class="img-right"><a href="http://www.ala.org.au" title="Atlas of Living Australia"><img
                    src="http://www.ala.org.au/wp-content/themes/ala2011/images/poweredby-ala.png" width="178"
                    height="62" alt=""/></a></div>
        </section>
    </div>
</footer>
<%--<script type="text/javascript">--%>
    <%--var uvOptions = {};--%>
    <%--(function() {--%>
        <%--var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;--%>
        <%--uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/5XG4VblqrwiubphT3ktPQ.js';--%>
        <%--var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);--%>
    <%--})();--%>
<%--</script>--%>
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