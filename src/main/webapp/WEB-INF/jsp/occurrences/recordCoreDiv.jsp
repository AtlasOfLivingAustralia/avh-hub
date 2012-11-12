<%-- 
    Document   : recordCoreDiv
    Date       : 1/05/12
    Time       : 12:10 PM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%><%@
        page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%><%@
        include file="/common/taglibs.jsp" %><%@
        page import="java.util.Map" %><%@
        page import="java.util.HashMap" %>
<% Map fieldsMap = new HashMap(); pageContext.setAttribute("fieldsMap", fieldsMap); %>
<%-- c:set target="${fieldsMap}" property="aKey" value="value for a key" /--%>
<div id="occurrenceDataset">
    <h3>Dataset</h3>
    <table class="occurrenceTable" id="datasetTable">
        <c:if test="${useAla == 'true'}">
            <!-- Data Provider -->
            <c:if test="${not fn:contains(skin, 'avh')}">
                <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="dataProvider" fieldName="Data provider">
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
                <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="dataResource" fieldName="Data set">
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
        </c:if>
        <!-- Institution -->
        <c:if test="${not fn:contains(skin, 'avh')}">
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
                    <c:if test="${not empty record.processed.attribution.institutionName}"><br/></c:if>
                    <span class="originalValue">Supplied as "${record.raw.occurrence.institutionCode}"</span>
                </c:if>
            </alatag:occurrenceTableRow>
        </c:if>
        <!-- Collection -->
        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldNameIsMsgCode="true" fieldCode="collectionCode" fieldName="Collection">
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
            <c:if test="${false && not empty record.raw.occurrence.collectionCode}">
                <c:set target="${fieldsMap}" property="collectionCode" value="true" />
                <c:if test="${not empty collectionName || not empty record.processed.attribution.collectionName}"><br/></c:if>
                <span class="originalValue" style="display:none">Supplied as "${record.raw.occurrence.collectionCode}"</span>
            </c:if>
        </alatag:occurrenceTableRow>
        <!-- Catalog Number -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="catalogueNumber" fieldName="Catalogue number">
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
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="otherCatalogNumbers" fieldName="Other catalogue numbers">
            <c:set target="${fieldsMap}" property="otherCatalogNumbers" value="true" />
            ${record.raw.occurrence.otherCatalogNumbers}
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
        <!-- not shown
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
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="basisOfRecord" fieldName="Basis of record">
            <c:set target="${fieldsMap}" property="basisOfRecord" value="true" />
            <c:choose>
                <c:when test="${not empty record.processed.occurrence.basisOfRecord && not empty record.raw.occurrence.basisOfRecord && record.processed.occurrence.basisOfRecord == record.raw.occurrence.basisOfRecord}">
                    <fmt:message key="${record.processed.occurrence.basisOfRecord}"/>
                </c:when>
                <c:when test="${not empty record.processed.occurrence.basisOfRecord && not empty record.raw.occurrence.basisOfRecord}">
                    <fmt:message key="${record.processed.occurrence.basisOfRecord}"/>
                    <br/><span class="originalValue">Supplied as "${record.raw.occurrence.basisOfRecord}"</span>
                </c:when>
                <c:when test="${not empty record.processed.occurrence.basisOfRecord}">
                    <fmt:message key="${record.processed.occurrence.basisOfRecord}"/>
                </c:when>
                <c:when test="${empty record.raw.occurrence.basisOfRecord}">
                   Not supplied
                </c:when>
                <c:otherwise>
                    <fmt:message key="${record.raw.occurrence.basisOfRecord}"/>
                </c:otherwise>
            </c:choose>
        </alatag:occurrenceTableRow>
        <!-- Preparations -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="preparations" fieldName="Preparations">
            <c:set target="${fieldsMap}" property="preparations" value="true" />
            ${record.raw.occurrence.preparations}
        </alatag:occurrenceTableRow>
        <!-- Identifier Name -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierName" fieldNameIsMsgCode="true" fieldName="Identified by">
            <c:set target="${fieldsMap}" property="identifiedBy" value="true" />
            ${record.raw.identification.identifiedBy}
        </alatag:occurrenceTableRow>
        <!-- Identified Date -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierDate"  fieldNameIsMsgCode="true" fieldName="Identified date">
            <c:set target="${fieldsMap}" property="identifierDate" value="true" />
            ${record.raw.identification.dateIdentified}
        </alatag:occurrenceTableRow>
        <!-- Identified Date -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identifierRole"  fieldNameIsMsgCode="true" fieldName="Identifier role">
            <c:set target="${fieldsMap}" property="identifierRole" value="true" />
            ${record.raw.identification.identifierRole}
        </alatag:occurrenceTableRow>
        <!-- Field Number -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="fieldNumber" fieldName="Field number">
            <c:set target="${fieldsMap}" property="fieldNumber" value="true" />
            ${record.raw.occurrence.fieldNumber}
        </alatag:occurrenceTableRow>
        <!-- Field Number -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identificationRemarks" fieldNameIsMsgCode="true" fieldName="Identification remarks">
            <c:set target="${fieldsMap}" property="identificationRemarks" value="true" />
            ${record.raw.identification.identificationRemarks}
        </alatag:occurrenceTableRow>
        <!-- Collector/Observer -->
        <c:set var="collectorNameLabel">
        <c:choose>
        <c:when test="${fn:containsIgnoreCase(record.processed.occurrence.basisOfRecord, 'specimen')}">Collector</c:when>
        <c:when test="${fn:containsIgnoreCase(record.processed.occurrence.basisOfRecord, 'observation')}">Observer</c:when>
        <c:otherwise>Collector/Observer</c:otherwise>
        </c:choose>
        </c:set>
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="collectorName" fieldName="${collectorNameLabel}">
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
        <!-- Record Number -->
        <c:set var="recordNumberLabel">
        <c:choose>
        <c:when test="${fn:containsIgnoreCase(record.processed.occurrence.basisOfRecord, 'specimen')}">Collecting number</c:when>
        <c:otherwise>Record number</c:otherwise>
        </c:choose>
        </c:set>
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="recordNumber" fieldName="${recordNumberLabel}">
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
        <!-- Record Date -->
        <c:set var="occurrenceDateLabel">
          <c:choose>
	        <c:when test="${fn:containsIgnoreCase(record.processed.occurrence.basisOfRecord, 'specimen')}">Collecting date</c:when>
    	    <c:otherwise>Record date</c:otherwise>
          </c:choose>
        </c:set>
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="occurrenceDate" fieldName="${occurrenceDateLabel}">
            <c:set target="${fieldsMap}" property="eventDate" value="true" />
            <c:if test="${empty record.processed.event.eventDate && record.raw.event.eventDate && empty record.raw.event.year && empty record.raw.event.month && empty record.raw.event.day}">
              [date not supplied]
            </c:if>
            <c:if test="${not empty record.processed.event.eventDate}">
                <span class="isoDate">${record.processed.event.eventDate}</span>
            </c:if>
            <c:if test="${empty record.processed.event.eventDate && (not empty record.processed.event.year || not empty record.processed.event.month || not empty record.processed.event.day)}">
              Year: ${record.processed.event.year},
              Month: ${record.processed.event.month},
              Day: ${record.processed.event.day}
            </c:if>
            <c:choose>
              <c:when test="${not empty record.processed.event.eventDate && not empty record.raw.event.eventDate && record.raw.event.eventDate != record.processed.event.eventDate}">
                <br/><span class="originalValue">Supplied as "${record.raw.event.eventDate}"</span>
              </c:when>
              <c:when test="${not empty record.raw.event.year || not empty record.raw.event.month || not empty record.raw.event.day}">
                <br/><span class="originalValue">Supplied as  "year: ${record.raw.event.year}, month: ${record.raw.event.month}, day: ${record.raw.event.day}"</span>
              </c:when>
              <c:when test="${record.raw.event.eventDate != record.processed.event.eventDate}">
                <br/><span class="originalValue">Supplied as "${record.raw.event.eventDate}"</span>
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
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="identificationQualifier" fieldName="Identification qualifier">
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
        <!-- Rights -->
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="rights" fieldName="Rights">
            <c:set target="${fieldsMap}" property="rights" value="true" />
            ${record.raw.occurrence.rights}
        </alatag:occurrenceTableRow>
        <!-- Occurrence details -->
        <alatag:occurrenceTableRow annotate="false" section="dataset" fieldCode="occurrenceDetails" fieldName="More details">
            <c:set target="${fieldsMap}" property="occurrenceDetails" value="true" />
            <c:if test="${not empty record.raw.occurrence.occurrenceDetails && fn:startsWith(record.raw.occurrence.occurrenceDetails,'http://')}">
                <a href="${record.raw.occurrence.occurrenceDetails}" target="_blank">${record.raw.occurrence.occurrenceDetails}</a>
            </c:if>
        </alatag:occurrenceTableRow>
        <!-- associatedOccurrences - handles the duplicates that are added via ALA Duplication Detection -->
        <c:if test="${not empty record.processed.occurrence.duplicationStatus}">
        	<c:set target="${fieldsMap}" property="duplicationStatus" value="true" />
        	<c:set target="${fieldsMap}" property="associatedOccurrences" value="true" />
        	<alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="duplicationStatus" fieldName="Associated Occurrence Status">
        		<fmt:message key="duplication.${record.processed.occurrence.duplicationStatus}"/>
        	</alatag:occurrenceTableRow>
        	<!-- Now handle the associatedOccurrences -->
        	<alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="associatedOccurrences" fieldName="Inferred Associated Occurrences">
        		<c:choose>
        			<c:when test="${record.processed.occurrence.duplicationStatus == 'R'}">        			 
        			This record has ${fn:length(fn:split(record.processed.occurrence.associatedOccurrences, '|')) } inferred associated occurrences
        			</c:when>
        			<c:otherwise>The occurrence is associated with a representative record.  </c:otherwise>
        		</c:choose>
        		<br>
        		For more information see <a href="#inferredOccurrenceDetails">Inferred associated occurrence details</a>
