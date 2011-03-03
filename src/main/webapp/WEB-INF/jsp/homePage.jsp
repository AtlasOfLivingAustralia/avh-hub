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
            * Specify charts to load.
            \************************************************************/
            function onLoadCallback() {
              // taxon chart
              jpLoadTaxonChart("dp20",null,"phylum");  // start with all phyla
            }
            /************************************************************\
            * Fire chart loading
            \************************************************************/
            google.load("visualization", "1", {packages:["corechart"]});
            google.setOnLoadCallback(onLoadCallback);

        </script>
    </head>
    <body>
        <div id="headingBar">
            <h1>Search for records in OZCAM</h1>
            <div id="solrSearchForm">
                <form action="${pageContext.request.contextPath}/occurrences/search" id="homepageSearchForm">
                    <input name="q" value="${param.q}" id="solrQuery" style="width:600px; height:20px; font-size:16px;"/>&nbsp;
                    <input type="submit" value="Submit" style="font-size:18px;"/>
                    <input type="hidden" id="lsid" value=""/>
                    <span id="advancedSearchLink"><a href="#advancedSearch">Advanced Search</a></span>
                </form>
            </div>
            <div id="advancedSearch">
                Advanced search options go here.
            </div>
            <br/><br/>
            <div class="section vertical-charts">
                <!--
                *******                                  *****
                ******* STANDALONE TAXON BREAKDOWN CHART *****
                *******                                  *****
                -->
                <div id='taxonChart'>
                    <img class='taxon-loading' alt='loading...' src='http://collections.ala.org.au/images/ala/ajax-loader.gif'/>
                </div>
                <div id='taxonChartCaption' style='visibility:hidden;'>
                    <span class='taxonChartCaption'>Click a slice or legend to drill into a group.</span><br/>
                    <span id='resetTaxonChart' class="resetChart" onclick='resetTaxonChart()'></span>
                </div>
                
            </div>
        </div>
    </body>
</html>