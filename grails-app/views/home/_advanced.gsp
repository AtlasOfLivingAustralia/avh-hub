<%@ page import="au.org.ala.biocache.hubs.FacetsName; org.apache.commons.lang.StringUtils" contentType="text/html;charset=UTF-8" %>
<style type="text/css">
    #content .nav-tabs > .active > a,
    #content .nav-tabs > .active > a:hover,
    #content .nav-tabs > .active > a:focus {
        background-color: #F0F0E8;
    }

    #content .nav-tabs li:not(.active) a {
        background-color: #fffef7;
    }

    .tab-content {
        background-color: #F0F0E8;
    }

</style>
<form name="advancedSearchForm" id="advancedSearchForm" action="${request.contextPath}/advancedSearch" method="POST">
    <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;" value="${params.q}"/>
    <input type="hidden" name="nameType" value="matched_name_children"/>
    <div class="" id="">

        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Taxonomy</a>
        <div class="toggleSection" id="taxonomySection">
            <div id="taxonSearchDiv">
                <table border="0" width="100" cellspacing="2" class=""  id="taxonomyOptions">
                    <thead/>
                    <tbody>
                        <g:each in="${ (1..4) }" var="i">
                            <g:set var="lsidParam" value="lsid_${i}"/>
                            <tr style="" id="taxon_row_${i}">
                                <td class="labels">Taxon name</td>
                                <td>
                                    <input type="text" name="taxonText" id="taxa_${i}" class="name_autocomplete" size="50" value="">
                                    <input type="hidden" name="lsid" class="lsidInput" id="lsid_${i}" value=""/>
                                </td>
                            </tr>
                        </g:each>
                        <input type="hidden" name="nameType" value="matched_name_children"/>
                    </tbody>
                </table>
            </div>
            <table border="0" width="100" cellspacing="2" class="" style="margin-left: 1px;">
                <thead/>
                <tbody>
                    <g:if test="${skin != 'avh'}">
                        <tr>
                            <td class="labels">Verbatim scientific name</td>
                            <td>
                                 <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="80" value=""/>
                            </td>
                        </tr>
                    </g:if>
                    <tr>
                        <td class="labels">Botanical group</td>
                        <td>
                            <select class="taxaGroup" name="species_group" id="species_group">
                                <option value="">-- select a botanical group --</option>
                                <g:each var="group" in="${request.getAttribute(FacetsName.SPECIES_GROUP.fieldname)}">
                                    <option value="${group.key}">${group.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Determiner</td>
                        <td>
                            <input type="text" name="identified_by" id="identified_by" class="dataset" placeholder=""  value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Determination date</td>
                        <td>
                            <input type="text" name="identified_date_start" id="identified_date_start" class="occurrence_date" placeholder="" value=""/>
                            to
                            <input type="text" name="identified_date_end" id="identified_date_end" class="occurrence_date" placeholder="" value=""/>
                            (YYYY-MM-DD)
                        </td>
                    </tr>
                </tbody>
            </table>
        </div><!-- end div.toggleSection -->
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Specimen</a>
        <div class="toggleSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Herbarium</td>
                        <td>
                            <select class="institution_uid collection_uid" name="institution_collection" id="institution_collection">
                                <option value="">-- select an herbarium --</option>
                                <g:each var="inst" in="${request.getAttribute(FacetsName.COLLECTION.fieldname)}">
                                    <!--<optgroup label="${inst.value}"> -->
                                    <g:if test="${inst.value}">
                                        <option value="${inst.key}">${inst.value}</option>
                                    </g:if>
                                    <!--</optgroup> -->
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Catalogue number</td>
                        <td>
                            <input type="text" name="catalogue_number" id="catalogue_number" class="dataset" placeholder="" value=""/>
                        </td>
                    </tr>
                    <tr>
                    <tr style="display:none;">
                        <td class="labels">Type material</td>
                        <td>
                            <input type="checkbox" name="type_material" id="type_material" class="dataset"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Full text search</td>
                        <td>
                            <input type="text" name="text" id="fulltext" class="text" placeholder="" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Record updated</td>
                        <td>
                            <input type="text" name="last_load_start" id="last_load_start" class="occurrence_date" placeholder="" value=""/>
                            to
                            <input type="text" name="last_load_end" id="last_load_end" class="occurrence_date" placeholder="" value=""/>
                            (YYYY-MM-DD)
                        </td>
                    </tr>
                    <tr>
                </tbody>
            </table>
        </div><!-- end div.toggleSection Specimen-->
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Collecting event</a>
        <div class="toggleSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Collector</td>
                        <td>
                            <input type="text" name="collector" id="collector" class="dataset" placeholder=""  value=""/>
                        </td>
                    </tr>
                    <td class="labels">Collecting number</td>
                    <td>
                        <input type="text" name="record_number" id="record_number" class="dataset" placeholder=""  value=""/>
                    </td>
                    </tr>
                    <tr>
                        <td class="labels">Collecting date</td>
                        <td>
                            <input type="text" name="start_date" id="startDate" class="occurrence_date" placeholder="" value=""/>
                            to
                            <input type="text" name="end_date" id="endDate" class="occurrence_date" placeholder="" value=""/>
                            (YYYY-MM-DD)
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Establishment means</td>
                        <td>
                            <select class="" name="cultivation_status" id="cultivation_status">
                                <option value="">-- select an establishment means --</option>
                                <g:each var="cs" in="${request.getAttribute(FacetsName.CULTIVATION_STATUS.fieldname)}">
                                    <option value="${cs.key}">${cs.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div><!-- end div.toggleSection Collecting Event -->
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Geography</a>
        <div class="toggleSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Country</td>
                        <td>
                            <select class="country" name="country" id="country">
                                <option value="">-- select a country --</option>
                                <g:each var="country" in="${request.getAttribute(FacetsName.COUNTRIES.fieldname)}">
                                    <option value="${country.key}">${country.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">State or territory</td>
                        <td>
                            <select class="state" name="state" id="state">
                                <option value="">-- select a state or territory --</option>
                                <g:each var="state" in="${request.getAttribute(FacetsName.STATES.fieldname)}">
                                    <option value="${state.key}">${state.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <g:set var="autoPlaceholder" value="start typing and select from the autocomplete drop-down list"/>
                    <tr>
                        <td class="labels"><abbr title="Interim Biogeographic Regionalisation of Australia">IBRA</abbr> region</td>
                        <td>
                            <%-- <input type="text" name="ibra" id="ibra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                            <select class="biogeographic_region" name="ibra" id="ibra">
                                <option value="">-- select an IBRA region --</option>
                                <g:each var="region" in="${request.getAttribute(FacetsName.IBRA.fieldname)}">
                                    <option value="${region.key}">${region.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels"><abbr title="Integrated Marine and Coastal Regionalisation of Australia (meso-scale)">IMCRA</abbr> region</td>
                        <td>
                            <%-- <input type="text" name="imcra" id="imcra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                            <select class="biogeographic_region" name="imcra_meso" id="imcra">
                                <option value="">-- select an IMCRA region --</option>
                                <g:each var="region" in="${request.getAttribute(FacetsName.IMCRA_MESO.fieldname)}">
                                    <option value="${region.key}">${region.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Local government area</td>
                        <td>
                            <select class="biogeographic_region" name="cl959" id="cl959">
                                <option value="">-- select local government area--</option>
                                <g:each var="region" in="${request.getAttribute(FacetsName.LGA.fieldname)}">
                                    <option value="${region.key}">${region.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div><!-- end div.toggleSection geography-->
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Herbarium transactions</a>
        <div class="toggleSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Duplicates sent to</td>
                        <td>
                                <%--<select class="institution_uid collection_uid" name="duplicates_institution_collection" id="duplicates_institution_collection"
                                         onChange="alert('not currently available, coming soon');$(this).find('option')[0].selected = true;return false;">
                                    <option value="">-- select an institution or collection --</option>
                                    <g:each var="inst" in="${institutions}">
                                        <optgroup label="${inst.value}">
                                            <option value="${inst.key}">All records from ${inst.value}</option>
                                            <g:each var="coll" in="${collections}">
                                                <c:choose>
                                                    <c:when test="${inst.key == 'in13' && fn:startsWith(coll.value, inst.value)}">
                                                        <option value="${coll.key}">${fn:replace(fn:replace(coll.value, inst.value, ""), " - " ,"")} Collection</option>
                                                    </c:when>
                                                    <c:when test="${inst.key == 'in6' && fn:startsWith(coll.value, 'Australian National')}">
                                                        <option value="${coll.key}">${coll.value}</option>
                                                    </c:when>
                                                    <c:when test="${fn:startsWith(coll.value, inst.value)}">
                                                        <option value="${coll.key}">${fn:replace(coll.value, inst.value, "")}</option>
                                                    </c:when>
                                                </c:choose>
                                            </g:each>
                                        </optgroup>
                                    </g:each>
                                </select>--%>
                            <input type="text" name="duplicate_inst" id="duplicate_inst" class="dataset" placeholder=""  value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Loan number</td>
                        <td>
                            <input type="text" name="loan_identifier" id="loan_identifier" class="dataset" placeholder=""  value=""/>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td class="labels">Exchange number</td>
                        <td>
                            <input type="text" name="exchange_number" id="exchange_number" class="dataset" placeholder="not currently searchable" readonly="readonly" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Borrowing institution</td>
                        <td>
                            <%--<input type="text" name="loan_destination" id="loan_destination" class="dataset" placeholder=""  value=""/>--%>
                            <select class="dataset" name="loan_destination" id="loan_destination">
                                <option value="">-- select a borrowing institution --</option>
                                <g:each var="ld" in="${request.getAttribute(FacetsName.LOAD_DESTINATION.fieldname)}">
                                    <option value="${ld.key}">${ld.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div><!-- end div.toggleSection Herbarium Transactions-->
        <br/>
        <input type="submit" value="Search" class="btn btn-primary" />
        &nbsp;&nbsp;
        <input type="reset" value="Clear all" id="clearAll" class="btn" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>
    </div><!-- end #extendedOptions -->
</form>