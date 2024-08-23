<!DOCTYPE html>
<html>
<head>
    <title><g:if env="development">Grails Runtime Exception</g:if><g:else>Error</g:else></title>
    <meta name="layout" content="${grailsApplication.config.getProperty('skin.layout')}"/>
    <g:if env="development"><asset:stylesheet src="errors.css" type="text/css"/></g:if>
    <style>
        ul.errors H1 {
            font-size: 18px;
        }
    </style>
</head>
<body>
<div class="${grailsApplication.config.getProperty('skin.fluidLayout')?'container-fluid':'container'}" id="main-content">
    <h1>
        Application error
    </h1>
    <hr />
    <g:if env="development">
        <ul class="errors">
            <g:if test="${Throwable.isInstance(exception)}">
                <li><g:renderException exception="${exception}" /></li>
            </g:if>
            <g:elseif test="${flash.message}">
                <li>${alatag.stripApiKey(message: flash.message)}</li>
            </g:elseif>
            <g:else>
                <li>An error has occurred</li>
                <li>Exception: ${exception}</li>
                <li>Message: ${message}</li>
                <li>Path: ${path}</li>
            </g:else>
        </ul>
    </g:if>
    <g:else>
        <g:if test="${flash.message}">
            <ul class="errors">
                <li>${alatag.stripApiKey(message: flash.message)}</li>
            </ul>
        </g:if>
    </g:else>
    <ul class="errors">
        <li>If this problem persists, please send an email to <a
                href="mailto:${grailsApplication.config.getProperty('supportEmail', 'support@ala.org.au')}?subject=Reporting error on page: ${request.serverName}${request.forwardURI}">${grailsApplication.config.getProperty('supportEmail', 'support@ala.org.au')}</a>
            and include the URL to this page.</li>
    </ul>
</div>
</body>
</html>
