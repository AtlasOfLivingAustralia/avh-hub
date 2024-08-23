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
    </body>
</html>
