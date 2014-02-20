/**
 * Delete a user assertion
 */
function deleteAssertion(recordUuid, assertionUuid){
    $.post('${pageContext.request.contextPath}/occurrences/assertions/delete',
        { recordUuid: recordUuid, assertionUuid: assertionUuid },
        function(data) {
            //retrieve all asssertions
            $.get('${pageContext.request.contextPath}/occurrences/groupedAssertions?recordUuid=${record.raw.uuid}', function(data) {
                $('#'+assertionUuid).fadeOut('slow', function() {
                    $('#userAssertions').html(data);
                    //if theres no child elements to the list, hide the heading
                    //alert("Number of user assertions : " +  $('#userAssertions').children().size()   )
                    if($('#userAssertions').children().size() < 1){
                        $('#userAssertionsContainer').hide("slow");
                    }
                });
            });
            refreshUserAnnotations();
        }
    );
}

/**
 * Convert camel case text to pretty version (all lower case)
 */
function fileCase(str) {
    return str.replace(/([a-z])([A-Z])/g, "$1 $2").toLowerCase().capitalize();
}

//load the assertions
function refreshUserAnnotations(){
    $.get("${pageContext.request.contextPath}/occurrences/${record.raw.uuid}/userAssertions.json", function(data) {

        if(data.assertionQueries.length == 0 && data.userAssertions.length == 0){
            $('#userAnnotationsDiv').hide('slow');
        } else {
            $('#userAnnotationsDiv').show('slow');
        }
        $('#userAnnotationsList').empty();

        for(var i=0; i < data.assertionQueries.length; i++){
            var $clone = $('#userAnnotationTemplate').clone();
            $clone.find('.issue').text(data.assertionQueries[i].assertionType);
            $clone.find('.user').text(data.assertionQueries[i].userName);
            $clone.find('.comment').text(data.assertionQueries[i].comment);
            $clone.find('.created').text(data.assertionQueries[i].created);
            if(data.assertionQueries[i].recordCount > 1){
                $clone.find('.viewMore').css({display:'block'});
                $clone.find('.viewMoreLink').attr('href', '${pageContext.request.contextPath}/occurrences/search?q=query_assertion_uuid:' + data.assertionQueries[i].uuid);
            }
            $('#userAnnotationsList').append($clone);
        }
        for(var i = 0; i < data.userAssertions.length; i++){
            var $clone = $('#userAnnotationTemplate').clone();
            $clone.find('.issue').text(data.userAssertions[i].name);
            $clone.find('.user').text(data.userAssertions[i].userDisplayName);
            //$clone.find('.userDisplayName').text("User: " + data.userAssertions[i].userDisplayName);
            $clone.find('.comment').text('Comment: ' + data.userAssertions[i].comment);
            $clone.find('.userRole').text(data.userAssertions[i].userRole !=null ? data.userAssertions[i].userRole: '');
            $clone.find('.userEntity').text(data.userAssertions[i].userEntityName !=null ? data.userAssertions[i].userEntityName: '');
            $clone.find('.created').text('Date created: ' + (moment(data.userAssertions[i].created,"YYYY-MM-DDTHH:mm:ssZ").format('YYYY-MM-DD')));
            if(data.userAssertions[i].userRole != null){
                $clone.find('.userRole').text(', ' + data.userAssertions[i].userRole);
            }
            if(data.userAssertions[i].userEntityName !=null){
                $clone.find('.userEntity').text(', ' + data.userAssertions[i].userEntityName);
            }
            if(OCC_REC.userId == data.userAssertions[i].userId){
                $clone.find('.deleteAnnotation').css({display:'block'});
                $clone.find('.deleteAnnotation').attr('id', data.userAssertions[i].uuid);
            } else {
                $clone.find('.deleteAnnotation').css({display:'none'});
            }
            $('#userAnnotationsList').append($clone);
        }
        updateDeleteEvents();
    });
}

function updateDeleteEvents(){
    $('.deleteAnnotation').off("click");
    $('.deleteAnnotation').on("click", function(e){
        e.preventDefault();
        var isConfirmed = confirm('Are you sure you want to delete this issue?');
        if (isConfirmed === true) {
            deleteAssertion('${ala:escapeJS(record.raw.uuid)}', this.id);
        }
    });
}

