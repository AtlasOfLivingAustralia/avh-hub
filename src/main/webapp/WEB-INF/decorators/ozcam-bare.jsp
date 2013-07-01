<%--
    Document   : main.jsp (sitemesh decorator file)
    Created on : 18/09/2009, 13:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
    <head profile="http://gmpg.org/xfn/11">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title><decorator:title default="OZCAM"/></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ozcam-0.3/style.css" type="text/css" media="screen,projection" />
        <!--<link rel="icon" type="image/x-icon" href="http://www.ozcam.org.au/favicon.ico" />-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
        <style type="text/css">
            div#fancy_inner {border-color:#BBBBBB}
            div#fancy_close {right:-15px;top:-12px}
            div#fancy_bg {background-color:#FFFFFF}
            body {background-color: #ffffff;}
        </style>
        <%@ include file="commonJS.jspf" %>

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
        <link id="responsiveCss" rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/bootstrap-responsive.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ala/bootstrapAdditions.css" type="text/css" media="screen,projection" />
        <decorator:head />
    </head>
    <body>
        <div class="wrapper">
            <div id="contentBox" style="margin-top: 20px;">
                <decorator:body />
                <div class="push"></div>
            </div>
        </div>
    </body>
</html>