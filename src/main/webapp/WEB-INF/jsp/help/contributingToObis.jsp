<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Partners </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>Contributing Data to the OBIS Network</h1>
    <div>&nbsp;</div>
    <div class="plain">
        <P>If you are the custodian of a dataset of marine species distributional data of potential interest to OBIS
            (for guidelines on what these might be, refer to the "FAQ" link at left), and are happy to provide public
            access to your data, there are two principal mechanisms by which you can connect your data to the OBIS
            network. </P>

        <P>One, if you have a sufficiently robust IT (computing) infrastructure, you can serve the data directly to the
            international OBIS portal. To do this, you will need a PC with a web server (for example the free "Apache"
            software), your data in a suitable format (for example, a database such as MySQL or other), and some
            "serving" middleware, for which OBIS employs the (free) "DiGIR" (Distributed Generic Information Retrieval)
            product. For more information, see below under "Setting up a DiGIR provider". </P>

        <P>As an alternative, OBIS Australia can host a "snapshot" of your data for you, on the OBIS Australia server.
            This means that the data will be exposed to the international Portal on your behalf, and will be identified
            as your data being served by OBIS Australia. The version of the dataset hosted on the OBIS Australia server
            can be arranged to be updated at intervals, for example if the dataset is dynamic (i.e., the content changes
            from time to time). To arrange this, please contact the <A href="mailto:Tony.Rees@csiro.au">node manager</A>.
        </P>
        <H4>Setting up a DiGIR provider</H4>

        <P>Instructions for setting up a DiGIR provider are contained on the International OBIS website via <A
                href="http://iobis.org/tech/provider/">this link</A>. OBIS recommends downloading and installing one of
            the GBIF DiGIR provider packages, which are currently available for Windows 2000/Windows XP, Linux RedHat
            7.3 and above, and Solaris. At OBIS Australia we also have experience installing DiGIR on Linux SuSE.</P>

        <P>You will also need to map your data to the OBIS data schema (information provided at the link above), for
            which we recommend making an extract (dump) of the data you wish to serve, in a single table which matches
            the OBIS schema as closely as possible (this will speed up web access to your dataset). Some sample data (as
            an MS Excel copy), re-formatted to suit the OBIS schema, is available <A
                    href="http://www.obis.org.au/contributing/sampledata1.xls">here</A>. OBIS Australia staff can
            provide advice and assistance if you find any of the above steps difficult.</P>

        <P>Once your DiGIR installation is working and your dataset is visible, you can then register your service with
            the International Portal and your data will be connected to the OBIS network, and visible to searches from
            OBIS Australia as well as any of the other entry points to the OBIS system. It should be noted that some
            data contributors have data in multiple databases, which they are able to connect to the OBIS network via a
            single DiGIR installation without losing the specific identity of each database.</P>
    </div>
</div>
</body>
</html> 