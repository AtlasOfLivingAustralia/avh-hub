<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="hostName" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}"/>
<c:set var="fullName"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader bundle="hubs" property="site.displayNameShort"/></c:set>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="decorator" content="${skin}"/>
    <meta name="section" content="help"/>
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Sponsors </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>Sponsors</h1>

    <h3>AVH Trust</h3>

    <p>The AVH Trust accepts private, tax-deductible donations to AVH. The Trust is managed by a board with government
        and private sector representation.</p>

    <h3>Sponsors</h3>

    <p class="row"><b>John T. Reid Charitable Trust</b></p>

    <div class="row">
        <div class="column col1"><img src="${pageContext.request.contextPath}/static/images/help/JohnTReid-logo-60.gif" alt="J.T. Reid Trust logo" height="60" width="37"/></div>
        <div class="column col2">Established in 1956 by prominent Australian businessman Sir John T. Reid, the <a
                href="http://www.johntreidtrusts.com.au/">John T. Reid Charitable Trust</a> supports a broad
            range of initiatives that aid community well-being and advancement. This includes financial support to
            programs concerned with social welfare, medical research, the environment and education.
        </div>
    </div>
    <br/>

    <p class="row"><b>Thyne Reid Foundation</b></p>

    <div class="row">
        <div class="column col1"></div>
        <div class="column col2">The Thyne Reid Foundation was created by the late Andrew Thyne Reid in 1944 and 1955.
            The Foundation encourages and supports projects in the fields of medicine, science, creative arts,
            environment, education, social and community needs.
        </div>
    </div>
    <br/>

    <p class="row"><b>The Myer Foundation</b></p>

    <div class="row">
        <div class="column col1"><img src="${pageContext.request.contextPath}/static/images/help/myer-foundation-logo.gif" alt="Myer Foundation logo" height="60"
                                      width="52"/></div>
        <div class="column col2">The <a href="http://www.myerfoundation.org.au/">Myer Foundation</a> mission is to build
            a fair, just, creative, sustainable and caring society through initiatives that promote positive changes in
            Australia, and in relation to Australia’s regional setting.
        </div>
    </div>
    <br/>

    <p class="row"><b>The R.E. Ross Trust</b></p>

    <div class="row">
        <div class="column col1"><img src="${pageContext.request.contextPath}/static/images/help/r-e-ross-logo-2.gif" alt="R.E. Ross Trust logo" width="60"
                                      height="48"/></div>
        <div class="column col2">The <a href="http://www.rosstrust.org.au/">R.E. Ross Trust</a> is a perpetual
            charitable Trust established in Victoria in 1970 by the will of the late Roy Everard Ross. The Trust is
            administered by five trustees who manage the Trust's assets and distribute its income in Victoria for
            charitable purposes.
        </div>
    </div>
    <br/>

    <p class="row"><b>The Ian Potter Foundation</b></p>

    <div class="row">
        <div class="column col1"><img src="${pageContext.request.contextPath}/static/images/help/ipf_colour-60.gif" alt="Ian Potter Foundation logo" width="60"
                                      height="60"/></div>
        <div class="column col2">Established in 1964, The <a href="http://www.ianpotter.org.au/">Ian Potter
            Foundation</a> is today one of Australia's largest private philanthropic
            foundations. It makes grants for general charitable purposes in Australia in the arts, education,
            environment and
            conservation, health, social welfare, science and medical research.
        </div>
    </div>
    <br class="row"/>

    <h3>Becoming an AVH sponsor</h3>

    <p>CHAH is interested in discussing sponsorship arrangements with private sector organisations and companies. For
        more information about the AVH project, please contact:</p>

    <p>Brendan Lepschi<br/>
        Executive Officer<br/>
        Australia's Virtual Herbarium Trust<br/>
        GPO Box 787<br/>
        Canberra ACT 2601</p>
</div>
</div>
</body>
</html> 