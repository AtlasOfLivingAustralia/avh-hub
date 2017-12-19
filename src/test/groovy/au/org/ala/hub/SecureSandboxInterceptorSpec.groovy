package au.org.ala.hub

//import au.org.ala.hub.SecureSandboxInterceptor
import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
//@TestFor(SecureSandboxInterceptor)
class SecureSandboxInterceptorSpec extends Specification {

    def setup() {
    }

    def cleanup() {

    }

    void "Test secureSandbox interceptor matching proxy"() {
        when:"A request matches the interceptor"
            withRequest(controller:"proxy")

        then:"The interceptor does match"
            interceptor.doesMatch()
    }

    void "Test secureSandbox interceptor matching occurrence"() {
        when:"A request matches the interceptor"
        withRequest(controller:"occurrence")

        then:"The interceptor does match"
        interceptor.doesMatch()
    }
}
