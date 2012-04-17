<%--
    Document   : main.jsp (sitemesh decorator file)
    Created on : 18/09/2009, 13:57
    Author     : dos009
--%><%@
        taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
        taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
        include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title><decorator:title default="Atlas of Living Australia" /></title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/style2010.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/style2011.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/css/wp-styles.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/css/buttons.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/css/jquery.autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/css/search.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/css/skin.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${initParam.centralServer}/wp-content/themes/ala2011/css/sf.css" type="text/css" media="screen" />

    <link rel="icon" type="image/x-icon" href="${initParam.centralServer}/wp-content/themes/ala2011/images/favicon.ico" />
    <link rel="shortcut icon" type="image/x-icon" href="${initParam.centralServer}/wp-content/themes/ala2011/images/favicon.ico" />

    <%@ include file="commonJS.jspf" %>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/widget.css" type="text/css" media="screen,projection" />
    <!-- CIRCLE PLAYER -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/circle.skin/circle.player.css" type="text/css" media="screen" />
    <c:set var="dev" value="${false}"/><%-- should be false in prod --%>

    <decorator:head />

    <script language="JavaScript" type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/html5.js"></script>
    <script language="JavaScript" type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/superfish/superfish.js"></script>
    <script language="JavaScript" type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/jquery.autocomplete.js"></script>
    <script language="JavaScript" type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/uservoice.js"></script>
    <script type="text/javascript">
        // initialise plugins
        jQuery(function(){
            jQuery('ul.sf').superfish( {
                delay:500,
                autoArrows:false,
                dropShadows:false
            });

            jQuery("form#search-form-2011 input#search-2011").autocomplete('http://bie.ala.org.au/search/auto.jsonp', {
                extraParams: {limit: 100},
                dataType: 'jsonp',
                parse: function(data) {
                    var rows = new Array();
                    data = data.autoCompleteList;
                    for(var i=0; i<data.length; i++){
                        rows[i] = {
                            data:data[i],
                            value: data[i].matchedNames[0],
                            result: data[i].matchedNames[0]
                        };
                    }
                    return rows;
                },
                matchSubset: false,
                formatItem: function(row, i, n) {
                    return row.matchedNames[0];
                },
                cacheLength: 10,
                minChars: 3,
                scroll: false,
                max: 10,
                selectFirst: false
            });
        });
    </script>
</head>
<c:set var="callingBodyClass"><decorator:getProperty property='body.class'/></c:set>
<c:set var="bodyClass">
    <c:choose>
        <c:when test="${not empty callingBodyClass}">${callingBodyClass}</c:when>
        <c:otherwise>datasets</c:otherwise>
    </c:choose>
</c:set>
<body class="${bodyClass}">
<div id="wrapper">
    <c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${fn:escapeXml(pageContext.request.queryString)}"/>
    <ala:header returnUrlPath="${returnUrlPath}" populateSearchBox="true" />
    <ala:menu />
        <div id="wrapper_border"><!-- div#wrapper_border - main content area-->
            <div id="border">
                <div id="content" style="">
                    <ala:loggedInUserId />
                    <decorator:body />
                </div><!-- end div#content -->
            </div><!-- end div#border -->
        </div><!-- end div#wrapper_border -->
    <ala:footer />
    <ala:analytics />
</div>
</body>
</html>