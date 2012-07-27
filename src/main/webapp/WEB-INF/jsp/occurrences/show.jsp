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
<c:when test="${skin == 'avh'}">
    <c:set var="recordId" value="${record.raw.occurrence.catalogNumber}"/>
</c:when>
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
<c:set var="spatialPortalUrl" scope="request"><ala:propertyLoader bundle="hubs" property="spatialPortalUrl"/></c:set>
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
        <title><fmt:message key="show.occurrenceRecord"/> ${recordId} | ${hubDisplayName} </title>
        <script type="text/javascript">
            contextPath = "${pageContext.request.contextPath}";
        </script>
        <jwr:style src="/css/record.css"/>
        <jwr:style src="/css/button.css"/>
        <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/static/js/charts2.js"></script>
        <%--<script type="text/javascript" language="javascript" src="http://collections.ala.org.au/js/datadumper.js"></script>--%>
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
                return str.replace(/([a-z])([A-Z])/g, "$1 $2").toLowerCase().capitalize();
            }

            /**
            * Capitalise first letter of string only
            * @return {String}
             */
            String.prototype.capitalize = function() {
                return this.charAt(0).toUpperCase() + this.slice(1);
            }

            /**
             * JQuery on document ready callback
             */
            $(document).ready(function() {

                <c:if test="${record.processed.attribution.provenance == 'Draft'}">
                $('#viewDraftButton').click(function(){
                    document.location.href = '${record.raw.occurrence.occurrenceID}';
                })
                </c:if>

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
                        $('#assertionSubmitProgress').css({'display':'block'});
                        $.post("${pageContext.request.contextPath}/occurrences/assertions/add",
                            { recordUuid: recordUuid, code: code, comment: comment, userId: userId, userDisplayName: userDisplayName},
                            function(data) {
                                $('#assertionSubmitProgress').css({'display':'none'});
                                $("#submitSuccess").html("Thanks for flagging the problem!");
                                $("#issueFormSubmit").hide();
                                $("input:reset").hide();
                                $("input#close").show();
                                //retrieve all assertions
                                $.get('${pageContext.request.contextPath}/occurrences/groupedAssertions?recordUuid=${record.raw.rowKey}', function(data) {
                                    //console.log("data", data);
                                    $('#userAssertions').html(data);
                                    $('#userAssertionsContainer').show("slow");
                                });
                            }
                        ).error(function() {
                            $('#assertionSubmitProgress').css({'display':'none'});
                            $("#submitSuccess").html("There was problem flagging the issue. Please try again later.");
                        });
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
                $('table.occurrenceTable, table.inner, table.layerIntersections, table.duplicationTable').each(function(i, el) {
                    $(this).find('tr').not('.sectionName').each(function(j, tr) {
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
                    $(".confirmVerifyCheck").click(function(e) {
                        $("#verifyAsk").hide();
                        $("#verifyDone").show();
                    });
                    $(".cancelVerify").click(function(e) {
                        $.fancybox.close();
                    });
                    $(".closeVerify").click(function(e) {
                        $.fancybox.close();
                    });
                    $(".confirmVerify").click(function(e) {
                        var code = "50000";
                        var userId = '${userId}';
                        var userDisplayName = '${userDisplayName}';
                        var recordUuid = '${record.raw.rowKey}';
                        // send assertion via AJAX... TODO catch errors
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

                $("#backButton a").click(function(e) {
                    e.preventDefault();
                    var url = $(this).attr("href");
                    if (url) {
                        // referer value from request object
                        window.location.href = url;
                    } else if (history.length) {
                        //There is history to go back to
                        history.go(-1);
                    } else {
                        alert("Sorry it appears the history has been lost, please use the browser&apso;s back button");
                    }
                });

                var sequenceTd = $("tr#nucleotides").find("td.value");
                var sequenceStr = sequenceTd.text().trim();
                if (sequenceStr.length > 10) {
                    // split long DNA sequences into blocks of 10 chars
                    $(sequenceTd).html("<code>"+sequenceStr.replace(/(.{10})/g,"$1 ")+"</code>");
                }
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
               var chartQuery = null;

               <c:choose>
                <c:when test="${record.processed.classification.taxonRank == 'species'}">
                chartQuery = 'species_guid:${fn:replace(record.processed.classification.taxonConceptID, ':', '\\:')}';
                </c:when>
                <c:when test="${record.processed.classification.taxonRank == 'subspecies'}">
                chartQuery = 'subspecies_guid:${fn:replace(record.processed.classification.taxonConceptID, ':', '\\:')}';
                </c:when>
               </c:choose>

               if(chartQuery != null){
                   $.each(data, function() {
                       //console.log("Render charts for LAYER: " + this.layerId +", outlier values: " +  this.outlierValues);
                       drawChart(this.layerId, chartQuery, this.layerId+'Outliers', this.outlierValues, this.recordLayerValue, false);
                       drawChart(this.layerId, chartQuery, this.layerId+'OutliersCumm', this.outlierValues, this.recordLayerValue, true);
                       //console.log("Rendered charts for LAYER: " + this.layerId);
                   })
               }
            }
            
            function drawChart(facetName, biocacheQuery, chartName, outlierValues, valueForThisRecord, cumulative){

                var facetChartOptions = { error: "badQuery", legend: 'right'}
                facetChartOptions.query = biocacheQuery;
                facetChartOptions.charts = [chartName];
                facetChartOptions[facetName] = {chartType: 'scatter'};

                //additional config
                facetChartOptions.cumulative = cumulative;
                facetChartOptions.outlierValues = outlierValues;    //retrieved from WS
                facetChartOptions.highlightedValue = valueForThisRecord;           //retrieved from the record

                //console.log('Start the drawing...' + chartName);
                facetChartGroup.loadAndDrawFacetCharts(facetChartOptions);
                //console.log('Finished the drawing...' + chartName);
            }

            google.load("visualization", "1", {packages:["corechart"]});
        </script>
    </head>
    <body>
        <spring:url var="json" value="/occurrences/${record.raw.uuid}.json" />
        <c:if test="${not empty record.raw}">
            <div id="headingBar" class="recordHeader">
                <c:if test="${not empty lastSearchUri}">
                    <div id="backButton" style="display:block;">
                        <a href="${lastSearchUri}" title="Return to search results">Back to search results</a>
                    </div>
                </c:if>
                <h1><fmt:message key="show.occurrenceRecord"/>: <span id="recordId">${recordId}</span></h1>
                <c:if test="${skin != 'avh'}">
                    <div id="jsonLink">
                        <c:if test="${isCollectionAdmin}">
                            <c:set var="admin" value=" - admin"/>
                        </c:if>
                        <c:if test="${not empty userDisplayName}">
                            Logged in as: ${userDisplayName} <!--(${userId}${admin})-->
                        </c:if>
                        <c:if test="${not empty clubView}">
                            <div id="clubView">Showing &quot;Club View&quot;</div>
                        </c:if>
                        <!-- <a href="${json}">JSON</a> -->
                    </div>
                </c:if>
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

                <c:if test="${record.processed.attribution.provenance != 'Draft'}">
                <div class="sidebar">
                    <div id="warnings">

                        <div id="systemAssertionsContainer" <c:if test="${empty record.systemAssertions}">style="display:none"</c:if>>
                        <h2>Data validation issues</h2>
                        <!--<p class="half-padding-bottom">Data validation tools identified the following possible issues:</p>-->
                        <c:set var="recordIsVerified" value="false"/>
                        <c:forEach items="${record.userAssertions}" var="userAssertion">
                            <c:if test="${userAssertion.name == 'userVerified'}"><c:set var="recordIsVerified" value="true"/></c:if>
                        </c:forEach>
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
                </c:if>
                <!-- recordIsVerified = ${recordIsVerified} || isCollectionAdmin = ${isCollectionAdmin}-->
                <c:if test="${isCollectionAdmin && (not empty record.systemAssertions || not empty record.userAssertions) && not recordIsVerified}">
                    <div class="sidebar">
                        <button class="rounded" id="verifyButton" href="#verifyRecord">
                            <span id="verifyRecordSpan" title="">Verify record</span>
                        </button>
                        <div style="display:none;">
                            <div id="verifyRecord">
                                <h3>Confirmation</h3>
                                <div id="verifyAsk">
                                    <p style="margin-bottom:10px;">
                                        Click the &quot;Confirm&quot; button to verify that this record is correct and that
                                        the listed &quot;validation issues&quot; are incorrect/invalid.
                                    </p>
                                    <button class="confirmVerify">Confirm</button>
                                    <button class="cancelVerify">Cancel</button>
                                </div>
                                <div id="verifyDone" style="display:none;">
                                    Record successfully verified
                                    <br/>
                                    <button class="closeVerify">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty record.processed.attribution.provenance && record.processed.attribution.provenance == 'Draft'}">
                <div class="sidebar">
                    <p class="grey-bg" style="padding:5px; margin-top:15px; margin-bottom:10px;">
                        This record is available for transcription in the
                        <a href="http://volunteer.ala.org.au/">Biodiversity Volunteer Portal</a>.
                    </p>

                    <button class="rounded" id="viewDraftButton" >
                        <span id="viewDraftSpan" title="View Draft">View draft in volunteer portal</span>
                    </button>
                </div>
                </c:if>
                <c:if test="${!isReadOnly && record.processed.attribution.provenance != 'Draft'}">
                <div class="sidebar">
                    <button class="rounded" id="assertionButton" href="#loginOrFlag">
                        <span id="loginOrFlagSpan" title="Flag an issue">Flag an issue</span>
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
                                        <label for="issueComment" style="vertical-align:top;">Comment:</label>
                                        <textarea name="comment" id="issueComment" style="width:380px;height:150px;" placeholder="Please add a comment here..."></textarea>
                                    </p>
                                    <p style="margin-top:20px;">
                                        <input id="issueFormSubmit" type="submit" value="Submit" />
                                        <input type="reset" value="Cancel" onClick="$.fancybox.close();"/>
                                        <input type="button" id="close" value="Close" style="display:none;"/>
                                        <span id="submitSuccess"></span>
                                    </p>
                                    <p id="assertionSubmitProgress" style="display:none;">
                                        <img src="${initParam.serverName}${pageContext.request.contextPath}/static/images/indicator.gif"/>
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
                <jsp:include page="recordCoreDiv.jsp"/>
            </div><!-- end of div#content2 -->

            <style type="text/css">
                #outlierFeedback #inferredOccurrenceDetails { float:left; clear:both; padding-left:10px;margin-top:30px; width:100%; }
                /*#outlierFeedback h3 {color: #718804; }*/
                #outlierFeedback #outlierInformation #inferredOccurrenceDetails { margin-bottom:20px; }
            </style>

			




            <script type="text/javascript" src="${biocacheService}/outlier/record/${uuid}.json?callback=renderOutlierCharts"></script>

			
            <div id="outlierFeedback">
                <c:if test="${not empty record.processed.occurrence.outlierForLayers}">
                    <div id="outlierInformation">
                        <h2>Outlier information</h2>
                        <p>
                            This record has been detected as an outlier using the 
                            <a href="http://code.google.com/p/ala-dataquality/wiki/DETECTED_OUTLIER_JACKKNIFE">Reverse Jackknife algorithm</a>
                            for the following layers:</p>
                        <ul>
                        <c:forEach items="${metadataForOutlierLayers}" var="layerMetadata">
                            <li>
                                <a href="http://spatial.ala.org.au/layers/more/${layerMetadata['name']}">${layerMetadata['displayname']} - ${layerMetadata['source']}</a><br/>
                                Notes: ${layerMetadata['notes']}<br/>
                                Scale: ${layerMetadata['scale']}
                            </li>
                        </c:forEach>
                        </ul>

                        <p style="margin-top:20px;">More information on the data quality work being undertaken by the Atlas is available here:
                            <ul>
                                <li><a href="http://code.google.com/p/ala-dataquality/wiki/DETECTED_OUTLIER_JACKKNIFE">http://code.google.com/p/ala-dataquality/wiki/DETECTED_OUTLIER_JACKKNIFE</a></li>
                                <li><a href="https://docs.google.com/open?id=0B7rqu1P0r1N0NGVhZmVhMjItZmZmOS00YmJjLWJjZGQtY2Y0ZjczZmUzZTZl">Notes on Methods for Detecting Spatial Outliers</a></li>
                            </ul>
                        </p>
                    </div>
                    <div id="charts"></div>
                </c:if>
                
              
				<c:if test="${not empty record.processed.occurrence.duplicationStatus }">
					<div id="inferredOccurrenceDetails">
              		<a href="#inferredOccurrenceDetails" name="inferredOccurrenceDetails" id="inferredOccurrenceDetails" hidden="true"></a>
              		<h2>Inferred Associated Occurrence Details</h2>
					<p>
					<c:choose>
						<c:when test="${record.processed.occurrence.duplicationStatus == 'R' }">This record has been identified as the <em>representative</em> occurrence in a group of associated occurrences.						
						</c:when>
						<c:otherwise>This record is associated with the <em>representative</em> record.						
						</c:otherwise>
					</c:choose>
					<p>More information about the Duplication Detection is available here:
						<ul>
							<li>
							<a href="http://code.google.com/p/ala-dataquality/wiki/INFERRED_DUPLICATE_RECORD">http://code.google.com/p/ala-dataquality/wiki/INFERRED_DUPLICATE_RECORD</a>							
							</li>
						</ul>
					</p>
					<c:if test="${not empty duplicateRecordDetails}">
						<table class="duplicationTable" style="border-bottom:none;">
							<tr class="sectionName"><td colspan="4">Representative Record</td></tr>
							<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Record UUID">
                            <a href="${pageContext.request.contextPath}/occurrences/${duplicateRecordDetails.uuid}">${duplicateRecordDetails.uuid}</a></alatag:occurrenceTableRow>
                            <alatag:occurrenceTableRow
        							annotate="false"
        							section="duplicate"                                    
        							fieldName="Data Resource">
        					<c:set var="dr">${fn:substring(duplicateRecordDetails.rowKey,0,fn:indexOf(duplicateRecordDetails.rowKey,"|"))}</c:set>
        					<a href="${collectionsWebappContext}/public/show/${dr}">${dataResourceCodes[dr]}</a>        							
				 			</alatag:occurrenceTableRow>
                            <c:if test="${not empty duplicateRecordDetails.rawScientificName}">
			        		<alatag:occurrenceTableRow
	                				annotate="false"
	                				section="duplicate"                                    
	                				fieldName="Raw Scientific Name">
	        					${duplicateRecordDetails.rawScientificName}</alatag:occurrenceTableRow>
		        			</c:if>
                            <alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Coordinates">
                            ${duplicateRecordDetails.latLong}</alatag:occurrenceTableRow>
                            <c:if test="${not empty duplicateRecordDetails.collector }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Collector">
                            ${duplicateRecordDetails.collector}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty duplicateRecordDetails.year }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Year">
                            ${duplicateRecordDetails.year}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty duplicateRecordDetails.month }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Month">
                            ${duplicateRecordDetails.month}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty duplicateRecordDetails.day }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Day">
                            ${duplicateRecordDetails.day}</alatag:occurrenceTableRow>
                            </c:if>
                            <!-- Loop through all the duplicate records -->
                            <tr class="sectionName"><td colspan="4">Related records</td></tr>
                            <c:forEach items="${duplicateRecordDetails.duplicates }" var="dup">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Record UUID">
                            <a href="${pageContext.request.contextPath}/occurrences/${dup.uuid}">${dup.uuid}</a></alatag:occurrenceTableRow>
                            <alatag:occurrenceTableRow
        							annotate="false"
        							section="duplicate"                                    
        							fieldName="Data Resource">
        					<c:set var="dr">${fn:substring(dup.rowKey,0,fn:indexOf(dup.rowKey,"|"))}</c:set>
        					<a href="${collectionsWebappContext}/public/show/${dr}">${dataResourceCodes[dr]}</a>        							
				 			</alatag:occurrenceTableRow>
                            <c:if test="${not empty dup.rawScientificName}">                            
			        		<alatag:occurrenceTableRow
	                				annotate="false"
	                				section="duplicate"                                    
	                				fieldName="Raw Scientific Name">
	        					${dup.rawScientificName}</alatag:occurrenceTableRow>
		        			</c:if>
                            <alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Coordinates">
                            ${dup.latLong}</alatag:occurrenceTableRow>
                             <c:if test="${not empty dup.collector }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Collector">
                            ${dup.collector}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty dup.year }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Year">
                            ${dup.year}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty dup.month }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Month">
                            ${dup.month}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty dup.day }">
                            	<alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Day">
                            ${dup.day}</alatag:occurrenceTableRow>
                            </c:if>
                            <c:if test="${not empty dup.dupTypes }">
                            <alatag:occurrenceTableRow
                                    annotate="false"
                                    section="duplicate"                                    
                                    fieldName="Comments">
                            	<c:forEach items="${dup.dupTypes }" var="dupType">
                            		<fmt:message key="duplication.${dupType.id}"/>
                            		<br>
                            	</c:forEach>
                            	</alatag:occurrenceTableRow>
                            	<tr class="sectionName"><td colspan="4"></td></tr>
                            </c:if>
                            </c:forEach>
						</table>
					</c:if>
					</p>					
				</c:if>
			</div>

                <div id="outlierInformation">
                    <c:if test="${not empty contextualSampleInfo}">
                    <h3>Additional political boundaries information</h3>
                    <table class="layerIntersections" style="border-bottom:none;">
                        <tbody>
                        <c:forEach items="${contextualSampleInfo}" var="sample" varStatus="vs">
                            <c:if test="${not empty sample.classification1 && (vs.first || (sample.classification1 != contextualSampleInfo[vs.index-1].classification1 && !vs.end))}">
                                <tr class="sectionName"><td colspan="4">${sample.classification1}</td></tr>
                            </c:if>
                            <alatag:occurrenceTableRow
                                    annotate="false"
                                    section="contextual"
                                    fieldCode="${sample.layerName}"
                                    fieldName="<a href=\"${spatialPortalUrl}layers/more/${sample.layerName}\" title=\"More information about this layer\">${sample.layerDisplayName}</a>">
                            ${sample.value}</alatag:occurrenceTableRow></c:forEach>
                        </tbody>
                    </table>
                    </c:if>

                    <c:if test="${not empty environmentalSampleInfo}">
                    <h3>Environmental sampling for this location</h3>
                    <table class="layerIntersections" style="border-bottom:none;">
                        <tbody>
                        <c:forEach items="${environmentalSampleInfo}" var="sample" varStatus="vs">
                            <c:if test="${not empty sample.classification1 && (vs.first || (sample.classification1 != environmentalSampleInfo[vs.index-1].classification1 && !vs.end))}">
                                <tr class="sectionName"><td colspan="4">${sample.classification1}</td></tr>
                            </c:if>
                            <alatag:occurrenceTableRow
                                    annotate="false"
                                    section="contextual"
                                    fieldCode="${sample.layerName}"
                                    fieldName="<a href=\"${spatialPortalUrl}layers/more/${sample.layerName}\" title=\"More information about this layer\">${sample.layerDisplayName}</a>">
                                ${sample.value} <c:if test="${not empty sample.units && !fn:containsIgnoreCase(sample.units,'dimensionless')}">${sample.units}</c:if>
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
                       <strong><fmt:message key="${userAssertion.name}"/></strong><br/>
                       Comment: <span class="userAssertionComment">${userAssertion.comment}</span><br/>
                       Flagged by: ${userAssertion.userDisplayName} <br/>
                       <c:if test="${not empty userAssertion.created}">
                           <fmt:parseDate var="assertionCreated" value="${userAssertion.created}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'"/>
                           <fmt:formatDate var="assertionCreatedString" value="${assertionCreated}" pattern="yyyy-MM-dd"/>
                           Created: ${assertionCreatedString} <br/>
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

    </body>
</html>
