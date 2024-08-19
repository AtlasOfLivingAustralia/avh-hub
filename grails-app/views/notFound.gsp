<!doctype html>
<html>
    <head>
        <title>Page Not Found</title>
        <meta name="layout" content="${grailsApplication.config.getProperty('skin.layout')}">
        <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
    </head>
    <body>
        <div class="${grailsApplication.config.getProperty('skin.fluidLayout')?'container-fluid':'container'}" id="main-content">
            <h1>Page Not Found</h1>
            <hr />
            <ul class="errors">
                <li><b>Error:</b> Page Not Found (404)</li>
                <li><b>Path:</b> ${request.forwardURI}</li>
            </ul>
        </div>
    <!-- Test test.heading g:message - <g:message code="test.heading" default="not set"/><br>
    Test test.heading alatag:message - <alatag:message code="test.heading" default="not set"/><br>
    Test test.app.only g:message - <g:message code="test.app.only" default="not set"/><br>
    Test test.app.only alatag:message - <alatag:message code="test.app.only" default="not set"/><br>
    Test test.plugin.only g:message - <g:message code="test.plugin.only" default="not set"/><br>
    Test test.plugin.only alatag:message - <alatag:message code="test.plugin.only" default="not set"/><br>
    Test class.eventDate (biocache-service) g:message - <g:message code="class.eventDate" default="not set"/><br>
    Test class.eventDate (biocache-service) alatag:message - <alatag:message code="class.eventDate" default="not set"/><br> -->
    </body>
</html>
