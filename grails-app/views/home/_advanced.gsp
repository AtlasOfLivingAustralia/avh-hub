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
<form name="advancedSearchForm" id="advancedSearchForm" action="${g.createLink(uri:'/advancedSearch')}" method="POST">
    <input type="hidden" name="nameType" value="taxa"/>
    <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;" value="${params.q}"/>
    <div class="" id="">
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Full text search</a>
        <div class="toggleSection" id="fulltextSection">
            <div id="fulltextSearchDiv">
                <table border="0" width="100" cellspacing="2" class=""  id="fulltextOptions">
                    <thead/>
                    <tbody>
                        <tr>
                            <td class="labels">Text</td>
                            <td>
                                <input type="text" name="text" id="fulltext" class="text" placeholder="" value=""/>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

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
                        <tr>
                            <td class="labels">Botanical group</td>
                            <td>
                                <select class="taxaGroup" name="species_group" id="species_group">
                                    <option value="">-- select a botanical group --</option>
                                    <g:each var="group" in="${request.getAttribute("species_group")}">
                                        <g:if test="${!grailsApplication.config.speciesGroupsIgnore.contains(group.value)}">
                                            <option value="${group.key}"><g:message code="advancedsearch.speciesgroup.${group.value}" default="${group.value}"/></option>
                                        </g:if>
                                    </g:each>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div><!-- end div.toggleSection -->
        
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Identification</a>
        <div class="toggleSection" id="identificationSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Identified by</td>
                        <td>
                            <input type="text" name="identified_by" id="identified_by" class="dataset" placeholder=""  value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">Identification date</td>
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
        
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Record</a>
        <div class="toggleSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Herbarium</td>
                        <td>
                            <select class="institution_uid collection_uid" name="institution_collection" id="institution_collection">
                                <option value="">-- select an herbarium --</option>
                                <g:each var="inst" in="${request.getAttribute("collection_uid")}">
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
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Occurrence</a>
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
                                <g:each var="cs" in="${request.getAttribute("establishment_means")}">
                                    <option value="${cs.key}">${cs.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div><!-- end div.toggleSection Collecting Event -->
        
        <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Location</a>
        <div class="toggleSection">
            <table border="0" width="100" cellspacing="2" class="">
                <thead/>
                <tbody>
                    <tr>
                        <td class="labels">Country</td>
                        <td>
                            <select class="country" name="country" id="country">
                                <option value="">-- select a country --</option>
                                <g:each var="country" in="${request.getAttribute("country")}">
                                    <option value="${country.key}">${country.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
<!--                    <td class="labels">State or territory</td>
                        <td>
                            <select class="state" name="state" id="state">
                                <option value="">-- select a state or territory --</option>
                                <g:each var="state" in="${request.getAttribute("state")}">
                                    <option value="${state.key}">${state.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>  -->
                    <tr>
                        <td class="labels">State, territory or province</td>
                        <td>
                            <select class="state" name="state_territory_province" id="state_territory_province">
                                <option value="">-- select a state, territory or province --</option>
                                <g:each var="state" in="${request.getAttribute("state")}">
                                    <option value="${state.key}">${state.value}</option>
                                </g:each>
                                <g:each var="region" in="${request.getAttribute("cl2117")}">
                                    <option value="${region.key}">${region.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <g:set var="autoPlaceholder" value="start typing and select from the autocomplete drop-down list"/>
                    <g:if test="${request.getAttribute("cl959") && request.getAttribute("cl959").size() > 1}">
                        <tr>
                            <td class="labels">Local government area</td>
                            <td>
                                <select class="lga" name="lga" id="lga">
                                    <option value="">-- select local government area--</option>
                                    <g:each var="region" in="${request.getAttribute("cl959").sort()}">
                                        <option value="${region.key}">${region.value}</option>
                                    </g:each>
                                </select>
                            </td>
                        </tr>
                    </g:if>
                    <g:if test="${request.getAttribute("cl1048") && request.getAttribute("cl1048").size() > 1}">
                        <tr>
                            <td class="labels"><abbr title="Interim Biogeographic Regionalisation of Australia">IBRA</abbr> region</td>
                            <td>
                                <%-- <input type="text" name="ibra" id="ibra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                                <select class="biogeographic_region" name="ibra" id="ibra">
                                    <option value="">-- select an IBRA region --</option>
                                    <g:each var="region" in="${request.getAttribute("cl1048").sort()}">
                                        <option value="${region.key}">${region.value}</option>
                                    </g:each>
                                </select>
                            </td>
                        </tr>
                    </g:if>
                    <g:if test="${request.getAttribute("cl21") && request.getAttribute("cl21").size() > 1}">
                        <tr>
                            <td class="labels"><abbr title="Integrated Marine and Coastal Regionalisation of Australia (meso-scale)">IMCRA</abbr> region</td>
                            <td>
                                <%-- <input type="text" name="imcra" id="imcra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                                <select class="biogeographic_region" name="imcra_meso" id="imcra">
                                    <option value="">-- select an IMCRA region --</option>
                                    <g:each var="region" in="${request.getAttribute("cl21").sort()}">
                                        <option value="${region.key}">${region.value}</option>
                                    </g:each>
                                </select>
                            </td>
                        </tr>
                    </g:if>
<!--                    <tr>
                        <td class="labels">NZ Province</td>
                        <td>
                            <select class="biogeographic_region" name="nz_provinces" id="nz_provinces">
                                <option value="">-- select a NZ province --</option>
                                <g:each var="region" in="${request.getAttribute("cl2117")}">
                                    <option value="${region.key}">${region.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr> -->
                    <tr>
                        <td class="labels">NZ Land District</td>
                        <td>
                            <select class="biogeographic_region" name="nz_districts" id="nz_districts">
                                <option value="">-- select a NZ Land District --</option>
                                <g:each var="region" in="${request.getAttribute("cl2116")}">
                                    <option value="${region.key}">${region.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="labels">NZ ECO Region</td>
                        <td>
                            <select class="biogeographic_region" name="nz_eco_regions" id="nz_eco_regions">
                                <option value="">-- select a NZ ECO region --</option>
                                <g:each var="region" in="${request.getAttribute("cl2115")}">
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
                                <g:each var="ld" in="${request.getAttribute("loan_destination")}">
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
