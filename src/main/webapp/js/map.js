/*
    Document   : map.js
    Created on : Feb 16, 2011, 3:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
 */
var map;
var Maps = (function() {

    var clickLocation;
    var occids;
    var infowindow;
    var infomarker;
    var overlayLayers = [];
    var envLayer;

    /**
     * post a query to the biocache-service
     * to check if there are any points
     * at the click location
     *
     */
    function loadOccurrencePopup(location) {

        clickLocation = location;

        infowindow.close();
        //need to calculate radius based on zoom level and point size
        var radius = 0;
        switch (map.zoom){
            case 0:
                radius = 800;
                break;
            case 1:
                radius = 400;
                break;
            case 2:
                radius = 200;
                break;
            case 3:
                radius = 100;
                break;
            case 4:
                radius = 50;
                break;
            case 5:
                radius = 25;
                break;
            case 6:
                radius = 20;
                break;
            case 7:
                radius = 7.5;
                break;
            case 8:
                radius = 3;
                break;
            case 9:
                radius = 1.5;
                break;
            case 10:
                radius = .75;
                break;
            case 11:
                radius = .25;
                break;
            case 12:
                radius = .15;
                break;
            case 13:
                radius = .1;
                break;
            case 14:
                radius = .05;
                break;
            case 15:
                radius = .025;
                break;
            case 16:
                radius = .015;
                break;
            case 17:
                radius = 0.0075;
                break;
            case 18:
                radius = 0.004;
                break;
            case 19:
                radius = 0.002;
                break;
            case 20:
                radius = 0.001;
                break;
        }

        //modifiers if we have a larger point size
        var size = $('#sizeslider').slider('value');
        if (size >= 5 && size < 8){
            radius = radius*2;
        }
        if (size >= 8){
            radius = radius*3;
        }

        var baseurl = Config.OCC_SEARCH_URL;
        var wmsinfo = baseurl + ((BC_CONF.searchString) ? encodeURI(BC_CONF.searchString) : "?"); // window.location.search;
        // remove spatial params from searchString param
        wmsinfo = wmsinfo.replace(/&lat\=.*/, '');
        wmsinfo += "&zoom=" + map.getZoom();
        wmsinfo += "&lat=" + location.lat();
        wmsinfo += "&lon=" + location.lng();
        wmsinfo += "&radius=" + radius;

        $('#maploading').show();
        $.ajax({
            url: wmsinfo,
            dataType: "jsonp",
            success: loadNewGeoJsonData
        });
    }

    function loadNewGeoJsonData(data) {
        var displayHtml = "Occurrence Information at " + clickLocation.toString();

        if (data.count > 0) {
            displayHtml = data.count + ((data.count>1)?' occurrences founds.':' occurrence found.');
            displayHtml += '<div id="occinfo">Loading occurrence info</div>';
            occids = data.occurrences;

            Maps.loadOccurrenceInfo(0);

            infomarker.setPosition(clickLocation);
        } else {
            //occids = new Array(); 
            occids == null; // did you mean occids = null ?

            displayHtml = data.count + ' occurrences found';
            $('#maploading').fadeOut('slow');
        }
    }

    function initialiseOverlays(lyrCount) {

        // clear any existing MySpecies layers only from the map
        if (overlayLayers.length > 0) {
            for (i=0;i<overlayLayers.length;i++){
                map.overlayMapTypes.removeAt(1);
            }
        }

        // clear our local array
        //map.overlayMapTypes.clear();
        overlayLayers = [];

        // add some placeholders
        if (lyrCount > 0) {
            for (i=0;i<lyrCount;i++){
                map.overlayMapTypes.push(null);
            }
        }
    }

    /**
    * Load occurrences wms with the selected params
    */
    function insertWMSOverlay(name, params) {
        var customParams = [
        "FORMAT=image/png8",
        "outline=true"
        ];

        if (arguments.length > 1) {
            for (var i = 0; i < arguments.length; i++) {
                customParams.push(arguments[i]);
            }
        }

        //Add query string params to custom params
        var searchParam = encodeURI(BC_CONF.searchString); // NdR - fixes bug where terms have quotes around them
        var pairs = searchParam.substring(1).split('&');
        for (var j = 0; j < pairs.length; j++) {
            customParams.push(pairs[j]);
        }
        //loadWMS(map, "http://spatial.ala.org.au/geoserver/wms?", customParams);
        //var overlayWMS = getWMSObject(map, "MySpecies - " + name, Config.OCC_WMS_BASE_URL, customParams);
        //        google.maps.event.addListener(overlayWMS, 'tilesloaded', function(event) {
        //            console.log("tiles loaded for overlayWMS");
        //        });
        //map.overlayMapTypes.insertAt(map.overlayMapTypes.length, overlayWMS);
        //overlayLayers.push(overlayWMS);
        var wmstile = new WMSTileLayer("MySpecies - " + name, Config.OCC_WMS_BASE_URL, customParams, wmsTileLoaded);
        if (name=='Other') {
            overlayLayers.splice(0,0,wmstile);
            overlayLayers.pop();
        } else {
            overlayLayers.push(wmstile);
        }
    }

    function wmsTileLoaded(numtiles) {
        $('#maploading').fadeOut("slow");
    }

    return {
        /**
         * loads a static map with all the points within Australia
         * and additional facets
         */
        loadMap: function() {
            var baseurl = "http://localhost:8080/biocache-service/occurrences/static";
            var wmsimg = baseurl + encodeURI(BC_CONF.searchString); // window.location.search;
            document.getElementById('wmsimg').src= wmsimg;
        },
        
        /**
         * loads google maps and the WMS layers for occurrences
         */
        initialise: function() {
            var centre = BC_CONF.mapDefaultCentreCoords ? BC_CONF.mapDefaultCentreCoords : "-27, 133";
            var latlngStr = centre.split(",",2);
            var lat = parseFloat(latlngStr[0]);
            var lng = parseFloat(latlngStr[1]);
            var myLatlng = new google.maps.LatLng(lat, lng);
            var zoomLevel = BC_CONF.mapDefaultZoom ? parseInt(BC_CONF.mapDefaultZoom) : 4;
            var myOptions = {
                zoom: zoomLevel,
                maxZoom: 20,
                scrollwheel: false, // Dave says: leave as false
                center: myLatlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scaleControl: true, 
                streetViewControl: false,
                draggableCursor: 'pointer'
            }
            map = new google.maps.Map(document.getElementById("mapcanvas"), myOptions);
            map.enableKeyDragZoom();
            infomarker = new google.maps.Marker({
                position: myLatlng,
                visible: false,
                title: "Click location", 
                map: map
            });
            infowindow = new google.maps.InfoWindow({
                maxWidth: 600
            });

            map.setOptions({
                mapTypeControlOptions: {
                    mapTypeIds: [
                    google.maps.MapTypeId.ROADMAP,
                    google.maps.MapTypeId.TERRAIN,
                    google.maps.MapTypeId.SATELLITE,
                    google.maps.MapTypeId.HYBRID
                    ],
                    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
                }
            });

            map.controls[google.maps.ControlPosition.TOP_RIGHT].push(document.getElementById('legend'));

            google.maps.event.addListener(map, 'click', function(event) {
                loadOccurrencePopup(event.latLng);
            });

            google.maps.event.addListener(map, 'tilesloaded', function() {
                $('#legend').show();
            });

            // listener - so that map.getBounds() is not undef
            var zoomed = false;
            var zoomParam = $.urlParam('zoom');
            google.maps.event.addListener(map, 'bounds_changed', function() {
                if (!zoomed && zoomParam != 'off') {
                    fitMapToBounds();
                }
                zoomed = true;
            });

            // populate the env.layer dropdown
            var opts='<option value="-1">None</option>';
            $.each(envLayers, function(key, value) {
                opts += '<option value="'+key+'">'+value[1]+'</option>';
            });
            $('#envLyrList').html(opts);
            
            // if spatial FT search (e.g. via explore your area) then 
            // draw circle and add marker for centre of area
            var lat = $.urlParam('lat');
            var lon = $.urlParam('lon');
            var rad = $.urlParam('radius');

            if (lat && lon && rad) {
                // spatial query (e.g. from EYA)
                var latLng = new google.maps.LatLng(lat, lon);

                var marker = new google.maps.Marker({
                    position: latLng,
                    title: 'Centre of spatial search',
                    map: map,
                    draggable: false
                });

                var infowindow1 = new google.maps.InfoWindow({
                    content: "Centre of spatial search <br/> with radius of " + rad + " km"
                });

                google.maps.event.addListener(marker, 'click', function() {
                    infowindow1.open(map, marker);
                });

                // Add a Circle overlay to the map.
                var circle = new google.maps.Circle({
                    map: map,
                    radius: rad * 1000,
                    strokeWeight: 1,
                    strokeColor: 'white',
                    strokeOpacity: 0.5,
                    fillColor: '#222', // '#2C48A6'
                    fillOpacity: 0.2,
                    zIndex: -100
                });

                // bind circle to marker
                circle.bindTo('center', marker, 'position');
                // add event listener so dots can be clicked on
                google.maps.event.addListener(circle, 'click', function(event) {
                    loadOccurrencePopup(event.latLng);
                });
            } 
            
        },

        /**
         * Load occurrences wms with the selected params 
         */
        toggleOccurrenceLayer: function(input) {
            var _idx = parseInt($(input).attr('id').substr(3));
            if ($(input).is(':checked')){
                map.overlayMapTypes.setAt((_idx+1),overlayLayers[_idx]);
            }else{
                if (map.overlayMapTypes.getLength()>0){
                    map.overlayMapTypes.setAt((_idx+1),null);
                }
            }
        },

        /**
         * iterate thru' the occurrence info popup 
         */
        loadOccurrenceInfo: function(curr) {

            var pbutton = '';
            var nbutton = '';
            if (curr > 0) {
                pbutton = '<a href="#map" onClick="Maps.loadOccurrenceInfo('+(curr-1)+')">&lt; Previous</a>';
            }
            if (curr < occids.length-1) {
                nbutton = '<a href="#map" onClick="Maps.loadOccurrenceInfo('+(curr+1)+')">Next &gt;</a>';
            }

            //infowindow.setContent('<div style="height:200px">Loading occurrence info. Please wait...</div>');
            var occUrl = Config.OCC_INFO_URL_JSON.replace(/_uuid_/g,occids[curr]);

            $.get(occUrl, function(record){
                var displayHtml = occids.length + ((occids.length>1)?' occurrences founds.':' occurrence found.');
                //console.log("data.record", data.record);
                var minHeight = "150px";
                if(record.processed.occurrence.images!=null && record.processed.occurrence.images.length >0){
                    minHeight = "250px";
                }

                displayHtml = '<div id="occinfo" style="min-height:' + minHeight + ';">';
                if(occids.length>1){
                    displayHtml += '<span class="occinfohead"><strong>Viewing ' + (curr+1) + ' of ' + occids.length + ' occurrence'+((occids.length>1)?'s':'')+'</strong></span>';
                }

                displayHtml += '<div id="textfields">';

                // catalogNumber 
                if(record.raw.occurrence.catalogNumber != null){
                    displayHtml += "Catalogue number: " + record.raw.occurrence.catalogNumber + '<br />';
                } else if(record.processed.occurrence.catalogNumber != null){
                    displayHtml += "Catalogue number: " + record.processed.occurrence.catalogNumber + '<br />';
                }

                if(record.raw.classification.vernacularName!=null && BC_CONF.skin != 'avh'){
                    displayHtml += record.raw.classification.vernacularName + '<br />';
                } else if(record.processed.classification.vernacularName!=null && BC_CONF.skin != 'avh'){
                    displayHtml += record.processed.classification.vernacularName + '<br />';
                }

                if(record.raw.classification.scientificName != null){
                    displayHtml += record.raw.classification.scientificName  + '<br />';
                } else {
                    displayHtml += formatSciName(record.processed.classification.scientificName, record.processed.classification.taxonRankID)  + '<br />';
                }

                if (BC_CONF.skin == 'avh') {
                    if(record.processed.attribution.collectionName != null){
                        displayHtml += "Collection: " + record.processed.attribution.collectionName;
                    } else  if(record.processed.attribution.institutionName != null){
                        displayHtml += "Institution: " + record.processed.attribution.institutionName;
                    }
                } else {
                    if(record.processed.attribution.institutionName != null){
                        displayHtml += "Institution: " + record.processed.attribution.institutionName;
                    } else  if(record.processed.attribution.dataResourceName != null){
                        displayHtml += record.processed.attribution.dataResourceName;
                    }
                }

                if (BC_CONF.skin == 'avh') {
                    if(record.raw.occurrence.recordedBy != null){
                        displayHtml += "<br/>Collector: " + record.raw.occurrence.recordedBy;
                    } else if(record.processed.occurrence.recordedBy != null){
                        displayHtml += "<br/>Collector: " + record.processed.occurrence.recordedBy;
                    }
                }

                if(record.processed.event.eventDate != null){
                    displayHtml += "<br/>";
                    var label = (BC_CONF.skin == 'avh') ? "Collection date: " : "Record date: ";
                    displayHtml += label + record.processed.event.eventDate;
                }

                displayHtml += '</div>';

                //http://biocache.ala.org.au/biocache-media/dr360/19673/0a0e05bb-f68b-443c-9670-355622cdaed8/5286199529_c6ae5672b4.jpg
                if(record.processed.occurrence.images!=null && record.processed.occurrence.images.length >0){
                    displayHtml += "<img style='margin-top:8px; max-width:150px; max-height:120px;' src ='"+record.images[0].alternativeFormats.thumbnailUrl+"'/>";
                }

                displayHtml += '<div id="occactions"">';
                displayHtml += '<a class="iframe fancy_iframe moreinfolink" href="'+(Config.OCC_INFO_URL_HTML.replace(/_uuid_/g,occids[curr]))+'">More information</a>';

                displayHtml += '<span class="pagebutton" style="padding-left:30px;">';
                if(pbutton.length>0) displayHtml +=  pbutton
                if(pbutton.length>0 && nbutton.length>0) displayHtml += "&nbsp;|&nbsp;"
                if(nbutton.length>0) displayHtml +=  nbutton
                displayHtml += '</span>';

                displayHtml += '</div>';
                displayHtml += '</div>';

                infowindow.setContent(displayHtml);
                infowindow.open(map,infomarker);
                $('#maploading').fadeOut('slow');
            });

            return false; 
        },

        /**
         * Load occurrences divided by the facet values 
         */
        loadOccurrencesByType: function(cbf) {

            $('#maploading').show();

            var _idx = -1;
            var legHtml = "";

            // set the default, if none available to institution_name
            if (arguments.length == 0) {
                cbf = 'institution_name';
            }

            if (cbf=="") {
                var key = 0;
                var label = "All occurrences";
                var colour = parseInt(getColourForIndex(0), 16);
                initialiseOverlays(1);
                insertWMSOverlay("All occurrences", "&colourby="+ colour +"&symsize="+$('#sizeslider').slider('value')); //fHashes[key]);
                legHtml += "<div>";
                legHtml += "<input type='checkbox' class='layer' id='lyr"+key+"' checked='checked' /> ";
                legHtml += "<img src='"+Config.BIOCACHE_SERVICE_URL+"/occurrences/legend?colourby="+ colour +"&width=10&height=10&qc="+Config.QUERY_CONTEXT+"' /> ";
                legHtml += "<label for='lyr"+key+"'>" + label + "</label>";
                legHtml += "</div>";

            } else {
                // get and check if the default facet is available,
                // if not, set it to the first one.
                _idx = $.inArray(cbf, facetNames);
                _idx = (_idx>-1)?_idx:1;
                $('#colourFacets').val(cbf);


                var fLabels = facetLabels[_idx].split("|");
                var fValues = facetValues[_idx].split("|");
                //var fHashes = facetValueHashes[_idx].split("|");
                var fCounts = facetValueCounts[_idx].split("|");

            
                // clear the current overlays
                //map.overlayMapTypes.clear();
                initialiseOverlays(fValues.length);

                // check if there is 'Other' value,
                // if so, then increment the values by 1
                var otherInc = false;
                if (facetLabels[_idx].indexOf('Other') > -1) {
                    otherInc = true;
                }
                
                // list to store species GUIDs in (to substitute names for)
                var lsidList = [];

                $.each(fValues, function(key, value) {
                    //var ptcolour = '#'+(Math.abs(fHashes[key])).toString(16);
                    //var ptcolour = (function(h){return '#000000'.substr(0,7-h.length)+h})((~~(Math.abs(fHashes[key]))).toString(16).substr(0,6));
                    //Maps.loadOccurrences("fq="+cbf+":"+value+"&colourby="+fHashes[key]);

                    var label = fLabels[key];
                    
                    if (cbf == "species_guid") {
                        if (label != "Other") {
                            // add gid to list
                            lsidList[key+1] = label;
                        } else {
                            lsidList[0] = label;
                        }
                    } 
                    
                    if (cbf == "geospatial_kosher") {
                        if (label == "false") {
                            label = "Questionable";
                        } else if (label == "true") {
                            label = "OK";
                        }
                    }
                    // year and month facets use a different colour scheme
                    var hexCode = otherColour;
                    if (label == "Other") {
                        hexCode = otherColour;
                    } else if (cbf.indexOf("year") != -1) {
                        hexCode = getDateColours(key);
                    } else if (cbf.indexOf("month") != -1) {
                        hexCode = getMonthColours(key);
                    } else {
                        hexCode = getColourForIndex(key);
                    }
                    var colour = parseInt(hexCode, 16);
                    if (label!='') {
                        var cbfq=cbf+":"+value;
                        if (value == "" && label=='Other') {
                            cbfq = "-("+cbf+":[* TO *])";
                        }

                        insertWMSOverlay(label, "fq="+cbfq+"&colourby="+colour+"&symsize="+$('#sizeslider').slider('value')); //fHashes[key]);

                        var layerIdx = key;
                        if (otherInc) {
                            layerIdx = ((label=='Other')?0:(key+1)); 
                        } 

                        legHtml += "<div class='layerWrapper'>";
                        legHtml += "<input type='checkbox' class='layer' id='lyr"+layerIdx+"' checked='checked' /> ";
                        legHtml += "<img src='"+Config.BIOCACHE_SERVICE_URL+"/occurrences/legend?colourby="+colour+"&width=10&height=10&qc="+Config.QUERY_CONTEXT+"' /> ";
                        legHtml += "<label for='lyr"+layerIdx+"'>" + label + "</label>";
                        legHtml += "</div>";
                    }

                });
                
                // Do JSON lookup for GUID -> taxon name
                if (cbf == "species_guid" && lsidList) {
                    var jsonUrl = BC_CONF.bieWebappUrl + "/species/namesFromGuids.json?guid=" + lsidList.join("&guid=") + "&callback=?";
                    $.getJSON(jsonUrl, function(data) {
                        // set the name in place of LSID
                        $.each(data, function(i, el) {
                            var j = i; // + ((lsidList.length >= 30) ? 1 : 0);
                            if (data[i]) {
                                $("label[for='lyr"+j+"']").html("<i>"+data[i]+"</i>");
                            }
                        });
                    });
                }
            }

            // display the legend content
            $('#legendContent').ready(function() {
                $('#legendContent').html(legHtml);
            });


            // now iterate thru' the array and load the layers
            $.each(overlayLayers, function(_idx, overlayWMS) {
                map.overlayMapTypes.setAt(_idx+1, overlayWMS);
            });

        },

        loadEnvironmentalLayer: function(selLayer) {
            map.overlayMapTypes.setAt(0, null);
            if (selLayer > -1) {
                var overlayWMS = new WMSTileLayer(envLayers[selLayer][1], "http://spatial.ala.org.au/geoserver/gwc/service/wms/reflect?", ["format=image/png","layers="+envLayers[selLayer][2]], wmsTileLoaded);
                map.overlayMapTypes.setAt(0, overlayWMS);
                // add legend
                var imgHtml = "Environmental Layer Legend<br/><img src='http://spatial.ala.org.au/geoserver/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=9&LAYER=" +
                    envLayers[selLayer][0] + "' alt='legend for layer: " + envLayers[selLayer][1] + "'/>";
                $("#envLegend").html(imgHtml);
            } else {
                $("#envLegend").html("");
            }
        }

    } // return: public variables and methods
})();

