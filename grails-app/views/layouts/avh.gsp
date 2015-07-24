%{--
  - Copyright (C) 2014 Atlas of Living Australia
  - All Rights Reserved.
  -
  - The contents of this file are subject to the Mozilla Public
  - License Version 1.1 (the "License"); you may not use this file
  - except in compliance with the License. You may obtain a copy of
  - the License at http://www.mozilla.org/MPL/
  -
  - Software distributed under the License is distributed on an "AS
  - IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  - implied. See the License for the specific language governing
  - rights and limitations under the License.
  --}%

<%--
  Created by IntelliJ IDEA.
  User: dos009@csiro.au
  Date: 5/03/2014
  Time: 1:48 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<g:set var="serverName" value="${grailsApplication.config.serverName}"/>
<g:set var="orgNameLong" value="${grailsApplication.config.skin.orgNameLong}"/>
<g:set var="orgNameShort" value="${grailsApplication.config.skin.orgNameShort}"/>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.1" rel="schema.AGLS" />
    <alatag:addApplicationMetaTags/>
    <meta name="DC.Title" content="Partners" lang="en" />	<meta name="DC.Function" content="Public information" />
    <meta name="DC.Description" content="${orgNameLong} (${orgNameShort}) is an online resource that provides immediate access to the wealth of plant specimen information held by Australian herbaria. ${orgNameShort} is a collaborative project of the state, Commonwealth and territory herbaria, developed under the auspices of the Council of Heads of Australasian Herbaria (CHAH), representing the major Australian collections." />
    <meta name="DC.Creator" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
    <meta name="DC.Publisher" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
    <meta name="DC.Type.Category" content="document" />
    <meta name="DC.Format" content="text/html" />
    <meta name="DC.Language" content="en_AU" scheme="RFC3066" />
    <meta name="DC.Coverage.Jurisdiction" content="Australian Government Departmental Consortium" />
    <meta name="DC.Coverage.PlaceName" content="Australia, world" />
    <meta name="DC.Audience" content="Botanists, horticulturalists, biologists, ecologists, environmentalists, conservationists, land managers, educators, students, historians, general public" />
    <meta name="DC.Availability" content="Freely available. Some parts of this resource are username and password restricted" />
    <meta name="DC.Rights" content="(c) Council of Heads of Australasian Herbaria, 2010" />
    <meta name="DC.Rights" content="Unless other stated, Intellectual Property associated with this resource resides with the Council of Heads of Australasian Herbaria and individual herbaria. Applications, source code and data are freely available for research, non-commercial and public good purposes" />
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1">
    <link rel="shortcut icon" href="${request.contextPath}/images/avh/favicon.ico" />
    <link rel='stylesheet' id='google_fonts-css'  href='//fonts.googleapis.com/css?family=Lato:300,400,700|Raleway:400,300,700' type='text/css' media='screen' />
    <title><g:layoutTitle /></title>

    <r:require modules="avh"/>

    <r:layoutResources/>
    <g:layoutHead />
</head>
<body>
<g:set var="fluidLayout" value="${pageProperty(name:'meta.fluidLayout')?:grailsApplication.config.skin?.fluidLayout}"/>
<g:set var="containerType" value="${fluidLayout ? 'container-fluid' : 'container'}"/>
<alatag:outageBanner />
<!-- Header -->
<!-- Navbar -->
<div id="avh-nav" class="navbar">
    <div class="${containerType}">
        <div class="navbar-inner">
            <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <div class="nav-collapse collapse">
                <ul class="nav">
                    <li><a href="http://avh.chah.org.au">Home</a></li>
                    <li><a href="http://${serverName}/search/#tab_simpleSearch">Search</a></li>
                    <li class="dropdown font-xsmall">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">About<span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="http://avh.chah.org.au/index.php/about/">About ${orgNameShort}</a></li>
                            <li><a href="http://avh.chah.org.au/index.php/terms-of-use/">Terms of use</a></li>
                        </ul>
                    </li>
                    <li class="dropdown font-xsmall">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Help<span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="http://avh.chah.org.au/index.php/help/using-avh">Using ${orgNameShort}</a></li>
                            <li><a href="http://avh.chah.org.au/index.php/help/data/">Data</a></li>
                            <li><a href="http://avh.chah.org.au/index.php/help/download-fields/">Download fields</a></li>
                        </ul>
                    </li>
                    <li><a href="http://avh.chah.org.au/index.php/news">News</a></li>
                </ul>
                <ul class="nav pull-right">
                    <li><a href="http://avh.chah.org.au/index.php/contact-us">Contact us</a></li>
                    <li><a href="https://www.facebook.com/AustVirtHerb"><img src="${request.contextPath}/images/avh/facebook-icon-small2.png" alt="" width="25" height="25"></a></li>
                </ul>
            </div>
        </div><!-- /.navbar-inner -->
    </div><!-- .container -->
</div><!-- /.navbar -->

<div id="site-branding" class="site-branding">
    <div class="${containerType}">
        <div class="site-logo"><img src="${request.contextPath}/images/avh/avh-logo-white-80.png" alt=""></div>
        <div class="site-header">
            <h1 class="site-title"><a href="http://avh.chah.org.au" rel="home">${orgNameShort}</a></h1>
            <h2 class="site-description">${orgNameLong}</h2>
        </div>
        <div class="span6 pull-right" id="rightMenu">
            <%--<a href="http://www.ala.org.au/my-profile/"><div id='loginId'>Logged in as niels.klazenga@rbg.vic.gov.au</div></a>--%>
            <g:set var="loginId"><alatag:loggedInUserDisplayname/></g:set>
            <a href="http://www.ala.org.au/my-profile/">${loginId}</a>
            <g:if test="${loginId}">|</g:if>
            <g:set var="returnUrlPath" value="${serverName}${request.requestURI}${request.queryString ? '?' : ''}${request.queryString}"/>
            <auth:loginLogout logoutUrl="${request.contextPath}/logout/logout" returnUrlPath="${returnUrlPath}"/>
            %{--<g:if test="${clubView}">--}%
                %{--| <div id="clubView"><span>Club View</span></div>--}%
            %{--</g:if>--}%
        </div>
    </div>
</div><!-- .site-branding -->
<!-- End header -->

<div id="main-content" class="${containerType}">
    <g:layoutBody />
</div>

<!-- Footer -->
<footer id="colophon" class="site-footer" role="contentinfo">
    <div class="${containerType}">
        <div class="row">
            <aside id="text-3" class="widget col-sm-6  clearfix widget_text powered-by">
                <div class="textwidget">
                    <a href="http://ala.org.au/"><r:img dir="images" file="atlas-poweredby_rgb-lightbg.png" plugin="biocache-hubs" alt="Powered by ALA logo"/></a>
                </div>
            </aside>
            <aside id="text-2" class="widget col-sm-6  clearfix widget_text contact-us">
                <div class="textwidget">
                    <a href="mailto:avh@chah.org.au" title="Contact us">avh@chah.org.au</a>
                </div>
            </aside>
        </div><!-- .row -->
    </div><!-- .container -->
</footer><!-- #colophon -->
<!-- End footer -->

<script type="text/javascript">
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    ga('create', 'UA-4355440-1', 'auto');
    ga('send', 'pageview');
</script>

<r:layoutResources/>
</body>
</html>
