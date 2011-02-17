<%--
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<c:set var="recordId" value="${record.raw.occurrence.collectionCode}:${record.raw.occurrence.catalogNumber}"/>
<c:set var="bieWebappContext" scope="request"><ala:propertyLoader bundle="hubs" property="bieWebappContext"/></c:set>
<c:set var="collectionsWebappContext" scope="request"><ala:propertyLoader bundle="hubs" property="collectionsWebappContext"/></c:set>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OzCam Hub - Occurrence Record ${recordId}</title>
        <script type="text/javascript">
            contextPath = "${pageContext.request.contextPath}";
        </script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/record.css" type="text/css" media="screen" />
    </head>
    <body>
        <c:if test="${not empty recordId}">
            <div id="headingBar" class="recordHeader">
                <h1>Occurrence Record: ${recordId} </h1>
                <div id="jsonLink"><a href="${record.raw.occurrence.uuid}.json">JSON</a></div>
                <c:if test="${not empty record.raw.classification.scientificName}">
                    <h2 style="font-size: 1.6em">
                        <alatag:formatSciName rankId="${record.raw.classification.taxonRankID}" name="${record.raw.classification.scientificName}"/> ${record.raw.classification.scientificNameAuthorship}
                        <c:if test="${not empty record.raw.classification.vernacularName}"> | ${record.raw.classification.vernacularName}</c:if>
                    </h2>
                </c:if>
            </div>
            <div id="SidebarBox">
                <c:if test="${not empty record.systemAssertions}">
                    <div class="sidebar">
                        <div id="warnings">
                            <h2>Possible Issues</h2>
                            <p class="half-padding-bottom">Data validation tools identified the following possible issues:</p>
                            <ul>
                                <c:forEach var="systemAssertion" items="${record.systemAssertions}">
                                    <li>
                                        ${systemAssertion.comment} <!--  code: ${systemAssertion.code} -->
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
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
            </div><!-- end div#SidebarBox -->
            <div id="content">
                <div id="occurrenceDataset">
                    <h3>Dataset</h3>
                    <table class="occurrenceTable" id="datasetTable">
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
                                <c:when test="${record.processed.attribution.dataResourceUid != null && not empty record.processed.attribution.dataResourceUid}">
                                    <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.dataResourceUid}">
                                        ${record.processed.attribution.dataResourceName}
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    ${record.processed.attribution.dataResourceName}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Institution -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="institutionCode" fieldName="Institution">
                            <c:choose>
                                <c:when test="${record.processed.attribution.institutionUid != null && not empty record.processed.attribution.institutionUid}">
                                    <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.institutionUid}">
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
                            <c:choose>
                                <c:when test="${not empty record.processed.attribution.collectionName && not empty record.processed.attribution.collectionUid}">
                                    <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.collectionUid}">
                                        ${record.processed.attribution.collectionName}
                                    </a>
                                </c:when>
                                <c:when test="${not empty record.processed.attribution.collectionUid}">
                                    <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.collectionUid}">
                                        [Collection name not known]
                                    </a>
                                </c:when>
                                <c:when test="${not empty record.processed.attribution.collectionName}">
                                    ${record.processed.attribution.collectionName}
                                </c:when>
                                <c:otherwise>
                                    [Collection name not known]
                                </c:otherwise>
                            </c:choose>
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
                        <!-- Record UUID -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="recordUuid" fieldName="Record UUID">
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.uuid}">
                                    ${record.processed.occurrence.uuid}
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.occurrence.uuid}
                                </c:otherwise>
                            </c:choose>
                        </alatag:occurrenceTableRow>
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
                        <!-- Collector/Observer -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="collectorName" fieldName="Collector/Observer">
                            <c:choose>
                                <c:when test="${not empty record.processed.occurrence.recordedBy && not empty record.raw.occurrence.recordedBy}">
                                    ${record.processed.occurrence.recordedBy}
                                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.recordedBy}"</span>
                                </c:when>
                                <c:when test="${not empty record.processed.occurrence.recordedBy}">
                                    ${record.processed.occurrence.recordedBy}
                                </c:when>
                                <c:when test="${not empty record.raw.occurrence.recordedBy}">
                                    ${record.raw.occurrence.recordedBy}
                                </c:when>
                            </c:choose>
                        </alatag:occurrenceTableRow>
                        <!-- Sampling Protocol -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="samplingProtocol" fieldName="Sampling Protocol">
                            ${record.raw.occurrence.samplingProtocol}
                        </alatag:occurrenceTableRow>
                        <!-- Type Status -->
                        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="typeStatus" fieldName="Type Status">
                            ${record.raw.occurrence.typeStatus}
                        </alatag:occurrenceTableRow>
                        <!-- taxonomic Issue -->
                        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="taxonomicIssue" fieldName="taxonomic Issue">
                            <c:if test="${occurrence.taxonomicIssue != 0}">${occurrence.taxonomicIssue}</c:if>
                        </alatag:occurrenceTableRow>
                    </table>
                </div>
                <div id="occurrenceTaxonomy">
                    <h3>Taxonomy</h3>
                    <table class="occurrenceTable" id="taxonomyTable">
                        
                    </table>
                </div>
            </div>
        </c:if>
    </body>
</html>
