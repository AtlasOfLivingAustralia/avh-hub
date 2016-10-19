<g:set var="serverName" value="${grailsApplication.config.serverName}"/>
<g:set var="orgNameLong" value="${grailsApplication.config.skin.orgNameLong}"/>
<g:set var="orgNameShort" value="${grailsApplication.config.skin.orgNameShort}"/>
<g:set var="avhHome" value="${grailsApplication.config.organisation.baseUrl}"/>
<!DOCTYPE html>
<html>
<head>
    <link rel="shortcut icon" href="${request.contextPath}/images/avh/favicon.ico" />
    <title>Error | ${orgNameLong}</title>
</head>
<body>

<div class="errors">
    <h1>
        An error occurred:
    </h1>
    <ul class="errors">
        <g:renderException exception="${exception}" />
    </ul>
<g:if test="${flash.message}">
    <ul class="errors">
        <li>${flash.message}</li>
    </ul>
</g:if>
</div>
</body>
</html>
