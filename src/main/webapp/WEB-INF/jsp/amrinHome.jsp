<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>

<!DOCTYPE HTML>

<html dir="ltr" lang="en-US">
<head>
    <title>AMRiN</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/amrin.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/buttons.css" type="text/css" media="screen,projection" />

    <!--<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/reset.css" />
     <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/screen.css" />   -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/html5.js"></script>

    <script type="text/javascript">
        contextPath = "";
    </script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min-1.7.1.js"></script>

    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.jsonp-2.1.4.min.js"></script>
    <script type="text/javascript" src="http://avh.ala.org.auhttp://collections.ala.org.au/js/charts2.js"></script>
    <script type="text/javascript" src="http://collections.ala.org.au/js/datadumper.js"></script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.pack.js"></script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ba-hashchange.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.transform.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.grab.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.jplayer.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/mod.csstransforms.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/circle.player.js"></script>
    <!--<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bieAutocomplete.js"></script>-->
    <script src="http://cdn.jquerytools.org/1.2.6/all/jquery.tools.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.cookie.js"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/tabs-no-images.css" />
    <!--<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/advancedSearch.js"></script>-->
    <!-- <script type="text/javascript">

        /************************************************************\
        * Fire chart loading
        \************************************************************/
        //google.load("visualization", "1", {packages:["corechart"]});
        //google.setOnLoadCallback(hubChartsOnLoadCallback);

       // $(document).ready(function() {
            //$("#advancedSearch").show();
            //$("ul.tabs").tabs("div.panes > div");
       //     $(".css-tabs:first").tabs(".css-panes:first > div", { history: true });
       // });

    </script>-->

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
        <h1 title="Australian Microbial Resources information Network"><a href=""><img src="http://www.ala.org.au/wp-content/themes/ala2011/images/amrin-lg.png" width="154" height="218" /></a></h1>
        <section>
            <div id="search">
                <form name="siteSearchForm" id="siteSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                    <label for="search">Quick search</label>
                    <input id="taxa" title="Search" type="text" name="taxa" placeholder="Quick search" class="name_autocomplete freetext" /><button value="Search" type="submit">Search</button>
                </form>
            </div>
            <p><strong>More options</strong>: <a href="${pageContext.request.contextPath}/search#advancedSearch">Advanced search</a>, <a href="${pageContext.request.contextPath}/search#taxaUpload">Batch name search</a>, <a href="${pageContext.request.contextPath}/search#catalogUpload">Batch catalogue no. search</a>, <a href="${pageContext.request.contextPath}/search#shapeFileUpload">Shapefile search</a></p>
        </section>
    </div>
</header>
<div class="inner two-col">
    <section>
        <h2>Welcome to the Australian Microbial Resources information Network</h2>
        <p>Culture collections of microorganisms  have a fundamental role providing authentic cultures underpinning research and testing in many scientific disciplines and in applications including  human, animal and plant health, industry, biotechnology, biosecurity, quarantine, the environment, and education.  AMRiN aims to provide integrated electronic access to information on the location and characteristics of microbial cultures in Australian collections of microorganisms. AMRiN is a developing facility.</p>
    </section>
    <section class="last gallery">
        <ul id="sliderbody">
            <li class="pic-1"><img src="${pageContext.request.contextPath}/static/images/amrin/amrin-01.jpg" alt="" width="400" height="300" /></li>
            <li class="pic-2"><img src="${pageContext.request.contextPath}/static/images/amrin/amrin-02.jpg" alt="" width="400" height="300" /></li>
            <li class="pic-3"><img src="${pageContext.request.contextPath}/static/images/amrin/amrin-03.jpg" alt="" width="400" height="300" /></li>
            <li class="pic-4"><img src="${pageContext.request.contextPath}/static/images/amrin/amrin-04.jpg" alt="" width="400" height="300" /></li>
            <li class="pic-5"><img src="${pageContext.request.contextPath}/static/images/amrin/amrin-05.jpg" alt="" width="400" height="300" /></li>
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
<script type="text/javascript">
    var uvOptions = {};
    (function() {
        var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
        uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/5XG4VblqrwiubphT3ktPQ.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
    })();
</script>
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