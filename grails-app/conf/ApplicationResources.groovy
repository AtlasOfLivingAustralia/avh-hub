modules = {
    application {
        resource url:'js/application.js'
    }

    ala {
        dependsOn 'bootstrap'
        resource url:'css/base.css'
        resource url:'css/bootstrapAdditions.css'
    }

    avh {
        dependsOn 'bootstrap'
        resource url:'css/bootstrapAdditions.css'
        resource url:'css/avh/style.css'
        resource url:'css/base.css'
    }

    search {
        dependsOn 'jquery'
        resource url:'css/search.css'
        resource url:'css/jquery.qtip.min.css'
        resource url:'js/purl.js'
        resource url:'js/jquery.cookie.js'
        resource url:'js/jquery.inview.min.js'
        resource url:'js/jquery.qtip.min.js'
        resource url:'js/jquery.jsonp-2.4.0.min.js'
        resource url:'js/jquery.i18n.properties-1.0.9.js'
        resource url:'js/charts2.js', disposition: 'head'
        resource url:'js/search.js'
    }

    slider {
        resource url:'css/slider.css'
        resource url:'js/bootstrap-slider.js'
    }

    leaflet {
        resource url:'js/leaflet-0.7.2/leaflet.css'
        resource url:'js/leaflet-0.7.2/leaflet.js'
        resource url:'js/leaflet-plugins/layer/tile/Google.js'
    }

    show {
        dependsOn 'jquery'
        resource url:'css/record.css'
        resource url:'js/audiojs/audio.min.js'
        resource url:'js/moment.min.js'
        resource url:'js/show.js'
    }

    exploreYourArea {
        dependsOn 'jquery'
        resource url:'css/jquery.qtip.min.css'
        resource url:'css/exploreYourArea.css'
        resource url:'js/jquery.qtip.min.js'
        resource url:'js/purl.js'
        resource url:'js/yourAreaMap.js'
    }
}