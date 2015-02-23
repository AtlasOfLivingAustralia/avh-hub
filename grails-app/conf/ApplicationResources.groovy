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
        resource url:[dir:'js', file:'bootstrap.js'], disposition: 'head', exclude: '*'
        resource url:[dir:'css', file:'bootstrap.css'] //, attrs:[media:'screen, projection, print']
        resource url:[dir:'css', file:'bootstrap-responsive.css'], exclude: '*', attrs:[media:'screen'] // id:'responsiveCss'
        //resource url:[dir:'css', file:'avh-extra.css']//, attrs:[media:'screen']
    }

    core {
        dependsOn 'jquery'
        resource url:[plugin: 'ala-bootstrap2', dir: 'js',file:'jquery-migrate-1.2.1.min.js']
        resource url: [dir:'js', file:'html5.js'], wrapper: { s -> "<!--[if lt IE 9]>$s<![endif]-->" }, disposition: 'head'
        resource url:[dir:'css', file:'jquery.autocomplete.css']
        resource url:[dir:'js', file:'jquery.autocomplete.js']
    }

}