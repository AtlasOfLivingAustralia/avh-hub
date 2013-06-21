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
        <script src="${pageContext.request.contextPath}/static/js/jquery.tools.min-1.2.6.js"></script>
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
                //$(".css-tabs:first").tabs(".css-panes:first > div", { history: true });

                $('a[data-toggle="tab"]').on('shown', function(e) {
                    //console.log("this", $(this).attr('id'));
                    var id = $(this).attr('id');
                    location.hash = 'tab_'+ $(e.target).attr('href').substr(1);
                });
                // catch hash URIs and trigger tabs
                if (location.hash !== '') {
                    $('.nav-tabs a[href="' + location.hash.replace('tab_','') + '"]').tab('show');
                    //$('.nav-tabs li a[href="' + location.hash.replace('tab_','') + '"]').click();
                } else {
                    $('.nav-tabs a:first').tab('show');
                }
            });

        </script>
        <style type="text/css">
            .nav-tabs > .active > a,
            .nav-tabs > .active > a:hover,
            .nav-tabs > .active > a:focus {
                background-color: #F0F0E8;
            }

            .nav-tabs li a {
                background-color: #fffef7;
            }

            .tab-content {
                background-color: #F0F0E8;
            }

        </style>
    </head>
    <body>
        <div id="headingBar">
            <h1 style="width:100%;" id="searchHeader">Search for records in <ala:propertyLoader bundle="hubs" property="site.displayName"/></h1>
        </div>
        <div class="row-fluid" id="content">
            <div class="span12">
                <div class="tabbable">
                    <ul class="nav nav-tabs" id="searchTabs">
                        <li><a id="t1" href="#simpleSearch" data-toggle="tab">Simple search</a></li>
                        <li><a id="t2" href="#advanceSearch" data-toggle="tab">Advanced search</a></li>
                        <li><a id="t3" href="#taxaUpload" data-toggle="tab">Batch taxon search</a></li>
                        <li><a id="t4" href="#catalogUpload" data-toggle="tab">Catalogue number search</a></li>
                        <li><a id="t5" href="#shapeFileUpload" data-toggle="tab">Shapefile search</a></li>
                    </ul>
                </div>
                <div class="tab-content searchPage">
                    <div id="simpleSearch" class="tab-pane active">
                        <form name="simpleSearchForm" id="simpleSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                            <table border="0" width="100" cellspacing="2" class="" style="margin-top: 15px;width: 100%;">
                                <thead/>
                                <tbody>
                                    <tr>
                                        <td>
                                            <input type="text" name="taxa" id="taxa" class="name_autocomplete freetext" placeholder="" size="70" style="width:500px;" value=""/>
                                            &nbsp;
                                            <input type="submit" value="Search" class="btn"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br/>
                                            <span style="font-size: 12px; color: #444;"><b>Note:</b> the quick search attempts to match a known <b>species/taxon</b> - by its scientific name or common name.
                                                If there are no name matches, a <b>full text</b> search will be performed on your query</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div><!-- end simpleSearch div -->
                    <div id="advanceSearch" class="tab-pane">
                        <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/advancedSearch" method="POST">
                            <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;">${param.q}</input>
                            <!--<a href="#searchOptions" id="extendedOptionsLink" class="toggleTitle">Search options</a>-->
                            <div class="" id="">

                                <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Taxonomy</a>
                                <div class="toggleSection" id="taxonomySection">
                                    <div id="taxonSearchDiv">
                                        <table border="0" width="100" cellspacing="2" class=""  id="taxonomyOptions">
                                            <thead/>
                                            <tbody>
                                                <c:forEach begin="1" end="4" step="1" var="i">
                                                    <c:set var="lsidParam" value="lsid_${i}"/>
                                                    <tr style="" id="taxon_row_${i}">
                                                        <td class="labels">Taxon name</td>
                                                        <td>
                                                            <input type="text" name="taxonText" id="taxa_${i}" class="name_autocomplete" size="50" value="">
                                                            <input type="hidden" name="lsid" class="lsidInput" id="lsid_${i}" value=""/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <input type="hidden" name="nameType" value="matched_name_children"/>
                                            </tbody>
                                        </table>
                                    </div>
                                    <table border="0" width="100" cellspacing="2" class="" style="margin-left: 1px;">
                                        <thead/>
                                        <tbody>
                                            <c:if test="${skin != 'avh'}">
                                                <tr>
                                                    <td class="labels">Verbatim scientific name</td>
                                                    <td>
                                                         <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="80" value=""/>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <td class="labels">Botanical group</td>
                                                <td>
                                                    <select class="taxaGroup" name="species_group" id="species_group">
                                                        <option value="">-- select a botanical group --</option>
                                                        <c:forEach var="group" items="${speciesGroups}">
                                                            <option value="${group}">${group}</option>
                                                        </c:forEach>
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
                                                        <c:forEach var="inst" items="${collections}">
                                                            <!--<optgroup label="${inst.value}"> -->
                                                            <c:if test="${not empty inst.value}">
                                                                <option value="${inst.key}">${inst.value}</option>
                                                            </c:if>
                                                            <!--</optgroup> -->
                                                        </c:forEach>
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
                                        <c:if test="${skin == 'avh'}">
                                            <tr>
                                                <td class="labels">Establishment means</td>
                                                <td>
                                                    <select class="" name="cultivation_status" id="cultivation_status">
                                                        <option value="">-- select an establishment means --</option>
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
                                <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Geography</a>
                                <div class="toggleSection">
                                    <table border="0" width="100" cellspacing="2" class="">
                                        <thead/>
                                        <tbody>
                                            <c:if test="${skin != 'ala'}">
                                                <tr>
                                                    <td class="labels">Country</td>
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
                                                <td class="labels">State or territory</td>
                                                <td>
                                                    <select class="state" name="state" id="state">
                                                        <option value="">-- select a state or territory --</option>
                                                        <c:forEach var="state" items="${states}">
                                                            <option value="${state}">${state}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                            <c:set var="autoPlaceholder" value="start typing and select from the autocomplete drop-down list"/>
                                            <tr>
                                                <td class="labels"><abbr title="Interim Biogeographic Regionalisation of Australia">IBRA</abbr> region</td>
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
                                                <td class="labels"><abbr title="Integrated Marine and Coastal Regionalisation of Australia (meso-scale)">IMCRA</abbr> region</td>
                                                <td>
                                                    <%-- <input type="text" name="imcra" id="imcra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/> --%>
                                                    <select class="biogeographic_region" name="imcra_meso" id="imcra">
                                                        <option value="">-- select an IMCRA region --</option>
                                                        <c:forEach var="region" items="${imcraMeso}">
                                                            <option value="${region}">${region}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="labels">Local government area</td>
                                                <td>
                                                    <select class="biogeographic_region" name="cl959" id="cl959">
                                                        <option value="">-- select local government area--</option>
                                                        <c:forEach var="region" items="${lgas}">
                                                            <option value="${region}">${region}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div><!-- end div.toggleSection geography-->
                                <c:if test="${skin == 'avh'}">
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
                                                            <c:forEach var="ld" items="${loanDestinations}">
                                                                <option value="${ld}">${ld}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div><!-- end div.toggleSection Herbarium Transactions-->
                                </c:if>
                                <br/>
                                <input type="submit" value="Search" class="btn"/>
                                &nbsp;&nbsp;
                                <input type="reset" value="Clear all" id="clearAll" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;" class="btn"/>

                            </div><!-- end #extendedOptions -->
                        </form>
                    </div><!-- end #advancedSearch div -->
                    <div id="taxaUpload" class="tab-pane">
                        <form name="taxaUploadForm" id="taxaUploadForm" action="${biocacheServiceUrl}/occurrences/batchSearch" method="POST">
                            <p>Enter a list of taxon names/scientific names, one name per line (common names not currently supported).</p>
                            <%--<p><input type="hidden" name="MAX_FILE_SIZE" value="2048" /><input type="file" /></p>--%>
                            <p><textarea name="queries" id="raw_names" class="span6" rows="15" cols="60"></textarea></p>
                            <p>
                                <%--<input type="submit" name="action" value="Download" />--%>
                                <%--&nbsp;OR&nbsp;--%>
                                <input type="hidden" name="redirectBase" value="${initParam.serverName}${pageContext.request.contextPath}/occurrences/search"/>
                                <input type="hidden" name="field" value="raw_name"/>
                                <input type="submit" name="action" value="Search" class="btn" /></p>
                        </form>
                    </div><!-- end #uploadDiv div -->
                    <div id="catalogUpload" class="tab-pane">
                        <form name="catalogUploadForm" id="catalogUploadForm" action="${biocacheServiceUrl}/occurrences/batchSearch" method="POST">
                            <p>Enter a list of catalogue numbers (one number per line).</p>
                            <%--<p><input type="hidden" name="MAX_FILE_SIZE" value="2048" /><input type="file" /></p>--%>
                            <p><textarea name="queries" id="catalogue_numbers" class="span6" rows="15" cols="60"></textarea></p>
                            <p>
                                <%--<input type="submit" name="action" value="Download" />--%>
                                <%--&nbsp;OR&nbsp;--%>
                                <input type="hidden" name="redirectBase" value="${initParam.serverName}${pageContext.request.contextPath}/occurrences/search"/>
                                <input type="hidden" name="field" value="catalogue_number"/>
                                <input type="submit" name="action" value="Search" class="btn"/></p>
                        </form>
                    </div><!-- end #catalogUploadDiv div -->
                    <div id="shapeFileUpload" class="tab-pane">
                        <form name="shapeUploadForm" id="shapeUploadForm" action="${pageContext.request.contextPath}/occurrences/shapeUpload" method="POST" enctype="multipart/form-data">
                            <p>Note: this feature is still experimental. If there are multiple polygons present in the shapefile,
                                only the first polygon will be used for searching.</p>
                            <p>Upload a shapefile (*.shp).</p>
                            <p><input type="file" name="file" class="" /></p>
                            <p><input type="submit" value="Search" class="btn"/></p>
                        </form>
                    </div><!-- end #shapeFileUpload  -->
                </div><!-- end .tab-content -->
            </div><!-- end .span12 -->
        </div><!-- end .row-fluid -->

    </body>
</html>