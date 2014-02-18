class BootStrap {
    def grailsApplication
    def init = { servletContext ->
        log.info "exploreYourArea.location = ${grailsApplication.config.exploreYourArea.location}"
    }
    def destroy = {
    }
}
