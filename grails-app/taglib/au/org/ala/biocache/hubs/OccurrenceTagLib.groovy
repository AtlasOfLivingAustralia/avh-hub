package au.org.ala.biocache.hubs

import groovy.xml.MarkupBuilder
import org.apache.commons.lang.StringUtils

class OccurrenceTagLib {
    //static defaultEncodeAs = 'html'
    //static encodeAsForTags = [tagName: 'raw']
    static namespace = 'alatag'     // namespace for headers and footers

    /**
     * Formats the display of dynamic facet names in Sandbox (facet options popup)
     *
     * @attr fieldName REQUIRED the field name
     */
    def formatDynamicFacetName = { attrs ->
        def fieldName = attrs.fieldName
        def output
        if (fieldName.endsWith('_s') || fieldName.endsWith('_i') || fieldName.endsWith('_d')) {
            output = fieldName.substring(0,-2).replaceAll("_", " ")
        } else if (fieldName.endsWith('_RNG')) {
            output = fieldName.substring(0,-4).replaceAll("_", " ") + " (range)"
        } else {
            output = "${g:message(code:"facet.${fieldName}", default: fieldName)}"
        }
        out << output
    }

    /**
     * Format scientific name for HTML display
     *
     * @attr rankId REQUIRED
     * @attr name REQUIRED
     * @attr acceptedName
     */
    def formatSciName = { attrs ->
        def name = attrs.name
        def acceptedName = attrs.acceptedName
        def rankId = attrs.rankId.toInteger()
        def acceptedNameOutput = ""
        def nameOutput = ""
        def ital = ["",""]

        if (!rankId || rankId >= 6000) {
            ital = ["<i>","</i>"]
        }

        if (acceptedName) {
            acceptedNameOutput = " (accepted name: ${ital[0]}${acceptedName}${ital[1]})"
        }

        nameOutput = "${ital[0]}${name}${ital[1]}${acceptedNameOutput}"

        out << nameOutput.trim()
    }

    /**
     * Output the appropriate raw scientific name for the record
     *
     * @attr occurrence REQUIRED the occurrence record (jsonObject)
     */
    def rawScientificName = { attrs ->
        def rec = attrs.occurrence
        def name

        if (rec.raw_scientificName) {
            name = rec.raw_scientificName
        } else if (rec.species) {
            name = rec.species
        } else if (rec.genus) {
            name = rec.genus
        } else if (rec.family) {
            name = rec.family
        } else if (rec.order) {
            name = rec.order
        } else if (rec.phylum) {
            name = rec.phylum
        }  else if (rec.kingdom) {
            name = rec.kingdom
        } else {
            name = ${g.message(code:"record.noNameSupplied", default: "No name supplied")}
        }

        out << name

//        <g:if test="${occurrence.raw_scientificName}">${occurrence.raw_scientificName}</g:if>
//        <g:elseif test="${occurrence.species}">${occurrence.species}</g:elseif>
//        <g:elseif test="${occurrence.genus}">${occurrence.genus}</g:elseif>
//        <g:elseif test="${occurrence.family}">${occurrence.family}</g:elseif>
//        <g:elseif test="${occurrence.order}">${occurrence.order}</g:elseif>
//        <g:elseif test="${occurrence.phylum}">${occurrence.phylum}</g:elseif>
//        <g:elseif test="${occurrence.kingdom}">${occurrence.kingdom}</g:elseif>
//        <g:else>No name supplied</g:else>
    }

    /**
     * Generate HTML for current filters
     *
     * @attr item REQUIRED
     */
    def currentFilterItem = { attrs ->
//        <g:set var="closeLink">&nbsp;<a href="#" data-facet="${item.key}:${item.value.value.encodeAsHTML()}" onClick="removeFacet(this); return false;" class="btn btn-mini btn-primary removeLink" title="remove filter">
//            <i class="icon-remove icon-white" style="margin-left:5px"></i></a></g:set>
//        <g:set var="filterLabel" value="${alatag.formatDynamicFacetName(fieldName: item.value.displayName)}"/>
//        <g:set var="fqLabel">
//            <g:if test="${filterLabel.startsWith('-')}"><span class="red">[exclude]</span> ${filterLabel.substring(1, filterLabel.size())}</g:if>
//            <g:else>${filterLabel}</g:else>
//        </g:set>
//        <span class="activeFq"><g:message code="${fqLabel}" default="{fqLabel}"/></span>${closeLink}
        def item = attrs.item
        def filterLabel = alatag.formatDynamicFacetName(fieldName: item.value.displayName)
        def fqLabel = (filterLabel.startsWith('-')) ? "<span class=\"red\">[exclude]</span> ${filterLabel.substring(1, filterLabel.size())}" : filterLabel

        def mb = new MarkupBuilder(out)
        mb.span(class:'activeFq') {
            mkp.yield(message(code: fqLabel, default: fqLabel))
        }
        mb.span() { mkp.yieldUnescaped("&nbsp;") }
        mb.a(
                href:"#",
                class: "btn btn-mini btn-primary removeLink",
                title: "remove filter",
                "data-facet":"${item.key}:${item.value.value.encodeAsURL()}",
                onClick:"removeFacet(this); return false;"
        ) {
            i(class:"icon-remove icon-white", style:"margin-left:5px", "")
        }
    }

