/*
    Document   : map.js
    Created on : Feb 16, 2011, 3:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
*/

var map, infomarker;
var Maps = (function() {

    function placeMarker(location) {
    //        var infomarker = new google.maps.Marker({
    //            position: location,
    //            map: map
    //        });
    //map.setCenter(location);

    }

    /**
     * post a query to the biocache-service
     * to check if there are any points
     * at the click location
     *
     */
    function loadOccurrencePopup(location) {
        console.log("Checking occurrence info at " + location.toString());

        var baseurl = "http://localhost:8080/biocache-service/occurrences/info";
        var wmsinfo = baseurl + window.location.search;
        wmsinfo += "&fq={!spatial latitude=" + location.lat() + " longitude=" + location.lng() + " radius=1 unit=km calc=arc threadCount=2}";
        wmsinfo += "&zoom=" + map.getZoom();
        wmsinfo += "&lat=" + location.lat();
        wmsinfo += "&lng=" + location.lng();
        wmsinfo += "&fq=lat:" + location.lat();
        wmsinfo += "&fq=long:" + location.lng();
        wmsinfo += "&fq=d:1";

        console.log("calling info: " + wmsinfo);
        //console.log((map && map.getZoom()) ? map.getZoom() : 12);

        $.get(wmsinfo, loadNewGeoJsonData);


        var displayHtml = "Occurrence Information at " + location.toString();
        var infowindow = new google.maps.InfoWindow({
            content: displayHtml,
            size: new google.maps.Size(50,50)
        });
        infomarker.setPosition(location);
        infowindow.open(map,infomarker);

    }

    function loadNewGeoJsonData(data) {
        console.log("loadNewGeoJsonData: ");
        console.log(data); 
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

            google.maps.event.addListener(map, 'click', function(event) {
                loadOccurrencePopup(event.latLng);
            });


            var customParams = [
            "FORMAT=image/png8",
            "LAYERS=ALA:ibra_reg_shape"
            ];

            //Add query string params to custom params
            var pairs = location.search.substring(1).split('&');
            for (var i = 0; i < pairs.length; i++) {
                customParams.push(pairs[i]);
            }
            //loadWMS(map, "http://spatial.ala.org.au/geoserver/wms?", customParams);
            loadWMS(map, "http://localhost:8080/biocache-service/occurrences/wms?", customParams);
        }

    } // return: public methods 
})();

// Jquery Document.onLoad equivalent
$(document).ready(function() {
    //Maps.loadMap();
    Maps.setLinks();
    Maps.loadGoogle(); 
;
}); // end JQuery document ready