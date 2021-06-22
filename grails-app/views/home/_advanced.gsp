
<asset:script type="text/javascript">
    $(document).ready(function() {
        // Init BS tooltip
        $('[data-toggle="tooltip"]').tooltip({ html: true });
    });
</asset:script>
<form name="advancedSearchForm" id="advancedSearchForm" action="${g.createLink(uri:'/advancedSearch')}" method="POST">
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
                <g:set var="matchedTaxonTooltip" value="${g.message(code:"advanced.taxon.tooltip.matched",default:"N/A")}"/>
                <g:set var="suppliedTaxonTooltip" value="${g.message(code:"advanced.taxon.tooltip.supplied",default:"N/A")}"/>
                <div class="radio">
                    <label title="Matched name – results will include known synonyms">
                        <input type="radio" name="nameType" id="nameType_1" value="taxa" checked>
                        Matched name
                    </label>
                    <a href="#" data-toggle="tooltip" data-placement="right" title="${matchedTaxonTooltip}"><i class="glyphicon glyphicon-question-sign"></i></a>
                </div>
                <div class="radio">
                    <label title="Supplied name – results will not include synonyms">
                        <input type="radio" name="nameType" id="nameType_2" value="raw_name">
                        Supplied name
                    </label>
                    <a href="#" data-toggle="tooltip" data-placement="right" title="${suppliedTaxonTooltip}"><i class="glyphicon glyphicon-question-sign"></i></a>
                </div>
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
                                    <option value="${cs.key}"><g:message code="establishment_means.${cs.key}" default="${cs.value}"/></option>
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
                                <g:each var="state" in="${request.getAttribute("state")?.sort()}">
                                    <option value="${state.key}">${state.value}</option>
                                </g:each>
                                <option value=""></option>
                                <g:each var="region" in="${request.getAttribute("cl2117")?.sort()}">
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
                                    <g:each var="region" in="${request.getAttribute("cl959")?.sort()}">
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
                                    <g:each var="region" in="${request.getAttribute("cl1048")?.sort()}">
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
                                    <g:each var="region" in="${request.getAttribute("cl21")?.sort()}">
                                        <option value="${region.key}">${region.value}</option>
                                    </g:each>
                                </select>
                            </td>
                        </tr>
                    </g:if>
                    <tr>
                        <td class="labels">NZ Land District</td>
                        <td>
                            <select class="biogeographic_region" name="nz_districts" id="nz_districts">
                                <option value="">-- select a NZ Land District --</option>
                                <g:each var="region" in="${request.getAttribute("cl2116")?.sort()}">
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
                                <g:each var="region" in="${request.getAttribute("cl2115")?.sort()}">
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
        <input type="reset" value="Clear all" id="clearAll" class="btn btn-default" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>
    </div><!-- end #extendedOptions -->
</form>