<%-- 	        	<c:forEach var="docc" items="${fn:split(record.processed.occurrence.associatedOccurrences, '|')}">
	                <a href="${pageContext.request.contextPath}/occurrences/${docc}">${docc}</a>
	                <br> 
	            </c:forEach> --%>
             </alatag:occurrenceTableRow>
             <c:if test="${not empty record.raw.occurrence.associatedOccurrences }">
             	<alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="associatedOccurrences" fieldName="Associated Occurrences">
             		${record.raw.occurrence.associatedOccurrences }
             	</alatag:occurrenceTableRow>
             </c:if>
        </c:if>
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
            <c:if test="${empty record.processed.classification.scientificName && not empty record.raw.classification.scientificName}">
                ${record.raw.classification.scientificName}
            </c:if>
        </alatag:occurrenceTableRow>
        <!-- original name usage -->
        <alatag:occurrenceTableRow annotate="true" section="taxonomy" fieldCode="originalNameUsage" fieldName="Original name">
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
<c:if test="${not empty compareRecord.Location}">
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
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="state" fieldName="State or territory">
                <c:set target="${fieldsMap}" property="stateProvince" value="true" />
                <c:set var="stateValue" value="${not empty record.processed.location.stateProvince ? record.processed.location.stateProvince : record.raw.location.stateProvince}" />
                <c:if test="${not empty stateValue}">
                    <%--<a href="${bieWebappContext}/regions/aus_states/${stateValue}">--%>
                        ${stateValue}
                    <%--</a>--%>
                </c:if>
                <c:if test="${not empty record.processed.location.stateProvince && not empty record.raw.location.stateProvince && (fn:toLowerCase(record.processed.location.stateProvince) != fn:toLowerCase(record.raw.location.stateProvince))}">
                    <br/><span class="originalValue">Supplied as: "${record.raw.location.stateProvince}"</span>
                </c:if>
            </alatag:occurrenceTableRow>
            <!-- Local Govt Area -->
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locality" fieldName="Local government area">
                <c:set target="${fieldsMap}" property="lga" value="true" />
                <c:if test="${not empty record.processed.location.lga}">
                    ${record.processed.location.lga}
                </c:if>
                <c:if test="${empty record.processed.location.lga && not empty record.raw.location.lga}">
                    ${record.raw.location.lga}
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
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="verbatimCoordinateSystem" fieldName="Verbatim coordinate system">
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
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="minimumDepthInMeters" fieldName="Minimum depth in metres">
                <c:set target="${fieldsMap}" property="minimumDepthInMeters" value="true" />
                ${record.raw.location.minimumDepthInMeters}
            </alatag:occurrenceTableRow>
            <!-- Max depth -->
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="maximumDepthInMeters" fieldName="Maximum depth in metres">
                <c:set target="${fieldsMap}" property="maximumDepthInMeters" value="true" />
                ${record.raw.location.maximumDepthInMeters}
            </alatag:occurrenceTableRow>
            <!-- Min elevation -->
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="minimumElevationInMeters" fieldName="Minimum elevation in metres">
                <c:set target="${fieldsMap}" property="minimumElevationInMeters" value="true" />
                ${record.raw.location.minimumElevationInMeters}
            </alatag:occurrenceTableRow>
            <!-- Max elevation -->
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="maximumElevationInMeters" fieldName="Maximum elevation in metres">
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
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="locationRemarks" fieldName="Location remarks">
                <c:set target="${fieldsMap}" property="locationRemarks" value="true" />
                ${record.raw.location.locationRemarks}
            </alatag:occurrenceTableRow>
            <!-- Field notes -->
            <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="fieldNotes" fieldName="Field notes">
                <c:set target="${fieldsMap}" property="fieldNotes" value="true" />
                ${record.raw.occurrence.fieldNotes}
            </alatag:occurrenceTableRow>
            <!-- Coordinate Precision -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinatePrecision" fieldName="Coordinate precision">
                <c:set target="${fieldsMap}" property="coordinatePrecision" value="true" />
                <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                    ${not empty record.processed.location.coordinatePrecision ? record.processed.location.coordinatePrecision : 'Unknown'}
                </c:if>
            </alatag:occurrenceTableRow>
            <!-- Coordinate Uncertainty -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="coordinateUncertaintyInMeters" fieldName="Coordinate uncertainty in metres">
                <c:set target="${fieldsMap}" property="coordinateUncertaintyInMeters" value="true" />
                <c:if test="${not empty record.raw.location.decimalLatitude || not empty record.raw.location.decimalLongitude}">
                    ${not empty record.processed.location.coordinateUncertaintyInMeters ? record.processed.location.coordinateUncertaintyInMeters : 'Unknown'}
                </c:if>
            </alatag:occurrenceTableRow>
            <!-- Data Generalizations -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="generalisedInMetres" fieldName="Coordinates generalised">
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
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="informationWithheld" fieldName="Information withheld">
                <c:set target="${fieldsMap}" property="informationWithheld" value="true" />
                <c:if test="${not empty record.processed.occurrence.informationWithheld}">
                    <span class="dataGeneralizations">${record.processed.occurrence.informationWithheld}</span>
                </c:if>
            </alatag:occurrenceTableRow>
            <!-- GeoreferenceVerificationStatus -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceVerificationStatus" fieldName="Georeference verification status">
                <c:set target="${fieldsMap}" property="georeferenceVerificationStatus" value="true" />
                ${record.raw.location.georeferenceVerificationStatus}
            </alatag:occurrenceTableRow>
            <!-- georeferenceSources -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceSources" fieldName="Georeference sources">
                <c:set target="${fieldsMap}" property="georeferenceSources" value="true" />
                ${record.raw.location.georeferenceSources}
            </alatag:occurrenceTableRow>
            <!-- georeferenceProtocol -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferenceProtocol" fieldName="Georeference protocol">
                <c:set target="${fieldsMap}" property="georeferenceProtocol" value="true" />
                ${record.raw.location.georeferenceProtocol}
            </alatag:occurrenceTableRow>
            <!-- georeferenceProtocol -->
            <alatag:occurrenceTableRow annotate="false" section="geospatial" fieldCode="georeferencedBy" fieldName="Georeferenced by">
                <c:set target="${fieldsMap}" property="georeferencedBy" value="true" />
                ${record.raw.location.georeferencedBy}
            </alatag:occurrenceTableRow>
            <!-- output any tags not covered already (excluding those in dwcExcludeFields) -->
            <alatag:formatExtraDwC compareRecord="${compareRecord}" fieldsMap="${fieldsMap}" group="Location" exclude="${dwcExcludeFields}"/>
        </table>
    </div>
</c:if>
<c:if test="${not empty record.raw.miscProperties}">
    <div id="additionalProperties">
        <h3>Additional properties</h3>
        <table class="occurrenceTable" id="miscellaneousPropertiesTable">
            <!-- Higher Geography -->
            <c:forEach items="${record.raw.miscProperties}" var="entry">
                <alatag:occurrenceTableRow annotate="true" section="geospatial" fieldCode="${entry.key}" fieldName="<span class='dwc'>${entry.key}</span>">${entry.value}</alatag:occurrenceTableRow>
            </c:forEach>
        </table>
    </div>
</c:if>