/*
    Document   : map.js
    Created on : Feb 22, 2011, 6:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
 */

var Config = (function() {

    return {

        OCC_WMS_BASE_URL: 'http://localhost:8080/biocache-service/occurrences/wms?',
        OCC_SEARCH_URL: 'http://localhost:8080/biocache-service/occurrences/info',
        OCC_INFO_URL_HTML: '/hubs-webapp/occurrence/_uuid_',
        OCC_INFO_URL_JSON: '/hubs-webapp/occurrence/_uuid_.json'
        //OCC_INFO_URL: 'http://localhost:8080/biocache-service/occurrence/'

    } // return: public variables and methods

})();