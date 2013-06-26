<%@
    taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
    taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
    include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="description" content="Atlas of Living Australia"/>
    <meta name="author" content="Atlas of Living Australia">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1">

    <title><decorator:title default="Atlas of Living Australia" /></title>

    <link rel="icon" type="image/x-icon" href="http://www.ala.org.au/wp-content/themes/ala2011/images/favicon.ico">
    <link rel="shortcut icon" type="image/x-icon" href="http://www.ala.org.au/wp-content/themes/ala2011/images/favicon.ico">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
    <link id="responsiveCss" rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/bootstrap-responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <%--<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/widget.css" type="text/css" media="screen,projection" />--%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/bootstrapAdditions.css" type="text/css" media="screen,projection" />

    <%--<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>--%>
    <%@ include file="commonJS.jspf" %>

    <decorator:head />

    <script src="${pageContext.request.contextPath}/static/js/bootstrap.js"></script>
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
        <script type="text/javascript" src="${initParam.centralServer}/wp-content/themes/ala2011/scripts/html5.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/respond.min.js"></script>
    <![endif]-->

    <script type="text/javascript">
        // initialise plugins
        jQuery(function(){
            // autocomplete on navbar search input
            jQuery("form#search-form-2011 input#search-2011, form#search-inpage input#search").autocomplete('http://bie.ala.org.au/search/auto.jsonp', {
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

            // Mobile/desktop toggle
            // TODO: set a cookie so user's choice is remembered across page requests
            var responsiveCssFile = $("#responsiveCss").attr("href"); // remember set href
            var viewportMeta = document.querySelector("meta[name=viewport]");
            var viewPortDefault = viewportMeta.getAttribute('content');

            $(".toggleResponsive").click(function(e) {
                e.preventDefault();
                $(this).find("i").toggleClass("icon-resize-small icon-resize-full");
                var currentHref = $("#responsiveCss").attr("href");
                if (currentHref) {
                    $("#responsiveCss").attr("href", ""); // set to desktop (fixed)
                    $(this).find("span").html("Mobile");
                    viewportMeta.setAttribute('content', 'width=980, initial-scale=1, maximum-scale=1');
                } else {
                    $("#responsiveCss").attr("href", responsiveCssFile); // set to mobile (responsive)
                    $(this).find("span").html("Desktop");
                    viewportMeta.setAttribute('content', viewPortDefault);
                }
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

<c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${fn:escapeXml(pageContext.request.queryString)}"/>
<ala:header logoutControllerUrlPath="/logout" returnUrlPath="${returnUrlPath}" populateSearchBox="true" />

<ala:menu/>

<div class="container" id="main-content">
    <ala:loggedInUserId />
    <div id="content" class="row-fluid">
        <decorator:body />
    </div>
</div><!--/.container-->

<div class="container hidden-desktop">
    <%-- Borrowed from http://marcusasplund.com/optout/ --%>
    <a class="btn btn-small toggleResponsive"><i class="icon-resize-full"></i> <span>Desktop</span> version</a>
</div>

<ala:footer/>

<script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
    var pageTracker = _gat._getTracker("UA-4355440-1");
    pageTracker._initData();
    pageTracker._trackPageview();
</script>
<script type="text/javascript">
    // show warning if using IE6
    if ($.browser.msie && $.browser.version.slice(0,1) == '6') {
        $('#header').prepend($('<div style="text-align:center;color:red;">WARNING: This page is not compatible with IE6.' +
                ' Many functions will still work but layout and image transparency will be disrupted.</div>'));
    }
</script>
</body>
</html>