// Jquery Document.onLoad equivalent
//$(document).ready(function() {
function initialiseMap() {

    // setup the size slider first
    $('#sizeslider').slider({
        range: "min",
        value: 4,
        min: 2,
        max: 10,
        slide: function (event, ui) {
            $('#sizeslider-val').html(ui.value);
        },
        stop: function (event, ui) {
            Maps.loadOccurrencesByType($('#colourFacets').val());
        }
    });

    //Maps.loadMap();
    Maps.initialise();
    Maps.loadOccurrencesByType($('#colourFacets').val());

    // live event for toggling layer views
    $('input.layer').live("click", function(){
        Maps.toggleOccurrenceLayer(this);
    });

    // live event for loading up fancybox styles
    $('a.iframe').live("mouseover click", function(){
        //initialise fancy box
        $("a.fancy_iframe").fancybox({
            'showCloseButton': true,
            'titleShow' : false,
            'autoDimensions' : false,
            'hideOnContentClick' : false,
            'hideOnOverlayClick': true,
            'width' : '85%',
            'height' : '85%',
            'autoScale' : false,
            'type' : 'iframe'
        });

        return false; 
    });



    // event for when a colourby facet is selected
    $('#colourFacets').change(function(){
        Maps.loadOccurrencesByType($('#colourFacets').val());
    });

    $('#envLyrList').change(function(){
        Maps.loadEnvironmentalLayer(parseInt($(this).val()));
    });

    // event for toggling the legend
    $("#legend div.title, #legend div:first").click(function() {
        $('#layerlist').toggle();
    });

    // event for toggle all layers
    $('#toggleAll').click(function(){
        $('input.layer').each(function(index) {
            $(this).attr('checked', ($(this).is(':checked'))?false:true);
            Maps.toggleOccurrenceLayer(this);
        });

    });

}
//}); // end JQuery document ready

