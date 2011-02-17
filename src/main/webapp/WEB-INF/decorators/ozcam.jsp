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
        <title><decorator:title default="Atlas of Living Australia" /></title>
        <link rel="stylesheet" href="http://www.ozcam.org.au/wp-content/themes/OZCAM-0.3/OZCAM 0.3/style.css" type="text/css" media="screen,projection" />
        <link rel="stylesheet" href="http://www.ozcam.org.au/wp-content/plugins/fancybox-for-wordpress/css/fancybox.css" type="text/css" media="screen" />
        <style type="text/css">
		div#fancy_inner {border-color:#BBBBBB}
		div#fancy_close {right:-15px;top:-12px}
		div#fancy_bg {background-color:#FFFFFF}
        </style>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.5.min.js"></script>
	    <!--<script type='text/javascript' src='http://www.ozcam.org.au/wp-includes/js/jquery/jquery.js?ver=1.4.2'></script>-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
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
<!--            <div id="SidebarBox">
                    <div class="sidebar">
                    </div>
                    <div class="sidebar">
                        <div id="search-sb">
                            <div class="textwidget">
                                <div class="searchbtn"><a href="http://www.biomaps.net.au/ozcam2/" target="_blank">Search <span class="caps">OZCAM</span></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="content">
                    <h1><span class="caps">OZCAM</span> Data</h1>
                    <h4><strong>Access­ing <span class="caps">OZCAM</span> data</strong></h4>
                    <p>To search for species records, map them and analyse the data use <a href="http://www.biomaps.net.au/ozcam2/" target="_self"><strong>Search <span class="caps">OZCAM</span></strong></a>.</p>
                    <h4><span class="caps">OZCAM</span> Schema</h4>
                    <p>Data pro­vided through <span class="caps">OZCAM</span> con­forms to a <a href="http://df.arcs.org.au/quickshare/63f9e40a847591aa/OZCAM%20Schema_revision_31_08_10.xlsx">stan­dard schema</a> devel­oped and approved by <a href="http://www.chafc.org.au/fcig/"><span class="caps">FCIG</span></a></p>
                    <h4><strong><span>Access­ing <span class="caps">OZCAM</span> providers directly</span></strong></h4>
                    <p>The links below are to the <span class="caps">OZCAM</span> cache access points for each of the col­lec­tions. These access points are in <span class="caps">XML</span> and pro­vide the nec­es­sary infor­ma­tion for query­ing these data sources</p>
                    <ul>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_am">Aus­tralian  Museum provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_csiro"><span class="caps">CSIRO</span> Aus­tralian National Fish Collection </a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_anwc">Aus­tralian  National Wildlife Col­lec­tion provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_nmv">Museum  Vic­to­ria provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_nt">North­ern  Ter­ri­tory Museum and Art Gallery provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_qvmag">Queen  Vic­to­ria Museum Art Gallery provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_qm">Queens­land  Museum provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_sama">South  Aus­tralian Museum Aus­tralia provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_tmag">Tas­man­ian  Museum and Art Gallery provider for <span class="caps">OZCAM</span></a></li>
                        <li><a href="http://tapir.austmus.gov.au/tapirlink/tapir.php/ozcam_wam">West­ern  Aus­tralia Museum provider for <span class="caps">OZCAM</span></a></li>
                    </ul>
                </div>-->
                <div class="push"></div> 
            </div>
            <div class="footer">OZCAM is an initiative of the Council of Heads of Australian Faunal Collections (CHAFC)</div>
        </div>
    </body>
</html>