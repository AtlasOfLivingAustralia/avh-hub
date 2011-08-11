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
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="decorator" content="<ala:propertyLoader bundle="hubs" property="sitemesh.skin"/>"/>
            <title>Explore Your Area | Atlas of Living Australia</title>
            <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/ala/biocache.css" />
            <script type="text/javascript" src="http://www.google.com/jsapi?key=${googleKey}"></script>
            <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-ui-1.8.4.custom.min.js"></script>
            <link type="text/css" rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala/css/biocache-theme/jquery-ui-1.8.custom.css" charset="utf-8">
            <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.ba-hashchange.min.js"></script>
            <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.qtip-1.0.0.min.js"></script>
            <script type="text/javascript">
                // Global variables for yourAreaMap.js
                var contextPath = "${pageContext.request.contextPath}";
                var biocacheServiceUrl = "${biocacheServiceUrl}";
                var zoom = ${zoom};
                var radius = ${radius};
                var speciesPageUrl = "${speciesPageUrl}";

                //make the taxa and rank global variable so that they can be used in the download
                var taxa = [];
                taxa[0] ="*";
                var rank ="*";
            </script>
            <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/explore/yourAreaMap.js"></script>
        </head>
        <body>
            <div id="header">
                <div id="breadcrumb">
                    <a href="${initParam.centralServer}">Home</a>
                    <a href="${initParam.centralServer}/explore">Explore</a>
                    Your Area
                </div>
                <h1>Explore Your Area</h1>
            </div>
            <div id="column-one" class="full-width">
                <div class="section">
                    <div>
                        <div id="mapOuter" style="width: 400px; height: 450px; float:right;">
                            <div id="mapCanvas" style="width: 400px; height: 430px;"></div>
                            <div style="font-size:11px;width:400px;color: black;" class="show-80">
                                <table id="cellCountsLegend">
                                    <tr>
                                        <td style="background-color:#333; color:white; text-align:right;">Records:&nbsp;</td>
                                        <td style="width:60px;background-color:#ffff00;">1&ndash;9</td>
                                        <td style="width:60px;background-color:#ffcc00;">10&ndash;49</td>
                                        <td style="width:60px;background-color:#ff9900;">50&ndash;99</td>
                                        <td style="width:60px;background-color:#ff6600;">100&ndash;249</td>
                                        <td style="width:60px;background-color:#ff3300;">250&ndash;499</td>
                                        <td style="width:60px;background-color:#cc0000;">500+</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div id="left-col">
                            <form name="searchForm" id="searchForm" action="" method="GET">
                                <div id="locationInput">
                                    <h2>Enter your location or address</h2>
                                    <div id="searchHints">E.g. a street address, place name, postcode or GPS coordinates (as lat, long)</div>
                                    <input name="address" id="address" size="50" value="${address}"/>
                                    <input id="locationSearch" type="submit" value="Search"/>
                                    <input type="hidden" name="latitude" id="latitude" value="${latitude}"/>
                                    <input type="hidden" name="longitude" id="longitude" value="${longitude}"/>
                                    <input type="hidden" name="location" id="location" value="${location}"/>
                                </div>
                                <div id="locationInfo">
                                    <c:if test="${true || not empty location}">
                                        <p>
                                            Showing records for: <span id="markerAddress">${location}</span>&nbsp;&nbsp<a href="#" id="addressHelp" style="text-decoration: none"><span class="help-container">&nbsp;</span></a>
                                        </p>
                                    </c:if>
                                    <table id="locationOptions">
                                        <tbody>
                                            <tr>
                                                <td>Display records in a
                                                    <select id="radius" name="radius">
                                                        <option value="1" <c:if test="${radius eq '1.0'}">selected</c:if>>1</option>
                                                        <option value="5" <c:if test="${radius eq '5.0'}">selected</c:if>>5</option>
                                                        <option value="10" <c:if test="${radius eq '10.0'}">selected</c:if>>10</option>
                                                    </select> km radius <!--<input type="submit" value="Reload"/>--></td>
                                                <td><img src="${pageContext.request.contextPath}/static/images/database_go.png" alt="search list icon" style="margin-bottom:-3px;" class="no-rounding"><a href="#" id="viewAllRecords">View all occurrence records</a></td>
                                                <td><button id="download" title="Download a list of all species (tab-delimited file)">Download</button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <div id="dialog-confirm" title="Continue with download?" style="display: none">
                                        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>You are about to
                                            download a list of species found within a <span id="rad"></span> km radius of <code>${location}</code>.<br/>
                                            Format: tab-delimited text file (called data.xls)</p>
                                    </div>
                                </div>
                                <div id="taxaBox">
                                    <div id="rightList" class="tableContainer">
                                        <table>
                                            <thead class="fixedHeader">
                                                <tr>
                                                    <th>&nbsp;</th>
                                                    <th>Species</th>
                                                    <th>Records</th>
                                                </tr>
                                            </thead>
                                            <tbody class="scrollContent">
                                            </tbody>
                                        </table>
                                    </div>
                                    <div id="leftList">
                                        <table id="taxa-level-0">
                                            <thead>
                                                <tr>
                                                    <th>Group</th>
                                                    <th>Species</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%--<c:forEach var="tg" items="${taxaGroups}">--%>
                                                    <%--<c:set var="indent">--%>
                                                        <%--<c:choose>--%>
                                                            <%--<c:when test="${tg.parentGroup == null}"></c:when>--%>
                                                            <%--<c:when test="${tg.parentGroup == 'ALL_LIFE'}">indent</c:when>--%>
                                                            <%--<c:otherwise>indent2</c:otherwise>--%>
                                                        <%--</c:choose>--%>
                                                    <%--</c:set>--%>
                                                    <%--<tr>--%>
                                                        <%--<td class="${indent}"><a href="${fn:join(tg.taxa, "|")}" id="${tg.rank}" title="${tg.label}" class="taxonBrowse">${tg.label}</a>--%>
                                                        <%--<td></td>--%>
                                                    <%--</tr>--%>
                                                <%--</c:forEach>--%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    </html>