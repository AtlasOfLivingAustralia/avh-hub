<%--
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
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
                $("#assertionButton").fancybox({
                    'href': '#loginOrFlag',
                    'hideOnContentClick' : false,
                    'hideOnOverlayClick': true,
                    'showCloseButton': true,
                    'titleShow' : false,
                    'autoDimensions' : false,
                    'width': '500',
                    'height': '300',
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
                $("td.dwc").each(function(i, el) {
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
                    
                    $.each(text, function(i, el) {
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
            }); // end JQuery document ready
            
            /*
             * IE doesn't support String.trim(), so add it in manually
             */
            if(typeof String.prototype.trim !== 'function') {
                String.prototype.trim = function() {
                    return this.replace(/^\s+|\s+$/g, ''); 
                }
            }
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
                        Logged in as: ${userDisplayName} (${userId}${admin})
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
                        </div>
                    </div>
                </div>
                <div class="sidebar">
                    <c:if test="${false && isCollectionAdmin}">
                        <button class="rounded" id="verifyButton">
                            <span id="assertionMaker" href="#verifyRecord" title="">Verify Record</span>
                        </button>
                    </c:if>
                </div>
                <div class="sidebar">
                    <button class="rounded" id="assertionButton">
                        <span id="assertionMaker" href="#loginOrFlag" title="">Flag an Issue</span>
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
                <div class="sidebar">
                    <button class="rounded" id="showRawProcessed" href="#processedVsRawView" title="Table showing both original and processed record values">
                        <span id="assertionMaker" href="#processedVsRawView" title="">Original vs Processed</span>
                    </button>
                </div>  
                <c:if test="${not empty record.processed.occurrence.images}">
                    <div class="sidebar">
                        <h2>Images</h2>
                        <c:forEach items="${record.processed.occurrence.images}" var="imageUrl">
                           <a href="${not empty record.raw.occurrence.occurrenceDetails ?  record.raw.occurrence.occurrenceDetails : imageUrl}"><img src="${imageUrl}" style="max-width: 250px;"/></a><br/>
                        </c:forEach>
                        <c:if test="${not empty record.raw.occurrence.rights}">
                        <cite>Rights: ${record.raw.occurrence.rights}</cite>
                        </c:if>
                    </div>
                </c:if>
                <c:if test="${not empty record.processed.location.decimalLatitude && not empty record.processed.location.decimalLongitude}">
                    <div class="sidebar">
                        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
                        <script type="text/javascript">
                            $(document).ready(function() {
                                var latlng = new google.maps.LatLng(${record.processed.location.decimalLatitude}, ${record.processed.location.decimalLongitude});
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
                <div id="occurrenceDataset">
                    <h3>Dataset</h3>
                    <table class="occurrenceTable" id="datasetTable">
                        <c:if test="${useAla == 'true'}">
                            <!-- Data Provider -->
                            <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="dataProvider" fieldName="Data Provider">
                                <c:choose>
                                    <c:when test="${record.processed.attribution.dataProviderUid != null && not empty record.processed.attribution.dataProviderUid}">
                                        <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.dataProviderUid}">
                                            ${record.processed.attribution.dataProviderName}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        ${record.processed.attribution.dataProviderName}
                                    </c:otherwise>
                                </c:choose>
                            </alatag:occurrenceTableRow>
                            <!-- Data Resource -->
                            <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="dataResource" fieldName="Data Set">
                                <c:choose>
                                    <c:when test="${record.raw.attribution.dataResourceUid != null && not empty record.raw.attribution.dataResourceUid}">
                                        <a href="${collectionsWebappContext}/public/show/${record.raw.attribution.dataResourceUid}">
                                            ${record.processed.attribution.dataResourceName}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        ${record.processed.attribution.dataResourceName}
                                    </c:otherwise>
                                </c:choose>
                            </alatag:occurrenceTableRow>
                        </c:if>
                        <!-- Institution -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="institutionCode" fieldName="Institution">
                            <c:choose>
                                <c:when test="${record.processed.attribution.institutionUid != null && not empty record.processed.attribution.institutionUid}">
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
                                    ${record.processed.attribution.institutionName}
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty record.raw.occurrence.institutionCode}">
                                <br/><span class="originalValue">Supplied as "${record.raw.occurrence.institutionCode}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Collection -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="collectionCode" fieldName="Collection">
                            <c:if test="${not empty record.processed.attribution.collectionUid}">
<!--                                <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.collectionUid}">-->
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
                                    ${record.processed.attribution.collectionName}
                                </c:when>
                                <c:when test="${not empty collectionName}">
                                    ${collectionName}
                                </c:when>
                            </c:choose>
                            <c:if test="${not empty record.processed.attribution.collectionUid}">
                                </a>
                            </c:if>
                            <c:if test="${not empty record.raw.occurrence.collectionCode}">
                                <br/><span class="originalValue">Supplied as "${record.raw.occurrence.collectionCode}"</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Catalog Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="catalogueNumber" fieldName="Catalogue Number">
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
                            ${record.raw.occurrence.otherCatalogNumbers}
                        </alatag:occurrenceTableRow>
                        <!-- Record Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="recordNumber" fieldName="Record number">
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.recordNumber && not empty record.raw.occurrence.recordNumber}">
                                    ${record.processed.occurrence.recordNumber}
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.basisOfrecordNumberRecord}"</span>
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.occurrence.recordNumber}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="citation" fieldName="Record citation">
                            ${record.raw.attribution.citation}
                        </alatag:occurrenceTableRow>                        
                        <!-- Occurrence ID -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="occurrenceID" fieldName="Occurrence ID">
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.occurrenceID && not empty record.raw.occurrence.occurrenceID}">
                                    <c:if test="${fn:startsWith(record.processed.occurrence.occurrenceID,'http://')}"><a href="${record.processed.occurrence.occurrenceID}"></c:if>
                                    ${record.processed.occurrence.occurrenceID}
                                    <c:if test="${fn:startsWith(record.processed.occurrence.occurrenceID,'http://')}"></a></c:if>                                    
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.occurrenceID}"</span>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${fn:startsWith(record.raw.occurrence.occurrenceID,'http://')}"><a href="${record.raw.occurrence.occurrenceID}"></c:if>                                
                                    ${record.raw.occurrence.occurrenceID}
                                    <c:if test="${fn:startsWith(record.raw.occurrence.occurrenceID,'http://')}"></a></c:if>                                                                        
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="citation" fieldName="Record citation">
                            ${record.raw.attribution.citation}
                        </alatag:occurrenceTableRow>                        
                        <!--
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="recordUuid" fieldName="Record UUID">
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
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierName" fieldName="Identifier">
                            ${record.raw.identification.identifiedBy}
                        </alatag:occurrenceTableRow>
                        <!-- Identified Date -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierDate" fieldName="Identified Date">
                            ${record.raw.identification.dateIdentified}
                        </alatag:occurrenceTableRow>
                        <!-- Field Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="fieldNumber" fieldName="Field Number">
                            ${record.raw.occurrence.fieldNumber}
                        </alatag:occurrenceTableRow>
                        <!-- Field Number -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identificationRemarks" fieldName="Identification Remarks">
                            ${record.raw.identification.identificationRemarks}
                        </alatag:occurrenceTableRow>
                        <!-- Collector/Observer -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="collectorName" fieldName="Collector/Observer">
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
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="samplingProtocol" fieldName="Sampling Protocol">
                            ${record.raw.occurrence.samplingProtocol}
                        </alatag:occurrenceTableRow>
                        <!-- Type Status -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="typeStatus" fieldName="Type Status">
                            ${record.raw.identification.typeStatus}
                        </alatag:occurrenceTableRow>
                        <!-- Reproductive Condition -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="reproductiveCondition" fieldName="Reproductive Condition">
                            ${record.raw.occurrence.reproductiveCondition}
                        </alatag:occurrenceTableRow>
                        <!-- Sex -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="sex" fieldName="Sex">
                            ${record.raw.occurrence.sex}
                        </alatag:occurrenceTableRow>
                        <!-- Behavior -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="behavior" fieldName="Behaviour">
                            ${record.raw.occurrence.behavior}
                        </alatag:occurrenceTableRow>
                        <!-- Individual count -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="individualCount" fieldName="Individual Count">
                            ${record.raw.occurrence.individualCount}
                        </alatag:occurrenceTableRow>
                        <!-- Life stage -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="lifeStage" fieldName="Life stage">
                            ${record.raw.occurrence.lifeStage}
                        </alatag:occurrenceTableRow>
                        <!-- Preparations -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="preparations" fieldName="Preparations">
                            ${record.raw.occurrence.preparations}
                        </alatag:occurrenceTableRow>
                        <!-- Rights -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="rights" fieldName="Rights">
                            ${record.raw.occurrence.rights}
                        </alatag:occurrenceTableRow>
                    </table>
                </div>
                <div id="occurrenceTaxonomy">
                    <h3>Taxonomy</h3>
                    <table class="occurrenceTable" id="taxonomyTable">
                        <!-- Preparations -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="higherClassification" fieldName="Higher Classification">
                            ${record.raw.classification.higherClassification}
                        </alatag:occurrenceTableRow>
                        <!-- Scientific Name -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="scientificName" fieldName="Scientific Name">
                            <c:if test="${not empty record.processed.classification.taxonConceptID}">
                                <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.taxonConceptID}">
                            </c:if>
                            <c:set var="displaySciName">
                                <c:choose>
                                    <c:when test="${not empty record.processed.classification.scientificName}">
                                        <alatag:formatSciName rankId="${record.processed.classification.taxonRankID}" name="${record.processed.classification.scientificName}"/>
                                        ${record.processed.classification.scientificNameAuthorship}
                                    </c:when>
                                    <c:when test="${not empty record.processed.classification.scientificName && not empty record.raw.classification.scientificName}">
                                        <alatag:formatSciName rankId="${record.processed.classification.taxonRankID}" name="${record.processed.classification.scientificName}"/>
                                        ${record.processed.classification.scientificNameAuthorship}
                                        (interpreted as <alatag:formatSciName rankId="${record.raw.classification.taxonRankID}" name="${record.raw.classification.scientificName}"/>
                                        ${record.raw.classification.scientificNameAuthorship})
                                    </c:when>
                                    <c:when test="${not empty record.raw.classification.scientificName}">
                                        <alatag:formatSciName rankId="${record.raw.classification.taxonRankID}" name="${record.raw.classification.scientificName}"/>
                                        ${record.raw.classification.scientificNameAuthorship}
                                    </c:when>
                                    <c:when test="${not empty record.raw.classification.genus && not empty record.raw.classification.specificEpithet}">
                                        <i>${record.raw.classification.genus} ${record.raw.classification.specificEpithet}</i>
                                        ${record.raw.classification.scientificNameAuthorship}
                                    </c:when>
                                    <c:otherwise>
                                        
                                    </c:otherwise>
                                </c:choose>
                            </c:set>
                            <c:choose>
                                <c:when test="${not empty record.processed.classification.taxonConceptID}">
                                    <c:choose>
                                        <c:when  test="${useAla == 'true'}">
                                            <a href="${bieWebappContext}/species/${record.processed.classification.taxonConceptID}">${displaySciName}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/taxa/${record.processed.classification.taxonConceptID}">${displaySciName}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <a href="${bieWebappContext}/search?q=${fn:replace(scientificName, '  ', ' ')}">${displaySciName}</a>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty record.raw.classification.scientificName && !fn:contains(displaySciName, record.raw.classification.scientificName)}">
                                <br/><span class="originalValue">Supplied as &quot;${record.raw.classification.scientificName}&quot;</span>
                                <!-- ${record.raw.classification.scientificName} || ${displaySciName} -->
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Taxon Rank -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="taxonRank" fieldName="Taxon Rank">
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
                        <alatag:occurrenceTableRow annotate="false" section="taxonomy" fieldCode="commonName" fieldName="Common Name">
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
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="associatedTaxa" fieldName="Associated Species">
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
                    </table>
                </div>
                <div id="geospatialTaxonomy">
                    <h3>Geospatial</h3>
                    <table class="occurrenceTable" id="geospatialTable">
                        <!-- Higher Geography -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="higherGeography" fieldName="Higher Geography">
                             ${record.raw.location.higherGeography}
                        </alatag:occurrenceTableRow>
                        <!-- Country -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="country" fieldName="Country">
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
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="biogeographicRegion" fieldName="Biogeographic Region">
                            <c:if test="${not empty record.processed.location.ibra}">
                                ${record.processed.location.ibra}
                            </c:if>
                            <c:if test="${empty record.processed.location.ibra && not empty record.raw.location.ibra}">
                                ${record.raw.location.ibra}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Local Govt Area -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locality" fieldName="Local Govt Area">
                            <c:if test="${not empty record.processed.location.lga}">
                                ${record.processed.location.lga}
                            </c:if>
                            <c:if test="${empty record.processed.location.lga && not empty record.raw.location.lga}">
                                ${record.raw.location.lga}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Habitat -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="habitat" fieldName="Habitat">
                            ${record.processed.location.habitat}
                        </alatag:occurrenceTableRow>
                        <!-- Latitude -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="latitude" fieldName="Latitude">
                            ${(not empty record.processed.location.decimalLatitude) ? record.processed.location.decimalLatitude : record.raw.location.decimalLatitude}
                        </alatag:occurrenceTableRow>
                        <!-- Longitude -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="longitude" fieldName="Longitude">
                            ${(not empty record.processed.location.decimalLongitude) ? record.processed.location.decimalLongitude : record.raw.location.decimalLongitude}
                        </alatag:occurrenceTableRow>
                        <!-- Geodetic datum -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="geodeticDatum" fieldName="Geodetic Datum">
                            ${record.raw.location.geodeticDatum}
                        </alatag:occurrenceTableRow>
                        <!-- verbatimCoordinateSystem -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="verbatimCoordinateSystem" fieldName="Vverbatim Coordinate System">
                            ${record.raw.location.verbatimCoordinateSystem}
                        </alatag:occurrenceTableRow>
                        <!-- Verbatim locality -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="verbatimLocality" fieldName="Verbatim locality">
                            ${record.raw.location.verbatimLocality}
                        </alatag:occurrenceTableRow>
                        <!-- Water Body -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="waterBody" fieldName="Water body">
                            ${record.raw.location.waterBody}
                        </alatag:occurrenceTableRow>
                        <!-- Min depth -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="minimumDepthInMeters" fieldName="Minimum Depth In Metres">
                            ${record.raw.location.minimumDepthInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Max depth -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="maximumDepthInMeters" fieldName="Maximum Depth In Metres">
                            ${record.raw.location.maximumDepthInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Min elevation -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="minimumElevationInMeters" fieldName="Minimum Elevation In Metres">
                            ${record.raw.location.minimumElevationInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Max elevation -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="maximumElevationInMeters" fieldName="Maximum Elevation In Metres">
                            ${record.raw.location.maximumElevationInMeters}
                        </alatag:occurrenceTableRow>
                        <!-- Island -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="island" fieldName="Island">
                            ${record.raw.location.island}
                        </alatag:occurrenceTableRow>
                        <!-- Island Group-->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="islandGroup" fieldName="Island group">
                            ${record.raw.location.islandGroup}
                        </alatag:occurrenceTableRow>
                        <!-- Location remarks -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locationRemarks" fieldName="Location Remarks">
                            ${record.raw.location.locationRemarks}
                        </alatag:occurrenceTableRow>
                        <!-- Occurrence remarks -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="occurrenceRemarks" fieldName="Occurrence Remarks">
                            ${record.raw.occurrence.occurrenceRemarks}
                        </alatag:occurrenceTableRow>
                        <!-- Field notes -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="fieldNotes" fieldName="Field Notes">
                            ${record.raw.occurrence.fieldNotes}
                        </alatag:occurrenceTableRow>
                        <!-- Coordinate Precision -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinatePrecision" fieldName="Coordinate Precision">
                            <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                                ${not empty record.processed.location.coordinatePrecision ? record.processed.location.coordinatePrecision : 'Unknown'}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Coordinate Uncertainty -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinateUncertaintyInMeters" fieldName="Coordinate Uncertainty (metres)">
                            <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                                ${not empty record.processed.location.coordinateUncertaintyInMeters ? record.processed.location.coordinateUncertaintyInMeters : 'Unknown'}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Data Generalizations -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="generalisedInMetres" fieldName="Coordinates Generalised">
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
                            <c:if test="${not empty record.processed.occurrence.informationWithheld}">
                                <span class="dataGeneralizations">${record.processed.occurrence.informationWithheld}</span>
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- GeoreferenceVerificationStatus -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceVerificationStatus" fieldName="Georeference Verification Status">
                            ${record.raw.location.georeferenceVerificationStatus}
                        </alatag:occurrenceTableRow>                        
                        <!-- georeferenceSources -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceSources" fieldName="Georeference Sources">
                            ${record.raw.location.georeferenceSources}
                        </alatag:occurrenceTableRow>                        
                        <!-- georeferenceProtocol -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceProtocol" fieldName="Georeference Protocol">
                            ${record.raw.location.georeferenceProtocol}
                        </alatag:occurrenceTableRow> 
                        <!-- georeferenceProtocol -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferencedBy" fieldName="Georeferenced By">
                            ${record.raw.location.georeferencedBy}
                        </alatag:occurrenceTableRow>  
                    </table>
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
        <c:if test="${empty record.raw}">
            <div id="content2">
                <h1>Record Not Found</h1>
                <p>The requested record ID "${uuid}" was not found</p>
            </div>
        </c:if>
    </body>
</html>

