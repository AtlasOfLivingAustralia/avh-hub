<%--
    Document   : amrin-skin.jsp (sitemesh decorator file)
    Created on : 11/10/2012, 11:20
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<c:set var="fullName"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader bundle="hubs" property="site.displayNameShort"/></c:set>
<c:set var="section"><decorator:getProperty property="meta.section"/></c:set>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">    
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title><decorator:title default="${shortName}"/></title>

    <%--<link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/amrin.css" type="text/css" media="screen,projection" />--%>
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/buttons.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tepapa/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/tepapa/favicon.ico" />
    <%@ include file="commonJS.jspf" %>
    <decorator:head />
</head>
<body>
    <nav>
        <div class="inner">
            <ul id="nav-site">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="${(section=='about')?'selected':''}"><a href="${pageContext.request.contextPath}/help/about.html">About</a></li>
                <li class="${(section=='termsofuse')?'selected':''}"><a href="${pageContext.request.contextPath}/help/termsofuse.html">Terms of use</a></li>
                <li class="${(section=='help')?'selected':''}"><a href="${pageContext.request.contextPath}/help/help.html">Help</a></li>
                <li class="${(section=='search')?'selected':''}""><a href="${pageContext.request.contextPath}/search">Search</a></li>
                <li class="${(section=='news')?'selected':''}"><a href="${pageContext.request.contextPath}/help/news.html">News</a></li>
            </ul>
            <ul id="nav-user">
                <li><a href="http://www.ala.org.au/my-profile/" title="My profile">My profile</a></li>
                <c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}"/>
                <li class="last"><ala:loginLogoutLink returnUrlPath="${returnUrlPath}"/></li>
            </ul>
        </div>
    </nav>
    <header id="site-header">
        <div class="inner">
            <h1 title="${fullName}"><a href="${pageContext.request.contextPath}/">LIVING AOTEAROA</a></h1>
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
    <div class="inner">
        <section>
            <decorator:body />
        </section>
    </div><!-- end div#inner -->
    <footer>
        <div class="inner">
            <section class="copyright">
                <div class="img-left"><a href="http://creativecommons.org/licenses/by/3.0/nz/"
                                         title="External link to Creative Commons"><img
                        src="http://www.ala.org.au/wp-content/themes/ala2011/images/creativecommons.png" width="88"
                        height="31" alt=""/></a></div>
                <p><a href="${pageContext.request.contextPath}/help/termsOfUse" title="Terms of Use">Terms of Use</a> |
                    <a href="${pageContext.request.contextPath}/help/contactTepapa">Contact</a>
                    <br/>This site is licensed
                    under a <a href="http://creativecommons.org/licenses/by/3.0/nz/"
                               title="External link to Creative Commons" class="external">Creative Commons Attribution
                        3.0 New Zealand License</a>.</p>

                <div class="img-right">
                    <a href="http://www.tepapa.govt.nz/" title="Museum of New Zealand Te Papa Tongarewa"><img
                            src="${pageContext.request.contextPath}/static/images/tepapa/tepapa-logo.png" alt="logo"/></a>
                    <a href="http://www.ala.org.au" title="Atlas of Living Australia"><img
                        src="http://www.ala.org.au/wp-content/themes/ala2011/images/poweredby-ala.png" width="178"
                        height="62" alt=""/></a>
                </div>
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
