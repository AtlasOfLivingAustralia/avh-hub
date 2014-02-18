modules = {
    application {
        resource url:'js/application.js'
    }

    search {
        //dependsOn 'jquery'
        resource url:'css/bootstrapAdditions.css'
        resource url:'css/search.css'
        resource url:'css/jquery.qtip.min.css'
        resource url:'js/purl.js'
        resource url:'js/jquery.cookie.js'
        resource url:'js/jquery.qtip.min.js'
        resource url:'js/jquery.i18n.properties-1.0.9.js'
        resource url:'js/search.js'
    }
}