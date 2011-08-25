/* 
 *  Copyright (C) 2011 Atlas of Living Australia
 *  All Rights Reserved.
 *
 *  The contents of this file are subject to the Mozilla Public
 *  License Version 1.1 (the "License"); you may not use this file
 *  except in compliance with the License. You may obtain a copy of
 *  the License at http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS
 *  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 *  implied. See the License for the specific language governing
 *  rights and limitations under the License.
 */

/**
 * Catch sort drop-down and build GET URL manually
 */
function reloadWithParam(paramName, paramValue) {
    var paramList = [];
    var q = $.getQueryParam('q'); //$.query.get('q')[0];
    var fqList = $.getQueryParam('fq'); //$.query.get('fq');
    var sort = $.getQueryParam('sort');
    var dir = $.getQueryParam('dir');
    var lat = $.getQueryParam('lat');
    var lon = $.getQueryParam('lon');
    var rad = $.getQueryParam('radius');
    var taxa = $.getQueryParam('taxa');
    // add query param
    if (q != null) {
        paramList.push("q=" + q);
    }
    // add filter query param
    if (fqList != null) {
        paramList.push("fq=" + fqList.join("&fq="));
    }
    // add sort param if already set
    if (paramName != 'sort' && sort != null) {
        paramList.push('sort' + "=" + sort);
    }

    if (paramName != null && paramValue != null) {
        paramList.push(paramName + "=" +paramValue);
    }
    
    if (lat && lon && rad) {
        paramList.push("lat=" + lat);
        paramList.push("lon=" + lon);
        paramList.push("radius=" + rad);
    }
    
    if (taxa) {
        paramList.push("taxa=" + taxa);
    }

    //alert("params = "+paramList.join("&"));
    //alert("url = "+window.location.pathname);
    window.location.href = window.location.pathname + '?' + paramList.join('&');
}

/**
 * triggered when user removes an active facet - re-calculates the request params for
 * page minus the requested fq param
 */
function removeFacet(facet) {
    var q = $.getQueryParam('q'); //$.query.get('q')[0];
    var fqList = $.getQueryParam('fq'); //$.query.get('fq');
    var lat = $.getQueryParam('lat');
    var lon = $.getQueryParam('lon');
    var rad = $.getQueryParam('radius');
    var taxa = $.getQueryParam('taxa');
    var paramList = [];
    if (q != null) {
        paramList.push("q=" + q);
    }
    
    if (lat && lon && rad) {
        paramList.push("lat=" + lat);
        paramList.push("lon=" + lon);
        paramList.push("radius=" + rad);
    }
    
    if (taxa) {
        paramList.push("taxa=" + taxa);
    }

    //alert("this.facet = "+facet+"; fqList = "+fqList.join('|'));

    if (fqList instanceof Array) {
        //alert("fqList is an array");
        for (var i in fqList) {
            var thisFq = decodeURI(fqList[i]); //.replace(':[',':'); // for dates to work
            //alert("fq = "+thisFq + " || facet = "+facet);
            if (thisFq.indexOf(facet) != -1) {  // if(str1.indexOf(str2) != -1){
                //alert("removing fq: "+fqList[i]);
                fqList.splice(fqList.indexOf(fqList[i]),1);
            }
        }
    } else {
        //alert("fqList is NOT an array");
        if (decodeURI(fqList) == facet) {
            fqList = null;
        }
    }
    //alert("(post) fqList = "+fqList.join('|'));
    if (fqList != null) {
        paramList.push("fq=" + fqList.join("&fq="));
    }

    window.location.href = window.location.pathname + '?' + paramList.join('&') + window.location.hash;
}

// vars for hiding drop-dpwn divs on click outside tem
var hoverDropDownDiv = false;