    /**
     * Generate facet links in the left hand column
     *
     * @attr fieldResult REQUIRED
     * @attr facetResult REQUIRED
     * @attr queryParam REQUIRED
     */
    def facetLinkItems = { attrs ->
        def fieldResult = attrs.fieldResult
        def facetResult = attrs.facetResult
        def queryParam = attrs.queryParam
//        <g:if test="${fieldResult.fq}">
//            <g:set var="fqValue" value="${fieldResult.label?.encodeAsURL()}" /><!-- fieldResult: fqValue = ${fqValue} -->
//            <li><a href="?${queryParam}&fq=${fieldResult.fq?.encodeAsURL()}"><g:message code="${fieldResult.label?:'unknown'}" default="${fieldResult.label}"/></a>
//                (<g:formatNumber number="${fieldResult.count}" format="#,###,###"/>)</li>
//        </g:if>
//        <g:else>
//            <g:set var="fqValue" value="${fieldResult.label?.encodeAsURL()}" /><!-- ELSE fqValue = ${fqValue} -->
//            <li><a href="?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22"><g:message code="${fieldResult.label ? fieldResult.label : 'unknown'}"/></a>
//            (<g:formatNumber number="${fieldResult.count}" format="#,###,###"/>)</li>
//        </g:else>
        def mb = new MarkupBuilder(out)
        def fqValue = fieldResult.label?.encodeAsURL()

        def addCounts = { count ->
            mb.span(class:"facetCount") {
                mkp.yieldUnescaped(" (")
                mkp.yield(g.formatNumber(number: "${count}", format:"#,###,###"))
                mkp.yieldUnescaped(")")
            }
        }

        // Catch specific facets fields
        if (fieldResult.fq) {
            // biocache-service has provided a fq field in the fieldResults list
            mb.li {
                a(href:"?${queryParam}&fq=${fieldResult.fq?.encodeAsURL()}") {
                    mkp.yield(message(code:"${fieldResult.label?:'unknown'}", default:"${fieldResult.label}"))
                    addCounts(fieldResult.count)
                }
            }
        } else if (StringUtils.startsWith(facetResult.fieldName, "occurrence_") && StringUtils.endsWith(fieldResult.label, "Z")) {
            // decade year ranges
            def startYear = fieldResult.label.substring(0, 4)
            def endDate = fieldResult.label.replace('0-01-01T00:00:00Z','9-12-31T11:59:59Z')
            def endYear = endDate.substring(0, 4)

            mb.li {
                a(href:"?${queryParam}&fq=${facetResult.fieldName}:[${fieldResult.label} TO ${endDate}]") {
                    mkp.yieldUnescaped("${startYear} - ${endYear}")
                    addCounts(fieldResult.count)
                }
            }
        } else {
            def label = g.message(code:"${facetResult.fieldName}.${fieldResult.label}", default:"")?:
                    g.message(code:"${fieldResult.label?:'unknown'}", default:"${fieldResult.label}")
            mb.li {
                a(href:"?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22") {
                    mkp.yield(label)
                    addCounts(fieldResult.count)
                }
            }
        }
    }

    /**
     * Determine the recordId
     *
     * @attr record REQUIRED the record object (JsonObject)
     */
    def getRecordId = { attrs ->
//        <c:when test="${skin == 'avh'}">
//            <c:set var="recordId" value="${record.raw.occurrence.catalogNumber}"/>
//        </c:when>
//        <c:when test="${not empty record.raw.occurrence.collectionCode && not empty record.raw.occurrence.catalogNumber}">
//            <c:set var="recordId" value="${record.raw.occurrence.collectionCode} - ${record.raw.occurrence.catalogNumber}"/>
//        </c:when>
//        <c:when test="${not empty record.processed.attribution.dataResourceName && not empty record.raw.occurrence.catalogNumber}">
//            <c:set var="recordId" value="${record.processed.attribution.dataResourceName} - ${record.raw.occurrence.catalogNumber}"/>
//        </c:when>
//        <c:when test="${not empty record.raw.occurrence.occurrenceID}">
//            <c:set var="recordId" value="${record.raw.occurrence.occurrenceID}"/>
//        </c:when>
//        <c:otherwise>
//            <c:set var="recordId" value="${record.raw.uuid}"/>
//        </c:otherwise>
        def record = attrs.record
        out << record.raw.uuid
    }

