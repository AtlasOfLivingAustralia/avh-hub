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

    /**
     * post a query to the biocache-service
     * to check if there are any points
     * at the click location
     *
     */
    function loadOccurrencePopup(location) {
        clickLocation = location;

        infowindow.close();

        var baseurl = Config.OCC_SEARCH_URL;
        var wmsinfo = baseurl + window.location.search;
        wmsinfo += "&zoom=" + map.getZoom();
        wmsinfo += "&lat=" + location.lat();
        wmsinfo += "&lon=" + location.lng();
        wmsinfo += "&radius=10";

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

            infomarker.setPosition(clickLocation);
            infowindow.open(map,infomarker);

            Maps.loadOccurrenceInfo(0);

        } else {
            //occids = new Array(); 
            occids == null;

            displayHtml = data.count + ' occurrences founds';
        }

    }

    function initialiseOverlays(lyrCount) {
        map.overlayMapTypes.clear();
        overlayLayers = [];

        if (lyrCount > 0) {
            for (i=0;i<lyrCount;i++){
                map.overlayMapTypes.push(null);
            }
        }
    }

    /**
    * Load occurrences wms with the selected params
    */
    function insertWMSOverlay(params) {
        var customParams = [
        "FORMAT=image/png8",
        "zoom:"+map.getZoom()
        ];

        if (arguments.length > 0) {
            for (var i = 0; i < arguments.length; i++) {
                customParams.push(arguments[i]);
            }
        }

        //Add query string params to custom params
        var pairs = location.search.substring(1).split('&');
        for (var i = 0; i < pairs.length; i++) {
            customParams.push(pairs[i]);
        }
        //loadWMS(map, "http://spatial.ala.org.au/geoserver/wms?", customParams);
        var overlayWMS = getWMSObject(map, Config.OCC_WMS_BASE_URL, customParams);
        //map.overlayMapTypes.insertAt(map.overlayMapTypes.length, overlayWMS);
        overlayLayers.push(overlayWMS);
    }

    return {
        setLinks: function(){
            var url = location.href.replace("map", "search");
        //document.getElementById("listLink").setAttribute("href", url);
        },

        /**
         * loads a static map with all the points within Australia
         * and additional facets
         */
        loadMap: function() {
            var baseurl = "http://localhost:8080/biocache-service/occurrences/static";
            var wmsimg = baseurl + window.location.search;
            document.getElementById('wmsimg').src= wmsimg;
        },
        
        /**
         * loads google maps and the WMS layers for occurrences
         */
        loadGoogle: function() {
            
            var myLatlng = new google.maps.LatLng(-27, 133);
            var myOptions = {
                zoom: 4,
                scrollwheel: false,
                center: myLatlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            map = new google.maps.Map(document.getElementById("mapcanvas"), myOptions);
            infomarker = new google.maps.Marker({
                position: myLatlng,
                visible: false,
                title: "Click location", 
                map: map
            });
            infowindow = new google.maps.InfoWindow({
                size: new google.maps.Size(50,50)
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

        },

        /**
         * Load occurrences wms with the selected params 
         */
        toggleOccurrenceLayer: function(input) {
            var _idx = parseInt($(input).attr('id').substr(3));
            if ($(input).is(':checked')){
                map.overlayMapTypes.setAt(_idx,overlayLayers[_idx]);
            }else{
                if (map.overlayMapTypes.getLength()>0){
                    map.overlayMapTypes.setAt(_idx,null);
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
                pbutton = '<span class="pagebutton"><a href="#map" onClick="Maps.loadOccurrenceInfo('+(curr-1)+')">&lt; Previous</a></span>';
            }
            if (curr < occids.length-1) {
                nbutton = '<span class="pagebutton" style="float: right"><a href="#map" onClick="Maps.loadOccurrenceInfo('+(curr+1)+')">Next &gt;</a></span>';
            }

            infowindow.setContent("Loading occurrence info. Please wait...");

            $.get(Config.OCC_INFO_URL_JSON.replace(/_uuid_/g,occids[curr]), function(data){
                var displayHtml = occids.length + ((occids.length>1)?' occurrences founds.':' occurrence found.');

                displayHtml = '<div id="occinfo">';
                displayHtml += '<span class="occinfohead"><strong>Viewing ' + (curr+1) + ' of ' + occids.length + ' occurrence'+((occids.length>1)?'s':'')+'.</strong></span>';
                displayHtml += "<br /><br />";

                displayHtml += "Scientific Name: " + data.record.raw.classification.scientificName + '<br />';
                displayHtml += "Family: " + data.record.raw.classification.family + '<br />';
                displayHtml += "Institution: " + data.record.processed.attribution.institutionName + '<br />';

                displayHtml += "<br />";
                displayHtml += '<a href="'+(Config.OCC_INFO_URL_HTML.replace(/_uuid_/g,occids[curr]))+'">More information</a>';

                displayHtml += "<br /><br />";
                displayHtml += pbutton + "           " + nbutton;
                
                displayHtml += '</div>';
                
                

                infowindow.setContent(displayHtml);
            });

            return false; 
        },

        /**
         * Load occurrences divided by the facet values 
         */
        loadOccurrencesByType: function() {
            var _idx = -1;
            var legHtml = "";
            var cbf = $('#colourFacets').val();

            // set the default, if none available to institution_name 
            if (cbf=='') {
                //Maps.loadOccurrences();
                cbf = 'institution_name';
            }
            
            // get and check if the default facet is available,
            // if not, set it to the first one. 
            _idx = $.inArray(cbf, facetNames);
            _idx = (_idx>-1)?_idx:0;
            $('#colourFacets').val(cbf);


            var fValues = facetValues[_idx].split("|");
            var fHashes = facetValueHashes[_idx].split("|");
            var fCounts = facetValueCounts[_idx].split("|");

            
            // clear the current overlays
            //map.overlayMapTypes.clear();
            initialiseOverlays(fValues.length);

            $.each(fValues, function(key, value) {
                //var ptcolour = '#'+(Math.abs(fHashes[key])).toString(16);
                //var ptcolour = (function(h){return '#000000'.substr(0,7-h.length)+h})((~~(Math.abs(fHashes[key]))).toString(16).substr(0,6));
                //Maps.loadOccurrences("fq="+cbf+":"+value+"&colourby="+fHashes[key]);
                insertWMSOverlay("fq="+cbf+":"+value+"&colourby="+fHashes[key]);

                legHtml += "<div>";
                //legHtml += "<span style='height: 10px; width: 10px; background: "+ptcolour+"'>&nbsp;&nbsp;&nbsp;&nbsp;</span> ";
                legHtml += "<input type='checkbox' class='layer' id='lyr"+key+"' checked='checked' /> ";
                legHtml += "<img src='http://localhost:8080/biocache-service/occurrences/legend?colourby="+fHashes[key]+"&width=10&height=10' /> ";
                legHtml += ((value=='')?'Other':value);
                legHtml += "</div>";
            });

            // display the legend content
            $('#legendContent').ready(function() {
                $('#legendContent').html(legHtml);
            }); 

            
            // now iterate thru' the array and load the layers
            //Maps.loadOccurrences();
            $.each(overlayLayers, function(_idx, overlayWMS) {
                map.overlayMapTypes.setAt(_idx, overlayWMS);
            }); 

        }

    } // return: public variables and methods
})();

// Jquery Document.onLoad equivalent
$(document).ready(function() {

    // hide the legend srtuff initially 
    //$('#legend div:not(.title)').toggle();
    $('#legend').show();
    $('#legend div:first').hide();
    $('#legendContent').hide();


    //Maps.loadMap();
    Maps.setLinks();
    Maps.loadGoogle();
    Maps.loadOccurrencesByType();

    // live event for toggling layer views
    $('input.layer').live("click", function(){
        Maps.toggleOccurrenceLayer(this);
    });

    // event for when a colourby facet is selected
    $('#colourFacets').change(function(){
        Maps.loadOccurrencesByType(); 
    });

    // event for toggling the legend
    $("#legend div.title, #legend div:first").click(function() {
        //$('#legend div:not(.title)').toggle();
        $('#legendContent').toggle();
        $('#legend div:first').toggle();
    });

;
}); // end JQuery document ready

