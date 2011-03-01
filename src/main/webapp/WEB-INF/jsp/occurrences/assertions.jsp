<%@page contentType="text/html" pageEncoding="UTF-8"%><%@
include file="/common/taglibs.jsp"
%>
<c:forEach var="assertion" items="${assertions}">
    <alatag:assertionListItem uuid="${assertion.uuid}" name="${assertion.name}"
              comment="${assertion.comment}" userId="${assertion.userId}" currentUserId="${userId}"/>
</c:forEach>