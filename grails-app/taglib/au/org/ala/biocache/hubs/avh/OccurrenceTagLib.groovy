package au.org.ala.biocache.hubs.avh

import groovy.xml.MarkupBuilder
import org.codehaus.groovy.grails.web.json.JSONObject

class OccurrenceTagLib {
    //static defaultEncodeAs = 'html'
    //static encodeAsForTags = [tagName: 'raw']
    static namespace = 'alatag'

    /**
     * Output a row (occurrence record) in the search results "Records" tab
     *
     * @attr occurrence REQUIRED
     */
    def formatListRecordRow = { attrs ->
        def JSONObject occurrence = attrs.occurrence
        def rawScientificName = alatag.rawScientificName(occurrence: occurrence)
        def mb = new MarkupBuilder(out)

        def outputResultsTd = { label, value, test ->
            if (test) {
                mb.td() {
                    strong(class:'resultsLabel') {
                        mkp.yieldUnescaped(label)
                    }
                    mkp.yieldUnescaped(value)
                }
            }
        }

        mb.div(class:'recordRow', id:occurrence.uuid ) {
            p(class:'rowA') {
                span(class:"occurrenceNames", "${rawScientificName}")

                if (occurrence.raw_catalogNumber!= null && occurrence.raw_catalogNumber) {
                    span(style:'display:inline-block;float:right;') {
                        strong(class:'resultsLabel') {
                            mkp.yieldUnescaped("Catalogue&nbsp;number:")
                        }
                        mkp.yieldUnescaped(occurrence.raw_catalogNumber)
                    }
                }
            }
            table(class:"avhRowB") {
                tr() {
                    outputResultsTd("State: ", occurrence.stateProvince, occurrence.stateProvince)
                    outputResultsTd("Locality: ", occurrence.lga, occurrence.lga)
                }
                tr() {
                    outputResultsTd("Collector: ", "${occurrence.collector}&nbsp;&nbsp;${occurrence.recordNumber}", true)
                    outputResultsTd("Data&nbsp;Resource: ", occurrence.dataResourceName, !occurrence.collectionName && occurrence.dataResourceName)
                    outputResultsTd("Date: ", occurrence.eventDate, occurrence.eventDate)
                    outputResultsTd("Date: ", occurrence.year, !occurrence.eventDate && occurrence.year)
                }
                tr() {
                    outputResultsTd("Herbarium: ", occurrence.collectionName, occurrence.collectionName)
                    td(colspan: '2', style: 'text-align: right;') {
                        a(
                                href: g.createLink(url:"${request.contextPath}/occurrences/${occurrence.uuid}"),
                                class:"occurrenceLink",
                                style:"margin-left: 15px;",
                                "View record"
                        )
                    }
                }
            }
        }
    }
}