/**
 * Format the disaply of a scientific name.
 * E.g. genus and below should be italicised
 */
function formatSciName(name, rankId) {
    var output = "";
    if (rankId && rankId >= 6000) {
        output = "<i>" + name + "</i>";
    } else {
        output = name;
    }

    return output;
}

/**
 * Get a colour value (hex) by its index value in an array (31 elements)
 */
function getColourForIndex(index) {
    var colours = ["3366CC","DC3912","FF9900","109618","990099","0099C6","DD4477","66AA00","B82E2E",
        "316395","994499","22AA99","AAAA11","6633CC","E67200","8B0707","651067","329262","5574A6",
        "3B3EAC","B77322","16D620","B91383","F43595","9C5935","A9C413","2A778D","668D1C","BEA413",
        "0C5922","743411"];
    colours = colours.concat(colours); // re-use the 31 colours again in array

    var hexCode = "";

    if (isInteger(index) && index < colours.length) {
        hexCode = colours[index];
    } else {
        hexCode = colours[0];
    }

    return hexCode;
}

var decadeColours = ['0530B3','053391','083574','043956','053A46','063C33','113A27','253423','312F30','3E293B','4F243D','601F39','731A33','851529','951124','A30D1D','B40817','BD060F'];
//var monthColours = ['0530B3','083574','043956','063C33','113A27','312F30','3E293B','601F39','731A33','951124','A30D1D','BD060F'];
var monthColours = ['9D0F19','A5093B','A40663','810D8D','59179C','2F2788','202F66','263043','392D27','4C281C','622215','811814'];
var otherColour = "b0b0b0";

