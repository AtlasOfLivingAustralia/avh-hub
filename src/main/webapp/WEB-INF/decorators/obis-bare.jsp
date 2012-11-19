<%--
    Document   : amrin-bare.jsp (sitemesh decorator file)
    Created on : 11/10/2012, 11:20
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">    
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title><decorator:title default="OBIS"/></title>
    <!-- test -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <!--css from ala - to replace with full url-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/asbp/tabs-no-images.css" type="text/css" media="screen" />
    <!--css for amrin-->
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/amrin.css" type="text/css" media="screen,projection" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/obis/style.css" type="text/css" media="screen" />

    <%@ include file="commonJS.jspf" %>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <decorator:head />

</head>
<body>
<div id="main_content" class="">

    <decorator:body />

</div><!--end main_content-->

</body>
</html>
