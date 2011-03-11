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
                    var advDiv = $(this).attr("href");
                    $(advDiv).css("display") == "none" ? $(advDiv).fadeIn() : $(advDiv).fadeOut();
                });

                

            }); // end document.ready

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
                    <input name="q" value="${param.q}" id="solrQuery" style="width:720px; height:20px; font-size:12px;"/>&nbsp;
                    <input type="submit" value="Submit" id="solrSubmit" style="font-size:18px;"/>
                    <input type="hidden" id="lsid" value=""/>
                    <span id="advancedSearchLink"><a href="#advancedSearch">Advanced Search</a></span>
                </form>
            </div>
            <div id="advancedSearch">
                <h4>Advanced search options</h4>
                <form name="advancedSearchForm" id="advancedSearchForm" action="${pageContext.request.contextPath}/occurrences/search">
                    <%--<b>Find records that have...</b>
                    <table border="0" width="100" cellspacing="2" class="compact">
                        <thead/>
                        <tbody>
                            <tr>
                                <td class="label">all these words</td>
                                <td><input type="text" value="" name="all_terms" style="width:100%"></td>
                            </tr>
                            <tr>
                                <td class="label">the exact wording or phrase</td>
                                <td><input type="text" value="" name="phrase" style="width:100%"></td>
                            </tr>
                            <tr>
                                <td class="label">one or more of these words:</td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%" class="nested"><tbody><tr><td width="31%"><input type="text" style="width:95%" value="" id="as_oq0"></td><td class="hint">&nbsp;OR&nbsp;</td><td width="31%"><input type="text" style="width:95%" value="" id="as_oq1"></td><td class="hint">&nbsp;OR&nbsp;</td><td width="31%"><input type="text" style="width:95%" value="" id="as_oq2"></td></tr></tbody></table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <b>But don't show records that have...</b>
                    <table border="0" width="100" cellspacing="2" class="compact">
                        <thead/>
                        <tbody>
                            <tr>
                                <td class="label">any of these unwanted words</td>
                                <td><input type="text" value="" name="exclude_words" style="width:100%"></td>
                            </tr>
                        </tbody>
                    </table> --%>
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
                                        <input type="button" id="clear_${i}" class="clear_taxon" value="clear" title="clear matched name" style="display: none; float:left"/>
                                    </td>
                                </tr>
                            </c:forEach>
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