/**
 * Capitalise first letter of string only
 * @return {String}
 */
String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

/**
 * JQuery on document ready callback
 */
$(document).ready(function() {

    <c:if test="${record.processed.attribution.provenance == 'Draft'}">
    $('#viewDraftButton').click(function(){
        document.location.href = '${record.raw.occurrence.occurrenceID}';
    })
    </c:if>

    // add assertion form display
    $("#assertionButton, #verifyButton").fancybox({
        //'href': '#loginOrFlag',
        'hideOnContentClick' : false,
        'hideOnOverlayClick': true,
        'showCloseButton': true,
        'titleShow' : false,
        'autoDimensions' : true,
        //'width': '500',
        //'height': '400',
        'padding': 15,
        'margin': 10
    });

    $('#showUncheckedTests').on('click', function(e){
        $('.uncheckTestResult').toggle();
    });

    $('#showMissingPropResult').on('click', function(e){
        $('.missingPropResult').toggle();
    });

    // raw vs processed popup
    $("#showRawProcessed").fancybox({
        //'href': '#loginOrFlag',
        'hideOnContentClick' : false,
        'hideOnOverlayClick': true,
        'showCloseButton': true,
        'titleShow' : false,
        'centerOnScroll': true,
        'transitionIn': 'elastic',
        'transitionOut': 'elastic',
        'speedIn': 500,
        'speedOut': 500,
        'autoDimensions' : false,
        'width': '80%',
        'height': '80%',
        'padding': 15,
        'margin': 10
    });

    refreshUserAnnotations();

    // bind to form submit for assertions
    $("form#issueForm").submit(function(e) {
        e.preventDefault();
        var comment = $("#issueComment").val();
        var code = $("#issue").val();
        var userDisplayName = '${userDisplayName}';
        var recordUuid = '${ala:escapeJS(record.raw.rowKey)}';
        if(code!=""){
            $('#assertionSubmitProgress').css({'display':'block'});
            $.post("${pageContext.request.contextPath}/occurrences/assertions/add",
                { recordUuid: recordUuid, code: code, comment: comment, userId: OCC_REC.userId, userDisplayName: userDisplayName},
                function(data) {
                    $('#assertionSubmitProgress').css({'display':'none'});
                    $("#submitSuccess").html("Thanks for flagging the problem!");
                    $("#issueFormSubmit").hide();
                    $("input:reset").hide();
                    $("input#close").show();
                    //retrieve all assertions
                    $.get('${pageContext.request.contextPath}/occurrences/groupedAssertions?recordUuid=${record.raw.uuid}', function(data) {
                        //console.log("data", data);
                        $('#userAssertions').html(data);
                        $('#userAssertionsContainer').show("slow");
                    });
                    refreshUserAnnotations();
                }
            ).error(function() {
                    $('#assertionSubmitProgress').css({'display':'none'});
                    $("#submitSuccess").html("There was problem flagging the issue. Please try again later.");
                });
        } else {
            alert("Please supply a issue type");
        }
    });

    $(".userAssertionComment").each(function(i, el) {
        var html = $(el).html();
        $(el).html(replaceURLWithHTMLLinks(html)); // convert it
    });


    // bind to form "close" button
    $("input#close").live("click", function(e) {
        // close the popup
        $.fancybox.close();
        // reset form back to default state
        $('form#issueForm')[0].reset();
        $("#submitSuccess").html("");
        $("#issueFormSubmit").show("slow");
        $("input:reset").show("slow");
        $("input#close").hide("slow");
    });

    // give every second row a class="grey-bg"
//                $('table.occurrenceTable, table.inner, table.layerIntersections, table.duplicationTable').each(function(i, el) {
//                    $(this).find('tr').not('.sectionName').each(function(j, tr) {
//                        if (j % 2 == 0) {
//                            $(this).addClass("grey-bg");
//                        }
//                    });
//                });

    // convert camel case field names to "normal"
    $("td.dwc, span.dwc").each(function(i, el) {
        var html = $(el).html();
        $(el).html(fileCase(html)); // conver it
    });

    // load a JS map with sensitiveDatasets values from hubs.properties file
    var sensitiveDatasets = {
    <c:forEach var="sds" items="${sensitiveDatasets}" varStatus="s">
    ${sds}: '<ala:propertyLoader checkSupplied="true" bundle="hubs" property="sensitiveDatasets.${sds}"/>'<c:if test="${not s.last}">,</c:if>
    </c:forEach>
}

// add links for dataGeneralizations pages in collectory
$("span.dataGeneralizations").each(function(i, el) {
    var field = $(this);
    var text = $(this).text().match(/\[.*?\]/g);

    if (text) {
        $.each(text, function(j, el) {
            var list = el.replace(/\[.*,(.*)\]/, "$1").trim();
            var code = list.replace(/\s/g, "_").toUpperCase();

            if (sensitiveDatasets[code]) {
                var linked = "<a href='" + sensitiveDatasets[code] + "' title='" + list
                    + " sensitive species list information page' target='collectory'>" + list + "</a>";
                var regex = new RegExp(list, "g");
                var html = $(field).html().replace(regex, linked);
                $(field).html(html);
            }
        });
    }
});

<c:if test="${isCollectionAdmin}">
$(".confirmVerifyCheck").click(function(e) {
    $("#verifyAsk").hide();
    $("#verifyDone").show();
    });
$(".cancelVerify").click(function(e) {
    $.fancybox.close();
    });
$(".closeVerify").click(function(e) {
    $.fancybox.close();
    });
$(".confirmVerify").click(function(e) {
    $("#verifySpinner").show();
    var code = "50000";
    var userDisplayName = '${userDisplayName}';
var recordUuid = '${ala:escapeJS(record.raw.rowKey)}';
var comment = $("#verifyComment").val();
if (!comment) {
    alert("Please add a comment");
    $("#verifyComment").focus();
    $("#verifySpinner").hide();
    return false;
    }
// send assertion via AJAX... TODO catch errors
$.post("${pageContext.request.contextPath}/occurrences/assertions/add",
                            { recordUuid: recordUuid, code: code, comment: comment, userId: OCC_REC.userId, userDisplayName: userDisplayName},
function(data) {
    // service simply returns status or OK or FORBIDDEN, so assume it worked...
    $("#verifyAsk").fadeOut();
    $("#verifyDone").fadeIn();
    }
).error(function (request, status, error) {
    alert("Error verifying record: " + request.responseText);
    }).complete(function() {
    $("#verifySpinner").hide();
    });
});
</c:if>

$("#backBtn a").click(function(e) {
    e.preventDefault();
    var url = $(this).attr("href");
    if (url) {
        // referer value from request object
        window.location.href = url;
    } else if (history.length) {
        //There is history to go back to
        history.go(-1);
    } else {
        alert("Sorry it appears the history has been lost, please use the browser&apso;s back button");
    }
});

var sequenceTd = $("tr#nucleotides").find("td.value");
var sequenceStr = sequenceTd.text().trim();
if (sequenceStr.length > 10) {
    // split long DNA sequences into blocks of 10 chars
    $(sequenceTd).html("<code>"+sequenceStr.replace(/(.{10})/g,"$1 ")+"</code>");
}

// context sensitive help on data quality tests
$(".dataQualityHelpLinkZZZ").click(function(e) {
    e.preventDefault();
    $("#dataQualityModal .modal-body").html(""); // clear content
    var code = $(this).data("code");
    var dataQualityItem = getDataQualityItem(code);
    var content = "Error: info not found";
    if (dataQualityItem) {
        content = "<div><b>Name: " + dataQualityItem.name + "</b></div>";
        content += "<div>" + dataQualityItem.description + "</div>";
        content += "<div><a href='http://code.google.com/p/ala-dataquality/wiki/" +
            dataQualityItem.name + "' target='wiki' title='More details on the wiki page'>Wiki page</a></div>";
    }

    //$("#dataQualityModal .modal-body").html(content);
    //$('#dataQualityModal').modal({show:true});
    $(this).popover({
        html : true,
        content: function() {
            return content;
        }
    });
});

$(".dataQualityHelpLinkZZ").popover({
    html : true,
    content: "Just a test"
}).click('click', function(e) { e.preventDefault(); });



$(".dataQualityHelpLink").popover({
    html : true,
    trigger: "click",
    title: function() {
        var code = $(this).data("code");
        var content = "";
        var dataQualityItem = getDataQualityItem(code);
        if (dataQualityItem) {
            content = "<button type='button' class='close' onclick='$(&quot;.dataQualityHelpLink&quot;).popover(&quot;hide&quot;);'>×</button>" + dataQualityItem.name;
        }
        return content;
    },
    content: function() {
        var code = $(this).data("code");
        var dataQualityItem = getDataQualityItem(code);
        var content = "Error: info not found";
        if (dataQualityItem) {
            //content = "<div><b>" + dataQualityItem.name + "</b></div>";
            content = "<div>" + dataQualityItem.description + "</div>";
            if (dataQualityItem.wiki) {
                content += "<div><i class='icon-share-alt'></i>&nbsp;<a href='http://code.google.com/p/ala-dataquality/wiki/" +
                    dataQualityItem.name + "' target='wiki' title='More details on the wiki page'>Wiki page</a></div>";
            }
        }
        return content;
    }
}).click('click', function(e) { e.preventDefault(); });

}); // end JQuery document ready

