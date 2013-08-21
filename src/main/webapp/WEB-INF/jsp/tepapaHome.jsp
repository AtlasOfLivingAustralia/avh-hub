<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="fullName"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayNameShort"/></c:set>
<!DOCTYPE HTML>

<html dir="ltr" lang="en-US">
<head>
    <title>Welcome to ${fullName}</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/tepapa/favicon.ico" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/buttons.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tepapa/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />

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
                timeout: 5000,
                type: 'sequence'
            });

            jQuery('#explore-here').click(function(el){
                window.location = jQuery(this).data('link');
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
            <li><a href="${pageContext.request.contextPath}/help/about.html">About</a></li>
            <li><a href="${pageContext.request.contextPath}/help/termsofuse.html">Terms of use</a></li>
            <li><a href="${pageContext.request.contextPath}/help/help.html">Help</a></li>
            <li class="${(section=='search')?'selected':''}"><a href="${pageContext.request.contextPath}/search">Search</a></li>
            <li><a href="${pageContext.request.contextPath}/help/news.html">News</a></li>
        </ul>
        <ul id="nav-user" style="display: none;">
            <li><a href="http://www.ala.org.au/my-profile/" title="My profile">My profile</a></li>
            <li class="last"><a href="https://auth.ala.org.au/cas/login?service=http://www.ala.org.au/wp-login.php?redirect_to=http://www.ala.org.au/my-profile/">Log in</a></li>
        </ul>
    </div>
</nav>
<header id="site-header">
    <div class="inner">
        <%--<h1 title="${shortName}"><a href=""><img src="${pageContext.request.contextPath}/static/images/obis/logo.png"  /></a></h1>--%>
        <section>
            <h1>LIVING AOTEAROA</h1>
            <h2>Demonstration site</h2>
            <button class="ac_input freetext" id="explore-here" data-link="${pageContext.request.contextPath}/search">EXPLORE HERE</button>
        </section>
    </div>
</header>
<div class="inner two-col">
    <section class="last gallery">
        <ul id="sliderbody">
            <li class="pic-1"><img src="${pageContext.request.contextPath}/static/images/tepapa/photo1.jpg" alt="stock photo"/></li>
            <li class="pic-2"><img src="${pageContext.request.contextPath}/static/images/tepapa/photo2.jpg" alt="stock photo" /></li>
            <li class="pic-3"><img src="${pageContext.request.contextPath}/static/images/tepapa/photo3.jpg" alt="stock photo" /></li>
            <li class="pic-4"><img src="${pageContext.request.contextPath}/static/images/tepapa/photo4.jpg" alt="stock photo" /></li>
            <li class="pic-5"><img src="${pageContext.request.contextPath}/static/images/tepapa/photo5.jpg" alt="stock photo" /></li>
        </ul>
        <p id="images-copyright">Images &copy; Te Papa<br/>
            Albatross images copyright & courtesy of D. Filippi</p>
    </section>
    <section id="homepage-text">
        <p>The Living Aotearoa - Biodiversity Pilot Portal is a unique platform to learn, discover and act on biodiversity and conservation both in Aotearoa / New Zealand and internationally.</p>
        <p>New Zealand is home to many unique and rare species.  This site is set up as a demonstration of how we can integrate information, and share what we know about species (and ultimately ecosystems), drawing data from a range of sources.</p>
        <p>We hope this portal helps engage people in conservation and biodiversity management decisions and increases our knowledge of the state of biodiversity in New Zealand.</p>
        <p>This site has been developed to test data display and data sharing concepts, using the platform provided by Atlas of Living Australia, focussed on New Zealand species and environmental variables.</p>
        <p style="color: #666">This Research has been funded by Department of Conservation, under a TFBIS grant.</p>
    </section>
</div>
<div class="inner">
    <section>
        <div id="participants">
            PARTICIPATING ORGANISATIONS:
            <br/>
            <a href="http://www.tepapa.govt.nz/" target="_blank"><img src="${pageContext.request.contextPath}/static/images/tepapa/tepapa-logo.png" alt="tepapa logo"/></a>
            <a href="http://www.niwa.co.nz/" target="_blank"><img src="${pageContext.request.contextPath}/static/images/tepapa/niwa-colour-50.png" alt="niwa logo" style="vertical-align:top;margin-top:35px;"/></a>
        </div>
    </section>
</div>
<footer>
    <div class="inner">
        <section class="copyright">
            <div class="img-left"><a href="http://creativecommons.org/licenses/by/3.0/nz/"
                                     title="External link to Creative Commons"><img
                    src="http://www.ala.org.au/wp-content/themes/ala2011/images/creativecommons.png" width="88"
                    height="31" alt=""/></a></div>
            <p><a href="${pageContext.request.contextPath}/help/termsOfUse" title="Terms of Use">Terms of Use</a> |
                <a href="${pageContext.request.contextPath}/help/contactTepapa">Contact</a><br/>This site is licensed under
                a <a href="http://creativecommons.org/licenses/by/3.0/nz/" title="External link to Creative Commons"
                     class="external">Creative Commons Attribution 3.0 New Zealand License</a>.</p>

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