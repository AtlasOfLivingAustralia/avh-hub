<%--
    Document   : avh-skin.jsp (sitemesh decorator file)
    Created on : 01/09/2010, 11:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<c:set var="avhUrl" value="http://chah.gov.au/avh/"/>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
    <head><title><decorator:title default="AVH" /></title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/avh/favicon.ico" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/reset.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/screen.css" />
	<link href="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.1" rel="schema.AGLS" />
	<meta name="DC.Title" content="Partners" lang="en" />	<meta name="DC.Function" content="Public information" />
	<meta name="DC.Description" content="Australia's Virtual Herbarium (AVH) is an online resource that provides immediate access to the wealth of plant specimen information held by Australian herbaria. AVH is a collaborative project of the state, Commonwealth and territory herbaria, developed under the auspices of the Council of Heads of Australasian Herbaria (CHAH), representing the major Australian collections." />
	<meta name="DC.Creator" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
	<meta name="DC.Publisher" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
	<meta name="DC.Type.Category" content="document" />
	<meta name="DC.Format" content="text/html" />
	<meta name="DC.Language" content="en_AU" scheme="RFC3066" />
	<meta name="DC.Coverage.Jurisdiction" content="Australian Government Departmental Consortium" />
	<meta name="DC.Coverage.PlaceName" content="Australia, world" />
	<meta name="DC.Audience" content="Botanists, horticulturalists, biologists, ecologists, environmentalists, conservationists, land managers, educators, students, historians, general public" />
	<meta name="DC.Availability" content="Freely available. Some parts of this resource are username and password restricted" />
	<meta name="DC.Rights" content="(c) Council of Heads of Australasian Herbaria, 2010" />
	<meta name="DC.Rights" content="Unless other stated, Intellectual Property associated with this resource resides with the Council of Heads of Australasian Herbaria and individual herbaria. Applications, source code and data are freely available for research, non-commercial and public good purposes" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    <<%@ include file="commonJS.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <decorator:head />
</head>
<body>
<div id="container">
	<div id="main_content" class="">
        <decorator:body />
    </div>
</div>
</body>
</html>
