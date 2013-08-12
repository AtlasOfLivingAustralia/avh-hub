<%--
    Document   : main.jsp (sitemesh decorator file)
    Created on : 18/09/2009, 13:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
<head profile="http://gmpg.org/xfn/11">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1">
    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/ozcam2013/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="http://ozcam.org.au/wp-content/themes/ozcam/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="http://ozcam.org.au/wp-content/themes/ozcam/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="http://ozcam.org.au/wp-content/themes/ozcam/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="http://ozcam.org.au/wp-content/themes/ozcam/ico/apple-touch-icon-57-precomposed.png">

    <title><decorator:title default="OZCAM" /></title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
    <link id="responsiveCss" rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/bootstrap-responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ozcam2013/bootstrapwp.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/bootstrapAdditions.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />

    <%@ include file="commonJS.jspf" %>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <decorator:head />
</head>
<body>
    <ala:outageBanner />
    <div class="hero-bg"></div>
    <div class="navbar navbar-inverse navbar-relative-top">
        <div class="navbar-inner">
            <div class="container">
                <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="brand" href="http://ozcam.org.au/" title="OZCAM" rel="home">OZCAM</a>
                <div class="nav-collapse wam-right"><ul id="main-menu" class="nav"><li id="menu-item-47" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-47"><a href="http://ozcam.org.au/about/">About</a></li>
                    <li id="menu-item-46" class="menu-item menu-item-type-post_type menu-item-object-page current-menu-item page_item page-item-41 current_page_item current-menu-ancestor current-menu-parent current_page_parent current_page_ancestor menu-item-46"><a href="http://ozcam.org.au/contributors/">Contributors</a>
                        <ul class="dropdown-menu pull-right">
                            <li id="menu-item-117" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-117"><a href="/contributors#ala">Atlas of Living Australia</a></li>
                            <li id="menu-item-50" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-50"><a href="/contributors#australian-museum">Australian Museum</a></li>
                            <li id="menu-item-51" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-51"><a href="/contributors#anbc">Australian National Biological Collections</a></li>
                            <li id="menu-item-67" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-67"><a href="/contributors#mv">Museum Vic-to-ria</a></li>
                            <li id="menu-item-68" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-68"><a href="/contributors#ntmag">North-ern Ter-ri-tory Museum and Art Gallery</a></li>
                            <li id="menu-item-69" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-69"><a href="/contributors#qvmag">Queen Vic-to-ria Museum Art Gallery</a></li>
                            <li id="menu-item-70" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-70"><a href="/contributors#qm">Queens-land Museum</a></li>
                            <li id="menu-item-71" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-71"><a href="/contributors#sam">South Aus-tralian Museum</a></li>
                            <li id="menu-item-72" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-72"><a href="/contributors#tmag">Tas-man-ian Museum and Art Gallery</a></li>
                            <li id="menu-item-73" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item menu-item-73"><a href="/contributors#wam">West-ern Aus-tralia Museum</a></li>
                        </ul>
                    </li>
                    <li id="menu-item-45" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-45"><a href="http://ozcam.org.au/news/">News</a></li>
                </ul></div>        </div>
        </div>
    </div>


    <!-- End Header -->
    <!-- Begin Template Content -->

    <header class="jumbotron subhead" id="overview">
        <div class="container">
            <h1>Search Specimens</h1>
            <p class="hide lead">OZCAM (Online Zoo-log-i-cal Col-lec-tions of Aus-tralian Muse-ums) pro-vides access to an online data-base of records aggre-gated from fau-nal col-lec-tions data-bases in Aus-tralian museums.</p>        </div>
    </header>

    <div class="main">
        <div class="container" id="content">
            <decorator:body />
            <div class="push"></div>
        </div><!--/.container -->
        <footer class="wamfooter">
            <div class="container">
                <div class="row">
                    <div class="span8">
                        <div id="text-7" class="widget widget_text">
                            <div class="textwidget">
                                <p><a href="/contributors/"><img src="${pageContext.request.contextPath}/static/images/ozcam2013/logo-banner.png" alt="Logos for the various partners of OZCAM" /></a></p>
                                <p>OZCAM is an initiative of the Council of Heads of Australian Faunal Collections (CHAFC)</p>
                            </div>
                        </div>
                    </div> <!-- /span8 -->
                    <div class="span4">
                        <a href="http://www.ala.org.au/" target="_black"><img src="${pageContext.request.contextPath}/static/images/atlas-poweredby_rgb-lightbg.png" alt=""/></a>
                    </div> <!-- /span4 -->
                </div>
            </div>
        </footer>
        <div class="footer hide">
            <div style="float: right;padding-right:30px;"><a href="http://www.ala.org.au/" target="_black"><img src="${pageContext.request.contextPath}/static/images/atlas-poweredby_rgb-lightbg.png" alt=""/></a></div>
            <span style="padding-left:80px;">OZCAM is an initiative of the Council of Heads of Australian Faunal Collections (CHAFC)</span>
        </div>
    </div>
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