    /**
     * Determine the scientific name
     *
     * @attr record REQUIRED the record object (JsonObject)
     */
    def getScientificName = { attrs ->
//        <c:choose>
//            <c:when test="${not empty record.processed.classification.scientificName}">
//                    ${record.processed.classification.scientificName} ${record.processed.classification.scientificNameAuthorship}
//            </c:when>
//            <c:when test="${not empty record.raw.classification.scientificName}">
//                ${record.raw.classification.scientificName} ${record.raw.classification.scientificNameAuthorship}
//            </c:when>
//            <c:otherwise>
//                    ${record.raw.classification.genus} ${record.raw.classification.specificEpithet}
//            </c:otherwise>
//        </c:choose>
        def record = attrs.record
        out << "${record.raw.classification.genus} ${record.raw.classification.specificEpithet}"
    }

    /**
     * TODO
     *
     * @attr groupedAssertions REQUIRED
     */
    def groupedAssertions = { attrs ->
        def groupedAssertions = attrs.groupedAssertions
        out << "${groupedAssertions} TODO"
    }

    /**
     * TODO
     *
     * @attr code REQUIRED
     */
    def dataQualityHelp = { attrs ->
        def code = attrs.code
        out << "${code} TODO"
    }

    /**
     * TODO
     *
     * @attr map REQUIRED
     */
    def formatRawVsProcessed = { attrs ->
//        <c:forEach var="group" items="${map}">
//            <c:choose>
//                <c:when test="${not empty group.value}">
//                    <c:forEach var="field" items="${group.value}" varStatus="status">
//                        <c:set var="grayBg">${(status.index % 2 == 0) ? 'grey-bg': ''}</c:set>
//                        <c:set var="rawRecordedBy"><alatag:authUserLookup userId="${field.raw}" allUserNamesByIdMap="${userNamesByIdMap}" allUserNamesByNumericIdMap="${userNamesByNumericIdMap}"/></c:set>
//                        <c:set var="proRecordedBy"><alatag:authUserLookup userId="${field.processed}" allUserNamesByIdMap="${userNamesByIdMap}" allUserNamesByNumericIdMap="${userNamesByNumericIdMap}"/></c:set>
//                        <tr>
//                            <c:if test="${status.first}">
//                                <td rowspan="${fn:length(group.value)}">${group.key}</td>
//                            </c:if>
//                            <td class="${grayBg} dwc">${field.name}</td>
//                            <td class="${grayBg}">${(field.name == 'recordedBy' && fn:contains(field.raw,'@')) ? rawRecordedBy : field.raw}<%-- we're obfuscating email addresses --%></td>
//                            <td class="${grayBg}">${(field.name == 'recordedBy' && fn:contains(field.processed,'@')) ? proRecordedBy : field.processed}<%-- we're obfuscating email addresses --%></td>
//                        </tr>
//                    </c:forEach>
//                </c:when>
//            </c:choose>
//        </c:forEach>
        def map = attrs.map
        def mb = new MarkupBuilder(out)

        map.each { group ->
            if (group.value) {
                group.value.eachWithIndex() { field, i ->
                    mb.tr() {
                        if (i == 0) {
                            td(class:"noStripe", rowspan:"${group.value.length()}", group.key)
                        }
                        td(field.name)
                        td(field.raw)
                        td(field.processed)
                    }
                }
            }
        }

    }

