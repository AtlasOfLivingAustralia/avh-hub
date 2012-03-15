<%--
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="queryContext" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.queryContext"/></c:set>
<c:set var="biocacheServiceUrl" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>
<c:set var="isALA" scope="request"><ala:propertyLoader bundle="hubs" property="useAla"/></c:set>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="${skin}"/>
        <title>Search for records | <ala:propertyLoader bundle="hubs" property="site.displayName"/></title>
        <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/charts.css" type="text/css" media="screen">
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/charts.js"></script> --%>
        <script src="http://cdn.jquerytools.org/1.2.6/all/jquery.tools.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.cookie.js"></script>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/tabs-no-images.css" />
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/advancedSearch.js"></script>
        <script type="text/javascript">

            /************************************************************\
            * Fire chart loading
            \************************************************************/
            //google.load("visualization", "1", {packages:["corechart"]});
            //google.setOnLoadCallback(hubChartsOnLoadCallback);

            $(document).ready(function() {
                //$("#advancedSearch").show();
                //$("ul.tabs").tabs("div.panes > div");
                $(".css-tabs:first").tabs(".css-panes:first > div", { history: true });
            });

        </script>
    </head>
    <body>
        <div id="headingBar">
            <h1 style="width:100%;" id="searchHeader">Search for records in <ala:propertyLoader bundle="hubs" property="site.displayName"/></h1>
        </div>
        <div id="content3">
            <!-- the tabs -->
            <ul class="css-tabs">
                <li><a id="t1" href="#search">Search</a></li>
                <li><a id="t2" href="#taxaUpload">Batch Taxon Search</a></li>
                <li><a id="t3" href="#shapeFileUpload">Shape File Upload</a></li>
            </ul>
            <div class="css-panes">
                <div id="simpleSearchDiv" class="paneDiv homePane">
                    <form name="simpleSearchForm" id="simpleSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                        <table border="0" width="100" cellspacing="2" class="compact" style="margin-top: 15px;">
                            <thead/>
                            <tbody>
                                <tr>
