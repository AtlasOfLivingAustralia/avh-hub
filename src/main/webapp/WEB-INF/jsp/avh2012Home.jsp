<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>

<%-- NOTE: this page is no longer used as webapp root for AVH redirects to http://avh.chah.org.au/ --%>

<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <meta charset="utf-8"/>
    <title>Australia's Virtual Herbarium</title>
    <link rel="shortcut icon" type="image/ico" href="${pageContext.request.contextPath}/static/images/avh2012/favicon.ico"/>

    <link rel="stylesheet" type="text/css" media="all" href="${pageContext.request.contextPath}/static/css/avh2012/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />

    <style type="text/css">
        div#fancy_inner {border-color:#BBBBBB}
        div#fancy_close {right:-15px;top:-12px}
        div#fancy_bg {background-color:#FFFFFF}
    </style>
    <script type='text/javascript' src='${pageContext.request.contextPath}/static/js/jquery.min-1.7.1.js'></script>

    <script type='text/javascript' src='${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.pack.js'></script>

    <!-- Fancybox for WordPress v2.7.2 -->

    <script type="text/javascript">
        jQuery.noConflict();
        jQuery(function(){
            jQuery.fn.getTitle = function() {
                var arr = jQuery("a.fancybox");
                jQuery.each(arr, function() {
                    var title = jQuery(this).children("img").attr("title");
                    jQuery(this).attr('title',title);
                })
            }
            var thumbnails = 'a:has(img)[href$=".bmp"],a:has(img)[href$=".gif"],a:has(img)[href$=".jpg"],a:has(img)[href$=".jpeg"],a:has(img)[href$=".png"],a:has(img)[href$=".BMP"],a:has(img)[href$=".GIF"],a:has(img)[href$=".JPG"],a:has(img)[href$=".JPEG"],a:has(img)[href$=".PNG"]';
            jQuery(thumbnails).addClass("fancybox").attr("rel","fancybox").getTitle();
            jQuery("a.fancybox").fancybox({
                'imageScale': true,
                'padding': 10,
                'zoomOpacity': true,
                'zoomSpeedIn': 500,
                'zoomSpeedOut': 500,
                'zoomSpeedChange': 300,
                'overlayShow': true,
                'overlayColor': "#666666",
                'overlayOpacity': 0.3,
                'enableEscapeButton': true,
                'showCloseButton': true,
                'hideOnOverlayClick': true,
                'hideOnContentClick': false,
                'frameWidth':  560,
                'frameHeight':  340,
                'centerOnScroll': true
            });
        })

    </script>

    <style type="text/css">
        #sliderbody, #sliderbody img {width: 444px;height: 270px;}
        #vslider {margin: 0px 0px 0px 0px;
            padding: 0;
            border: none;}
        #vslider {height: 270px;overflow: hidden;}
        #vslider ul {list-style: none !important;margin: 0 !important;padding: 0 !important;}
        #vslider ul li {list-style: none !important;margin: 0 !important;padding: 0 !important;}
        #sliderbody {overflow: hidden !important;}
        #sliderbody img {-ms-interpolation-mode: bicubic;}
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/avh2012/vslider.js"></script>
    <script type="text/javascript">
        /*** vslider Init ***/
        jQuery.noConflict();
        jQuery(document).ready(function(){
            jQuery('ul#sliderbody').innerfade({
                animationtype: 'fade',
                speed: 1000,
                timeout: 4000,
                type: 'sequence',
                containerheight: '270px'
            });
        });
    </script>
</head>

