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
<c:set var="scientificName">
    <c:choose>
        <c:when test="${not empty record.processed.classification.scientificName}">
            ${record.processed.classification.scientificName} ${record.processed.classification.scientificNameAuthorship}
        </c:when>
        <c:otherwise>
            ${record.raw.classification.scientificName} ${record.raw.classification.scientificNameAuthorship}
        </c:otherwise>
    </c:choose>
</c:set>
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
        <spring:url var="json" value="/occurrence/${record.raw.uuid}.json" />
        <c:if test="${not empty recordId}">
            <div id="headingBar" class="recordHeader">
                <h1>Occurrence Record: <span id="recordId">${recordId}</span></h1>
                <div id="jsonLink"><a href="${json}">JSON</a></div>
                <c:if test="${not empty record.raw.classification.scientificName}">
                    <h2 id="headingSciName">
                        <c:choose>
                            <c:when test="${not empty record.processed.classification.scientificName}">
                                <alatag:formatSciName rankId="${record.processed.classification.taxonRankID}" name="${record.processed.classification.scientificName}"/>
                                ${record.processed.classification.scientificNameAuthorship}
                            </c:when>
                            <c:otherwise>
                                <alatag:formatSciName rankId="${record.raw.classification.taxonRankID}" name="${record.raw.classification.scientificName}"/>
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
                <c:if test="${not empty record.systemAssertions}">
                    <div class="sidebar">
                        <div id="warnings">
                            <h2>Possible Issues</h2>
                            <p class="half-padding-bottom">Data validation tools identified the following possible issues:</p>
                            <ul>
                                <c:forEach var="systemAssertion" items="${record.systemAssertions}">
                                    <li>
                                        <!--  code: ${systemAssertion.code} -->
                                        ${systemAssertion.comment}<c:if test="${not empty systemAssertion.name}">: ${systemAssertion.name}</c:if>
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
                                <c:when test="${not empty record.processed.attribution.collectionUid && not empty collectionName}">
                                    <a href="${collectionsWebappContext}/public/show/${record.processed.attribution.collectionUid}">
                                        ${collectionName}
                                    </a>
                                </c:when>
                                <c:when test="${not empty record.processed.attribution.collectionName}">
                                    ${record.processed.attribution.collectionName}
                                </c:when>
                                <c:when test="${not empty collectionName}">
                                    ${collectionName}
                                </c:when>
                                <c:otherwise>
                                    <%-- [Collection name not known] --%>
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
                                <c:when test="${not empty record.processed.uuid}">
                                    ${record.processed.uuid}
                                </c:when>
                                <c:otherwise>
                                    ${record.raw.uuid}
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
                    </table>
                </div>
                <div id="occurrenceTaxonomy">
                    <h3>Taxonomy</h3>
                    <table class="occurrenceTable" id="taxonomyTable">
                        <!-- Scientific Name -->
                        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="scientificName" fieldName="Scientific Name">
                            <c:if test="${not empty record.processed.classification.taxonConceptID}">
                                <a href="${bieWebappContext}/species/${record.processed.classification.taxonConceptID}">
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
                                    <c:otherwise>
                                        <alatag:formatSciName rankId="${record.processed.classification.taxonRankID}" name="${record.processed.classification.scientificName}"/>
                                        ${record.processed.classification.scientificNameAuthorship}
                                    </c:otherwise>
                                </c:choose>
                            </c:set>
                            <c:choose>
                                <c:when test="${not empty record.processed.classification.taxonConceptID}">
                                    <a href="${bieWebappContext}/species/${record.processed.classification.taxonConceptID}">${displaySciName}</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${bieWebappContext}/search?q=${fn:replace(scientificName, '  ', ' ')}">${displaySciName}</a>
                                </c:otherwise>
                            </c:choose>
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.kingdomID}">
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.phylumID}">
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.classID}">
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.orderID}">
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.familyID}">
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.genusID}">
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
                                <a href="${bieWebappContext}/species/${record.processed.classification.speciesID}">
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
                    </table>
                </div>
                <div id="geospatialTaxonomy">
                    <h3>Geospatial</h3>
                    <table class="occurrenceTable" id="geospatialTable">
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
                                <a href="${bieWebappContext}/regions/aus_states/${stateValue}">${stateValue}</a>
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
                        <!-- Latitude -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="latitude" fieldName="Latitude">
                            ${(not empty record.processed.location.decimalLatitude) ? record.processed.location.decimalLatitude : record.raw.location.decimalLatitude}
                        </alatag:occurrenceTableRow>
                        <!-- Longitude -->
                        <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="longitude" fieldName="Longitude">
                            ${(not empty record.processed.location.decimalLongitude) ? record.processed.location.decimalLongitude : record.raw.location.decimalLongitude}
                        </alatag:occurrenceTableRow>
                        <!-- Coordinate Precision -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinatePrecision" fieldName="Coordinate Precision (metres)">
                            <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                                ${not empty record.processed.location.coordinateUncertaintyInMeters ? record.processed.location.coordinateUncertaintyInMeters : 'Unknown'}
                            </c:if>
                        </alatag:occurrenceTableRow>
                        <!-- Coordinates Generalised -->
                        <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="generalisedInMetres" fieldName="Coordinates Generalised">
                            <c:if test="${not empty record.processed.location.coordinatePrecision}">
                                Due to sensitivity concerns, the coordinates of this record have been generalised to ${rawOccurrence.generalisedInMetres} metres.
                            </c:if>
                        </alatag:occurrenceTableRow>

                    </table>
                </div>
            </div>
        </c:if>
    </body>
</html>

