/*
    Document   : map.js
    Created on : Feb 22, 2011, 6:25:27 PM
    Author     : "Ajay Ranipeta <Ajay.Ranipeta@csiro.au>"
 */

var Config = (function() {

    //BIOCACHE_SERVICE_URL = "http://ala-bie1.vm.csiro.au:8080/biocache-service";
    BIOCACHE_SERVICE_URL = "";

    return {

        //BIOCACHE_SERVICE_URL: 'http://ala-bie1.vm.csiro.au:8080/biocache-service',
        OCC_WMS_BASE_URL: BIOCACHE_SERVICE_URL + '/occurrences/wms?',
        OCC_SEARCH_URL: BIOCACHE_SERVICE_URL + '/occurrences/info',
        OCC_INFO_URL_HTML: contextPath+'/occurrences/fragment/_uuid_',
        OCC_INFO_URL_JSON: contextPath+'/occurrences/_uuid_.json',
        OCC_ANNOTATE_URL_HTML: contextPath+'/occurrences/annotate/_uuid_',

        /**
         * setup the Config with the base url 
         */
        setupUrls: function(baseurl) {
            this.BIOCACHE_SERVICE_URL = baseurl;
            this.OCC_WMS_BASE_URL = baseurl + '/occurrences/wms?';
            this.OCC_SEARCH_URL = baseurl + '/occurrences/info';
        }

    } // return: public variables and methods

})();