<!--                                    <td>Species Search</td>-->
                                    <td>
                                        <input type="text" name="taxa" id="taxa" class="name_autocomplete freetext" placeholder="" size="70" style="width:500px;" value=""/>
                                        &nbsp;
                                        <input type="submit" value="Search" class="freetext"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <br/>
                                        <span style="font-size: 12px; color: #444;"><b>Note:</b> the simple search attempts to match a known <b>species/taxon</b> - by its scientific name or common name.
                                            If there are no name matches, a <b>full text</b> search will be performed on your query</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </form>
                    <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/advancedSearch" method="POST">
                        <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;">${param.q}</input>
                        <a href="#searchOptions" id="extendedOptionsLink" class="toggleTitle">Search Options</a>
                        <div class="toggleSection" id="extendedOptions">

                            <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Taxonomy</a>
                            <div class="toggleSection" id="taxonomySection">
                                <div id="taxonSearchDiv">
                                    <table border="0" width="100" cellspacing="2" class="compact"  id="taxonomyOptions">
                                        <thead/>
                                        <tbody>
                                            <c:forEach begin="1" end="4" step="1" var="i">
                                                <c:set var="lsidParam" value="lsid_${i}"/>
                                                <tr style="" id="taxon_row_${i}">
                                                    <td class="label">Taxon Name</td>
                                                    <td>
                                                        <input type="text" name="taxonText" id="taxa_${i}" class="name_autocomplete" size="50" value="">
                                                        <input type="hidden" name="lsid" class="lsidInput" id="lsid_${i}" value=""/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:choose>
                                                <c:when test="${skin != 'avh'}">
                                                    <tr>
                                                        <td>
                                                             <a href="#nameMatchingOptions" id="#nameMatchingOptions" class="toggleOptions" style="font-size: 11px;">Name matching options</a>
                                                        </td>
                                                        <td style="font-size: 12px;line-height: 1.5em;">
                                                            <div id="nameMatchingOptions">
                                                                <input type="radio" name="nameType" value="matched_name_children" checked="checked"/> Match
                                                                all known names (including synonyms) and include records for child taxa<br/>
                                                                <input type="radio" name="nameType" value="matched_name"/> Match
                                                                all known names (including synonyms) but do NOT include records for child taxa<br/>
                                                                <input type="radio" name="nameType" value="raw_name"/> Match the verbatim scientific name on records (will NOT include
                                                                records with synonyms or child taxa)
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="nameType" value="matched_name_children"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <table border="0" width="100" cellspacing="2" class="compact" style="margin-left: 1px;">
                                    <thead/>
                                    <tbody>
                                        <c:if test="${skin != 'avh'}">
                                            <tr>
                                                <td class="label">Verbatim Scientific Name</td>
                                                <td>
                                                     <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="80" value=""/>
                                                </td>
                                            </tr>
                                        </c:if>
                                        <tr>
                                            <td class="label">Botanical Group</td>
                                            <td>
                                                <select class="taxaGroup" name="species_group" id="species_group">
                                                    <option value="">-- select a botanical group --</option>
                                                    <c:forEach var="group" items="${speciesGroups}">
                                                        <option value="${group}">${group}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div><!-- end div.toggleSection -->
                                    <%--                        <b>Find records that specify the following scientific name (verbatim/unprocessed name)</b>
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
                            </table>--%>
                            <a href="#extendedOptions" class="toggleTitle">Geography</a>
                            <div class="toggleSection">
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                        <c:if test="${skin != 'ala'}">
                                            <tr>
                                                <td class="label">Country</td>
                                                <td>
                                                    <select class="country" name="country" id="country">
                                                        <option value="">-- select a country --</option>
                                                        <c:forEach var="country" items="${countries}">
                                                            <option value="${country}">${country}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                        </c:if>
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
                                            <td class="label"><abbr title="Interim Biogeographic Regionalisation of Australia">IBRA</abbr> region</td>
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
                                            <td class="label"><abbr title="Integrated Marine and Coastal Regionalisation of Australia">IMCRA</abbr> region</td>
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
                                            <td class="label">Local Govt. Area</td>
                                            <td>
                                                <input type="text" name="places" id="lga" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div><!-- end div.toggleSection geography-->
                            <a href="#extendedOptions" class="toggleTitle">Collecting Event</a>
                            <div class="toggleSection">
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                        <tr>
                                            <td class="label">Collector Name</td>
                                            <td>
                                                 <input type="text" name="collector" id="collector" class="dataset" placeholder=""  value=""/>
                                            </td>
                                        </tr>
                                        <%--<tr>
                                            <td class="label">Collectors Number</td>
                                            <td>
                                                 <input type="text" name="collectors_number" id="collectors_number" class="dataset" placeholder=""  value=""/>
                                            </td>
                                        </tr>--%>
                                        <tr>
                                            <td class="label">Collection Date</td>
                                            <td>
                                                <input type="text" name="start_date" id="startDate" class="occurrence_date" placeholder="" value=""/>
                                                to
                                                <input type="text" name="end_date" id="endDate" class="occurrence_date" placeholder="" value=""/>
                                                 (YYYY-MM-DD)
                                            </td>
                                        </tr>
                                        <c:if test="${skin == 'avh'}">
                                            <tr>
                                                <td class="label">Cultivation Status</td>
                                                <td>
                                                     <select class="" name="cultivation_status" id="cultivation_status">
                                                        <option value="">-- select a cultivation status --</option>
                                                        <c:forEach var="cs" items="${cultivationStatus}">
                                                            <option value="${cs}">${cs}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div><!-- end div.toggleSection Collecting Event -->
                            <a href="#extendedOptions" class="toggleTitle">${(skin == 'avh') ? 'Specimen' : 'Record'}</a>
                            <div class="toggleSection">
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                        <tr>
                                            <td class="label">Full Text</td>
                                            <td>
                                                <input type="text" name="text" id="fulltext" class="text" placeholder="" value=""/>
                                            </td>
                                        </tr>
                                        <c:if test="${skin != 'avh'}">
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
                                        </c:if>
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
                                        <tr>
                                            <td class="label">Catalogue Number</td>
                                            <td>
                                                 <input type="text" name="catalog_number" id="catalog_number" class="dataset" placeholder="" value=""/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Record Number</td>
                                            <td>
                                                 <input type="text" name="record_number" id="record_number" class="dataset" placeholder=""  value=""/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Type Material</td>
                                            <td>
                                                 <input type="checkbox" name="type_material" id="type_material" class="dataset"/>
                                            </td>
                                        </tr>
                                        <c:if test="${skin == 'avh'}">
                                            <tr>
                                                <td class="label">Duplicates held at</td>
                                                <td>
                                                     <%--<select class="institution_uid collection_uid" name="duplicates_institution_collection" id="duplicates_institution_collection"
                                                             onChange="alert('not currently available, coming soon');$(this).find('option')[0].selected = true;return false;">
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
                                                                            <option value="${coll.key}">${coll.value}</option>
                                                                        </c:when>
                                                                        <c:when test="${fn:startsWith(coll.value, inst.value)}">
                                                                            <option value="${coll.key}">${fn:replace(coll.value, inst.value, "")}</option>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </optgroup>
                                                        </c:forEach>
                                                    </select>--%>
                                                     <input type="text" name="duplicate_inst" id="duplicate_inst" class="dataset" placeholder=""  value=""/>
                                                </td>
                                            </tr>
                                        </c:if>
                                        <tr>
                                            <td class="label">Record last modified</td>
                                            <td>
                                                <input type="text" name="last_load_start" id="last_load_start" class="occurrence_date" placeholder="" value=""/>
                                                to
                                                <input type="text" name="last_load_end" id="last_load_end" class="occurrence_date" placeholder="" value=""/>
                                                (YYYY-MM-DD)
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                            </div><!-- end div.toggleSection Speciemen-->
                            <c:if test="${skin == 'avh'}">
                                <a href="#extendedOptions" class="toggleTitle">Herbarium Transactions</a>
                                <div class="toggleSection">
                                    <table border="0" width="100" cellspacing="2" class="compact">
                                        <thead/>
                                        <tbody>
                                            <tr>
                                                <td class="label">Borrowing Institution</td>
                                                <td>
                                                    <%--<input type="text" name="loan_destination" id="loan_destination" class="dataset" placeholder=""  value=""/>--%>
                                                    <select class="loan_destination" name="loan_destination" id="basis_of_record">
                                                        <option value="">-- select a Borrowing Institution --</option>
                                                        <c:forEach var="ld" items="${loanDestinations}">
                                                            <option value="${ld}">${ld}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">Loan Number</td>
                                                <td>
                                                    <input type="text" name="loan_number" id="loan_number" class="dataset" placeholder=""  value=""/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">Exchange Number</td>
                                                <td>
                                                    <input type="text" name="exchange_number" id="exchange_number" class="dataset" placeholder="not currently searchable" readonly="readonly" value=""/>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div><!-- end div.toggleSection Herbarium Transactions-->
                            </c:if>
                            <br/>
                            <input type="submit" value="Search" />
                            &nbsp;&nbsp;
                            <input type="reset" value="Clear all" id="clearAll" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>

                        </div><!-- end #extendedOptions -->
                    </form>
                </div><!-- end simpleSearch div -->
                <div id="uploadDiv" class="paneDiv homePane">
                    <form name="taxaUploadForm" id="taxaUploadForm" action="${biocacheServiceUrl}/occurrences/taxaList" method="POST">
                        <p>Enter a list of taxa (one taxon per line) and either <strong>download</strong> a <abbr title="comma separated values">CSV</abbr>
                            file containing records OR perform a <strong>search</strong>.</p>
                        <%--<p><input type="hidden" name="MAX_FILE_SIZE" value="2048" /><input type="file" /></p>--%>
                        <p><textarea name="names" id="names" rows="15" cols="60"></textarea></p>
                        <p> <input type="submit" name="action" value="Download" />
                            &nbsp;OR&nbsp;
                            <input type="hidden" name="redirectBase" value="${initParam.serverName}${pageContext.request.contextPath}/occurrences/search"/>
                            <input type="submit" name="action" value="Search" /></p>
                    </form>
                </div><!-- end #uploadDiv div -->
                <div id="shapeDiv" class="paneDiv homePane">
                    <form name="shapeUploadForm" id="shapeUploadForm" action="${pageContext.request.contextPath}/occurrence/shapeUpload" method="POST" enctype="multipart/form-data">
                        <p>Upload a shape file (.shx):</p>
                        <p><input type="file" name="file"/></p>
                        <p><input type="submit" value="Search" /></p>
                    </form>
                </div>
            </div><!-- end panes div -->

        </div>
    </body>
</html>