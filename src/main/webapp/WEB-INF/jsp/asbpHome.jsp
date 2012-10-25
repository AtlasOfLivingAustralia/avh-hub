<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>

<!DOCTYPE HTML>
<html dir="ltr" lang="en-US">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Australian Seed Bank Partnership</title>
    <link rel="shortcut icon" href="http://seedpartnership.org.au/sites/default/files/favicon_32px_0.ico" type="image/vnd.microsoft.icon" />
    <!--css from ala - to replace with full url-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/asbp/tabs-no-images.css" type="text/css" media="screen" />
    <!--css for asbp-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/asbp/asbp_ala_seedhub.css" type="text/css" media="screen" />

</head>

<body>

<div id="main_content" class="">

    <!--Header-->
    <div id="header">
        <a href="http://seedpartnership.org.au/" title="Home" rel="home" id="logo">
            <img src="http://seedpartnership.org.au/sites/default/files/seedbank_logo_0.png" alt="Home" border="0"/>
        </a>
        <!--Menu-->
        <div id="nice_menus-1">
            <ul class="nice-menu">
                <li><a href="${pageContext.request.contextPath}/search">Search</a></li>
                <li><a href="${pageContext.request.contextPath}/help/help.html">Help</a></li>
                <li><a href="http://seedpartnership.org.au/about/aboutus" title="About Us">About Us</a></li>
                <li><a href="http://seedpartnership.org.au/initiatives">Initiatives</a></li>
                <li><a href="http://seedpartnership.org.au/partners" title="Partners and Associates">Partners and Associates</a></li>
                <li><a href="http://seedpartnership.org.au/contact" title="Contact">Contact</a></li>
                <li><a href="http://seedpartnership.org.au/">ASBP Home</a></li>
            </ul>
        </div>
    </div>
    <!--end Header-->
    <div class="breadcrumb">&nbsp;</div>
    <h1>The Australian Seed Bank</h1>
    <div class="home-menu-block">
        <h2><a href="${pageContext.request.contextPath}/search">Search</a></h2>
        <h2><a href="http://seedpartnership.org.au/help.html">Help</a></h2>
    </div>
    <p>The Australian Seed Bank is an online resource for the review of conservation seed collections in Australia. It aims to support the planning of seed collection programs and offers some data to guide seed germination testing. Users of the Australian Seed Bank data are able to search and map collections of species made by the members of the <a href="http://seedpartnership.org.au/">Australian Seed Bank Partnership</a> across Australia as well as analyse germination information from some partners.</p>
    <p>&nbsp;</p>
    <div><img src="http://seedpartnership.org.au/sites/default/files/images/banner/banner_img_6.jpg" alt="Seed collections made for the Royal Tasmanian Botanical Gardens" width="310" height="215" title="Seed collections made for the Royal Tasmanian Botanical Gardens"> &nbsp;&nbsp; <img src="http://seedpartnership.org.au/sites/default/files/images/banner/banner_img_8.jpg" alt="Allocasuarina misera cones" title="Allocasuarina misera cones" width="310" height="215"> &nbsp;&nbsp; <img src="http://seedpartnership.org.au/sites/default/files/images/banner/banner_img_13.jpg" alt="Xanthorrhoea preissii seed rain"  title="Xanthorrhoea preissii seed rain" width="310" height="215"></div><br>

    <div><img src="http://seedpartnership.org.au/sites/default/files/seedhub_partner_logos.jpg" width="965" height="100" border="0" usemap="#Map" target="_blank">
        <map name="Map">
            <area shape="rect" coords="-2,1,99,97" href="http://www.anbg.gov.au/" target="_blank" alt="Australian National Botanic Gardens Seed Bank" title="Australian National Botanic Gardens Seed Bank">
            <area shape="rect" coords="104,2,267,96" href="http://www.environment.sa.gov.au/botanicgardens/Gardens_and_Collections/Seed_Conservation_Centre_share" target="_blank" alt="South Australian Seed Conservation Centre, Botanic Gardens of Adelaide" title="South Australian Seed Conservation Centre, Botanic Gardens of Adelaide">
            <area shape="rect" coords="269,4,447,97" href="http://www.bgpa.wa.gov.au/horticulture/wa-seed-tech-centre" target="_blank" alt="The Western Australia Seed Technology Centre, Kings Park and Botanic Garden" title="The Western Australia Seed Technology Centre, Kings Park and Botanic Garden">
            <area shape="rect" coords="449,5,521,98" href="http://www.brisbane.qld.gov.au/facilities-recreation/parks-and-venues/parks/brisbane-botanic-gardens-mt-coot-tha/index.htm" target="_blank" alt="Brisbane Botanic Gardens Conservation Seed Bank, Brisbane City Council" title="Brisbane Botanic Gardens Conservation Seed Bank, Brisbane City Council">
            <area shape="rect" coords="525,3,606,96" href="http://www.rbgsyd.nsw.gov.au/" target="_blank" alt="NSW Seedbank, The Royal Botanic Gardens and Domain Trust" title="NSW Seedbank, The Royal Botanic Gardens and Domain Trust">
            <area shape="rect" coords="610,4,670,99" href="http://www.rbg.vic.gov.au/science/conservation-research/victorian-conservation-seedbank" target="_blank" alt="The Victorian Conservation Seedbank, Royal Botanic Gardens Melbourne" title="The Victorian Conservation Seedbank, Royal Botanic Gardens Melbourne">
            <area shape="rect" coords="673,4,905,96" href="http://www.dec.wa.gov.au/content/view/2933/1955/1/1/" target="_blank" alt="Threatened Flora Seed Centre, Department of Environment and Conservation, Western Australia" title="Threatened Flora Seed Centre, Department of Environment and Conservation, Western Australia">
            <area shape="rect" coords="906,4,967,97" href="http://www.rtbg.tas.gov.au/index.aspx?base=157" target="_blank" alt="SeedSafe – Tasmania, Royal Tasmanian Botanical Gardens" title="SeedSafe – Tasmania, Royal Tasmanian Botanical Gardens">
        </map>
    </div>

</div>

<!--Footer-->
<div class="footer">
    <div style="background: url(http://seedpartnership.org.au/sites/all/themes/seedbank/images/footer_slogan.gif) no-repeat right bottom; height: 42px; vertical-align: top"></div>
    <div style="font-size: 0.75em; float:left;">Copyright © 2012 Council of Heads of Australian Botanic Gardens Inc. (CHABG)</div>
    <div style="font-size: 0.75em; text-align:right;"><a href="http://seedpartnership.org.au/privacy">Privacy &amp; Disclaimer</a></div>

</div>


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