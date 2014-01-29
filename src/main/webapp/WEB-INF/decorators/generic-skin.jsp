<%--
    Document   : ala-skin.jsp (sitemesh decorator file)
    Created on : 18/09/2009, 13:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
include file="/common/taglibs.jsp" %><c:set
  var="hubDisplayName" scope="request"><ala:propertyLoader checkSupplied="true" bundle="hubs" property="site.displayName"/></c:set>

<!DOCTYPE html>
<html dir="ltr" lang="en-US">
<head profile="http://gmpg.org/xfn/11">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="description" content="Atlas of Living Australia"/>
    <meta name="author" content="Atlas of Living Australia">
    <meta name="viewport" content="width=device-width, initial-scale=0.8, maximum-scale=1">

    <title><decorator:title default="${hubDisplayName}" /></title>

    <link rel="icon" type="image/x-icon" href="favicon.ico">
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/generic/css/bootstrap.css">
    <link id="responsiveCss" rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/generic/css/bootstrap-responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <%--<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/widget.css" type="text/css" media="screen,projection" />--%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/bootstrapAdditions.css" type="text/css" media="screen,projection" />
    <style type="text/css">
        /* BS headings are too big - reduce them a bit */
        h1 { font-size: 30px; line-height: 30px; }
        h2 { font-size: 26px; line-height: 30px; }
        h3 { font-size: 22px; line-height: 30px; }
        h4 { font-size: 18px; line-height: 20px; }
        h5 { font-size: 14px; line-height: 20px; }
        h6 { font-size: 12px; line-height: 20px; }
        body > #main-content {
            margin-top: 0px;
        }
        #footer {
            margin: 20px;
            padding-top: 10px;
            border-top: 1px solid #CCC;
            font-size: 12px;
        }
        #main-content #content #customiseFacetsButton .dropdown-menu, #main-content #resultsReturned .dropdown-menu  {
            background-color: #fff;
        }
    </style>
        <%--<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>--%>
    <%@ include file="commonJS.jspf" %>

    <decorator:head />

    <script src="${pageContext.request.contextPath}/static/css/generic/js/bootstrap.min.js"></script>
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
<body class="<decorator:getProperty property='body.class'/>">
    <div class="navbar navbar-inverse navbar-static-top">
        <div class="navbar-inner">
            <div class="container-fluid">
                <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="brand" href="#">${hubDisplayName}</a>
                <div class="nav-collapse collapse">
                    <p class="navbar-text pull-right">
                        Logged in as <a href="#" class="navbar-link">Username</a>
                    </p>
                    <ul class="nav">
                        <li class="active"><a href="#">Home</a></li>
                        <li><a href="#about">About</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                </div><!--/.nav-collapse -->
            </div><!--/.container-fluid -->
        </div><!--/.navbar-inner -->
    </div><!--/.navbar -->

    <div class="container-fluid" id="main-content">
        <ala:loggedInUserId />
        <div id="content" class="row-fluid">
            <decorator:body />
        </div>
    </div><!--/#main-content-->

    <div id="footer">
        <div class="container-fluid">
            <%--
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <jsp:useBean id="date" class="java.util.Date" />
            <fmt:formatDate value="${date}" pattern="yyyy" var="currentYear" />
            <p>&copy; ${hubDisplayName} ${currentYear}</p>
            --%>
            <div class="row-fluid">
                <a href="http://creativecommons.org/licenses/by/3.0/au/" title="External link to Creative Commons"><img src="http://www.ala.org.au/wp-content/themes/ala2011/images/creativecommons.png" width="88" height="31" alt=""></a>
                This site is licensed under a <a href="http://creativecommons.org/licenses/by/3.0/au/" title="External link to Creative Commons" class="external">Creative Commons Attribution 3.0 Australia License</a>. Provider content may be covered by other <a href="http://www.ala.org.au/about-the-atlas/terms-of-use/" title="Terms of Use">Terms of Use</a>.
            </div>
        </div>
    </div><!--/#footer -->
    <br/>
</body>
</html>