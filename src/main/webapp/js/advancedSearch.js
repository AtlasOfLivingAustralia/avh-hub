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
 * JQuery on document ready callback
 */
$(document).ready(function() {
    // Autocomplete
    $("input[name=name_autocomplete]").autocomplete('http://bie.ala.org.au/search/auto.json', {
        //width: 350,
        extraParams: {limit:100},
        dataType: 'jsonp',
        parse: function(data) {
            var rows = new Array();
            data = data.autoCompleteList;
            for(var i=0; i<data.length; i++){
                rows[i] = {
                    data:data[i],
                    value: data[i].guid,
                    result: data[i].matchedNames[0]
                };
            }
            return rows;
        },
        matchSubset: false,
        highlight: false,
        delay: 600,
        formatItem: function(row, i, n) {
            var result = (row.scientificNameMatches) ? row.scientificNameMatches[0] : row.commonNameMatches ;
            if (row.name != result && row.rankString) {
                result = result + "<div class='autoLine2'>" + row.rankString + ": " + row.name + "</div>";
            } else if (row.rankString) {
                result = result + "<div class='autoLine2'>" + row.rankString + "</div>";
            }
            result = "<input type='button' value='Add' style='float:right'/>" + result
            return result;
        },
        cacheLength: 10,
        minChars: 3,
        scroll: false,
        max: 10,
        selectFirst: false
    }).result(function(event, item) {
        // user has selected an autocomplete item
        // determine the next avail taxon row (num) to add to
        var num = 1;
        for (i=1;i<=4;i++) {
            if (!$("#sciname_" + i).html()) {
                num = i;
                break;
            }
        }
        
        $("input#lsid_" + num).val(item.guid); // add lsid to hidden field
        // build the name string
        var matchedName = "<b>" + item.name + "</b>";
        if (item.rankId && item.rankId >= 6000) {
            matchedName = "<i>" + matchedName + "</i>";
        }
        if (item.rankString) {
            matchedName = item.rankString + ": " + matchedName;
        }
        if (item.commonName) {
            matchedName = matchedName + " | " + item.commonName;
        }

        $("#sciname_" + num).html(matchedName); // populate the matched name
        $("#clear_" + num).show(); // show the 'clear' button
        $("tr#taxon_row_" + num).show("slow"); // show the row
        var queryText = $("#solrQuery").val();
        $("#solrQuery").val(queryText + " lsid:" + item.guid); // add LSID to the main query input
        $("#name_autocomplete").val(""); // clear the search test
    });

    // "clear" button next to each taxon row
    $("input.clear_taxon").click(function(e) {
        e.preventDefault();
        $(this).hide();
        var num = $(this).attr("id").replace("clear_", ""); // get the num
        var lsid = $("input#lsid_" + num).val();
        $('#sciname_' + num).html(''); // clear taxon
        $("tr#taxon_row_" + num).hide("slow"); // hide the row
        var query = $("#solrQuery").val(); // get the query text
        query = query.replace("lsid:" + lsid, "").trim(); // reomve the LSID
        $("#solrQuery").val(query); // replace with new query text
    });

    // search submit
    $("#solrSearchForm").submit(function(e) {
        e.preventDefault();
        var lsid = $("input#lsid").val();
        var url;
        if (lsid) {
            // redirect to taxon search if lsid
            url = contextPath + "/occurrences/taxa/" + lsid;
        } else {
            // normal full text search
            url = contextPath + "/occurrences/search?q=" + $("input#solrQuery").val();
        }
        window.location.href = url;
    });

    // Lookup buttons
    $("input.taxaLookup").fancybox({
        'hideOnContentClick' : false,
        'hideOnOverlayClick': true,
        'showCloseButton': true,
        'titleShow' : false,
        'autoDimensions' : false,
        'width': '600',
        'height': '200',
        'padding': 15,
        'margin': 10,
        'onComplete': function(el) {
            var num = $(el).attr("id");
            //$("span#nameNum").html(num);
            $("input[name=name_autocomplete]").attr("id", num);
        }
    });
});
