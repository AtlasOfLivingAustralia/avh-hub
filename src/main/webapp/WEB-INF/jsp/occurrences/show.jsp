<%--                                                                                       userAssertionComments
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html>
<c:choose>
<c:when test="${not empty record.raw.occurrence.collectionCode && not empty record.raw.occurrence.catalogNumber}">
	<c:set var="recordId" value="${record.raw.occurrence.collectionCode}:${record.raw.occurrence.catalogNumber}"/>
</c:when>
<c:when test="${not empty record.raw.occurrence.occurrenceID}">
	<c:set var="recordId" value="${record.raw.occurrence.occurrenceID}"/>
</c:when>
<c:otherwise>
	<c:set var="recordId" value="${record.raw.uuid}"/>
</c:otherwise>
</c:choose>
<c:set var="bieWebappContext" scope="request"><ala:propertyLoader bundle="hubs" property="bieWebappContext"/></c:set>
<c:set var="collectionsWebappContext" scope="request"><ala:propertyLoader bundle="hubs" property="collectionsWebappContext"/></c:set>
<c:set var="useAla" scope="request"><ala:propertyLoader bundle="hubs" property="useAla"/></c:set>
<c:set var="hubDisplayName" scope="request"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="biocacheService" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>

<%--<c:set var="sensitiveDatasets" scope="request"><ala:propertyLoader bundle="hubs" property="sensitiveDatasets.NSW_DECCW"/></c:set>--%>
<c:set var="scientificName">
    <c:choose>
        <c:when test="${not empty record.processed.classification.scientificName}">
            ${record.processed.classification.scientificName} ${record.processed.classification.scientificNameAuthorship}
        </c:when>
        <c:when test="${not empty record.raw.classification.scientificName}">
            ${record.raw.classification.scientificName} ${record.raw.classification.scientificNameAuthorship}
        </c:when>
        <c:otherwise>
            ${record.raw.classification.genus} ${record.raw.classification.specificEpithet}
        </c:otherwise>
    </c:choose>
