class BootStrap {
    def grailsApplication, messageSource
    def init = { servletContext ->
        // sanity check for external properties
        log.debug "exploreYourArea.location = ${grailsApplication.config.exploreYourArea.location}"
        // sanity check for i18n
        log.debug "biocache-service i18n check - facet.pestStatus = ${messageSource.getMessage('facet.pestStatus', null, Locale.ENGLISH)}"
        // local i18n value override check
        log.debug "biocache-service i18n check - facet.state = ${messageSource.getMessage('facet.state', null, Locale.ENGLISH)}" // State or Territory vs State/Territory
        // local only check
        log.debug "biocache-service i18n check - confirm.message = ${messageSource.getMessage('default.button.delete.confirm.message', null, Locale.ENGLISH)}"
    }
    def destroy = {
    }
}
