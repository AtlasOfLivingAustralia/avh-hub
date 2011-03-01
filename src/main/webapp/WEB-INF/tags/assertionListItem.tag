<%-- 
    Document   : assertionListItem
    Created on : Mar 1, 2011, 11:52:04 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%><%@ 
include file="/common/taglibs.jsp" %><%@
tag description="Print a <li> for user assertions on occurrence record page" pageEncoding="UTF-8"%><%@
attribute name="uuid" required="true" type="java.lang.String" %><%@
attribute name="name" required="true" type="java.lang.String" %><%@
attribute name="userId" required="true" type="java.lang.String" %><%@
attribute name="comment" required="false" type="java.lang.String" %><%@
attribute name="currentUserId" required="false" type="java.lang.String" %>
<li id="${uuid}">
    <fmt:message key="${name}"/> <c:if test="${not empty comment}">- ${comment}</c:if>
    <c:if test="${(not empty currentUserId) && (currentUserId eq userId)}">
        <br/><strong>(added by you - <a href="#" class="deleteAssertion" id="${uuid}">delete</a>)</strong>
    </c:if>
</li>
