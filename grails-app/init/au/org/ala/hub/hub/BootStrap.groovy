package au.org.ala.hub.hub

class BootStrap {
    def grailsApplication

    def init = { servletContext ->
        log.info "config.security.cas = ${grailsApplication.config.getProperty('security.cas')}"
        log.info "config.ala.skin = ${grailsApplication.config.getProperty('ala.skin')}"
        log.info "config.biocache.ajax.useProxy = ${grailsApplication.config.getProperty('biocache.ajax.useProxy')}"
        log.warn "config.serverName = ${grailsApplication.config.getProperty('serverName')}"
        log.warn "config.grails.serverURL = ${grailsApplication.config.getProperty('grails.serverURL')}"
        //  log.warn "config.headerAndFooter.baseURL = ${grailsApplication.config.getProperty('headerAndFooter.baseURL')}"
    }
    def destroy = {
    }
}
