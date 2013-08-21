<%--                                                                                       userAssertionComments
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<c:choose>
    <c:when test="${fn:contains(skin, 'avh')}">
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
<c:set var="bieWebappContext" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="bieWebappContext"/></c:set>
<c:set var="collectionsWebappContext" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="collectionsWebappContext"/></c:set>
<c:set var="useAla" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="useAla"/></c:set>
<c:set var="hubDisplayName" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayName"/></c:set>
<c:set var="biocacheService" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>

<%--<c:set var="sensitiveDatasets" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="sensitiveDatasets.NSW_DECCW"/></c:set>--%>
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

            /**
             * JQuery on document ready callback
             */
            $(document).ready(function() {
                // convert camel case field names to "normal"
                $("td.dwc, span.dwc").each(function(i, el) {
                    var html = $(el).html();
                    $(el).html(fileCase(html)); // conver it
                });

                // load a JS map with sensitiveDatasets values from hubs.properties file
                var sensitiveDatasets = {
                    <c:forEach var="sds" items="${sensitiveDatasets}" varStatus="s">
                    ${sds}: '<ala:propertyLoader checkSupplied="true" bundle="hubs" property="sensitiveDatasets.${sds}"/>'<c:if test="${not s.last}">,</c:if>
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
            });

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
        </script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/record.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/button.css" type="text/css" media="screen" />
        <style type="text/css">
            div#fullRecord {
                float: right;
                display: inline-block;
                font-size: 14px;
                font-weight: bold;
                margin-top: 15px;
            }

            div#fullRecord a:link {
                text-decoration: none;
            }

            #container {
                width: 95%;
            }

            #content2 {
                width: 98%;
            }

            #main_content {
                margin-top: 10px;
                margin-bottom: 10px;
                width: 100%;
            }

            .occurrenceTable th {
                width: 20%;
            }
        </style>
    </head>
    <body>
    <c:if test="${not empty record.raw}">
        <div id="headingBar" class="recordHeader">
            <div id="fullRecord">
                <a href="${pageContext.request.contextPath}/occurrence/${record.raw.uuid}" id="fullRecordLink" class="btn"
                   target="_parent"  title="View the full record">View full record</a>
            </div>
            <h1><fmt:message key="show.occurrenceRecord"/>: <span id="recordId">${recordId}</span></h1>
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
        <div id="content2">
            <jsp:include page="recordCoreDiv.jsp"/>
        </div><!-- end of div#content2 -->
    </c:if>
    <c:if test="${empty record.raw}">
        <div id="headingBar">
            <h1>Record Not Found</h1>
            <p>The requested record ID "${uuid}" was not found</p>
        </div>
    </c:if>
    </body>
</html>