</c:set>
<html>
    <head>
        <!-- Skin selected: ${skin} -->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="${skin}"/>
        <title>Record ${recordId} | ${hubDisplayName} </title>
        <script type="text/javascript">
            contextPath = "${pageContext.request.contextPath}";
        </script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/record.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/button.css" type="text/css" media="screen" />
        <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/static/js/charts2.js"></script>
        <script type="text/javascript" language="javascript" src="http://collections.ala.org.au/js/datadumper.js"></script>
        <script type="text/javascript">
            /**
             * Delete a user assertion
             */
            function deleteAssertion(recordUuid, assertionUuid){
                $.post('${pageContext.request.contextPath}/occurrences/assertions/delete',
                    { recordUuid: recordUuid,assertionUuid: assertionUuid },
                    function(data) {
                        //retrieve all asssertions
                        $.get('${pageContext.request.contextPath}/occurrences/groupedAssertions?recordUuid=${record.raw.rowKey}', function(data) {
                            $('#'+assertionUuid).fadeOut('slow', function() {
                                $('#userAssertions').html(data);

                                //if theres no child elements to the list, hide the heading
                                //alert("Number of user assertions : " +  $('#userAssertions').children().size()   )
                                if($('#userAssertions').children().size() < 1){
                                    $('#userAssertionsContainer').hide("slow");
                                }
                            });
                        });
                    }
                );
            }
            
            /**
            * Convert camel case text to pretty version (all lower case)
            */
            function fileCase(str) {
                return str.replace(/([a-z])([A-Z])/g, "$1 $2").toLowerCase();
            }

            /**
             * JQuery on document ready callback
             */
            $(document).ready(function() {

                // add assertion form display
                $("#assertionButton, #verifyButton").fancybox({
                    //'href': '#loginOrFlag',
                    'hideOnContentClick' : false,
                    'hideOnOverlayClick': true,
                    'showCloseButton': true,
                    'titleShow' : false,
                    'autoDimensions' : true,
                    //'width': '500',
                    //'height': '400',
                    'padding': 15,
                    'margin': 10
                });
                
                // raw vs processed popup
                $("#showRawProcessed").fancybox({
                    //'href': '#loginOrFlag',
                    'hideOnContentClick' : false,
                    'hideOnOverlayClick': true,
                    'showCloseButton': true,
                    'titleShow' : false,
                    'centerOnScroll': true,
                    'transitionIn': 'elastic',
                    'transitionOut': 'elastic',
                    'speedIn': 500,
                    'speedOut': 500,
                    'autoDimensions' : false,
                    'width': '80%',
                    'height': '80%',
                    'padding': 15,
                    'margin': 10
                });

                // user flagged issues popup
                $("#showUserFlaggedIssues").fancybox({
                    //'href': '#loginOrFlag',
                    'hideOnContentClick' : false,
                    'hideOnOverlayClick': true,
                    'showCloseButton': true,
                    'titleShow' : false,
                    'centerOnScroll': true,
                    'transitionIn': 'elastic',
                    'transitionOut': 'elastic',
                    'speedIn': 500,
                    'speedOut': 500,
                    'autoDimensions' : false,
                    'width': '50%',
                    'height': '50%',
                    'padding': 15,
                    'margin': 10
                });


                // bind to form submit for assertions
                $("form#issueForm").submit(function(e) {
                    e.preventDefault();
                    var comment = $("#issueComment").val();
                    var code = $("#issue").val();
                    var userId = '${userId}';
                    var userDisplayName = '${userDisplayName}';
                    var recordUuid = '${record.raw.rowKey}';
                    if(code!=""){
                        $.post("${pageContext.request.contextPath}/occurrences/assertions/add",
                            { recordUuid: recordUuid, code: code, comment: comment, userId: userId, userDisplayName: userDisplayName},
                            function(data) {
                                $("#submitSuccess").html("Thanks for flagging the problem!");
                                $("#issueFormSubmit").hide();
                                $("input:reset").hide();
                                $("input#close").show();
                                //retrieve all asssertions
                                $.get('${pageContext.request.contextPath}/occurrences/groupedAssertions?recordUuid=${record.raw.rowKey}', function(data) {
                                    //console.log("data", data);
                                    $('#userAssertions').html(data);
                                    $('#userAssertionsContainer').show("slow");
                                });
                            }
                        );
                    } else {
                        alert("Please supply a issue type");
                    }
                });

                $(".userAssertionComment").each(function(i, el) {
                    var html = $(el).html();
                    $(el).html(replaceURLWithHTMLLinks(html)); // conver it
                });


                // bind to form "close" button
                $("input#close").live("click", function(e) {
                    // close the popup
                    $.fancybox.close();
                    // reset form back to default state
                    $('form#issueForm')[0].reset();
                    $("#submitSuccess").html("");
                    $("#issueFormSubmit").show("slow");
                    $("input:reset").show("slow");
                    $("input#close").hide("slow");
                });

                //var isConfirmed = {};
                // catch link to delete user assertion
                $("a.deleteAssertion").live('click', function(e) {
                    e.preventDefault();
                    var assertionUuid = $(this).attr("id");
                    var isConfirmed = confirm('Are you sure you want to delete this issue?');
                    if (isConfirmed === true) {
                        deleteAssertion('${record.raw.rowKey}', assertionUuid);
                    }
                    //isConfirmed = false; // don't remember the confirm
                });
                
                // give every second row a class="grey-bg"
                $('table#datasetTable, table#taxonomyTable, table#geospatialTable, table.inner').each(function(i, el) {
                    $(this).find('tr').each(function(j, tr) {
                        if (j % 2 == 0) {
                            $(this).addClass("grey-bg");
                        }
                    });
                });
                
                // convert camel case field names to "normal"
                $("td.dwc, span.dwc").each(function(i, el) {
                    var html = $(el).html();
                    $(el).html(fileCase(html)); // conver it
                });
                
                // load a JS map with sensitiveDatasets values from hubs.properties file
                var sensitiveDatasets = {
                    <c:forEach var="sds" items="${sensitiveDatasets}" varStatus="s">
                        ${sds}: '<ala:propertyLoader bundle="hubs" property="sensitiveDatasets.${sds}"/>'<c:if test="${not s.last}">,</c:if>
                    </c:forEach>
                }
                
                // add links for dataGeneralizations pages in collectory
                $("span.dataGeneralizations").each(function(i, el) {
                    var field = $(this);
                    var text = $(this).text().match(/\[.*?\]/g);
                    
                    if (text) {
                        $.each(text, function(j, el) {
                            var list = el.replace(/\[.*,(.*)\]/, "$1").trim();
                            var code = list.replace(/\s/g, "_").toUpperCase();
                            
                            if (sensitiveDatasets[code]) {
                                var linked = "<a href='" + sensitiveDatasets[code] + "' title='" + list 
                                    + " sensitive species list information page' target='collectory'>" + list + "</a>";
                                var regex = new RegExp(list, "g");
                                var html = $(field).html().replace(regex, linked);
                                $(field).html(html);
                            }
                        });
                    }
                });

                <c:if test="${not empty record.sounds}">
                    var myCirclePlayer = new CirclePlayer("#jquery_jplayer_1",
                    {
                        oga: "${record.sounds[0].alternativeFormats['audio/ogg']}",
                        mp4: "${record.sounds[0].alternativeFormats['audio/mpeg']}"
                    }, {
                        cssSelectorAncestor: "#cp_container_1"
                    });
                </c:if>
                
                <c:if test="${isCollectionAdmin}">
                    $("#confirmVerifyCheck").click(function(e) {
                        $("#verifyAsk").hide();
                        $("#verifyDone").show();
                    });
                    $(".cancelVerify").click(function(e) {
                        $.fancybox.close();
                    });
                    $("#confirmVerify").click(function(e) {
                        var code = "50000";
                        var userId = '${userId}';
                        var userDisplayName = '${userDisplayName}';
                        var recordUuid = '${record.raw.rowKey}';
                        // send assertion via AJAX... TODO catach errors
                        $.post("${pageContext.request.contextPath}/occurrences/assertions/add",
                            { recordUuid: recordUuid, code: code, userId: userId, userDisplayName: userDisplayName},
                            function(data) {
                                // service simply returns status or OK or FORBIDDEN, so assume it worked...
                                $("#verifyAsk").fadeOut();
                                $("#verifyDone").fadeIn();
                            }
                        );
                    });
                </c:if>
            }); // end JQuery document ready
            
            /*
             * IE doesn't support String.trim(), so add it in manually
             */
            if(typeof String.prototype.trim !== 'function') {
                String.prototype.trim = function() {
                    return this.replace(/^\s+|\s+$/g, ''); 
                }
            }

        function replaceURLWithHTMLLinks(text) {
            var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i;
            return text.replace(exp,"<a href='$1'>$1</a>");
        }

        function renderOutlierCharts(data){
           var query = 'lsid:"urn:lsid:biodiversity.org.au:afd.taxon:0c139726-2add-4abe-a714-df67b1d4b814"';
           $.each(data, function() {
               console.log("Render charts for LAYER: " + this.layerId +", outlier values: " +  this.outlierValues);
               drawChart(this.layerId, query, this.layerId+'Outliers', this.outlierValues, this.recordLayerValue, false);
               drawChart(this.layerId, query, this.layerId+'OutliersCumm', this.outlierValues, this.recordLayerValue, true);
           })
        }

        function drawChart(facetName, biocacheQuery, chartName, outlierValues, valueForThisRecord, cummalative){

            var facetChartOptions = { error: "badQuery", legend: 'right'}
            facetChartOptions.query = biocacheQuery;
            facetChartOptions.charts = [chartName];
            facetChartOptions[facetName] = {chartType: 'scatter'};

            //additional config
            facetChartOptions.cummalative = cummalative;
            facetChartOptions.outlierValues = outlierValues;    //retrieved from WS
            facetChartOptions.highlightedValue = valueForThisRecord;           //retrieved from the record

            console.log('Start the drawing...' + chartName);
            facetChartGroup.loadAndDrawFacetCharts(facetChartOptions);
            console.log('Finished the drawing...' + chartName);
        }

        google.load("visualization", "1", {packages:["corechart"]});
        </script>

    </head>
    <body>
        <spring:url var="json" value="/occurrences/${record.raw.uuid}.json" />
        <c:if test="${not empty record.raw}">
            <div id="headingBar" class="recordHeader">
                <h1>Occurrence Record: <span id="recordId">${recordId}</span></h1>
                <div id="jsonLink">
                    <c:if test="${isCollectionAdmin}">
                        <c:set var="admin" value=" - admin"/>
                    </c:if>
                    <c:if test="${not empty userDisplayName}">
                        Logged in as: ${userDisplayName} <!--(${userId}${admin})-->
                    </c:if>
                    <c:if test="${not empty clubView}">
                        Viewing "club view" of record
                    </c:if>
                    <!-- <a href="${json}">JSON</a> -->
                </div>
                <c:if test="${not empty record.raw.classification}">
                    <h2 id="headingSciName">
                        <c:choose>
                            <c:when test="${not empty record.processed.classification.scientificName}">
                                <alatag:formatSciName rankId="${record.processed.classification.taxonRankID}" name="${record.processed.classification.scientificName}"/>
                                ${record.processed.classification.scientificNameAuthorship}
                            </c:when>
                            <c:when test="${not empty record.raw.classification.scientificName}">
                                <alatag:formatSciName rankId="${record.raw.classification.taxonRankID}" name="${record.raw.classification.scientificName}"/>
                                ${record.raw.classification.scientificNameAuthorship}
                            </c:when>
                            <c:otherwise>
                                <i>${record.raw.classification.genus} ${record.raw.classification.specificEpithet}</i>
                                ${record.raw.classification.scientificNameAuthorship}
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${not empty record.processed.classification.vernacularName}">
                                | ${record.processed.classification.vernacularName}
                            </c:when>
                            <c:when test="${not empty record.raw.classification.vernacularName}">
                                | ${record.raw.classification.vernacularName}
                            </c:when>
                        </c:choose>
                    </h2>
                </c:if>
            </div>

            <div id="SidebarBox">
                <c:if test="${not empty collectionLogo}">
                    <div class="sidebar">
                        <img src="${collectionLogo}" alt="institution logo" id="institutionLogo"/>
                    </div>
                </c:if>
                <div class="sidebar">
                    <div id="warnings">

                        <div id="systemAssertionsContainer" <c:if test="${empty record.systemAssertions}">style="display:none"</c:if>>
                        <h2>Data validation issues</h2>
                        <!--<p class="half-padding-bottom">Data validation tools identified the following possible issues:</p>-->
                        <ul id="systemAssertions">
                            <c:forEach var="systemAssertion" items="${record.systemAssertions}">
                                <li>
                                    <c:if test="${empty systemAssertion.comment}">
                                        <spring:message code="${systemAssertion.name}" text="${systemAssertion.name}"/>
                                    </c:if>
                                    ${systemAssertion.comment}
                                </li>
                            </c:forEach>
                        </ul>
                        </div>

                        <div id="userAssertionsContainer" <c:if test="${empty record.userAssertions}">style="display:none"</c:if>>
                        <h2>User flagged issues</h2>
                        <ul id="userAssertions">
                        <!--<p class="half-padding-bottom">Users have highlighted the following possible issues:</p>-->
                            <alatag:groupedAssertions groupedAssertions="${groupedAssertions}" />
                        </ul>
                        <div id="userAssertionsDetailsLink"><a id="showUserFlaggedIssues" href="#userFlaggedIssuesDetails">
                            View issue list & comments
                        </a></div>
                        </div>
                    </div>
                </div>
                <div class="sidebar">
                    <c:if test="${isCollectionAdmin}">
                        <button class="rounded" id="verifyButton" href="#verifyRecord" >
                            <span id="verifyRecordSpan" title="">Verify Record</span>
                        </button>
                        <div style="display:none;">
                            <div id="verifyRecord">
                                <h3>Confirmation</h3>
                                <div id="verifyAsk">
                                    <p style="margin-bottom:10px;">Are you sure you want to verify this record as being correct?</p>
                                    <button id="confirmVerify">Confirm</button> 
                                    <button class="cancelVerify">Cancel</button> 
                                </div>
                                <div id="verifyDone" style="display:none;">
                                    Record successfully verified
                                    <br/>
                                    <button class="cancelVerify">Close</button> 
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <c:if test="${!isReadOnly}">
                <div class="sidebar">
                    <button class="rounded" id="assertionButton" href="#loginOrFlag">
                        <span id="loginOrFlagSpan" title="">Flag an Issue</span>
                    </button>
                    <div style="display:none">
                        <c:choose>
                        <c:when test="${empty userId}">
                            <div id="loginOrFlag">
                                Login please
                                <a href="https://auth.ala.org.au/cas/login?service=${initParam.serverName}${pageContext.request.contextPath}/occurrences/${record.raw.uuid}">Click here</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div id="loginOrFlag">
                                You are logged in as  <strong>${userDisplayName} (${userId})</strong>.
                                <form id="issueForm">
                                   <p style="margin-top:20px;">
                                        <label for="issue">Issue type:</label>
                                        <select name="issue" id="issue">
                                            <c:forEach items="${errorCodes}" var="code">
                                            <option value="${code.code}"><spring:message code="${code.name}" text="${code.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </p>
                                    <p style="margin-top:30px;">
                                        <label for="comment" style="vertical-align:top;">Comment:</label>
                                        <textarea name="comment" id="issueComment" style="width:380px;height:150px;" placeholder="Please add a comment here..."></textarea>
                                    </p>
                                    <p style="margin-top:20px;">
                                        <input id="issueFormSubmit" type="submit" value="Submit" />
                                        <input type="reset" value="Cancel" onClick="$.fancybox.close();"/>
                                        <input type="button" id="close" value="Close" style="display:none;"/>
                                        <span id="submitSuccess"></span>
                                    </p>
                                </form>
                            </div>
                        </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                </c:if>
                <div class="sidebar">
                    <button class="rounded" id="showRawProcessed" href="#processedVsRawView" title="Table showing both original and processed record values">
                        <span id="processedVsRawViewSpan" href="#processedVsRawView" title="">Original vs Processed</span>
                    </button>
                </div>
                <c:if test="${not empty record.processed.occurrence.images}">
                    <div class="sidebar">
                        <h2>Images</h2>
                        <c:forEach items="${record.processed.occurrence.images}" var="imageUrl">
                           <a href="${not empty record.raw.occurrence.occurrenceDetails ?  record.raw.occurrence.occurrenceDetails : imageUrl}" target="_blank"><img src="${imageUrl}" style="max-width: 250px;"/></a><br/>
                        </c:forEach>
                        <c:if test="${not empty record.raw.occurrence.rights}">
                        <cite>Rights: ${record.raw.occurrence.rights}</cite>
                        </c:if>
                    </div>
                </c:if>
                <c:if test="${not empty record.processed.location.decimalLatitude && not empty record.processed.location.decimalLongitude}">
                    <c:set var="latLngStr">
                        <c:choose>
                            <c:when test="${not empty clubView && record.raw.location.decimalLatitude != record.processed.location.decimalLatitude}">
                                ${record.raw.location.decimalLatitude},${record.raw.location.decimalLongitude}
                            </c:when>
                            <c:otherwise>
                                ${record.processed.location.decimalLatitude},${record.processed.location.decimalLongitude}
                            </c:otherwise>
                        </c:choose>
                    </c:set>
                    <div class="sidebar">

                        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
                        <script type="text/javascript">
                            $(document).ready(function() {
                                var latlng = new google.maps.LatLng(${latLngStr});
                                var myOptions = {
                                    zoom: 5,
                                    center: latlng,
                                    scrollwheel: false,
                                    scaleControl: true,
                                    streetViewControl: false,
                                    mapTypeControl: true,
                                    mapTypeControlOptions: {
                                        style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
                                        mapTypeIds: [google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.HYBRID, google.maps.MapTypeId.TERRAIN ]
                                    },
                                    mapTypeId: google.maps.MapTypeId.ROADMAP
                                };

                                var map = new google.maps.Map(document.getElementById("occurrenceMap"), myOptions);

                                var marker = new google.maps.Marker({
                                    position: latlng,
                                    map: map,
                                    title:"Occurrence Location"
                                });

                                <c:if test="${not empty record.processed.location.coordinateUncertaintyInMeters}">
                                        var radius = parseInt('${record.processed.location.coordinateUncertaintyInMeters}');

                                        if (!isNaN(radius)) {
                                            // Add a Circle overlay to the map.
                                            circle = new google.maps.Circle({
                                                map: map,
                                                radius: radius, // 3000 km
                                                strokeWeight: 1,
                                                strokeColor: 'white',
                                                strokeOpacity: 0.5,
                                                fillColor: '#2C48A6',
                                                fillOpacity: 0.2
                                            });
                                            // bind circle to marker
                                            circle.bindTo('center', marker, 'position');
                                        }
                            </c:if>
                                    });
                        </script>
                        <h2>Location of record</h2>
                        <div id="occurrenceMap"></div>
                    </div>
                </c:if>
                <c:if test="${not empty record.sounds}">
                    <style type="text/css">
                      .cp-play { left:-20px; top: -5px;}
                      .cp-pause { left:-20px; top: -5px; }
                      #soundsHeader { margin-top:15px; }
                    </style>
                    <div class="sidebar">
                        <h2 id="soundsHeader">Sounds</h2>
                        <!-- The jPlayer div must not be hidden. Keep it at the root of the body element to avoid any such problems. -->
                        <div id="jquery_jplayer_1" class="cp-jplayer"></div>
                        <div class="prototype-wrapper"> <!-- A wrapper to emulate use in a webpage and center align -->
                            <!-- The container for the interface can go where you want to display it. Show and hide it as you need. -->
                            <div id="cp_container_1" class="cp-container">
                                <div class="cp-buffer-holder"> <!-- .cp-gt50 only needed when buffer is > than 50% -->
                                    <div class="cp-buffer-1"></div>
                                    <div class="cp-buffer-2"></div>
                                </div>
                                <div class="cp-progress-holder"> <!-- .cp-gt50 only needed when progress is > than 50% -->
                                    <div class="cp-progress-1"></div>
                                    <div class="cp-progress-2"></div>
                                </div>
                                <div class="cp-circle-control"></div>
                                <ul class="cp-controls">
                                    <li><a href="#" class="cp-play" tabindex="1">play</a></li>
                                    <li><a href="#" class="cp-pause" style="display:none;" tabindex="1">pause</a></li>
                                    <!-- Needs the inline style here, or jQuery.show() uses display:inline instead of display:block -->
                                </ul>
                            </div>
                        </div>
                        <c:if test="${not empty record.raw.occurrence.rights}">
                        <cite>Rights: ${record.raw.occurrence.rights}</cite>
                        </c:if>
                        <p>Please press the play button to hear the sound file associated with this occurrence record.</p>
                    </div>
                 </c:if>
                 <c:if test="${not empty record.raw.lastModifiedTime && not empty record.processed.lastModifiedTime}">
                     <div class="sidebar" style="margin-top: 10px;font-size: 12px; color: #555;">
                         <c:catch var="parseError">
                             <fmt:parseDate var="rawLastModified" value="${record.raw.lastModifiedTime}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'"/>
                             <fmt:formatDate var="rawLastModifiedString" value="${rawLastModified}" pattern="yyyy-MM-dd"/>
                             <fmt:parseDate var="processedLastModified" value="${record.processed.lastModifiedTime}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'"/>
                             <fmt:formatDate var="processedLastModifiedString" value="${processedLastModified}" pattern="yyyy-MM-dd"/>
                         </c:catch>
                         <c:if test="${not empty parseError}">
                             <c:set var="rawLastModifiedString" value="${record.raw.lastModifiedTime}"/>
                             <c:set var="processedLastModifiedString" value="${record.processed.lastModifiedTime}"/>
                         </c:if>
                         Date loaded: ${rawLastModifiedString}<br/>
                         Date last processed: ${processedLastModifiedString}<br/>
                     </div>
                 </c:if>
            </div><!-- end div#SidebarBox -->
            <div id="content2">
                <% Map fieldsMap = new HashMap(); pageContext.setAttribute("fieldsMap", fieldsMap); %>
                <%-- c:set target="${fieldsMap}" property="aKey" value="value for a key" /--%>
                <div id="occurrenceDataset">
                    <h3>Dataset</h3>
                    <table class="occurrenceTable" id="datasetTable">
                        <c:if test="${useAla == 'true'}">
                            <!-- Data Provider -->
                            <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="dataProvider" fieldName="Data Provider">
                                <c:choose>
                                    <c:when test="${record.processed.attribution.dataProviderUid != null && not empty record.processed.attribution.dataProviderUid}">
                                        <c:set target="${fieldsMap}" property="dataProviderUid" value="true" />
                                        <c:set target="${fieldsMap}" property="dataProviderName" value="true" />
                                        <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.dataProviderUid}">
                                            ${record.processed.attribution.dataProviderName}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set target="${fieldsMap}" property="dataProviderName" value="true" />
                                        ${record.processed.attribution.dataProviderName}
                                    </c:otherwise>
                                </c:choose>
                            </alatag:occurrenceTableRow>
                            <!-- Data Resource -->
                            <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="dataResource" fieldName="Data Set">
                                <c:choose>
                                    <c:when test="${record.raw.attribution.dataResourceUid != null && not empty record.raw.attribution.dataResourceUid}">
                                        <c:set target="${fieldsMap}" property="dataResourceUid" value="true" />
                                        <c:set target="${fieldsMap}" property="dataResourceName" value="true" />
                                        <a href="${collectionsWebappContext}/public/show/${record.raw.attribution.dataResourceUid}">
                                            ${record.processed.attribution.dataResourceName}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set target="${fieldsMap}" property="dataResourceName" value="true" />
                                        ${record.processed.attribution.dataResourceName}
                                    </c:otherwise>
                                </c:choose>
                            </alatag:occurrenceTableRow>
                        </c:if>
                        <!-- Institution -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="institutionCode" fieldName="Institution">
                            <c:choose>
                                <c:when test="${record.processed.attribution.institutionUid != null && not empty record.processed.attribution.institutionUid}">
                                    <c:set target="${fieldsMap}" property="institutionUid" value="true" />
                                    <c:set target="${fieldsMap}" property="institutionName" value="true" />
                                    <!-- <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.institutionUid}"> -->
                                    <c:choose>
                                        <c:when test="${useAla == 'true'}">
                                            <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.institutionUid}">
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/institution/${record.processed.attribution.institutionUid}">
                                        </c:otherwise>
                                    </c:choose>
                                        ${record.processed.attribution.institutionName}
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <c:set target="${fieldsMap}" property="institutionName" value="true" />
                                    ${record.processed.attribution.institutionName}
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty record.raw.occurrence.institutionCode}">
                                <c:set target="${fieldsMap}" property="institutionCode" value="true" />
                                <br/><span class="originalValue">Supplied as "${record.raw.occurrence.institutionCode}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Collection -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="collectionCode" fieldName="Collection">
                            <c:if test="${not empty record.processed.attribution.collectionUid}">
                                <c:set target="${fieldsMap}" property="collectionUid" value="true" />
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                       <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.collectionUid}">
                                    </c:when>
                                    <c:otherwise>
                                       <a href="${pageContext.request.contextPath}/collection/${record.processed.attribution.collectionUid}" title="view collection page">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty record.processed.attribution.collectionName}">
                                    <c:set target="${fieldsMap}" property="collectionName" value="true" />
                                    ${record.processed.attribution.collectionName}
                                </c:when>
                                <c:when test="${not empty collectionName}">
                                    <c:set target="${fieldsMap}" property="collectionName" value="true" />
                                    ${collectionName}
                                </c:when>
                            </c:choose>
                            <c:if test="${not empty record.processed.attribution.collectionUid}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.raw.occurrence.collectionCode}">
                                <c:set target="${fieldsMap}" property="collectionCode" value="true" />
                                <br/><span class="originalValue">Supplied as "${record.raw.occurrence.collectionCode}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Catalog Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="catalogueNumber" fieldName="Catalogue Number">
                            <c:set target="${fieldsMap}" property="catalogNumber" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.catalogNumber && not empty record.raw.occurrence.catalogNumber}">
                                    ${record.processed.occurrence.catalogNumber}
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.catalogNumber}"</span>
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.occurrence.catalogNumber}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Other Catalog Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="otherCatalogNumbers" fieldName="Other Catalogue Numbers">
                            <c:set target="${fieldsMap}" property="otherCatalogNumbers" value="true" />
                            ${record.raw.occurrence.otherCatalogNumbers}
                        </alatag:occurrenceTableRow>
                        <!-- Record Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="recordNumber" fieldName="Record number">
                        <c:set target="${fieldsMap}" property="recordNumber" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.recordNumber && not empty record.raw.occurrence.recordNumber}">
                                    ${record.processed.occurrence.recordNumber}
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.recordNumber}"</span>
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.occurrence.recordNumber}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="citation" fieldName="Record citation">
                            <c:set target="${fieldsMap}" property="citation" value="true" />
                            ${record.raw.attribution.citation}
                        </alatag:occurrenceTableRow>                        
                        <!-- Occurrence ID -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="occurrenceID" fieldName="Occurrence ID">
                            <c:set target="${fieldsMap}" property="occurrenceID" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.occurrenceID && not empty record.raw.occurrence.occurrenceID}">
                                    <c:if test="${fn:startsWith(record.processed.occurrence.occurrenceID,'http://')}"><a href="${record.processed.occurrence.occurrenceID}" target="_blank"></c:if>
                                    ${record.processed.occurrence.occurrenceID}
                                    <c:if test="${fn:startsWith(record.processed.occurrence.occurrenceID,'http://')}"></a></c:if>                                    
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.occurrenceID}"</span>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${fn:startsWith(record.raw.occurrence.occurrenceID,'http://')}"><a href="${record.raw.occurrence.occurrenceID}" target="_blank"></c:if>
                                    ${record.raw.occurrence.occurrenceID}
                                    <c:if test="${fn:startsWith(record.raw.occurrence.occurrenceID,'http://')}"></a></c:if>                                                                        
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="citation" fieldName="Record citation">
                            <c:set target="${fieldsMap}" property="citation" value="true" />
                            ${record.raw.attribution.citation}
                        </alatag:occurrenceTableRow>                        
                        <!--
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="recordUuid" fieldName="Record UUID">
                            <c:set target="${fieldsMap}" property="recordUuid" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.uuid}">
                                    ${record.processed.uuid}
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.uuid}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        -->
                        <!-- Basis of Record -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="basisOfRecord" fieldName="Basis of Record">
                            <c:set target="${fieldsMap}" property="basisOfRecord" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.basisOfRecord && not empty record.raw.occurrence.basisOfRecord}">
                                    ${record.processed.occurrence.basisOfRecord}
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.basisOfRecord}"</span>
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.occurrence.basisOfRecord}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>

                        <!-- Record Date -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="occurrenceDate" fieldName="Record Date">
                            <c:set target="${fieldsMap}" property="eventDate" value="true" />
                            <c:if test="${empty record.processed.event.eventDate && record.raw.event.eventDate && empty record.raw.event.year && empty record.raw.event.month && empty record.raw.event.day}">
                                [date not supplied]
                            </c:if>
                            <c:if test="${not empty record.processed.event.eventDate}">
                               ${record.processed.event.eventDate}
                            </c:if>
                            <c:if test="${empty record.processed.event.eventDate && (not empty record.processed.event.year || not empty record.processed.event.month || not empty record.processed.event.day)}">
                                Year: ${record.processed.event.year},
                                Month: ${record.processed.event.month},
                                Day: ${record.processed.event.day}
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty record.raw.event.eventDate}">
                                    <br/><span class="originalValue">Supplied as "${record.raw.event.eventDate}"</span>
                                </c:when>
                                <c:when test="${not empty record.raw.event.year || not empty record.raw.event.month || not empty record.raw.event.day}">
                                    <br/><span class="originalValue">Supplied as  "year: ${record.raw.event.year}, month: ${record.raw.event.month}, day: ${record.raw.event.day}"</span>
                                </c:when>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Identifier Name -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierName" fieldName="Identified by">
                            <c:set target="${fieldsMap}" property="identifiedBy" value="true" />
                            ${record.raw.identification.identifiedBy}
                        </alatag:occurrenceTableRow>
                        <!-- Identified Date -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierDate" fieldName="Identified date">
                            <c:set target="${fieldsMap}" property="identifierDate" value="true" />
                            ${record.raw.identification.dateIdentified}
                        </alatag:occurrenceTableRow>
                        <!-- Field Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="fieldNumber" fieldName="Field number">
                            <c:set target="${fieldsMap}" property="fieldNumber" value="true" />
                            ${record.raw.occurrence.fieldNumber}
                        </alatag:occurrenceTableRow>
                        <!-- Field Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identificationRemarks" fieldName="Identification remarks">
                            <c:set target="${fieldsMap}" property="identificationRemarks" value="true" />
                            ${record.raw.identification.identificationRemarks}
                        </alatag:occurrenceTableRow>
                        <!-- Collector/Observer -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="collectorName" fieldName="Collector/Observer">
                            <c:set target="${fieldsMap}" property="recordedBy" value="true" />
                            <c:set var="rawRecordedBy" value="${(fn:contains(record.raw.occurrence.recordedBy, '@')) 
                                                                ? fn:substringBefore(record.raw.occurrence.recordedBy,'@') 
                                                                : record.raw.occurrence.recordedBy}"/>
                            <c:set var="proRecordedBy" value="${(fn:contains(record.processed.occurrence.recordedBy, '@')) 
                                                                ? fn:substringBefore(record.processed.occurrence.recordedBy,'@') 
                                                                : record.processed.occurrence.recordedBy}"/>
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.recordedBy && not empty record.raw.occurrence.recordedBy}">
                                    ${proRecordedBy}
                                    <br/><span class="originalValue">Supplied as "${rawRecordedBy}"</span>
                                </c:when>
                                <c:when test="${not empty record.processed.occurrence.recordedBy}">
                                    ${proRecordedBy}
                                </c:when>
                                <c:when test="${not empty record.raw.occurrence.recordedBy}">
                                    ${rawRecordedBy}
                                </c:when>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Sampling Protocol -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="samplingProtocol" fieldName="Sampling protocol">
                            <c:set target="${fieldsMap}" property="samplingProtocol" value="true" />
                            ${record.raw.occurrence.samplingProtocol}
                        </alatag:occurrenceTableRow>
                        <!-- Type Status -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="typeStatus" fieldName="Type status">
                            <c:set target="${fieldsMap}" property="typeStatus" value="true" />
                            ${record.raw.identification.typeStatus}
                        </alatag:occurrenceTableRow>
                        <!-- Identification Qualifier -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identificationQualifier" fieldName="Identification Qualifier">
                            <c:set target="${fieldsMap}" property="identificationQualifier" value="true" />
                            ${record.raw.identification.identificationQualifier}
                        </alatag:occurrenceTableRow>
                        <!-- Reproductive Condition -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="reproductiveCondition" fieldName="Reproductive condition">
                            <c:set target="${fieldsMap}" property="reproductiveCondition" value="true" />
                            ${record.raw.occurrence.reproductiveCondition}
                        </alatag:occurrenceTableRow>
                        <!-- Sex -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="sex" fieldName="Sex">
                            <c:set target="${fieldsMap}" property="sex" value="true" />
                            ${record.raw.occurrence.sex}
                        </alatag:occurrenceTableRow>
                        <!-- Behavior -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="behavior" fieldName="Behaviour">
                            <c:set target="${fieldsMap}" property="behavior" value="true" />
                            ${record.raw.occurrence.behavior}
                        </alatag:occurrenceTableRow>
                        <!-- Individual count -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="individualCount" fieldName="Individual count">
                            <c:set target="${fieldsMap}" property="individualCount" value="true" />
                            ${record.raw.occurrence.individualCount}
                        </alatag:occurrenceTableRow>
                        <!-- Life stage -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="lifeStage" fieldName="Life stage">
                            <c:set target="${fieldsMap}" property="lifeStage" value="true" />
                            ${record.raw.occurrence.lifeStage}
                        </alatag:occurrenceTableRow>
                        <!-- Preparations -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="preparations" fieldName="Preparations">
                            <c:set target="${fieldsMap}" property="preparations" value="true" />
                            ${record.raw.occurrence.preparations}
                        </alatag:occurrenceTableRow>
                        <!-- Rights -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="rights" fieldName="Rights">
                            <c:set target="${fieldsMap}" property="rights" value="true" />
                            ${record.raw.occurrence.rights}
                        </alatag:occurrenceTableRow>
                        <!-- Occurrence details -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="occurrenceDetails" fieldName="More details">
                            <c:set target="${fieldsMap}" property="occurrenceDetails" value="true" />
                            <c:if test="${not empty record.raw.occurrence.occurrenceDetails && fn:startsWith(record.raw.occurrence.occurrenceDetails,'http://')}"><a href="${record.raw.occurrence.occurrenceDetails}" target="_blank">${record.raw.occurrence.occurrenceDetails}</a>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- output any tags not covered already (excluding those in dwcExcludeFields) -->
                        <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Attribution" exclude="${dwcExcludeFields}"/>
                        <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Occurrence" exclude="${dwcExcludeFields}"/>
                        <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Event" exclude="${dwcExcludeFields}"/>
                        <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Identification" exclude="${dwcExcludeFields}"/>
                    </table>
                </div>
                <div id="occurrenceTaxonomy">
                    <h3>Taxonomy</h3>
                    <table class="occurrenceTable" id="taxonomyTable">
                        <!-- Higher classification -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="higherClassification" fieldName="Higher classification">
                            <c:set target="${fieldsMap}" property="higherClassification" value="true" />
                            ${record.raw.classification.higherClassification}
                        </alatag:occurrenceTableRow>

                        <!-- Scientific name -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="scientificName" fieldName="Scientific name">
                            <c:set target="${fieldsMap}" property="taxonConceptID" value="true" />
                            <c:set target="${fieldsMap}" property="scientificName" value="true" />
                            <c:set var="baseTaxonUrl">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">${bieWebappContext}/species/</c:when>
                                    <c:otherwise>${pageContext.request.contextPath}/taxa/</c:otherwise>
                                </c:choose>
                            </c:set>
                            <c:if test="${not empty record.processed.classification.taxonConceptID}">
                                <a href="${baseTaxonUrl}${record.processed.classification.taxonConceptID}">
                            </c:if>
                            <c:if test="${record.processed.classification.taxonRankID > 5000}"><i></c:if>
                            ${record.processed.classification.scientificName}
                            <c:if test="${record.processed.classification.taxonRankID > 5000}"></i></c:if>
                            <c:if test="${not empty record.processed.classification.taxonConceptID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.scientificName && not empty record.raw.classification.scientificName && (fn:toLowerCase(record.processed.classification.scientificName) != fn:toLowerCase(record.raw.classification.scientificName))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.scientificName}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>

                        <!-- original name usage -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="originalNameUsage" fieldName="Original Name">
                            <c:set target="${fieldsMap}" property="originalNameUsage" value="true" />
                            <c:set target="${fieldsMap}" property="originalNameUsageID" value="true" />
                            <c:if test="${not empty record.processed.classification.originalNameUsageID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.originalNameUsageID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.originalNameUsageID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.originalNameUsage}">
                                ${record.processed.classification.originalNameUsage}
                            </c:if>
                            <c:if test="${empty record.processed.classification.originalNameUsage && not empty record.raw.classification.originalNameUsage}">
                                ${record.raw.classification.originalNameUsage}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.originalNameUsageID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.originalNameUsage && not empty record.raw.classification.originalNameUsage && (fn:toLowerCase(record.processed.classification.originalNameUsage) != fn:toLowerCase(record.raw.classification.originalNameUsage))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.originalNameUsage}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>

                        <!-- Taxon Rank -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="taxonRank" fieldName="Taxon rank">
                            <c:set target="${fieldsMap}" property="taxonRank" value="true" />
                            <c:set target="${fieldsMap}" property="taxonRankID" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.classification.taxonRank}">
                                    <span style="text-transform: capitalize;">${record.processed.classification.taxonRank}</span>
                                </c:when>
                                <c:when test="${empty record.processed.classification.taxonRank && not empty record.raw.classification.taxonRank}">
                                    <span style="text-transform: capitalize;">${record.raw.classification.taxonRank}</span>
                                </c:when>
                                <c:otherwise>
                                    [rank not known]
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty record.processed.classification.taxonRank && not empty record.raw.classification.taxonRank  && (fn:toLowerCase(record.processed.classification.taxonRank) != fn:toLowerCase(record.raw.classification.taxonRank))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.taxonRank}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Common name -->
                        <alatag:occurrenceTableRow annotate="false" section="taxonomy" fieldCode="commonName" fieldName="Common name">
                            <c:set target="${fieldsMap}" property="vernacularName" value="true" />
                            <c:if test="${not empty record.processed.classification.vernacularName}">
                                ${record.processed.classification.vernacularName}
                            </c:if>
                            <c:if test="${empty record.processed.classification.vernacularName && not empty record.raw.classification.vernacularName}">
                                ${record.raw.classification.vernacularName}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.vernacularName && not empty record.raw.classification.vernacularName && (fn:toLowerCase(record.processed.classification.vernacularName) != fn:toLowerCase(record.raw.classification.vernacularName))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.vernacularName}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Kingdom -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="kingdom" fieldName="Kingdom">
                            <c:set target="${fieldsMap}" property="kingdom" value="true" />
                            <c:set target="${fieldsMap}" property="kingdomID" value="true" />
                            <c:if test="${not empty record.processed.classification.kingdomID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.kingdomID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.kingdomID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.kingdom}">
                                ${record.processed.classification.kingdom}
                            </c:if>
                            <c:if test="${empty record.processed.classification.kingdom && not empty record.raw.classification.kingdom}">
                                ${record.raw.classification.kingdom}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.kingdomID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.kingdom && not empty record.raw.classification.kingdom && (fn:toLowerCase(record.processed.classification.kingdom) != fn:toLowerCase(record.raw.classification.kingdom))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.kingdom}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Phylum -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="phylum" fieldName="Phylum">
                            <c:set target="${fieldsMap}" property="phylum" value="true" />
                            <c:set target="${fieldsMap}" property="phylumID" value="true" />
                            <c:if test="${not empty record.processed.classification.phylumID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.phylumID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.phylumID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.phylum}">
                                ${record.processed.classification.phylum}
                            </c:if>
                            <c:if test="${empty record.processed.classification.phylum && not empty record.raw.classification.phylum}">
                                ${record.raw.classification.phylum}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.phylumID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.phylum && not empty record.raw.classification.phylum && (fn:toLowerCase(record.processed.classification.phylum) != fn:toLowerCase(record.raw.classification.phylum))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.phylum}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Class -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="classs" fieldName="Class">
                            <c:set target="${fieldsMap}" property="classs" value="true" />
                            <c:set target="${fieldsMap}" property="classID" value="true" />
                            <c:if test="${not empty record.processed.classification.classID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.classID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.classID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.classs}">
                                ${record.processed.classification.classs}
                            </c:if>
                            <c:if test="${empty record.processed.classification.classs && not empty record.raw.classification.classs}">
                                ${record.raw.classification.classs}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.classID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.classs && not empty record.raw.classification.classs && (fn:toLowerCase(record.processed.classification.classs) != fn:toLowerCase(record.raw.classification.classs))}">
                                <br/><span classs="originalValue">Supplied as "${record.raw.classification.classs}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Order -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="order" fieldName="Order">
                            <c:set target="${fieldsMap}" property="order" value="true" />
                            <c:set target="${fieldsMap}" property="orderID" value="true" />
                            <c:if test="${not empty record.processed.classification.orderID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.orderID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.orderID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.order}">
                                ${record.processed.classification.order}
                            </c:if>
                            <c:if test="${empty record.processed.classification.order && not empty record.raw.classification.order}">
                                ${record.raw.classification.order}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.orderID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.order && not empty record.raw.classification.order && (fn:toLowerCase(record.processed.classification.order) != fn:toLowerCase(record.raw.classification.order))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.order}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Family -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="family" fieldName="Family">
                            <c:set target="${fieldsMap}" property="family" value="true" />
                            <c:set target="${fieldsMap}" property="familyID" value="true" />
                            <c:if test="${not empty record.processed.classification.familyID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.familyID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.familyID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.family}">
                                ${record.processed.classification.family}
                            </c:if>
                            <c:if test="${empty record.processed.classification.family && not empty record.raw.classification.family}">
                                ${record.raw.classification.family}
                            </c:if>
                            <c:if test="${not empty record.processed.classification.familyID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.family && not empty record.raw.classification.family && (fn:toLowerCase(record.processed.classification.family) != fn:toLowerCase(record.raw.classification.family))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.classification.family}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Genus -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="genus" fieldName="Genus">
                            <c:set target="${fieldsMap}" property="genus" value="true" />
                            <c:set target="${fieldsMap}" property="genusID" value="true" />
                            <c:if test="${not empty record.processed.classification.genusID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.genusID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.genusID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.genus}">
                                <i>${record.processed.classification.genus}</i>
                            </c:if>
                            <c:if test="${empty record.processed.classification.genus && not empty record.raw.classification.genus}">
                                <i>${record.raw.classification.genus}</i>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.genusID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.genus && not empty record.raw.classification.genus && (fn:toLowerCase(record.processed.classification.genus) != fn:toLowerCase(record.raw.classification.genus))}">
                                <br/><span class="originalValue">Supplied as "<i>${record.raw.classification.genus}</i>"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Species -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="species" fieldName="Species">
                            <c:set target="${fieldsMap}" property="species" value="true" />
                            <c:set target="${fieldsMap}" property="speciesID" value="true" />
                            <c:set target="${fieldsMap}" property="specificEpithet" value="true" />
                            <c:if test="${not empty record.processed.classification.speciesID}">
                                <c:choose>
                                    <c:when test="${useAla == 'true'}">
                                         <a href="${bieWebappContext}/species/${record.processed.classification.speciesID}">
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.speciesID}">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty record.processed.classification.species}">
                                    <i>${record.processed.classification.species}</i>
                                </c:when>
                                <c:when test="${not empty record.raw.classification.species}">
                                    <i>${record.raw.classification.species}</i>
                                </c:when>
                                <c:when test="${not empty record.raw.classification.specificEpithet && not empty record.raw.classification.genus}">
                                    <i>${record.raw.classification.genus} ${record.raw.classification.specificEpithet}</i>
                                </c:when>
                            </c:choose>
                            <c:if test="${not empty record.processed.classification.speciesID}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.processed.classification.species && not empty record.raw.classification.species && (fn:toLowerCase(record.processed.classification.species) != fn:toLowerCase(record.raw.classification.species))}">
                                <br/><span class="originalValue">Supplied as "<i>${record.raw.classification.species}</i>"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Associated Taxa -->
                        <c:if test="${not empty record.raw.occurrence.associatedTaxa}">
                            <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="associatedTaxa" fieldName="Associated species">
                                <c:set target="${fieldsMap}" property="associatedTaxa" value="true" />
                                <c:set var="colon" value=":"/>
                                <c:choose>
                                    <c:when test="${fn:contains(record.raw.occurrence.associatedTaxa,colon)}">
                                        <c:set var="associatedName" value="${fn:substringAfter(record.raw.occurrence.associatedTaxa,colon)}"/>
                                        ${fn:substringBefore(record.raw.occurrence.associatedTaxa,colon) }: <a href="${bieWebappContext}/species/${fn:replace(associatedName, '  ', ' ')}">${associatedName}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${bieWebappContext}/species/${fn:replace(record.raw.occurrence.associatedTaxa, '  ', ' ')}">${record.raw.occurrence.associatedTaxa}</a>
                                    </c:otherwise>
                                </c:choose>
                            </alatag:occurrenceTableRow>
                        </c:if>
                        <!-- output any tags not covered already (excluding those in dwcExcludeFields) -->
                        <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Classification" exclude="${dwcExcludeFields}"/>
                    </table>
                </div>
                <div id="geospatialTaxonomy">
                    <h3>Geospatial</h3>
                    <table class="occurrenceTable" id="geospatialTable">
                        <!-- Higher Geography -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="higherGeography" fieldName="Higher geography">
                            <c:set target="${fieldsMap}" property="higherGeography" value="true" />
                            ${record.raw.location.higherGeography}
                        </alatag:occurrenceTableRow>
                        <!-- Country -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="country" fieldName="Country">
                            <c:set target="${fieldsMap}" property="country" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.location.country}">
                                    ${record.processed.location.country}
                                </c:when>
                                <c:when test="${not empty record.processed.location.countryCode}">
                                    <fmt:message key="country.${record.processed.location.countryCode}"/>
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.location.country}
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty record.processed.location.country && not empty record.raw.location.country && (fn:toLowerCase(record.processed.location.country) != fn:toLowerCase(record.raw.location.country))}">
                                <br/><span class="originalValue">Supplied as "${record.raw.location.country}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- State/Province -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="state" fieldName="State/Province">
                            <c:set target="${fieldsMap}" property="stateProvince" value="true" />
                            <c:set var="stateValue" value="${not empty record.processed.location.stateProvince ? record.processed.location.stateProvince : record.raw.location.stateProvince}" />
                            <c:if test="${not empty stateValue}">
                                <%--<a href="${bieWebappContext}/regions/aus_states/${stateValue}">--%>${stateValue}<%--</a>--%>
                            </c:if>
                            <c:if test="${not empty record.processed.location.stateProvince && not empty record.raw.location.stateProvince && (fn:toLowerCase(record.processed.location.stateProvince) != fn:toLowerCase(record.raw.location.stateProvince))}">
                                <br/><span class="originalValue">Supplied as: "${record.raw.location.stateProvince}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Locality -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locality" fieldName="Locality">
                            <c:set target="${fieldsMap}" property="locality" value="true" />
                            <c:if test="${not empty record.processed.location.locality}">
                                ${record.processed.location.locality}
                            </c:if>
                            <c:if test="${empty record.processed.location.locality && not empty record.raw.location.locality}">
                                ${record.raw.location.locality}
                            </c:if>
                            <c:if test="${not empty record.processed.location.locality && not empty record.raw.location.locality && (fn:toLowerCase(record.processed.location.locality) != fn:toLowerCase(record.raw.location.locality))}">
                                <br/><span class="originalValue">Supplied as: "${record.raw.location.locality}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Biogeographic Region -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="biogeographicRegion" fieldName="Biogeographic region">
                            <c:set target="${fieldsMap}" property="ibra" value="true" />
                            <c:if test="${not empty record.processed.location.ibra}">
                                ${record.processed.location.ibra}
                            </c:if>
                            <c:if test="${empty record.processed.location.ibra && not empty record.raw.location.ibra}">
                                ${record.raw.location.ibra}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Local Govt Area -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locality" fieldName="Local Govt Area">
                            <c:set target="${fieldsMap}" property="lga" value="true" />
                            <c:if test="${not empty record.processed.location.lga}">
                                ${record.processed.location.lga}
                            </c:if>
                            <c:if test="${empty record.processed.location.lga && not empty record.raw.location.lga}">
                                ${record.raw.location.lga}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Habitat -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="habitat" fieldName="Terrestrial/Marine">
                            <c:set target="${fieldsMap}" property="habitat" value="true" />
                            ${record.processed.location.habitat}
                        </alatag:occurrenceTableRow>
                        <!-- Latitude -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="latitude" fieldName="Latitude">
                            <c:set target="${fieldsMap}" property="decimalLatitude" value="true" />
                            <c:choose>
                                <c:when test="${not empty clubView && record.raw.location.decimalLatitude != record.processed.location.decimalLatitude}">
                                    ${record.raw.location.decimalLatitude}
                                </c:when>
                                <c:when test="${not empty record.raw.location.decimalLatitude && record.raw.location.decimalLatitude != record.processed.location.decimalLatitude}">
                                    ${record.processed.location.decimalLatitude}<br/><span class="originalValue">Supplied as: "${record.raw.location.decimalLatitude}"</span>
                                </c:when>
                                <c:when test="${not empty record.processed.location.decimalLatitude}">
                                    ${record.processed.location.decimalLatitude}
                                </c:when>
                                <c:when test="${not empty record.raw.location.decimalLatitude}">
                                    ${record.raw.location.decimalLatitude}
                                </c:when>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Longitude -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="longitude" fieldName="Longitude">
                            <c:set target="${fieldsMap}" property="decimalLongitude" value="true" />
                            <c:choose>
                                <c:when test="${not empty clubView && record.raw.location.decimalLongitude != record.processed.location.decimalLongitude}">
                                    ${record.raw.location.decimalLongitude}
                                </c:when>
                                <c:when test="${not empty record.raw.location.decimalLongitude && record.raw.location.decimalLongitude != record.processed.location.decimalLongitude}">
                                    ${record.processed.location.decimalLongitude}<br/><span class="originalValue">Supplied as: "${record.raw.location.decimalLongitude}"</span>
                                </c:when>
                                <c:when test="${not empty record.processed.location.decimalLongitude}">
                                    ${record.processed.location.decimalLongitude}
                                </c:when>
                                <c:when test="${not empty record.raw.location.decimalLongitude}">
                                    ${record.raw.location.decimalLongitude}
                                </c:when>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Geodetic datum -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="geodeticDatum" fieldName="Geodetic datum">
                            <c:set target="${fieldsMap}" property="geodeticDatum" value="true" />
                            ${record.raw.location.geodeticDatum}
                        </alatag:occurrenceTableRow>
                        <!-- verbatimCoordinateSystem -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="verbatimCoordinateSystem" fieldName="Verbatim Coordinate System">
                            <c:set target="${fieldsMap}" property="verbatimCoordinateSystem" value="true" />
                            ${record.raw.location.verbatimCoordinateSystem}
                        </alatag:occurrenceTableRow>
                        <!-- Verbatim locality -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="verbatimLocality" fieldName="Verbatim locality">
                            <c:set target="${fieldsMap}" property="verbatimLocality" value="true" />
                            ${record.raw.location.verbatimLocality}
                        </alatag:occurrenceTableRow>
                        <!-- Water Body -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="waterBody" fieldName="Water body">
                            <c:set target="${fieldsMap}" property="waterBody" value="true" />
                            ${record.raw.location.waterBody}
                        </alatag:occurrenceTableRow>
                        <!-- Min depth -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="minimumDepthInMeters" fieldName="Minimum Depth In Metres">
                            <c:set target="${fieldsMap}" property="minimumDepthInMeters" value="true" />
                            ${record.raw.location.minimumDepthInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Max depth -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="maximumDepthInMeters" fieldName="Maximum Depth In Metres">
                            <c:set target="${fieldsMap}" property="maximumDepthInMeters" value="true" />
                            ${record.raw.location.maximumDepthInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Min elevation -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="minimumElevationInMeters" fieldName="Minimum Elevation In Metres">
                            <c:set target="${fieldsMap}" property="minimumElevationInMeters" value="true" />
                            ${record.raw.location.minimumElevationInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Max elevation -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="maximumElevationInMeters" fieldName="Maximum Elevation In Metres">
                            <c:set target="${fieldsMap}" property="maximumElevationInMeters" value="true" />
                            ${record.raw.location.maximumElevationInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Island -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="island" fieldName="Island">
                            <c:set target="${fieldsMap}" property="island" value="true" />
                            ${record.raw.location.island}
                        </alatag:occurrenceTableRow>
                        <!-- Island Group-->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="islandGroup" fieldName="Island group">
                            <c:set target="${fieldsMap}" property="islandGroup" value="true" />
                            ${record.raw.location.islandGroup}
                        </alatag:occurrenceTableRow>
                        <!-- Location remarks -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locationRemarks" fieldName="Location Remarks">
                            <c:set target="${fieldsMap}" property="locationRemarks" value="true" />
                            ${record.raw.location.locationRemarks}
                        </alatag:occurrenceTableRow>
                        <!-- Occurrence remarks -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="occurrenceRemarks" fieldName="Occurrence Remarks">
                            <c:set target="${fieldsMap}" property="occurrenceRemarks" value="true" />
                            ${record.raw.occurrence.occurrenceRemarks}
                        </alatag:occurrenceTableRow>
                        <!-- Field notes -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="fieldNotes" fieldName="Field Notes">
                            <c:set target="${fieldsMap}" property="fieldNotes" value="true" />
                            ${record.raw.occurrence.fieldNotes}
                        </alatag:occurrenceTableRow>
                        <!-- Coordinate Precision -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinatePrecision" fieldName="Coordinate Precision">
                            <c:set target="${fieldsMap}" property="coordinatePrecision" value="true" />
                            <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                                ${not empty record.processed.location.coordinatePrecision ? record.processed.location.coordinatePrecision : 'Unknown'}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Coordinate Uncertainty -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinateUncertaintyInMeters" fieldName="Coordinate Uncertainty (metres)">
                            <c:set target="${fieldsMap}" property="coordinateUncertaintyInMeters" value="true" />
                            <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                                ${not empty record.processed.location.coordinateUncertaintyInMeters ? record.processed.location.coordinateUncertaintyInMeters : 'Unknown'}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Data Generalizations -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="generalisedInMetres" fieldName="Coordinates Generalised">
                            <c:set target="${fieldsMap}" property="generalisedInMetres" value="true" />
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.dataGeneralizations && fn:contains(record.processed.occurrence.dataGeneralizations, 'is already generalised')}">
                                    ${record.processed.occurrence.dataGeneralizations}
                                </c:when>
                                <c:when test="${not empty record.processed.occurrence.dataGeneralizations}">
                                    Due to sensitivity concerns, the coordinates of this record have been generalised: &quot;<span class="dataGeneralizations">${record.processed.occurrence.dataGeneralizations}</span>&quot;.
                                </c:when>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Information Withheld -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="informationWithheld" fieldName="Information Withheld">
                            <c:set target="${fieldsMap}" property="informationWithheld" value="true" />
                            <c:if test="${not empty record.processed.occurrence.informationWithheld}">
                                <span class="dataGeneralizations">${record.processed.occurrence.informationWithheld}</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- GeoreferenceVerificationStatus -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceVerificationStatus" fieldName="Georeference Verification Status">
                            <c:set target="${fieldsMap}" property="georeferenceVerificationStatus" value="true" />
                            ${record.raw.location.georeferenceVerificationStatus}
                        </alatag:occurrenceTableRow>                        
                        <!-- georeferenceSources -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceSources" fieldName="Georeference Sources">
                            <c:set target="${fieldsMap}" property="georeferenceSources" value="true" />
                            ${record.raw.location.georeferenceSources}
                        </alatag:occurrenceTableRow>                        
                        <!-- georeferenceProtocol -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceProtocol" fieldName="Georeference Protocol">
                            <c:set target="${fieldsMap}" property="georeferenceProtocol" value="true" />
                            ${record.raw.location.georeferenceProtocol}
                        </alatag:occurrenceTableRow> 
                        <!-- georeferenceProtocol -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferencedBy" fieldName="Georeferenced By">
                            <c:set target="${fieldsMap}" property="georeferencedBy" value="true" />
                            ${record.raw.location.georeferencedBy}
                        </alatag:occurrenceTableRow>
                        <!-- output any tags not covered already (excluding those in dwcExcludeFields) -->
                        <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Location" exclude="${dwcExcludeFields}"/>
                    </table>
                </div>
            </div><!-- end of content2 -->

            <style type="text/css">
                #outlierFeedback { float:left; clear:both; padding-left:10px;margin-top:30px; width:100%; }
                #outlierFeedback h3 {color: #718804; }
                #outlierFeedback #outlierInformation { margin-bottom:20px; }
            </style>


            <div id="outlierFeedback">
                <c:if test="${not empty record.processed.occurrence.outlierForLayers}">
                    <div id="outlierInformation">
                        <h2>Outlier information</h2>
                        <p> This record has been detected as an outlier using the JackKnife algorithm for the following layers:</p>
                        <ul>
                        <c:forEach items="${metadataForOutlierLayers}" var="layerMetadata">
                            <li>
                                <!--LayerID: ${layerMetadata['id']}<br/> -->
                                <a href="http://spatial.ala.org.au/layers/more/${layerMetadata['name']}">${layerMetadata['displayname']} - ${layerMetadata['source']}</a><br/>
                                Notes: ${layerMetadata['notes']}<br/>
                                Scale: ${layerMetadata['scale']}
                            </li>
                        </c:forEach>
                        </ul>
                    </div>
                    <div id="charts"></div>
                </c:if>

                <div id="outlierInformation">
                    <c:if test="${not empty contextualSampleInfo}">
                    <h3>Addtional political boundaries information</h3>
                    <table class="layerIntersections" style="border-bottom:none;">
                        <tbody>
                        <c:forEach items="${contextualSampleInfo}" var="sample">
                            <alatag:occurrenceTableRow annotate="false" section="contextual"
                                                   fieldCode="${sample.layerName}" fieldName="${sample.layerDisplayName}">
                                ${sample.value}
                            </alatag:occurrenceTableRow>
                        </c:forEach>
                        </tbody>
                    </table>
                    </c:if>

                    <c:if test="${not empty environmentalSampleInfo}">
                    <h3>Environmental sampling for this location</h3>
                    <table class="layerIntersections" style="border-bottom:none;">
                        <tbody>
                        <c:forEach items="${environmentalSampleInfo}" var="sample">
                        <alatag:occurrenceTableRow annotate="false" section="contextual" fieldCode="${sample.layerName}"
                                                   fieldName="${sample.layerDisplayName}">${sample.value}
                        </alatag:occurrenceTableRow>
                        </c:forEach>
                        </tbody>
                    </table>
                    </c:if>
                </div>
            </div>
            
            <div style="display:none;clear:both;">
                <div id="processedVsRawView">
                    <h2>&quot;Original versus Processed&quot; Comparison Table</h2>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:15%;text-align:center;">Group</th>
                                <th style="width:15%;text-align:center;">Field Name</th>
                                <th style="width:35%;text-align:center;">Original</th>
                                <th style="width:35%;text-align:center;">Processed</th>
                            </tr>
                        </thead>
                        <tbody>
                            <alatag:formatRawVsProcessed map="${compareRecord}"/>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

       <div style="display:none;clear:both;">
            <div id="userFlaggedIssuesDetails">
                <h2>User flagged issues</h2>
                <c:forEach items="${record.userAssertions}" var="userAssertion">
                    <p>
                       <strong><spring:message code="${userAssertion.name}" text="$userAssertion.name}"/></strong><br/>
                       Comment: <span class="userAssertionComment">${userAssertion.comment}</span><br/>
                       Flagged by: ${userAssertion.userDisplayName} <br/>
                       <c:if test="${not empty userAssertion.created}">
                       Created: ${userAssertion.created} <br/>
                       </c:if>
                    </p>
                </c:forEach>
            </div>
        </div>

        <c:if test="${empty record.raw}">
            <div id="headingBar">
                <h1>Record Not Found</h1>
                <p>The requested record ID "${uuid}" was not found</p>
            </div>
        </c:if>

        <script type="text/javascript" language="javascript" src="${biocacheService}/outlier/record/${uuid}.json?callback=renderOutlierCharts"/>
    </body>
</html>

