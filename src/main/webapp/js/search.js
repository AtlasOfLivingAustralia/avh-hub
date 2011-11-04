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

/**
 * Load all the charts 
 */
function loadAllCharts() {
    var queryString = BC_CONF.searchString.replace("?q=","");
    var biocacheServiceUrl = BC_CONF.biocacheServiceUrl; //BC_CONF.biocacheServiceUrl, // "http://ala-macropus.it.csiro.au/biocache-service";
    
    var taxonomyChartOptions = {
        query: queryString,
        backgroundColor: "#eeeeee",
        biocacheServicesUrl: biocacheServiceUrl,
        displayRecordsUrl: BC_CONF.serverName
    };
    
    var facetChartOptions = {
        query: queryString, 
        charts: ['institution_uid','state','species_group','assertions','type_status','biogeographic_region','state_conservation','occurrence_year'],
        institution_uid: {backgroundColor: "#eeeeee"},
        state: {backgroundColor: "#eeeeee"},
        species_group: {backgroundColor: "#eeeeee", title: 'By higher-level group', ignore: ['Animals','Insects','Crustaceans']},
        assertions: {backgroundColor: "#eeeeee"},
        type_status: {backgroundColor: "#eeeeee"},
        biogeographic_region: {backgroundColor: "#eeeeee"},
        state_conservation: {backgroundColor: "#eeeeee"},
        occurrence_year:{backgroundColor: "#eeeeee"},
        biocacheServicesUrl: biocacheServiceUrl,
        displayRecordsUrl: BC_CONF.serverName
    };
    
    loadTaxonomyChart(taxonomyChartOptions);
    loadFacetCharts(facetChartOptions);
}

/**
 * Load images in images tab
 */
function loadImagesInTab() {
    loadImages(0);
}

function loadImages(start) {
    start = (start) ? start : 0;
    var imagesJsonUri = BC_CONF.biocacheServiceUrl + "/occurrences/search.json" + BC_CONF.searchString + 
        "&fq=multimedia:Multimedia&facet=false&pageSize=20&start=" + start + "&callback=?";
    $.getJSON(imagesJsonUri, function(data) {
        //console.log("data",data);
        if (data.occurrences) {
            //var htmlUl = "";
            if (start == 0) {
                $("#imagesGrid").html("");
            }
            var count = 0;
            $.each(data.occurrences, function(i, el) {
                count++;
                var imgEl = $("<img src='" + el.image.replace(/^\/data/,'http://biocache.ala.org.au') + 
                    "' style='height: 100px; cursor: pointer;'/>");
                var metaData = {
                    uuid: el.uuid,
                    rank: el.taxonRank,
                    rankId: el.taxonRankID,
                    sciName: el.raw_scientificName,
                    commonName: (el.raw_vernacularName) ? "| " + el.raw_vernacularName : "",
                    date: new Date(el.eventDate * 1000),
                    basisOfRecord: el.basisOfRecord
                };
                imgEl.data(metaData);
                //htmlUl += htmlLi;
                $("#imagesGrid").append(imgEl);
                
            });
            
            if (count + start < data.totalRecords) {
                //console.log("load more", count, start, count + start, data.totalRecords);
                $('#imagesGrid').data('count', count + start);
                $("#loadMoreImages").show();
            } else {
                $("#loadMoreImages").hide();
            }
            
            $('#imagesGrid img').ibox(); // enable hover effect
        }
    });
}

/**
 * iBox Jquery plugin for Google Images hover effect.
 * Origina by roxon http://stackoverflow.com/users/383904/roxon
 * Posted to stack overflow: 
 *   http://stackoverflow.com/questions/7411393/pop-images-like-google-images/7412302#7412302
 */
