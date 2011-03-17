<%--
    Document   : list
    Created on : Feb 2, 2011, 10:54:57 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Occurrence Search | OZCAM</title>
        <link rel="stylesheet" href="static/css/charts.css" type="text/css" media="screen">
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/charts.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/advancedSearch.js"></script>
        <script type="text/javascript">
            /**
             * JQuery on document ready callback
             */
            $(document).ready(function() {
                // advanced search link
                $("#advancedSearchLink a").click(function(e) {
                    e.preventDefault();
                    showHideAdvancedSearch();
                });

                var url = escape(window.location.hash.replace( /^#/, '')); // escape used to prevent injection attacks

                if (url == "advanced_search") {
                    showHideAdvancedSearch();
                }
                

            }); // end document.ready
            
            function showHideAdvancedSearch() {
                var advDiv = $("div#advancedSearch");
                
                if ($(advDiv).css("display") == "none") {
                    $(advDiv).fadeIn();
                    window.location.hash = "advanced_search";
                } else {
                     $(advDiv).fadeOut();
                     window.location.hash = "";
                }
            }

            /************************************************************\
            * Fire chart loading
            \************************************************************/
            google.load("visualization", "1", {packages:["corechart"]});
            google.setOnLoadCallback(hubChartsOnLoadCallback);

        </script>
    </head>
    <body>
        <div id="headingBar">
            <h1>Search for records in OZCAM</h1>
            <div id="solrSearchForm">
                <form action="${pageContext.request.contextPath}/occurrences/search" id="homepageSearchForm">
                    <input name="q" value="<c:out value='${param.q}'/>" id="solrQuery" style="width:720px; height:20px; font-size:12px;"/>&nbsp;
                    <input type="submit" value="Submit" id="solrSubmit" style="font-size:14px;"/>
                    <input type="hidden" id="lsid" value=""/>
                    <span id="advancedSearchLink"><a href="#advanced_search">Advanced Search</a></span>
                </form>
            </div>
            <div id="advancedSearch">
                <h4>Advanced search options</h4>
                <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/occurrences/search">
                    <b>Find records for the following taxa...</b>
                    <table border="0" width="100" cellspacing="2" class="compact">
                        <thead/>
                        <tbody>
                            <tr>
                                <td class="label">Search for taxon name</td>
                                <td>
                                    <input type="text" value="" id="name_autocomplete" name="name_autocomplete" 
                                           placeholder="Start typing a common name or scientific name..." style="width:600px;">
                                    <br/>
                                    <div id="taxonSearchHint">Start typing a common name or scientific name and click on a matched name from the autocomplete dropdown list.
                                    You can add up to 6 taxa to use in your search.</div>
                                </td>
                            </tr>
                            <c:forEach begin="1" end="6" step="1" var="i">
                                <tr style="display: none" id="taxon_row_${i}">
                                    <td class="label">Species/Taxon</td>
                                    <td>
                                        <%-- Search <input type="text" value="" id="${i}"name="name_autocomplete"  style="width:35%"> --%>
                                        <div class="matchedName" id="sciname_${i}"></div>
                                        <input type="hidden" id="lsid_${i}" value=""/>
                                        <input type="button" id="clear_${i}" class="clear_taxon" value="clear" title="Remove this taxon" style="display: none; float:left"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <b>Find records from the following species group</b>
                    <table border="0" width="100" cellspacing="2" class="compact">
                        <thead/>
                        <tbody>
                            <tr>
                                <td class="label">Species Group</td>
                                <td>
                                     <select class="species_group">
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
                                <td class="label">Institution name</td>
                                <td>
                                    <select class="institution_uid">
                                        <option value="">-- select an institution --</option>
                                        <c:forEach var="inst" items="${institutions}">
                                            <option value="${inst.key}">${inst.value}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">Collection name</td>
                                <td>
                                    <select class="collection_uid">
                                        <option value="">-- select a collection --</option>
                                        <c:forEach var="coll" items="${collections}">
                                            <option value="${coll.key}">${coll.value}</option> 
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
                                    <select class="state">
                                        <option value="">-- select a state --</option>
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
                                    <input type="text" name="ibra" id="ibra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">IMCRA region</td>
                                <td>
                                    <input type="text" name="imcra" id="imcra" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">LGA region</td>
                                <td>
                                    <input type="text" name="lga" id="lga" class="region_autocomplete" value="" placeholder="${autoPlaceholder}"/>
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
                                     <select class="type_status">
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
                                     <select class="basis_of_record">
                                        <option value="">-- select a basis of record --</option>
                                        <c:forEach var="bor" items="${basisOfRecord}">
                                            <option value="${bor}">${bor}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <b>Find records within the following date range</b>
                    <table border="0" width="100" cellspacing="2" class="compact">
                        <thead/>
                        <tbody>
                            <tr>
                                <td class="label">Begin Date</td>
                                <td>
                                     <input type="text" id="startDate" class="occurrence_date" placeholder="will have data picker" value=""/>
                                     leave blank for earliest record date
                                </td>
                            </tr>
                            <tr>
                                <td class="label">End Date</td>
                                <td>
                                     <input type="text" id="endDate" class="occurrence_date" placeholder="will have data picker" value=""/>
                                     leave blank for most recent record date
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <input type="button" id="advancedSubmit" value="Advanced Search" onClick="$('#solrSubmit').click()"/>
                </form>
            </div>
            <br/><br/>
            <jsp:include page="chartDiv.jsp"/>
        </div>
    </body>
</html>