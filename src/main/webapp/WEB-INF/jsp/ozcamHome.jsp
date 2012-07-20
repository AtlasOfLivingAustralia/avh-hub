<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US"> 
<head profile="http://gmpg.org/xfn/11"> 
    <title>OZCAM</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ozcam-0.3/style.css" type="text/css" media="screen,projection" />
 
    <meta name='robots' content='noindex,nofollow' />
 
    <link rel="stylesheet" href="http://www.ozcam.org.au/wp-content/plugins/fancybox-for-wordpress/css/fancybox.css" type="text/css" media="screen" />

	<style type="text/css">
		div#fancy_inner {border-color:#BBBBBB}
		div#fancy_close {right:-15px;top:-12px}
		div#fancy_bg {background-color:#FFFFFF}
			</style>

	<script type='text/javascript' src='http://www.ozcam.org.au/wp-includes/js/jquery/jquery.js?ver=1.4.2'></script> 
    <script type='text/javascript' src='http://www.ozcam.org.au/wp-content/plugins/s3slider-plugin/js/s3slider.js?ver=3.0.4'></script>
    <script type='text/javascript'>
    /* <![CDATA[ */
    var ie6w = {
        url: "http://www.ozcam.org.au/wp-content/plugins/shockingly-big-ie6-warning",
        test: "false",
        jstest: "false",
        t1: "WARNING",
        t2: "You are using Internet Explorer version 6.0 or lower. Due to security issues and lack of support for Web Standards it is highly recommended that you upgrade to a modern browser.",
        t3: "After the update you can acess this site normally.",
        firefox: "true",
        opera: "true",
        chrome: "true",
        safari: "true",
        ie: "false",
        firefoxu: "http://www.getfirefox.net/",
        operau: "http://www.opera.com/",
        chromeu: "http://www.google.com/chrome/",
        safariu: "http://www.apple.com/safari/",
        ieu: "http://www.microsoft.com/windows/ie/"
    };
    /* ]]> */
    </script>
    <script type='text/javascript' src='http://www.ozcam.org.au/wp-content/plugins/shockingly-big-ie6-warning/js/ie6w_center.js?ver=3.0.4'></script>
    <script type='text/javascript' src='http://www.ozcam.org.au/wp-content/plugins/fancybox-for-wordpress/js/jquery.fancybox-1.2.6.min.js?ver=1.3.2'></script>
    <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://www.ozcam.org.au/xmlrpc.php?rsd" />
    <link rel="wlwmanifest" type="application/wlwmanifest+xml" href="http://www.ozcam.org.au/wp-includes/wlwmanifest.xml" />
    <link rel='index' title='OZCAM' href='http://www.ozcam.org.au/' />
    <link rel='next' title='About &lt;span class=&quot;caps&quot;&gt;OZCAM&lt;/span&gt;' href='http://www.ozcam.org.au/ozcam-data/' />
    <meta name="generator" content="WordPress 3.0.4" />
    <link rel='canonical' href='http://www.ozcam.org.au/' />


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

            // Supported file extensions
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
    <!-- END Fancybox for WordPress -->

    <!-- Start vslider -->
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
    <script type="text/javascript" src="http://www.ozcam.org.au/wp-content/plugins/vslider/js/vslider.js"></script>
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
    <!-- End vslider -->

    <style type="text/css">
    sup {
        vertical-align: 60%;
        font-size: 75%;
        line-height: 100%;
    }
    sub {
        vertical-align: -10%;
        font-size: 75%;
        line-height: 100%;
    }
    .amp {
        font-family: Baskerville, "Goudy Old Style", "Palatino", "Book Antiqua", "Warnock Pro", serif;
        font-weight: normal;
        font-style: italic;
        font-size: 1.1em;
        line-height: 1em;
    }
    .caps {
        font-size: 90%;
    }
    .dquo {
        margin-left:-.40em;
    }
    .quo {
        margin-left:-.2em;
    }
    /* because formatting .numbers should consider your current font settings, we will not style it here */

    </style>
 
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
	<li class="page_item page-item-4 current_page_item"><a href="${pageContext.request.contextPath}" title="Home">Home</a></li>
