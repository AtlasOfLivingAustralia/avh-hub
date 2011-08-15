<%-- 
    Document   : advancedSearchDiv
    Created on : Mar 18, 2011, 11:57:29 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@ include file="/common/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="advancedSearch">
    <h4>Advanced search options</h4>
    <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/advancedSearch" method="POST">
        <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;">${param.q}</input>
        <b>Find records that have</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">ALL of these words (full text)</td>
                    <td>
                         <input type="text" name="text" id="text" class="dataset" placeholder="" size="80" value="${param.text}"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records for the ANY of the following taxa (matched/processed taxon concepts)</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
<%--                <tr>
                    <td class="label">Search for taxon name</td>
                    <td>
                        <input type="text" value="" id="name_autocomplete" 
                               placeholder="Start typing a common name or scientific name..." style="width:600px;">
                        <br/>
                        <div id="taxonSearchHint">Start typing a common name or scientific name and click on a matched name from the autocomplete dropdown list.
                        You can add up to 6 taxa to use in your search.</div>
                    </td>
                </tr>
                <c:forEach begin="1" end="6" step="1" var="i">
                    <c:set var="lsidParam" value="lsid_${i}"/>
                    <tr style="display: none" id="taxon_row_${i}">
                        <td class="label">Species/Taxon</td>
                        <td>
                            <div class="matchedName" id="sciname_${i}"></div>
                            <input type="hidden" name="lsid" id="${lsidParam}" value="${param.lsid}"/>
                            <input type="button" id="clear_${i}" class="clear_taxon" value="clear" title="Remove this taxon" style="display: none; float:left"/>
                        </td>
                    </tr>
                </c:forEach>--%>
                <c:forEach begin="1" end="4" step="1" var="i">
                    <c:set var="lsidParam" value="lsid_${i}"/>
                    <tr style="" id="taxon_row_${i}">
                        <td class="label">Species/Taxon</td>
                        <td>
                            <input type="text" value="" id="taxa_${i}" name="taxa" class="name_autocomplete" style="width:35%">
                            <input type="hidden" name="lsid" class="lsidInput" id="taxa_${i}" value=""/>
                            <%-- <div class="matchedName" id="sciname_${i}"></div>
                            
                            <input type="button" id="clear_${i}" class="clear_taxon" value="clear" title="Remove this taxon" style="display: none; float:left"/> --%>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <b>Find records that specify the following scientific name (verbatim/unprocessed name)</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Raw Scientific Name</td>
                    <td>
                         <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="80" value=""/>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records from the following species group</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Species Group</td>
                    <td>
                         <select class="species_group" name="species_group" id="species_group">
                            <option value="">-- select a species group --</option>
                            <c:forEach var="group" items="${speciesGroups}">
                                <option value="${group}">${group}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records from the following institution or collection</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Institution or Collection</td>
                    <td>
                        <select class="institution_uid collection_uid" name="institution_collection" id="institution_collection">
                            <option value="">-- select an institution or collection --</option>
                            <c:forEach var="inst" items="${institutions}">
                                <optgroup label="${inst.value}">
                                    <option value="${inst.key}">All records from ${inst.value}</option>
                                    <c:forEach var="coll" items="${collections}">
                                        <c:choose>
                                            <c:when test="${inst.key == 'in13' && fn:startsWith(coll.value, inst.value)}">
                                                <option value="${coll.key}">${fn:replace(fn:replace(coll.value, inst.value, ""), " - " ,"")} Collection</option>
                                            </c:when>
                                            <c:when test="${inst.key == 'in6' && fn:startsWith(coll.value, 'Australian National')}">
                                                <%-- <option value="${coll.key}">${fn:replace(coll.value,"Australian National ", "")}</option> --%>
                                                <option value="${coll.key}">${coll.value}</option>
                                            </c:when>
                                            <c:when test="${fn:startsWith(coll.value, inst.value)}">
                                                <option value="${coll.key}">${fn:replace(coll.value, inst.value, "")}</option>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </optgroup>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records from the following regions</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">State/Territory</td>
                    <td>
                        <select class="state" name="state" id="state">
                            <option value="">-- select a state/territory --</option>
                            <c:forEach var="state" items="${states}">
                                <option value="${state}">${state}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <c:set var="autoPlaceholder" value="start typing and select from the autocomplete drop-down list"/>
                <tr>
                    <td class="label">IBRA region</td>
                    <td>
                        <%-- <input type="text" name="ibra" id="ibra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                        <select class="biogeographic_region" name="ibra" id="ibra">
                            <option value="">-- select an IBRA region --</option>
                            <c:forEach var="region" items="${ibra}">
                                <option value="${region}">${region}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label">IMCRA region</td>
                    <td>
                        <%-- <input type="text" name="imcra" id="imcra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                        <select class="biogeographic_region" name="imcra" id="imcra">
                            <option value="">-- select an IMCRA region --</option>
                            <c:forEach var="region" items="${imcra}">
                                <option value="${region}">${region}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label">LGA region</td>
                    <td>
                        <input type="text" name="places" id="lga" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records from the following type status</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Type Status</td>
                    <td>
                         <select class="type_status" name="type_status" id="type_status">
                            <option value="">-- select a type status --</option>
                            <c:forEach var="type" items="${typeStatus}">
                                <option value="${type}">${type}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records from the following basis of record (record type)</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Basis of record</td>
                    <td>
                         <select class="basis_of_record" name="basis_of_record" id="basis_of_record">
                            <option value="">-- select a basis of record --</option>
                            <c:forEach var="bor" items="${basisOfRecord}">
                                <option value="${bor}">${bor}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
        <b>Find records with the following dataset fields</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Catalogue Number</td>
                    <td>
                         <input type="text" name="catalogue_number" id="catalogue_number" class="dataset" placeholder="" value=""/>
                    </td>
                </tr>
                <tr>
                    <td class="label">Record Number</td>
                    <td>
                         <input type="text" name="record_number" id="record_number" class="dataset" placeholder="" value=""/>
                    </td>
                </tr>
                <%--<tr>
                    <td class="label">Collector Name</td>
                    <td>
                         <input type="text" name="collector" id="collector" class="dataset" placeholder="" value=""/>
                    </td>
                </tr> --%>
            </tbody>
        </table>
        <b>Find records within the following date range</b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
                <tr>
                    <td class="label">Begin Date</td>
                    <td>
                         <input type="text" name="start_date" id="startDate" class="occurrence_date" placeholder="" value=""/>
                          (YYYY-MM-DD) leave blank for earliest record date
                    </td>
                </tr>
                <tr>
                    <td class="label">End Date</td>
                    <td>
                         <input type="text" name="end_date" id="endDate" class="occurrence_date" placeholder="" value=""/>
                         (YYYY-MM-DD) leave blank for most recent record date
                    </td>
                </tr>
            </tbody>
        </table>
<!--       <input type="button" id="advancedSubmit" value="Search" onClick="$('#advancedSearchForm').submit()"/>-->
        <input type="submit" value="Search" />
        &nbsp;&nbsp;
        <input type="reset" value="Clear all" id="clearAll" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>
<!--        &nbsp;&nbsp;<a id="showHideAdvancedOptions" href="#advanced_search_show">Hide advanced search options</a>-->
    </form>
</div>