function getDateColours(index) {

    var hexCode = "";

    if (isInteger(index) && index < decadeColours.length) {
        hexCode = decadeColours[index];
    } else {
        hexCode = decadeColours[decadeColours.length-1];
    }

    return hexCode;
}

function getMonthColours(index) {

    var hexCode = "";

    if (isInteger(index) && index < monthColours.length) {
        hexCode = monthColours[index];
    } else {
        hexCode = monthColours[monthColours.length-1];
    }

    return hexCode;
}

/**
 * Is input var an integer. Returns boolean.
 */
function isInteger(value) {
    if ((parseFloat(value) == parseInt(value)) && !isNaN(value)) {
        return true;
    } else {
        return false;
    }
}

/**
 * utility to get URL params
 * E.g. $.urlParam('foo')
 */
$.urlParam = function(name){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (!results) {
        return 0; 
    }
    return results[1] || 0;
}

/**
 * Triggered on map bounds change event.
 * Zooms map to either spatial search or from WMS data bounds 
 */
function fitMapToBounds() {
    // all other searches (non-spatial)
    // do webservice call to get max extent of WMS data
    var jsonUrl = BC_CONF.biocacheServiceUrl + "/webportal/bounds.json" + BC_CONF.searchString + "&callback=?";

    $.getJSON(jsonUrl, function(data) {
        if (data.length == 4) {
            var sw = new google.maps.LatLng(data[1],data[0]);
            var ne = new google.maps.LatLng(data[3],data[2]);
            //var dataBounds = new google.maps.LatLngBounds(sw, ne);
            var dataBounds = new google.maps.LatLngBounds();
            dataBounds.extend(ne);
            dataBounds.extend(sw);
            var centre = dataBounds.getCenter();
            //map.fitBounds(bounds);
            var mapBounds = map.getBounds()

            if (mapBounds && mapBounds.contains(sw) && mapBounds.contains(ne) && dataBounds) {
                // data bounds is smaller than all of Aust
                //console.log("smaller bounds",dataBounds,mapBounds)
                map.fitBounds(dataBounds);

                if (map.getZoom() > 15) {
                    map.setZoom(15);
                }
            } else if (BC_CONF.zoomOutsideAustralia) {
                //map.fitBounds(dataBounds);
                //console.log("zoom", map.getZoom())
                map.fitBounds(dataBounds);

                if (map.getZoom() == 0) {
                    map.setCenter(centre);
                    map.setZoom(2);
                }
            }
        }
    });
}