<body>
<div id="wrapper">
    <div id="navigation">
        <div class="skip-link"><a class="assistive-text" href="#content" title="Skip to primary content">Skip to primary content</a></div>
        <div class="skip-link"><a class="assistive-text" href="#secondary" title="Skip to secondary content">Skip to secondary content</a></div>
        <div id="nav-inside">
            <ul id="nav_start">
                <li></li>
            </ul>
            <ul id="nav">
                <li class="page_item page-item-1"><a href="http://avh.chah.org.au/" title="Home">Home</a></li>
                <li class="page_item page-item-3"><a href="http://avh.chah.org.au/index.php/about/" title="About AVH">About AVH</a></li>
                <li class="page_item page-item-7"><a href="http://avh.chah.org.au/index.php/terms-of-use/" title="Terms of use">Terms of use</a></li>
                <li class="page_item page-item-4"><a href="http://avh.chah.org.au/index.php/help/" title="Help">Help</a></li>
                <li class="page_item page-item-2"><a href="${pageContext.request.contextPath}/search" title="Search">Search</a></li>
                <li class="page_item page-item-5"><a href="http://avh.chah.org.au/index.php/news/" title="News">News</a></li>
            </ul>
        </div>
    </div>
    <div id="hp-header">
        <div id="feature">
            <div id="featureBox">
                <div id="slider">
                    <div id="vslider">
                        <ul id="sliderbody">
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_1.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_2.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_3.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_4.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_5.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_6.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                            <li><a href=""><img src="${pageContext.request.contextPath}/static/images/avh2012/slide_7.jpg" width="440" height="270" alt="featured" class="vsliderImg" /></a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div id="hp-LogoBox">
                <div id="hp-Logo">
                    <div id="searchBox">
                        <form action="${pageContext.request.contextPath}/occurrences/search" id="solrSearchForm">
                            <input type="text" id="taxaQuery" name="taxa" value=""/>
                            <input type="submit" id="solrSubmit" value="Search"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="hp-contentBox">
        <div id="sponsors">
            <h1>Participating organisations</h1>
            <div class="simpleimage">
                <a href="http://www.dec.wa.gov.au/our-environment/science-and-research/wa-herbarium.html">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_PERTH.jpg" alt="Western Australian Herbarium" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://lrm.nt.gov.au/herbarium#.UJb3jLLib1A">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_DNA.jpg" alt="Northern Territory Herbarium" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.environment.sa.gov.au/Knowledge_Bank/Science_research/State_Herbarium">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_AD.jpg" alt="State Herbarium of South Australia" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.ehp.qld.gov.au/plants/herbarium/">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_BRI.jpg" alt="Queensland Herbarium" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.rbgsyd.nsw.gov.au/science/Herbarium_and_resources">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_NSW.jpg" alt="National Herbarium of New South Wales" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.cpbr.gov.au/cpbr/">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_CANB.jpg" alt="Australian National Herbarium" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.rbg.vic.gov.au/science/information-and-resources/national-herbarium-of-victoria">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_MEL.jpg" alt="National Herbarium of Victoria" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.tmag.tas.gov.au/">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_HO.jpg" alt="Tasmanian Herbarium" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.ath.org.au/">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_ATH.jpg" alt="Australian Tropical Herbarium" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.environment.gov.au/biodiversity/abrs/">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_ABRS.jpg" alt="Australian Biological Resources Study" />
                </a>
            </div>
            <div class="simpleimage">
                <a href="http://www.virtualherbarium.org.nz/home">
                    <img src="${pageContext.request.contextPath}/static/images/avh2012/logo_NZVH.jpg" alt="New Zealand Virtual Herbarium" />
                </a>
            </div>
        </div>

        <div id="hp-content">
            <p>Welcome to <b>Australia's Virtual Herbarium (AVH)</b></p>
            <p>AVH provides access to information obtained from the collections held in Australian herbaria.</p>
            <p>Australia’s major state and territory herbaria house over six million plant, algae and fungi specimens.
                The collecting data stored with these specimens provides the most complete picture of the distribution
                of Australia’s flora to date.</p>
            <p>From this site you can search, map, download and analyse records from the databases of the major herbaria in Australia.</p>
         </div>
        <div class="push"></div>
    </div>

    <div class="footer">
        <div id="footer">
                    <span class="footer_item_1">
                        <a href="http://ala.org.au"><img src="${pageContext.request.contextPath}/static/images/atlas-poweredby_rgb-lightbg.png" alt=""/></a>
                    </span>
                    <span class="footer_item_2">
                        AVH is an initiative of the Council of Heads of Australasian Herbaria (CHAH)
                    </span>
                    <span class="footer_item_3">
                        <a href="mailto:avh@ala.org.au">avh@ala.org.au</a>
                    </span>
        </div>
    </div>
</div>


</body>
</html>