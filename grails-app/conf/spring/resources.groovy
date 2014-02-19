// Place your Spring DSL code here
beans = {
    messageSource(org.springframework.context.support.ReloadableResourceBundleMessageSource) {
        basenames = ["classpath:grails-app/i18n/messages","http://biocache.ala.org.au/ws/facets/i18n"]
        cacheSeconds = 300
        useCodeAsDefaultMessage = true
    }
}
