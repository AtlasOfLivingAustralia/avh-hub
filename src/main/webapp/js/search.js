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
    var paramList = [];
    if (q != null) {
        paramList.push("q=" + q);
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

    // set height of resultsOuter div to solrResults height
    var solrHeight = $("div.solrResults").height();
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
            left: parseInt($listDiv.css('left'),10) == 0 ? -$listDiv.outerWidth() : 0 },
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
}); // end JQuery document ready