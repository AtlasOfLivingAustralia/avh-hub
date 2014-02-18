package au.org.ala.biocache.hubs

import groovy.xml.MarkupBuilder

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
                "data-facet":"${item.key}:${item.value.value.encodeAsHTML()}",
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

        if (fieldResult.fq) {
            mb.li {
                a(href:"?${queryParam}&fq=${fieldResult.fq?.encodeAsURL()}") {
                    mkp.yield(message(code:"${fieldResult.label?:'unknown'}", default:"${fieldResult.label}"))
                    addCounts(fieldResult.count)
                }
            }
        } else if (false) {
            // todo
        } else {
            mb.li {
                a(href:"?${queryParam}&fq=${facetResult.fieldName}:%22${fqValue}%22") {
                    mkp.yield(message(code:"${fieldResult.label?:'unknown'}", default:"${fieldResult.label}"))
                    addCounts(fieldResult.count)
                }
            }
        }

    }
}
