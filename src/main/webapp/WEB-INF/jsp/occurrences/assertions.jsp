<%@page contentType="text/html" pageEncoding="UTF-8"%><%@
include file="/common/taglibs.jsp"
%><c:forEach var="assertion" items="${assertions}">
    <li id="${assertion.uuid}"><spring:message code="${assertion.name}" text="${assertion.name}"/> ${pageContext.request.userPrincipal}
        <c:if test="${(not empty userId) && (userId eq assertion.userId)}">
            <c:if test="${(not empty userId) && (userId eq assertion.userId)}">
                <br/><strong>(added by you - <a href="javascript:deleteAssertion('${recordUuid}','${assertion.uuid}');">delete</a>)</strong>
            </c:if>
        </c:if>
    </li>
</c:forEach>