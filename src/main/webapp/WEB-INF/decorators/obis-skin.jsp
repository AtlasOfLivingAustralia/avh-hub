<%--
    Document   : amrin-skin.jsp (sitemesh decorator file)
    Created on : 11/10/2012, 11:20
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<c:set var="fullName"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayNameShort"/></c:set>
<c:set var="section"><decorator:getProperty property="meta.section"/></c:set>
<c:set var="serverName" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="serverName" checkInit="true"/></c:set>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">    
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title><decorator:title default="${shortName}"/></title>
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

    <%@ include file="commonJS.jspf" %>

    <script src="${pageContext.request.contextPath}/static/js/bootstrap.js"></script>
    <!--[if lt IE 9]>
    <script type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/html5.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/respond.min.js"></script>
    <![endif]-->

    <decorator:head />
</head>
<body>
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
    <header id="site-header">
        <div class="container">
            <h1 title="${fullName}"><a href=""><img src="${pageContext.request.contextPath}/static/images/obis/logo-small.png" /></a></h1>
            <section>
                <div id="search">
                    <form name="siteSearchForm" id="siteSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                        <label for="search">Quick search</label>
                        <input id="taxaQuery" title="Search" type="text" name="taxa" placeholder="Quick search" class="ac_input freetext" value="<c:out value='${param.taxa}'/>" /><button value="Search" type="submit">Search</button>
                    </form>
                </div>
                <p><strong>More options</strong>: <a href="${pageContext.request.contextPath}/search#advancedSearch">Advanced search</a>,
                    <a href="${pageContext.request.contextPath}/search#taxaUpload">Batch taxon search</a>,
                    <a href="${pageContext.request.contextPath}/search#catalogUpload">Batch catalogue no. search</a>,
                    <a href="${pageContext.request.contextPath}/search#shapeFileUpload">Shapefile search</a></p>
            </section>
        </div>
    </header>
    <div id="content">
        <section class="container">
            <decorator:body />
        </section>
    </div><!-- end div#inner -->
    <footer class="">
        <div class="container">
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