    /**
     * TODO
     *
     * @attr fieldName REQUIRED
     * @attr fieldNameIsMsgCode
     * @attr fieldCode REQUIRED
     * @attr section REQUIRED
     * @attr annotate REQUIRED
     * @attr path
     * @attr guid
     */
    def occurrenceTableRow = { attrs, body ->
//        <c:set var="bodyText"><jsp:doBody/></c:set>
//        <c:set var="annoIcon"><c:if test="${annotate}">${section}</c:if></c:set>
//        <c:choose>
//          <c:when test="${not empty guid}">
//            <c:set var="link">${path}${guid}</c:set>
//          </c:when>
//          <c:otherwise>
//            <c:set var="link"></c:set>
//          </c:otherwise>
//        </c:choose>
//        <c:if test="${not empty bodyText}">
//            <tr id="${fieldCode}">
//                <td class="dwcLabel">
//                <c:choose>
//                <c:when test="${fieldNameIsMsgCode}"><fmt:message key="${fieldName}"/></c:when>
//                        <c:otherwise>${fieldName}</c:otherwise>
//                </c:choose>
//                </td>
//                <%--<td class="annoText" name="${fieldCode}"></td>--%>
//                <td class="value">
//                    <c:if test="${not empty link}"><a href="${link}"></c:if>${bodyText}<c:if test="${not empty link}"></a></c:if>
//                <div class="annoText"></div>
//                </td>
//                <%--<td class="${annoIcon}" name="${fieldCode}"></td>--%>
//            </tr>
//        </c:if>
        String bodyText = (String) body()
        def guid = attrs.guid
        def path = attrs.path
        def fieldCode = attrs.fieldCode
        def fieldName = attrs.fieldName
        def fieldNameIsMsgCode = attrs.fieldNameIsMsgCode

        if (StringUtils.isNotBlank(bodyText)) {
            def link = (guid) ? "${path}${guid}" : ""
            def mb = new MarkupBuilder(out)

            mb.tr(id:"${fieldCode}") {
                td(class:"dwcLabel") {
                    if (fieldNameIsMsgCode) {
                        mkp.yield(g.message(code: "${fieldName}", default :"${fieldName}"))
                    } else {
                        mkp.yieldUnescaped(fieldName)
                    }

                }
                td(class:"value") {
                    if (link) {
                        a(href: link) {
                            mkp.yieldUnescaped(bodyText)
                        }
                    } else {
                        mkp.yieldUnescaped(bodyText)
                    }
                }
            }
        }
    }

//    attribute name="compareRecord" required="true" type="java.util.Map" %><%@
//    attribute name="fieldsMap" required="true" type="java.util.Map" %><%@
//    attribute name="group" required="true" type="java.lang.String" %><%@
//    attribute name="exclude" required="true" type="java.lang.String" %>

//    <c:forEach items="${compareRecord[group]}" var="cr">
//        <c:set var="key" value="${cr.name}" />
//        <c:if test="${empty fieldsMap[key] && !fn:contains(exclude, key)}">
//            <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="${cr.name}" fieldName="<span class='dwc'>${cr.name}</span>">
//                <c:choose>
//                    <c:when test="${not empty cr.processed && not empty cr.raw && cr.processed == cr.raw}">${cr.processed}</c:when>
//                    <c:when test="${empty cr.raw && not empty cr.processed}"><fmt:message key="${cr.processed}"/></c:when>
//                    <c:when test="${not empty cr.raw && empty cr.processed}"><fmt:message key="${cr.raw}"/></c:when>
//                    <c:otherwise>${cr.processed} <br/><span class="originalValue">Supplied as ${cr.raw}</span></c:otherwise>
//                </c:choose>
//            </alatag:occurrenceTableRow>
//        </c:if>
//    </c:forEach>


    /**
     * TODO
     *
     * @attr compareRecord REQUIRED
     * @attr fieldsMap REQUIRED
     * @attr group REQUIRED
     * @attr exclude REQUIRED
     */
    def formatExtraDwC = { attrs ->
        def compareRecord = attrs.compareRecord
        Map fieldsMap = attrs.fieldsMap
        def group = attrs.group
        def exclude = attrs.exclude
        def output = ""
        def mb = new MarkupBuilder(out)

        compareRecord.get(group).each { cr ->
            def key = cr.name
            def label = g.message(code:key, default:"")?:StringUtils.capitalize(key)

            // only output fields not already included (by checking fieldsMap Map) && not in excluded list
            if (!fieldsMap.containsKey(key) && !StringUtils.containsIgnoreCase(exclude, key)) {
                //def mb = new MarkupBuilder(out)
                def tagBody

                if (cr.processed && cr.raw && cr.processed == cr.raw) {
                    tagBody = cr.processed
                } else if (!cr.raw && cr.processed) {
                    tagBody = cr.processed
                } else if (cr.raw && !cr.processed) {
                    tagBody = cr.raw
                } else {
                    tagBody = "${cr.processed} <br/><span class='originalValue'>Supplied as ${cr.raw}</span>"
                }
                output += alatag.occurrenceTableRow(annotate:"true", section:"dataset", fieldCode:"${key}", fieldName:"<span class='dwc'>${label}</span>") {
                    tagBody
                }
            }
        }

        out << output
    }


}
