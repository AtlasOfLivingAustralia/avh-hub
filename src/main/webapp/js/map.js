var Maps = (function() {

    var filterList = {};

    return {
        setLinks: function(){
            var url = location.href.replace("map", "search");
            document.getElementById("listLink").setAttribute("href", url);
        },

        addFilter: function(key, value) {
            //filterList.push({key: value});
            filterList[key] = value; 
        },

        getFilters: function() {
            return filterList; 
        },

        loadMap: function() {
            var baseurl = "http://localhost:8080/occurrences/wms";
            var wmsimg = baseurl + window.location.search;
            document.getElementById('wmsimg').src= wmsimg;
        },
        loadGoogle: function() {
            
            //var myLatlng = new google.maps.LatLng(-23.75, 133);
            var myLatlng = new google.maps.LatLng(42.760369, -71.031445);
            var myOptions = {
                zoom: 18,
            //zoom: 4,
                center: myLatlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            var map = new google.maps.Map(document.getElementById("map-canvas"), myOptions);

            var customParams = [
                "FORMAT=image/png8",
                "LAYERS=massgis:GISDATA.ASSESSPAR_POLY_PUBLIC_NOROADS,massgis:GISDATA.ASSESSPARNC_POLY_PUB_NOROADS",
                "STYLES=GISDATA.ASSESSPAR_POLY_PUBLIC::Yellow_Outlines,GISDATA.ASSESSPARNC_POLY_PUB_NOROADS::Plum_Outlines_Max10k"
            ];

            //Add query string params to custom params
            var pairs = location.search.substring(1).split('&');
            for (var i = 0; i < pairs.length; i++) {
                customParams.push(pairs[i]);
            }
            loadWMS(map, "http://giswebservices.massgis.state.ma.us/geoserver/wms?", customParams);
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