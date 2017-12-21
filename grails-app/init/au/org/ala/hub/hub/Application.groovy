package au.org.ala.hub.hub

import grails.boot.GrailsApp
import grails.boot.config.GrailsAutoConfiguration

class Application extends GrailsAutoConfiguration {

    Closure doWithSpring

    static void main(String[] args) {
        GrailsApp.run(Application, args)
    }
}