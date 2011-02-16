/*
    Document   : map.js
    Created on : Feb 16, 2011, 3:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
*/

var Maps = (function() {

    //var filterList = [];
    var filterList = {};

    return {

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

        loadWMS: function() {
            // add wms layer here
        },

        loadGoogle: function() {
            // load google base map here.

            loadWMS();
        }

    } // return: public methods 
})();

// Jquery Document.onLoad equivalent
$(document).ready(function() {
    Maps.loadMap();
    Maps.loadGoogle(); 
;
}); // end JQuery document ready