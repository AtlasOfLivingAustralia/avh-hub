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
        <meta name="section" content="search"/>
        <title>Search for records | <ala:propertyLoader bundle="hubs" property="site.displayName"/></title>
        <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/charts.css" type="text/css" media="screen">
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/charts.js"></script> --%>
        <script src="${pageContext.request.contextPath}/static/js/jquery.tools.min-1.2.6.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.cookie.js"></script>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/tabs-no-images.css" />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/base.css" />
        <%--<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/advancedSearch.js"></script>--%>
        <jwr:script src="/js/advancedSearch.js"/>
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
                //$('#searchTabs a:first').tab('show');

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
    </head>
    <body>
        <div id="headingBar">
            <h1 style="width:100%;" id="searchHeader">Search for records in <ala:propertyLoader bundle="hubs" property="site.displayName"/></h1>
        </div>
        <div class="row-fluid">
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
                            <br/>
                            <div class="controls">
                                <div class="input-append">
                                    <input type="text" name="taxa" id="taxa" class="input-xxlarge">
                                    <input id="locationSearch" type="submit" class="btn" value="Search">
                                </div>
                            </div>
                            <div>
                                <br/>
                                <span style="font-size: 12px; color: #444;">
                                    <b>Note:</b> the simple search attempts to match a known <b>species/taxon</b> - by its scientific name or common name.
                                    If there are no name matches, a <b>full text</b> search will be performed on your query
                                </span>
                            </div>
                        </form>
                    </div><!-- end simpleSearch div -->
                    <div id="advanceSearch" class="tab-pane">
                        <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/advancedSearch" method="POST">
                            <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;" value="${param.q}"/>
                            <input type="hidden" name="nameType" value="matched_name_children"/>
                            <b>Find records that have</b>
                            <table border="0" width="100" cellspacing="2" class="compact">
                                <thead/>
                                <tbody>
                                <tr>
                                    <td class="labels">ALL of these words (full text)</td>
                                    <td>
                                        <input type="text" name="text" id="text" class="dataset" placeholder="" size="80" value="${param.text}"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            <b>Find records for ANY of the following taxa (matched/processed taxon concepts)</b>
                            <table border="0" width="100" cellspacing="2" class="compact">
                                <thead/>
                                <tbody>
                                <c:forEach begin="1" end="4" step="1" var="i">
                                    <c:set var="lsidParam" value="lsid_${i}"/>
                                    <tr style="" id="taxon_row_${i}">
                                        <td class="labels">Species/Taxon</td>
                                        <td>
                                            <input type="text" value="" id="taxa_${i}" name="taxonText" class="name_autocomplete" size="60">
                                            <input type="hidden" name="lsid" class="lsidInput" id="taxa_${i}" value=""/>
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
                                    <td class="labels">Raw Scientific Name</td>
                                    <td>
                                        <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="60" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            <b>Find records from the following species group</b>
                            <table border="0" width="100" cellspacing="2" class="compact">
                                <thead/>
                                <tbody>
                                <tr>
                                    <td class="labels">Species Group</td>
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
                                    <td class="labels">Institution or Collection</td>
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
                                <c:if test="${not isALA}">
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
                                    <td class="labels">State/Territory</td>
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
                                    <td class="labels"><abbr title="Integrated Marine and Coastal Regionalisation of Australia">IMCRA</abbr> region</td>
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
                                    <td class="labels">Local Govt. Area</td>
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
                            <c:if test="${fn:length(typeStatus) >1}">
                                <b>Find records from the following type status</b>
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                    <tr>
                                        <td class="labels">Type Status</td>
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
                            </c:if>
                            <c:if test="${fn:length(typeStatus) >1}">
                                <b>Find records from the following basis of record (record type)</b>
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                    <tr>
                                        <td class="labels">Basis of record</td>
                                        <td>
                                            <select class="basis_of_record" name="basis_of_record" id="basis_of_record">
                                                <option value="">-- select a basis of record --</option>
                                                <c:forEach var="bor" items="${basisOfRecord}">
                                                    <option value="${bor}"><fmt:message key="${bor}"/></option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </c:if>
                            <b>Find records with the following dataset fields</b>
                            <table border="0" width="100" cellspacing="2" class="compact">
                                <thead/>
                                <tbody>
                                <tr>
                                    <td class="labels">Catalogue Number</td>
                                    <td>
                                        <input type="text" name="catalogue_number" id="catalogue_number" class="dataset" placeholder="" value=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="labels">Record Number</td>
                                    <td>
                                        <input type="text" name="record_number" id="record_number" class="dataset" placeholder="" value=""/>
                                    </td>
                                </tr>
                                <%--<tr>
                                    <td class="labels">Collector Name</td>
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
                                    <td class="labels">Begin Date</td>
                                    <td>
                                        <input type="text" name="start_date" id="startDate" class="occurrence_date" placeholder="" value=""/>
                                        (YYYY-MM-DD) leave blank for earliest record date
                                    </td>
                                </tr>
                                <tr>
                                    <td class="labels">End Date</td>
                                    <td>
                                        <input type="text" name="end_date" id="endDate" class="occurrence_date" placeholder="" value=""/>
                                        (YYYY-MM-DD) leave blank for most recent record date
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            <input type="submit" value="Search" class="btn btn-primary" />
                            &nbsp;&nbsp;
                            <input type="reset" value="Clear all" id="clearAll" class="btn" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>
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