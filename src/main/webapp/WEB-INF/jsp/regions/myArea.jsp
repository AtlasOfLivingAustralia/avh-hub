<%--
    Document   : show
    Created on : Apr 21, 2010, 9:36:39 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="googleKey" scope="request"><ala:propertyLoader bundle="hubs" property="googleKey"/></c:set>
<c:set var="biocacheServiceUrl" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>
<c:set var="queryContext" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.queryContext"/></c:set>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="${skin}"/>
        <meta name="section" content="yourArea"/>
        <title>Explore Your Area | Atlas of Living Australia</title>
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/ala/biocache.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/jquery.qtip.min.css" type="text/css" media="screen" />
        <link type="text/css" rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala/css/biocache-theme/jquery-ui-1.8.custom.css" charset="utf-8">
        <script type="text/javascript" src="https://www.google.com/jsapi?key=${googleKey}"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-ui-1.8.4.custom.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.qtip.min.js"></script>
        <script type="text/javascript">
            // Global variables for yourAreaMap.js
            var EYA_CONF = {
                contextPath: "${pageContext.request.contextPath}",
                biocacheServiceUrl: "${biocacheServiceUrl}",
                zoom: ${zoom},
                radius: ${radius},
                speciesPageUrl: "${speciesPageUrl}",
                queryContext: "${queryContext}"
            }

            //make the taxa and rank global variable so that they can be used in the download
            var taxa = ["*"], rank = "*";
        </script>
        <jwr:script src="/js/explore/yourAreaMap.js"/>
    </head>
    <body class="regions">
        <div id="header">
            <c:if test="${skin == 'ala'}">
                <div id="breadcrumb">
                    <ol class="breadcrumb">
                        <li><a href="${initParam.centralServer}">Home</a> <span class=" icon icon-arrow-right"></span></li>
                        <li><a href="${initParam.centralServer}/species-by-location/">Locations</a> <span class=" icon icon-arrow-right"></span></li>
                        <li class="active">Your Area</li>
                    </ol>
                </div>
            </c:if>
            <h1>Explore Your Area</h1>
        </div>
        <form name="searchForm" id="searchForm" class="" action="" method="GET">
            <div class="control-group">
                <label class="control-label" for="address"><h4>Enter your location or address:</h4></label>
                <div class="controls">
                    <div class="input-append">
                        <input type="text" name="address" id="address" class="input-xlarge">
                        <input id="locationSearch" type="submit" class="btn" value="Search"/>
                        <input type="hidden" name="latitude" id="latitude" value="${latitude}"/>
                        <input type="hidden" name="longitude" id="longitude" value="${longitude}"/>
                        <input type="hidden" name="location" id="location" value="${location}"/>
                    </div>
                    <span class="help-inline">E.g. a street address, place name, postcode or GPS coordinates (as lat, long)</span>
                </div>
            </div>
            <div id="locationInfoZ" class="span8 row-fluid " style="margin-bottom:20px;margin-left:0;">
                <c:if test="${true || not empty location}">
                    <div class="span12">
                        Showing records for: <span id="markerAddress">${location}</span>&nbsp;&nbsp<a href="#" id="addressHelp" style="text-decoration: none"><span class="help-container">&nbsp;</span></a>
                    </div>
                </c:if>
                <div class="row-fluid">
                    <div class="span4">
                        Display records in a
                        <select id="radius" name="radius" class="" style="width:auto;line-height:18px;margin-bottom:0;">
                            <option value="1" <c:if test="${radius eq '1.0'}">selected</c:if>>1</option>
                            <option value="5" <c:if test="${radius eq '5.0'}">selected</c:if>>5</option>
                            <option value="10" <c:if test="${radius eq '10.0'}">selected</c:if>>10</option>
                        </select> km radius
                    </div>
                    <div class="span4">
                        <a href="#" id="viewAllRecords" class="btn"><i class="icon-list"></i>&nbsp;&nbsp;View
                        <span id="recordsGroupText">all</span> occurrence records</a>
                    </div>
                    <div class="span4">
                        <button id="downloadLink" href="#download" title="Download a list of all species (tab-delimited file)" class="btn"><i class="icon-download"></i>&nbsp;&nbsp;Download</button>
                    </div>
                </div>
                <div id="dialog-confirm" title="Continue with download?" style="display: none">
                    <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>You are about to
                        download a list of species found within a <span id="rad"></span> km radius of <code>${location}</code>.<br/>
                        Format: tab-delimited text file (called data.xls)</p>
                </div>
            </div>
        </form>
        <div class="row-fluid">
            <div class="span7">
                <div id="taxaBox">
                    <div id="leftList">
                        <table id="taxa-level-0">
                            <thead>
                            <tr>
                                <th>Group</th>
                                <th>Species</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div id="rightList" class="tableContainer">
                        <table>
                            <thead class="fixedHeader">
                            <tr>
                                <th>&nbsp;</th>
                                <th><a href="0" id="speciesSort" data-sort="taxa" title="sort by taxa">Species</a>
                                    <span id="sortSeparator">:</span>
                                    <a href="0" id="commonSort" data-sort="common" title="sort by common name">Common Name</a></th>
                                <th><a href="0" data-sort="count" title="sort by record count">Records</a></th>
                            </tr>
                            </thead>
                            <tbody class="scrollContent">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- .span7 -->
            <div class="span5">
                <div id="mapCanvas" style="width: 400px; height: 420px;margin-top:0px;"></div>
                <div style="font-size:11px;width:400px;color:black;height:20px;" class="show-80">
                    <table id="cellCountsLegend">
                        <tr>
                            <td style="background-color:#000; color:white; text-align:right;">Records:&nbsp;</td>
                            <td style="width:60px;background-color:#ffff00;">1&ndash;9</td>
                            <td style="width:60px;background-color:#ffcc00;">10&ndash;49</td>
                            <td style="width:60px;background-color:#ff9900;">50&ndash;99</td>
                            <td style="width:60px;background-color:#ff6600;">100&ndash;249</td>
                            <td style="width:60px;background-color:#ff3300;">250&ndash;499</td>
                            <td style="width:60px;background-color:#cc0000;">500+</td>
                        </tr>
                    </table>
                </div>
                <div id="mapTips">
                    <b>Tip</b>: you can fine-tune the location of the area by dragging the red marker icon
                </div>
            </div><!-- .span5 -->
        </div><!-- .row-fluid -->

        <div style="display:none">
            <jsp:include page="../downloadDiv.jsp"/>
        </div>
    </body>
</html>