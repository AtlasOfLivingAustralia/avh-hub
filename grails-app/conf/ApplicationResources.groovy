modules = {
//    application {
//        resource url:'js/application.js'
//    }

    // Define your skin module here - it must 'dependsOn' either bootstrap (ALA version) or bootstrap2 (unmodified) and core

    avh {
        dependsOn 'bootstrap', 'hubCore' // from ala-web-theme plugin
        resource url:[dir:'css', file:'avh/style.css']
    }

}