(function($) {
    $.fn.ibox = function() {
        // set zoom ratio //
        resize = 50;
        ////////////////////
        var img = this;
        img.parent().append('<div id="ibox" />');
        var ibox = $('#ibox');
        var elX = 0;
        var elY = 0;

        img.each(function() {
            var el = $(this);

            el.mouseenter(function() {
                ibox.html('');
                var elH = el.height();
                elX = el.position().left - 6; // 6 = CSS#ibox padding+border
                elY = el.position().top - 6;
                var h = el.height();
                var w = el.width();
                var wh;
                checkwh = (h < w) ? (wh = (w / h * resize) / 2) : (wh = (w * resize / h) / 2);

                $(this).clone().prependTo(ibox);
                var md = $(el).data();
                var link = BC_CONF.contextPath + "/occurrences/"  + md.uuid;
                var itals = (md.rankId >= 6000) ? "<span style='font-style: italic;'>" : "<span>";
                var infoDiv = "<div style=''><a href='" + link + "'><span style='text-transform: capitalize'>" + 
                    md.rank + "</span>: " +  itals + md.sciName + "</span> " + 
                    md.commonName + "</a></div>";
                $(ibox).append(infoDiv);
                $(ibox).click(function(e) {
                    e.preventDefault();
                    window.location.href = link;
                });
                
                ibox.css({
                    top: elY + 'px',
                    left: elX + 'px',
                    "max-width": $(el).width() + (2 * wh) + 12
                });

                ibox.stop().fadeTo(200, 1, function() {
                    //$(this).animate({top: '-='+(resize/2), left:'-='+wh},200).children('img').animate({height:'+='+resize},200);
                    $(this).children('img').animate({height:'+='+resize},200);
                });
                
            });

            ibox.mouseleave(function() {
                ibox.html('').hide();
            });
        });
    };
})(jQuery);

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
        var downloadUrl = $("input#downloadUrl").val().replace(/\\ /g, " ");
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
        var downloadUrl = $("input#downloadChecklistUrl").val().replace(/\\ /g, " ") + "&facets=species_guid&lookup=true&file="+$("#filename").val();
        //alert("downloadUrl = " + downloadUrl);
        window.location.href = downloadUrl;
        $.fancybox.close();
    });

    // catch checklist download submit button
    $("#downloadFieldGuideSubmitButton").click(function(e) {
        e.preventDefault();
        var downloadUrl = $("input#downloadFieldGuideUrl").val().replace(/\\ /g, " ") + "&facets=species_guid";

        window.open(downloadUrl);

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
    $('ul.facets').oneShowHide({
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
        // IE7< has limit of 2000 chars on URL so split into 2 requests        
        var guidListA = guidList.slice(0, 15) // first 15 elements
        var jsonUrlA = BC_CONF.bieWebappUrl + "/species/namesFromGuids.json?guid=" + guidListA.join("&guid=") + "&callback=?";
        $.getJSON(jsonUrlA, function(data) {
            // set the name in place of LSID
            $("li.species_guid").each(function(i, el) {
                if (i < 15) {
                    $(el).find("a").html("<i>"+data[i]+"</i>");
                } else {
                    return false; // breaks each loop
                }
            });
        });
        
        if (guidList.length > 15) {
            var guidListB = guidList.slice(15)
            var jsonUrlB = BC_CONF.bieWebappUrl + "/species/namesFromGuids.json?guid=" + guidListB.join("&guid=") + "&callback=?";
            $.getJSON(jsonUrlB, function(data) {
                // set the name in place of LSID
                $("li.species_guid").each(function(i, el) {
                    // skip forst 15 elements
                    if (i > 14) {
                        var k = i - 15;
                        $(el).find("a").html("<i>"+data[k]+"</i>");
                    }
                });
            });
        }
    }
    
    // do the same for the selected facet
    var selectedLsid = $("b.species_guid").attr("id");
    if (selectedLsid) {
        var jsonUrl2 = BC_CONF.bieWebappUrl + "/species/namesFromGuids.json?guid=" + selectedLsid + "&callback=?";
        $.getJSON(jsonUrl2, function(data) {
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
        var jsonUri = BC_CONF.biocacheServiceUrl + "/occurrences/search.json?q=lsid:" + lsid + "&facets=raw_taxon_name&pageSize=0&flimit=50&callback=?";
        $.getJSON(jsonUri, function(data) {
            // list of synonyms
            var synList = "<div class='refineTaxaSearch' id='refineTaxaSearch_"+i+"'>" + 
                "This taxon search will include records with synonyms and child taxa of " +
                "<a href='" + BC_CONF.bieWebappUrl + "/species/" + lsid + "' title='Species page' class='bold'>" +
                nameString + "</a>.<br/>Below are the <u>original scientific names</u> " + 
                "which appear on records in this result set:<ul>";
            var synListSize = 0;
            $.each(data.facetResults, function(k, el) {
                //console.log("el", el);
                if (el.fieldName == "raw_taxon_name") {
                    $.each(el.fieldResult, function(j, el1) {
                        synListSize++;
                        synList += "<li><a href='" + BC_CONF.contextPath + "/occurrences/search?q=raw_taxon_name:%22" + el1.label + "%22'>" + el1.label + "</a> (" + el1.count + ")";
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
    
    // Jquery Tools Tabs setup
    var tabsInit = { 
        map: false,
        charts: false,
        images: false
    };

    $(".css-tabs").tabs(".css-panes > div", { 
        history: true,
        effect: 'fade',
        onClick: function(event, tabIndex) {
            if (tabIndex == 1 && !tabsInit.map) {
                // trigger map load
                initialiseMap();
                tabsInit.map = true; // only initialise once!
            } else if (tabIndex == 2 && !tabsInit.charts) {
                // trigger charts load
                loadAllCharts();
                tabsInit.charts = true; // only initialise once!
            } else if (tabIndex == 3 && !tabsInit.images && BC_CONF.hasMultimedia) {
                loadImagesInTab();
                tabsInit.images = true;
            }
        }
    });
    
//    $("#imagesGrid img").live("mouseover mouseout", function(event) {
//        event.preventDefault();
//        if ( event.type == "mouseover" ) {
//            // do something on mouseover
//            $(this).height("150px");
//        } else {
//            // do something on mouseout
//            $(this).height("100px");
//        }
//        
//    });
    $("#loadMoreImages").live("click", function(e) {
        e.preventDefault();
        var start = $("#imagesGrid").data('count');
        //console.log("start", start);
        loadImages(start);
    });
            
    // add click even on each record row in results list
    $(".recordRow").click(function(e) {
        e.preventDefault();
        window.location.href = BC_CONF.contextPath + "/occurrence/" + $(this).attr("id");
    }).hover(function(){
        // mouse in
        $(this).css('cursor','pointer');
        $(this).css('background-color','#FFF');
    }, function(){
        // mouse out
        $(this).css('cursor','default');
        $(this).css('background-color','transparent');
    });
}); // end JQuery document ready
