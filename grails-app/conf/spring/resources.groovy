import au.org.ala.biocache.hubs.ExtendedPluginAwareResourceBundleMessageSource

// Place your Spring DSL code here
beans = {
    messageSource(ExtendedPluginAwareResourceBundleMessageSource) {
        basenames = ["classpath:grails-app/i18n/messages","http://biocache.ala.org.au/ws/facets/i18n"]
        cacheSeconds = 300
        useCodeAsDefaultMessage = true
    }
}
