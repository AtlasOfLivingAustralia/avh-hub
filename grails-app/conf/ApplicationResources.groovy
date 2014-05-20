modules = {
//    application {
//        resource url:'js/application.js'
//    }

    // Define your skin module here - it must 'dependsOn' either bootstrap (ALA version) or bootstrap2 (unmodified) and core

    avh {
        dependsOn 'bootstrapLocal', 'hubCore' // from ala-web-theme plugin
        resource url:[dir:'css', file:'avh/style.css']
    }

    bootstrapLocal {
        dependsOn 'core'
        defaultBundle 'main-core'
        resource url:[dir:'js', file:'bootstrap.js', plugin: 'ala-web-theme'], disposition: 'head', exclude: '*'
        resource url:[dir:'css', file:'bootstrap.css', plugin: 'ala-web-theme'] //, attrs:[media:'screen, projection, print']
        resource url:[dir:'css', file:'bootstrap-responsive.css', plugin: 'ala-web-theme'], exclude: '*', attrs:[media:'screen'] // id:'responsiveCss'
        //resource url:[dir:'css', file:'avh-extra.css']//, attrs:[media:'screen']
    }

}