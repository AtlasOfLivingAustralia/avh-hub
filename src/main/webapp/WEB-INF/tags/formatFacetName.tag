<%@ include file="/common/taglibs.jsp" %><%@
attribute name="fieldName" required="true" type="java.lang.String" %>
<c:set var="fieldName" value="${fn:trim(fieldName)}"/>
<c:choose>
    <c:when test="${fn:endsWith(fieldName,'_s') || fn:endsWith(fieldName,'_i') || fn:endsWith(fieldName,'_d') || fn:endsWith(fieldName,'_RNG')}">
        ${fn:replace(fn:substring(fieldName, 0, fn:length(fieldName)-2), '_', ' ')}
        <c:if test="${fn:endsWith(fieldName,'_RNG')}">
            (range)
        </c:if>
    </c:when>
    <c:otherwise>
        <fmt:message key="facet.${fieldName}"/>
    </c:otherwise>
</c:choose>