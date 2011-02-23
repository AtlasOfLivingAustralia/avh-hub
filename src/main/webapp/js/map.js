/*
    Document   : map.js
    Created on : Feb 16, 2011, 3:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
 */

var OCC_INFO_URL = 'http://localhost:8080/biocache-service/occurrence/'; 

var map;
var Maps = (function() {

    var clickLocation;
    var occids;
    var infowindow;
    var infomarker; 

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

        $.get(wmsinfo, loadNewGeoJsonData);

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

    return {
        setLinks: function(){
            var url = location.href.replace("map", "search");
            document.getElementById("listLink").setAttribute("href", url);
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
                center: myLatlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            map = new google.maps.Map(document.getElementById("map-canvas"), myOptions);
            infomarker = new google.maps.Marker({
                position: myLatlng,
                visible: false,
                title: "Click location", 
                map: map
            });
            infowindow = new google.maps.InfoWindow({
                size: new google.maps.Size(50,50)
            });


            google.maps.event.addListener(map, 'click', function(event) {
                loadOccurrencePopup(event.latLng);
            });

        },

        loadOccurrences: function(params) {
            var customParams = [
            "FORMAT=image/png8",
            "LAYERS=ALA:ibra_reg_shape"
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
            loadWMS(map, Config.OCC_WMS_BASE_URL, customParams);
        },

        loadOccurrenceInfo: function(curr) {

            var pbutton = '';
            var nbutton = '';
            if (curr > 0) {
                pbutton = '<span class="pagebutton"><a href="#" onClick="Maps.loadOccurrenceInfo('+(curr-1)+')">&lt; Previous</a></span>';
            }
            if (curr < occids.length-1) {
                nbutton = '<span class="pagebutton" style="float: right"><a href="#" onClick="Maps.loadOccurrenceInfo('+(curr+1)+')">Next &gt;</a></span>';
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

                displayHtml += "<br /><br />";
                displayHtml += '<a href="'+(Config.OCC_INFO_URL_HTML.replace(/_uuid_/g,occids[curr]))+'">More information</a>';

                displayHtml += "<br /><br />";
                displayHtml += pbutton + "           " + nbutton;
                
                displayHtml += '</div>';
                
                

                infowindow.setContent(displayHtml);
            });

            return false; 
        }



    } // return: public variables and methods
})();

// Jquery Document.onLoad equivalent
$(document).ready(function() {
    //Maps.loadMap();
    Maps.setLinks();
    Maps.loadGoogle();
    Maps.loadOccurrences();

    $('#colourFacets').change(function(){
        var cbf = $('#colourFacets').val();

        console.log("Colouring by '" + cbf + "' ");
        
        //if (cbf=='') return;

        //TODO: Check if more than one custom maptype available, e.g: other wms layers
        // for now, let's just assume the species layer
        if (map.overlayMapTypes.length == 1) {
            map.overlayMapTypes.removeAt(0); 
        }

        Maps.loadOccurrences("colourby="+cbf);
    //            var baseurl = "http://localhost:8080/biocache-service/occurrences/static";
    //            var wmsimg = baseurl + window.location.search + "&colourby="+cbf;
    //            document.getElementById('wmsimg').src= wmsimg;

    });

;
}); // end JQuery document ready