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
        <title><decorator:title default="OZCAM" /></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ozcam-0.3/style.css" type="text/css" media="screen,projection" />
        <!--<link rel="icon" type="image/x-icon" href="http://www.ozcam.org.au/favicon.ico" />-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
        <style type="text/css">
		div#fancy_inner {border-color:#BBBBBB}
		div#fancy_close {right:-15px;top:-12px}
		div#fancy_bg {background-color:#FFFFFF}
        </style>
        
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
                        <li class="page_item page-item-4"><a href="http://www.ozcam.org.au/" title="Home">Home</a></li>
                        <li class="page_item page-item-6"><a href="http://www.ozcam.org.au/ozcam-data/" title="About OZCAM">About <span class="caps">OZCAM</span></a></li>
                        <li class="page_item page-item-9 current_page_item"><a href="http://www.ozcam.org.au/using-ozcam-data/" title="OZCAM Data"><span class="caps">OZCAM</span> Data</a></li>
                        <li class="page_item page-item-11"><a href="http://www.ozcam.org.au/rights/" title="Copyright">Copyright</a></li>
                        <li class="page_item page-item-13"><a href="http://www.ozcam.org.au/contact-us/" title="Contact us">Contact us</a></li>
                        <li class="page_item page-item-154"><a href="http://www.ozcam.org.au/news/" title="News">News</a></li>
                    </ul>
                </div></div>
            <!-- etc. -->
            <div id="header">
                <div id="feature">
                    <div id="LogoBox">
                        <div id="Logo"></div></div>
                </div>
            </div>
            <div id="contentBox" style="margin-top: 20px;">
                <decorator:body />
                <div class="push"></div>
            </div>
            <div class="footer">
                <div style="float: right;padding-right:30px;"><a href="http://www.ala.org.au/" target="_black"><img src="${pageContext.request.contextPath}/static/images/atlas-poweredby_rgb-lightbg.png" alt=""/></a></div>
                <span style="padding-left:80px;">OZCAM is an initiative of the Council of Heads of Australian Faunal Collections (CHAFC)</span>
            </div>
        </div>
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