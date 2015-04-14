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
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.1" rel="schema.AGLS" />
    <alatag:addApplicationMetaTags/>
    <meta name="DC.Title" content="Partners" lang="en" />	<meta name="DC.Function" content="Public information" />
    <meta name="DC.Description" content="Australia's Virtual Herbarium (AVH) is an online resource that provides immediate access to the wealth of plant specimen information held by Australian herbaria. AVH is a collaborative project of the state, Commonwealth and territory herbaria, developed under the auspices of the Council of Heads of Australasian Herbaria (CHAH), representing the major Australian collections." />
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
    <title><g:layoutTitle /></title>

    <r:require modules="avh"/>

    <r:layoutResources/>
    <g:layoutHead />
</head>
<body>
<g:set var="fluidLayout" value="${pageProperty(name:'meta.fluidLayout')?:grailsApplication.config.skin?.fluidLayout}"/>
<g:set var="containerType" value="${fluidLayout ? 'container-fluid' : 'container'}"/>
<alatag:outageBanner />
<div class="wrapper ">
    <!-- BS style header -->
    <div class="navbarFullWidth">
        <div class="navbar navbar-static-top ">
            <div class="navbar-inner">
                <div class="${containerType}">
                    <ul class="nav">
                        <li class="page_item page-item-1"><a href="http://avh.chah.org.au/" title="Home">Home</a></li>
                        <li class="page_item page-item-3 hidden-phone"><a href="http://avh.chah.org.au/index.php/about/" title="About AVH">About AVH</a></li>
                        <li class="page_item page-item-7 hidden-phone"><a href="http://avh.chah.org.au/index.php/terms-of-use/" title="Terms of use">Terms of use</a></li>
                        <li class="page_item page-item-4"><a href="http://avh.chah.org.au/index.php/help/" title="Help">Help</a></li>
                        <li class="page_item page-item-2"><a href="${request.contextPath}/search" title="Search">Search</a></li>
                        <li class="page_item page-item-5 hidden-phone"><a href="http://avh.chah.org.au/index.php/news/" title="News">News</a></li>
                    </ul>
                </div>
            </div>
        </div><!-- /.navbar -->
        <div class="${containerType}">
            <div id="avhLogoRow" class="row-fluid">
                <div class="span6">
                    <a href="http://avh.chah.org.au/"><img src="${request.contextPath}/css/avh/images/logo_AVH-white-transparent-small.png"/></a>
                </div>
                <div class="span6 pull-right" id="rightMenu">
                    <%--<a href="http://www.ala.org.au/my-profile/"><div id='loginId'>Logged in as niels.klazenga@rbg.vic.gov.au</div></a>--%>
                    <g:set var="loginId"><alatag:loggedInUserDisplayname/></g:set>
                    <a href="http://www.ala.org.au/my-profile/">${loginId}</a>
                    <g:if test="${loginId}">|</g:if>
                    <g:set var="returnUrlPath" value="${serverName}${request.requestURI}${request.queryString ? '?' : ''}${request.queryString}"/>
                    <auth:loginLogout logoutUrl="${request.contextPath}/logout/logout" returnUrlPath="${returnUrlPath}"/>
                    <g:if test="${clubView}">
                        | <div id="clubView"><span>Club View</span></div>
                    </g:if>
                </div>
            </div><!-- /.row-fluid -->
        </div>
    </div>

    <div id="contentBox" class="${containerType} content" style="margin-top: 20px;">
        <g:layoutBody />
        <div class="push"></div>
    </div>
    <div class="footer">
        <div id="footer">
            <span class="footer_item_1">
                <a href="http://ala.org.au/"><r:img dir="images" file="atlas-poweredby_rgb-lightbg.png" plugin="biocache-hubs" alt="Powered by ALA logo"/></a>
            </span>
            <span class="footer_item_2">
                AVH is an initiative of the Council of Heads of Australasian Herbaria (CHAH)
            </span>
            <span class="footer_item_3">
                <a href="mailto:avh@chah.org.au">avh@chah.org.au</a>
            </span>
        </div>
    </div>
</div>
<script type="text/javascript">
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    ga('create', 'UA-4355440-1', 'auto');
    ga('send', 'pageview');
</script>

<r:layoutResources/>
<g
</body>
</html>