<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="fullName"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader bundle="hubs" property="site.displayNameShort"/></c:set>
<!DOCTYPE HTML>

<html dir="ltr" lang="en-US">
<head>
    <title>Welcome to OBIS Australia</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/amrin.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/buttons.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/obis/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />

    <script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/html5.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min-1.7.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bieAutocomplete.js"></script>

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
    <div class="inner">
        <ul id="nav-site">
            <li class="selected"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/search">Search</a></li>
            <li><a href="${pageContext.request.contextPath}/occurrences/search">Records</a></li>
        </ul>
        <ul id="nav-user">
            <li><a href="http://www.ala.org.au/my-profile/" title="My profile">My profile</a></li>
            <li class="last"><a href="https://auth.ala.org.au/cas/login?service=http://www.ala.org.au/wp-login.php?redirect_to=http://www.ala.org.au/my-profile/">Log in</a></li>
        </ul>
    </div>
</nav>
<header id="site-header">
    <div class="inner">
        <h1 title="${shortName}"><a href=""><img src="${pageContext.request.contextPath}/static/images/obis/logo.png"  /></a></h1>
        <section>
            <div id="search">
                <form name="siteSearchForm" id="siteSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                    <label for="search">Quick search</label>
                    <input id="taxaQuery" title="Search" type="text" name="taxa" placeholder="Quick search" class="name_autocomplete freetext" /><button value="Search" type="submit">Search</button>
                </form>
            </div>
            <p><strong>More options</strong>: <a href="${pageContext.request.contextPath}/search#advancedSearch">Advanced search</a>, <a href="${pageContext.request.contextPath}/search#taxaUpload">Batch name search</a>, <a href="${pageContext.request.contextPath}/search#catalogUpload">Batch catalogue no. search</a>, <a href="${pageContext.request.contextPath}/search#shapeFileUpload">Shapefile search</a></p>
        </section>
    </div>
</header>
<div class="inner two-col">
    <section>
        <h2>Welcome to ${shortName}</h2>
        <p>The Ocean Biogeographic Information System (OBIS) is an international&nbsp;federation of organisations and people&nbsp;sharing a vision to
            make marine biogeographic data, from all over the world, freely available over the internet. It functions as a web-based provider of
            global geo-referenced information on marine species. It provides a single entry point to query expert databases on species and habitats
            and provides a variety of tools for visualising relationships&nbsp;between marine species and their environment. OBIS is also the information
            component of the <span class="link-external"><span class="link-external"><a href="http://www.coml.org/">Census of Marine Life
            Program</a></span>.</span></p>
    </section>
    <section class="last gallery">
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
    </section>
</div>
<footer>
    <div class="inner">
        <section class="copyright">
            <div class="img-left"><a href="http://creativecommons.org/licenses/by/3.0/au/" title="External link to Creative Commons"><img src="http://www.ala.org.au/wp-content/themes/ala2011/images/creativecommons.png" width="88" height="31" alt="" /></a></div><p><a href="" title="Terms of Use">Terms of Use</a> | <a href="">Contact</a><br />This site is licensed under a <a href="http://creativecommons.org/licenses/by/3.0/au/" title="External link to Creative Commons" class="external">Creative Commons Attribution 3.0 Australia License</a>.</p><div class="img-right"><a href="http://www.ala.org.au" title="Atlas of Living Australia"><img src="http://www.ala.org.au/wp-content/themes/ala2011/images/poweredby-ala.png" width="178" height="62" alt="" /></a></div>
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