// Jquery Document.onLoad equivalent
$(document).ready(function() {
    // listeners for sort & paging widgets
    $("select#sort").change(function() {
        var val = $("option:selected", this).val();
        reloadWithParam('sort',val);
    });
    $("select#dir").change(function() {
        var val = $("option:selected", this).val();
        reloadWithParam('dir',val);
    });
    $("select#sort").change(function() {
        var val = $("option:selected", this).val();
        reloadWithParam('sort',val);
    });
    $("select#dir").change(function() {
        var val = $("option:selected", this).val();
        reloadWithParam('dir',val);
    });
    $("select#per-page").change(function() {
        var val = $("option:selected", this).val();
        reloadWithParam('pageSize',val);
    });

    // download link
    $("#downloadLink").fancybox({
        'hideOnContentClick' : false,
        'hideOnOverlayClick': true,
        'showCloseButton': true,
        'titleShow' : false,
        'autoDimensions' : false,
        'width': '500',
        'height': '300',
        'padding': 15,
        'margin': 10
    });

    // catch download submit button
    $("#downloadSubmitButton").click(function(e) {
        e.preventDefault();
        var downloadUrl = $("input#downloadUrl").val();
        var reason = $("#reason").val();
        if(typeof reason == "undefined")
            reason = "";
        downloadUrl = downloadUrl + "&type=&email="+$("#email").val()+"&reason="+encodeURIComponent(reason)+"&file="+$("#filename").val();
        //alert("downloadUrl = " + downloadUrl);
        window.location.href = downloadUrl;
        $.fancybox.close();
    });
    // catch checklist download submit button
    $("#downloadCheckListSubmitButton").click(function(e) {
        e.preventDefault();
        var downloadUrl = $("input#downloadChecklistUrl").val() + "&facets=species_guid&lookup=true";
        //alert("downloadUrl = " + downloadUrl);
        window.location.href = downloadUrl;
        $.fancybox.close();
    });

    // set height of resultsOuter div to solrResults height
    var pageLength = $("select#per-page").val() || 20;
    var solrHeight = $("div.solrResults").height() + (2 * pageLength) + 70;
    //console.log("solrHeight", solrHeight, pageLength);
    var mapHeight = $("div#mapwrapper").height();
    $("#resultsOuter").css("height", (solrHeight > mapHeight ) ? solrHeight : mapHeight );

    // animate the display of showing results list vs map
    // TODO: make this a toggle() so that double clicks don't break it
    var hashType = ["list", "map"]; //
    $("#listMapButton").click(function(e) {
        e.preventDefault();
        // remove name so changing hash value does not jump the page
        $(".jumpTo").attr("name", ""); 
        // change the button text...
        $("#listMapButton").fadeOut('slow', function() {
            // Animation complete
            var spanText = $("#listMapLink").html();
            if (spanText == 'Map') {
                $("#listMapLink").html('List');
                window.location.hash = "map";
            } else {
                $("#listMapLink").html('Map');
                window.location.hash = 'list';
            }
            // add <a name=""> attr's back
            $(".jumpTo").each(function(i, el) {
                $(this).attr("name", hashType[i]);
            });
        });
        $("#listMapButton").fadeIn('slow');
        
        // make list & map div slide left & right
        var $listDiv = $("div.solrResults"); // list
        $listDiv.animate({
            left: parseInt($listDiv.css('left'),10) == 0 ? -$listDiv.outerWidth() : 0},
            {duration: "slow"}
        );
        var $mapDiv = $("div#mapwrapper"); // map
        $mapDiv.animate({
            left: parseInt($mapDiv.css('left'),10) == 0 ? $mapDiv.outerWidth() : 0},
            {duration: "slow"}
        );
    });

    // page load - detect if map is requested via #map hash
    if (window.location.hash == "#map") {
        //alert("hash is map");
        $("div.solrResults").css("left", -730);
        $("div#mapwrapper").css("left", 0);
        $("#listMapLink").html("List");
    } else if (window.location.hash == "" && $.getQueryParam('start')) {
        window.location.hash = "#list";
    }

    // add hash to URIs for facet links, so map/list state is maintained
    $("#subnavlist a").click(function(e) {
        e.preventDefault();
        var url = $(this).attr("href");
        window.location.href = url + window.location.hash;
    });

    // add show/hide links to facets
    $('#subnavlist ul.facets').oneShowHide({
        numShown: 3,
        showText : '+ show more',
        hideText : '- show less',
        className: 'showHide'
    });
    
    // Substitute LSID strings for tacon names in facet values for species
    var guidList = [];
    $("li.species_guid").each(function(i, el) {
        guidList[i] = $(el).attr("id");
    });
    
    if (guidList.length > 0) {
        // AJAX call to get names for LSIDs
        var jsonUrl = bieWebappUrl + "/species/namesFromGuids.json?guid=" + guidList.join("&guid=") + "&callback=?";
        $.getJSON(jsonUrl, function(data) {
            // set the name in place of LSID
            $("li.species_guid").each(function(i, el) {
                $(el).find("a").html("<i>"+data[i]+"</i>");
            });
        });
    }
    
    // do the same for the selected facet
    var selectedLsid = $("b.species_guid").attr("id");
    if (selectedLsid) {
        var jsonUrl = bieWebappUrl + "/species/namesFromGuids.json?guid=" + selectedLsid + "&callback=?";
        $.getJSON(jsonUrl, function(data) {
            // set the name in place of LSID
            $("b.species_guid").html("<i>"+data[0]+"</i>");
        });
    }
    
    // remove *:* query from search bar
    var q = $.getQueryParam('q');
    if (q && q[0] == "*:*") {
        $(":input#solrQuery").val("");
    }
    
    // show hide facet display options
    $("#customiseFacets a").click(function(e) {
        e.preventDefault();
        $('#facetOptions').toggle();
    });
    
    $("#facetOptions").position({
        my: "left top",
        at: "left bottom",
        of: $("#customiseFacets"), // or this
        offset: "0 -1",
        collision: "none"
    });
    $("#facetOptions").hide();
    
    var userFacets = $.cookie("user_facets");
    //console.log("userFacets", userFacets);
    // load stored prefs from cookie
    if (userFacets) {
        $(":input.facetOpts").removeAttr("checked"); 
        var facetList = userFacets.split(",");
        for (i in facetList) {
            if (typeof facetList[i] === "string") {
                var thisFacet = facetList[i];
                //console.log("thisFacet", thisFacet);
                $(":input.facetOpts[value='"+thisFacet+"']").attr("checked","checked");
            }
        }
    }
    
    $("a#selectNone").click(function(e) {
        e.preventDefault();
        $(":input.facetOpts").removeAttr("checked");
    });
    $("a#selectAll").click(function(e) {
        e.preventDefault();
        $(":input.facetOpts").attr("checked","checked");
    });
    
    $(":input#updateFacetOptions").click(function(e) {
        e.preventDefault();
        var selectedFacets = [];
        $(":input.facetOpts").each(function() {
            var selected = ($(this).attr("checked")) ? true : false;
            if (selected) {
                selectedFacets.push($(this).val());
            }
        });
        //console.log("selectedFacets", selectedFacets);
        $.cookie("user_facets", selectedFacets);
        document.location.reload(true);
    });
    
    // taxa search - show included synonyms with popup to allow user to refine to a single name
    
    $("span.lsid").each(function(i, el) {
        var lsid = $(this).attr("id");
        var nameString = $(this).html();
        var jsonUri = biocacheServiceUrl + "/occurrences/search.json?q=lsid:" + lsid + "&facets=raw_taxon_name&pageSize=0&flimit=50&callback=?";
        $.getJSON(jsonUri, function(data) {
            // list of synonyms
            var synList = "<div class='refineTaxaSearch' id='refineTaxaSearch_"+i+"'>" + 
                "This taxon search will include records with synonyms and child taxa of " +
                "<a href='" + bieWebappUrl + "/species/" + lsid + "' title='Species page' class='bold'>" +
                nameString + "</a>.<br/>Below are the <u>original scientific names</u> " + 
                "which appear on records in this result set:<ul>";
            var synListSize = 0;
            $.each(data.facetResults, function(k, el) {
                //console.log("el", el);
                if (el.fieldName == "raw_taxon_name") {
                    $.each(el.fieldResult, function(j, el1) {
                        synListSize++;
                        synList += "<li><a href='" + contextPath + "/occurrences/search?q=raw_taxon_name:%22" + el1.label + "%22'>" + el1.label + "</a> (" + el1.count + ")";
                    });
                    
                }
            });
            
            if (synListSize == 0) {
                synList += "<li style='list-style:none;'>[no records found]</li>";
            }
            
            synList += "</ul>";
            
            if (synListSize >= 50) {
                synList += "<div>[Only showing the top 50 names]</div>";
            } 
            
            synList += "</div>";
            $("#resultsReturned").append(synList);
            // position it under the drop down
            $("#refineTaxaSearch_"+i).position({
                my: "right top",
                at: "right bottom",
                of: $(el), // or this
                offset: "0 -1",
                collision: "none"
            });
            $("#refineTaxaSearch_"+i).hide();
        });
        // format display with drop-down
        //$("span.lsid").before("<span class='plain'> which matched: </span>");
        $(el).html("<a href='#' title='display query info' id='" + i + "'>" + nameString + "</a>");
        $(el).addClass("dropDown");
    });
        
    $("#queryDisplay a").click(function(e) {
        e.preventDefault();
        var j = $(this).attr("id");
        $("#refineTaxaSearch_"+j).toggle();
    });
    
    // close drop-down divs when clicked outside 
    $('#customiseFacets > a, #refineTaxaSearch, #queryDisplay a, #facetOptions').live("mouseover mouseout", function(event) {
        if ( event.type == "mouseover" ) {
            hoverDropDownDiv = true;
        } else {
            hoverDropDownDiv = false;
        }
    });
    
    $("body").mouseup(function(){ 
        if (!hoverDropDownDiv) $('.refineTaxaSearch, #facetOptions').hide();
    });
    
}); // end JQuery document ready