var dataQualityDataIsLoaded = false;
var dataQualityItems = {};

function getDataQualityItem(code) {

    if (!dataQualityDataIsLoaded) {
        var url = "${pageContext.request.contextPath}/data-quality/allCodes.json";
        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: function(data) {
                if (data && data[1]) {
                    $.each(data, function(key, val) {
                        console.log("data", key, val);
                        dataQualityItems[key] = val;
                    });
                }
            },
            complete: function() {
                dataQualityDataIsLoaded = true;
            },
            async: false
        });
    }
    console.log("dataQualityItems",dataQualityItems);
    if (dataQualityItems[code]) {
        return dataQualityItems[code];
    }
}

/*
 * IE doesn't support String.trim(), so add it in manually
 */
if(typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, '');
    }
}

function replaceURLWithHTMLLinks(text) {
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i;
    return text.replace(exp,"<a href='$1'>$1</a>");
}

function renderOutlierCharts(data){
    var chartQuery = null;

    <c:choose>
        <c:when test="${record.processed.classification.taxonRank == 'species'}">
        chartQuery = 'species_guid:${fn:replace(record.processed.classification.taxonConceptID, ':', '\\:')}';
        </c:when>
        <c:when test="${record.processed.classification.taxonRank == 'subspecies'}">
        chartQuery = 'subspecies_guid:${fn:replace(record.processed.classification.taxonConceptID, ':', '\\:')}';
        </c:when>
    </c:choose>

    if(chartQuery != null){
        $.each(data, function() {
            drawChart(this.layerId, chartQuery, this.layerId+'Outliers', this.outlierValues, this.recordLayerValue, false);
            drawChart(this.layerId, chartQuery, this.layerId+'OutliersCumm', this.outlierValues, this.recordLayerValue, true);
        })
    }
}

function drawChart(facetName, biocacheQuery, chartName, outlierValues, valueForThisRecord, cumulative){

    var facetChartOptions = { error: "badQuery", legend: 'right'}
    facetChartOptions.query = biocacheQuery;
    facetChartOptions.charts = [chartName];
    facetChartOptions.backgroundColor = '#FFFEF7';
    facetChartOptions.width = "75%";
    facetChartOptions[facetName] = {chartType: 'scatter'};


    //additional config
    facetChartOptions.cumulative = cumulative;
    facetChartOptions.outlierValues = outlierValues;    //retrieved from WS
    facetChartOptions.highlightedValue = valueForThisRecord;           //retrieved from the record

    //console.log('Start the drawing...' + chartName);
    facetChartGroup.loadAndDrawFacetCharts(facetChartOptions);
    //console.log('Finished the drawing...' + chartName);
}
google.load("visualization", "1", {packages:["corechart"]});