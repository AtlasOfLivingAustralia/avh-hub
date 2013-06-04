<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="hostName" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}"/>
<c:set var="fullName"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader bundle="hubs" property="site.displayNameShort"/></c:set>
<c:set var="attribution"><ala:propertyLoader bundle="hubs" property="site.attribution"/></c:set>
<c:set var="jurisdiction"><ala:propertyLoader bundle="hubs" property="site.jurisdiction"/></c:set>
<c:set var="jurisdictionCode"><ala:propertyLoader bundle="hubs" property="site.jurisdiction.code"/></c:set>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="decorator" content="${skin}"/>
    <meta name="section" content="help"/>
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Terms of Use </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>Terms of Use</h1>

    <br/>
    <p>The use of ${fullName} is subject to the terms of use outlined below. ${fullName}
        forms part of the <a href="http://www.ala.org.au/">Atlas of Living Australia</a> (ALA); see the
        <a href="http://www.ala.org.au/about-the-atlas/terms-of-use/#cy">ALA Terms of Use</a> for additional information.
    </p>
    <h2>Copyright
    </h2>
    <p>With the exception of the ${shortName} logo and logos of participating organisations, the images on the Home page, and where otherwise noted, all material presented
        on this website is provided under a    <a href="http://creativecommons.org/licenses/by/3.0/au/">Creative
            Commons Attribution 3.0 ${(not empty jurisdiction) ? jurisdiction : "Australia"}</a> licence. This allows for re-distribution of the
        data and any derivative works based on the data, provided that the source of the data is acknowledged.
    <p>
        The details of the relevant licence conditions are available on the Creative Commons website (accessible using
        the links provided) as is the    <a href="http://creativecommons.org/licenses/by/3.0/au/legalcode">full legal code
        for the CC BY 3 ${(not empty jurisdictionCode) ? jurisdictionCode : "AU"} licence</a>.
    </p>
    <p>
        Content from this website should be attributed as:
        <br/>
    <blockquote>${attribution}</blockquote>
    </p>
    <h2>
        Disclaimer
    </h2>
    <p>
        ${fullName} (${shortName}) data is supplied as is. No warranty, express or implied, is made concerning
        the accuracy or fitness for a particular
        purpose of the data. The user shall use ${shortName} at their own risk.
        <c:if test="${shortName == 'avh'}">
            The Council of Heads of Australasian Herbaria Inc.
            (CHAH) will not be liable for any loss or
            damage arising from the use of or reliance upon the data, or
            reliance on its availability at any time.
        </c:if>
    </p>
    <p>
        The views, opinions, findings and recommendations expressed on this service are those of the author(s)
        and data custodian(s) and do not necessarily reflect the views of
        <c:choose>
            <c:when test="${shortName == 'avh'}">
                the Australian Commonwealth Government, any Australian state or territory government, any
                Australian regional government or any other
                Australian government agency.
            </c:when>
            <c:otherwise>
                ${fullName}
            </c:otherwise>
        </c:choose>

    </p>
    <p>
        Reference on this service to any specific commercial products, process or service by trade name, trademark,
        manufacturer or otherwise, does not necessarily
        constitute or imply its endorsement, recommendation or favouring by
        <c:choose>
            <c:when test="${shortName == 'avh'}">
                CHAH or any Australian Government agency,
            </c:when>
            <c:otherwise>
                ${fullName}
            </c:otherwise>
        </c:choose>
        and shall not be used for advertising or product endorsement purposes.
    </p>
    <h2>
        Privacy
    </h2>
    <p>
        Information from this service resides on a computer system funded by the Commonwealth, state and territory
        governments of Australia. ${fullName} uses

        <a href="http://www.google.com/intl/en_uk/analytics/index.html">Google Analytics</a>

        to monitor site usage for statistical purposes. The information logged may include: the user's Internet
        protocol (IP) address and top level domain name, the date and time the site was visited, the pages
        accessed, the queries performed and data downloaded, the previous site visited and the browser used. Any
        unauthorised access to this system is prohibited and is subject to various Australian criminal and civil laws.
    </p>
    <p>
        In order to use certain features available on the ${shortName} website, you must register as a user with
        the Atlas of Living Australia (ALA). When registering, a genuine e-mail address must be provided.
    </p>
    <p>
        In some cases, you may be asked to provide your real name or other identifying or contact details
        &ndash; such personal information will be managed in accordance with the ALA
        <a href="http://www.ala.org.au/about-the-atlas/terms-of-use/privacy-policy/">Privacy Policy</a>.
    </p>
	<p>&nbsp;</p>

</div>

</body>
</html> 