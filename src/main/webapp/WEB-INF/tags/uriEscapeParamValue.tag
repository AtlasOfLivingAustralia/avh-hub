<%@ include file="/common/taglibs.jsp" %><%@
    attribute name="input" required="true" type="java.lang.String" %><%--
    Tag to escape param values. E.g. ? to %3f & " to %22, etc.
    --%><c:url var="url" value=""><c:param name="output" value="${input}" /></c:url><c:set var="url2" value="${fn:substringAfter(url, '=')}" />
${url2}