<li class="page_item page-item-6"><a href="http://www.ozcam.org.au/ozcam-data/" title="About OZCAM">About <span class="caps">OZCAM</span></a></li> 
<li class="page_item page-item-9"><a href="http://www.ozcam.org.au/using-ozcam-data/" title="OZCAM Data"><span class="caps">OZCAM</span> Data</a></li> 
<li class="page_item page-item-11"><a href="http://www.ozcam.org.au/rights/" title="Copyright">Copyright</a></li> 
<li class="page_item page-item-13"><a href="http://www.ozcam.org.au/contact-us/" title="Contact us">Contact us</a></li> 
<li class="page_item page-item-154"><a href="http://www.ozcam.org.au/news/" title="News">News</a></li> 
</ul>	
</div></div> 
<!-- etc. --> 
<div id="hp-header"> 
<div id="feature"> 
<div id="featureBox"> 
<div id="slider">
    <div id="vslider">
        <ul id="sliderbody">
            
                                <li><a href=""><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/Thumb10.png" alt="featured" class="vsliderImg" /></a></li>
                                <li><a href=""><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/Thumb11.png" alt="featured" class="vsliderImg" /></a></li>
                                <li><a href=""><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/Thumb12.png" alt="featured" class="vsliderImg" /></a></li>
                                <li><a href=""><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/Thumb15.png" alt="featured" class="vsliderImg" /></a></li>
                                <li><a href=""><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/Thumb16.png" alt="featured" class="vsliderImg" /></a></li>
                                <li><a href=""><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/Thumb03.png" alt="featured" class="vsliderImg" /></a></li>
                
                
                
                
                        </ul>
    </div>

</div> 
</div> 
<div id="hp-LogoBox"> 
<div id="hp-Logo"> 
<div class="hp-contentbutton"><a href="${pageContext.request.contextPath}/home">Search OZCAM</a></div>
<!--<ul id="search">
  <li><a href="http://www.biomaps.net.au/biomaps2/" target="_blank">OZCAM2 (BioMaps) Portal</a></li></ul>--> 
</div></div> 
</div> 
 
 
 
</div> 
<div id="hp-contentBox"> 
<div id="sponsors"> 
<h1>Participating Organisations</h1> 
	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>csiro.jpg</h1> -->		<a href="http://www.csiro.au/csiro/channel/_ca_dch2t.html">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/csiro.jpg" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>am.png</h1> -->		<a href="http://www.australianmuseum.net.au/">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/am.png" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>nt.png</h1> -->		<a href="http://www.nt.gov.au/nreta/museums/index.html">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/nt.png" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>qm.png</h1> -->		<a href="http://www.qm.qld.gov.au/">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/qm.png" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>mv1.jpg</h1> -->		<a href="http://museumvictoria.com.au">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/mv1.jpg" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>tasmania.jpg</h1> -->		<a href="http://www.tmag.tas.gov.au/">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/tasmania.jpg" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>qvm.png</h1> -->		<a href="http://www.qvmag.tas.gov.au/">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/qvm.png" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>sa.jpg</h1> -->		<a href="http://www.samuseum.sa.gov.au/page/default.asp?site=1">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/sa.jpg" alt="" /></p> 
		</a>	</div> 
	<br /></div>	<div class="float">	<div class="simpleimage"> 
				<!-- Control Title: <h1>wam1.jpg</h1> -->		<a href="http://www.museum.wa.gov.au/">		<p><img src="http://www.ozcam.org.au/wp-content/uploads/2011/01/wam1.jpg" alt="" /></p> 
		</a>	</div> 
	<br /></div><div class="spacer"></div> 
</div> 
<div id="hp-content"> 
  
    <p>Welcome to the <a><strong>Online Zoological Collections of Australian Museums</strong></a></p>
    <p>From this site you can search, map and down­load species records from many of Australia&apos;s fauna collections.</p>
    <p>Museums hold vast collections of specimens from the natural world and these represent a key resource for taxonomy, systematics, conservation and the sustainable use of our biodiversity. This website provides a way to discover more about Australia&apos;s diverse fauna by allowing virtual access to the combined collections of many of Australia&apos;s museums.</p>
    <p>Click the <a href="${pageContext.request.contextPath}/home" target="_self"><strong>Search <span class="caps">OZCAM</span></strong></a> button to search the <span class="caps">OZCAM</span> database online.</p>
    <p>To access a feed of the raw data, go to the <a href="http://www.ozcam.org.au/?page_id=9" target="_self"><strong><span class="caps">OZCAM</span> Data</strong></a> page.</p>
    <p>Latest <a href="http://www.ozcam.org.au/?page_id=154" target="_self"><strong><span class="caps">OZCAM</span> News</strong></a></p>

	<!--  <div class="hp-contentbutton"><a href="http://www.biomaps.net.au/biomaps2/" target="_blank">OZCAM2 (BioMaps) Portal</a></div>
  <div class="hp-contentbutton"><a href="http://digir.austmus.gov.au/ozcam/DiGIR.php" target="_blank">TAPIR provider</a></div>--> 
</div> 
<div class="push"></div> 
</div> 
<div class="footer">OZCAM is an initiative of the Council of Heads of Australian Faunal Collections (CHAFC)</div> 
 
</div>

<script type="text/javascript">
  var uvOptions = {};
  (function() {
    var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
    uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/5XG4VblqrwiubphT3ktPQ.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
  })();
</script>
</body> 
</html> 