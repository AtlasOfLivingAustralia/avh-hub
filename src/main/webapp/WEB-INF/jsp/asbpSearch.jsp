<%--
    Document   : custom advanced search page for Seed Bank
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
                <li><a id="t1" href="#quickSearch">Quick search</a></li>
                <li><a id="t2" href="#advancedSearch">Advanced search</a></li>
                <li><a id="t3" href="#taxaUpload">Batch name search</a></li>
                <li><a id="t4" href="#catalogUpload">Batch catalogue no. search</a></li>
                <li><a id="t5" href="#shapeFileUpload">Shapefile search</a></li>
            </ul>
            <div class="css-panes">
                <div id="simpleSearchDiv" class="paneDiv homePane">
                    <form name="simpleSearchForm" id="simpleSearchForm" action="${pageContext.request.contextPath}/occurrences/search" method="GET">
                        <table border="0" width="100" cellspacing="2" class="compact" style="margin-top: 15px;">
                            <thead/>
                            <tbody>
                                <tr>
                                    <td>
                                        <input type="text" name="taxa" id="taxa" class="name_autocomplete freetext" placeholder="" size="70" style="width:500px;" value=""/>
                                        &nbsp;
                                        <input type="submit" value="Search" class="freetext"/>
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
                </div>
                <div id="advancedSearchDiv" class="paneDiv homePane">
                    <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/advancedSearch" method="POST">
                        <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;">${param.q}</input>
                        <!--<a href="#searchOptions" id="extendedOptionsLink" class="toggleTitle">Search options</a>-->
                        <div class="toggleSectionXXX" id="extendedOptionsXXXX">

                            <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Taxonomy</a>
                            <div class="toggleSection" id="taxonomySection">
                                <div id="taxonSearchDiv">
                                    <table border="0" width="100" cellspacing="2" class="compact"  id="taxonomyOptions">
                                        <thead/>
                                        <tbody>
                                            <c:forEach begin="1" end="4" step="1" var="i">
                                                <c:set var="lsidParam" value="lsid_${i}"/>
                                                <tr style="" id="taxon_row_${i}">
                                                    <td class="label">Taxon name</td>
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
                                <table border="0" width="100" cellspacing="2" class="compact" style="margin-left: 1px;">
                                    <thead/>
                                    <tbody>
                                        <tr>
                                            <td class="label">Verbatim scientific name</td>
                                            <td>
                                                 <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="80" value=""/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Species group</td>
                                            <td>
                                                <select class="taxaGroup" name="species_group" id="species_group">
                                                    <option value="">-- select a species group --</option>
                                                    <c:forEach var="group" items="${speciesGroups}">
                                                        <option value="${group}">${group}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        <%--<tr>--%>
                                            <%--<td class="label">Determiner</td>--%>
                                            <%--<td>--%>
                                                <%--<input type="text" name="identified_by" id="identified_by" class="dataset" placeholder=""  value=""/>--%>
                                            <%--</td>--%>
                                        <%--</tr>--%>
                                        <%--<tr>--%>
                                            <%--<td class="label">Determination date</td>--%>
                                            <%--<td>--%>
                                                <%--<input type="text" name="identified_date_start" id="identified_date_start" class="occurrence_date" placeholder="" value=""/>--%>
                                                <%--to--%>
                                                <%--<input type="text" name="identified_date_end" id="identified_date_end" class="occurrence_date" placeholder="" value=""/>--%>
                                                <%--(YYYY-MM-DD)--%>
                                            <%--</td>--%>
                                        <%--</tr>--%>
                                    </tbody>
                                </table>
                            </div><!-- end div.toggleSection -->
                            <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Specimen</a>
                            <div class="toggleSection">
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                        <tr>
                                            <td class="label">Institution</td>
                                            <td>
                                                <select class="institution_uid" name="institution" id="institution">
                                                    <option value="">-- select an institution --</option>
                                                    <c:forEach var="inst" items="${institutions}">
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
                                            <td class="label">Accession number</td>
                                            <td>
                                                <input type="text" name="catalogue_number" id="catalogue_number" class="dataset" placeholder="" value=""/>
                                            </td>
                                        </tr>
                                        <tr>
                                        <tr style="display:none;">
                                            <td class="label">Type material</td>
                                            <td>
                                                <input type="checkbox" name="type_material" id="type_material" class="dataset"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Full text search</td>
                                            <td>
                                                <input type="text" name="text" id="fulltext" class="text" placeholder="" value=""/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Record updated</td>
                                            <td>
                                                <input type="text" name="last_load_start" id="last_load_start" class="occurrence_date" placeholder="" value=""/>
                                                to
                                                <input type="text" name="last_load_end" id="last_load_end" class="occurrence_date" placeholder="" value=""/>
                                                (YYYY-MM-DD)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Conservation status</td>
                                            <td>
                                                <select class="" name="state_conservation" id="state_conservation">
                                                    <option value="">-- select a conservation status --</option>
                                                    <c:forEach var="status" items="${stateConservations}">
                                                        <c:if test="${not empty status}">
                                                            <option value="${status}">${status}</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div><!-- end div.toggleSection Specimen-->
                            <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Collecting event</a>
                            <div class="toggleSection">
                                <table border="0" width="100" cellspacing="2" class="compact">
                                    <thead/>
                                    <tbody>
                                        <tr>
                                            <td class="label">Collector</td>
                                            <td>
                                                <input type="text" name="collector" id="collector" class="dataset" placeholder=""  value=""/>
                                            </td>
                                        </tr>
                                        <td class="label">Collecting number</td>
                                        <td>
                                            <input type="text" name="record_number" id="record_number" class="dataset" placeholder=""  value=""/>
                                        </td>
                                        </tr>
                                        <tr>
                                            <td class="label">Collecting date</td>
                                            <td>
                                                <input type="text" name="start_date" id="startDate" class="occurrence_date" placeholder="" value=""/>
                                                to
                                                <input type="text" name="end_date" id="endDate" class="occurrence_date" placeholder="" value=""/>
                                                (YYYY-MM-DD)
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div><!-- end div.toggleSection Collecting Event -->
                            <a href="#extendedOptions" class="toggleTitle toggleTitleActive">Geography</a>
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
                                            <td class="label">State or territory</td>
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
                                            <td class="label"><abbr title="Integrated Marine and Coastal Regionalisation of Australia (meso-scale)">IMCRA</abbr> region</td>
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
                                            <td class="label">Local government area</td>
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

                            <br/>
                            <input type="submit" value="Search" />
                            &nbsp;&nbsp;
                            <input type="reset" value="Clear all" id="clearAll" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>

                        </div><!-- end #extendedOptions -->
                    </form>
                </div><!-- end simpleSearch div -->
                <div id="uploadDiv" class="paneDiv homePane">
                    <form name="taxaUploadForm" id="taxaUploadForm" action="${biocacheServiceUrl}/occurrences/batchSearch" method="POST">
                        <p>Enter a list of taxon names (one name per line).</p>
                        <%--<p><input type="hidden" name="MAX_FILE_SIZE" value="2048" /><input type="file" /></p>--%>
                        <p><textarea name="queries" id="raw_names" rows="15" cols="60"></textarea></p>
                        <p>
                            <%--<input type="submit" name="action" value="Download" />--%>
                            <%--&nbsp;OR&nbsp;--%>
                            <input type="hidden" name="redirectBase" value="${initParam.serverName}${pageContext.request.contextPath}/occurrences/search"/>
                            <input type="hidden" name="field" value="raw_name"/>
                            <input type="submit" name="action" value="Search" /></p>
                    </form>
                </div><!-- end #uploadDiv div -->
                <div id="catalogUploadDiv" class="paneDiv homePane">
                    <form name="catalogUploadForm" id="catalogUploadForm" action="${biocacheServiceUrl}/occurrences/batchSearch" method="POST">
                        <p>Enter a list of catalogue numbers (one number per line).</p>
                        <%--<p><input type="hidden" name="MAX_FILE_SIZE" value="2048" /><input type="file" /></p>--%>
                        <p><textarea name="queries" id="catalogue_numbers" rows="15" cols="60"></textarea></p>
                        <p>
                            <%--<input type="submit" name="action" value="Download" />--%>
                            <%--&nbsp;OR&nbsp;--%>
                            <input type="hidden" name="redirectBase" value="${initParam.serverName}${pageContext.request.contextPath}/occurrences/search"/>
                            <input type="hidden" name="field" value="catalogue_number"/>
                            <input type="submit" name="action" value="Search" /></p>
                    </form>
                </div><!-- end #uploadDiv div -->
                <div id="shapeDiv" class="paneDiv homePane">
                    <form name="shapeUploadForm" id="shapeUploadForm" action="${pageContext.request.contextPath}/occurrences/shapeUpload" method="POST" enctype="multipart/form-data">
                        <p>Note: this feature is still experimental. If there are multiple polygons present in the shapefile,
                            only the first polygon will be used for searching.</p>
                        <p>Upload a shapefile (.shp).</p>
                        <p><input type="file" name="file" value="Choose file"/></p>
                        <p><input type="submit" value="Search" /></p>
                    </form>
                </div>
            </div><!-- end panes div -->

        </div>
    </body>
</html>