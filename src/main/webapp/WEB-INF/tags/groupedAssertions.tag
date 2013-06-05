<%-- 
    Document   : assertionListItem
    Created on : Mar 1, 2011, 11:52:04 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%><%@ 
include file="/common/taglibs.jsp" %><%@
tag description="Print a <li> for user assertions on occurrence record page" pageEncoding="UTF-8"%><%@
attribute name="groupedAssertions" required="false" type="java.util.Collection" %>
<c:forEach items="${groupedAssertions}" var="assertion">
<li id="${assertion.usersAssertionUuid}">
    <fmt:message key="${assertion.name}"/>
    <c:choose>
        <c:when test="${assertion.assertionByUser}">
            <br/>
            <strong>
                ( added by you
                <c:choose>
                    <c:when test="${fn:length(assertion.users)>1}">
                        and ${fn:length(assertion.users) - 1} ${fn:length(assertion.users)>2 ? 'other users' : 'other user'})
                    </c:when>
                    <c:otherwise>
                     )
                    </c:otherwise>
                </c:choose>
            </strong>
        </c:when>
        <c:otherwise>
            (added by ${fn:length(assertion.users)} ${fn:length(assertion.users)>1 ? 'users' : 'user'})
        </c:otherwise>
    </c:choose>
    <c:if test="${false && isCollectionAdmin && assertion.name != 'userVerified'}">
        <div style="border: 1px solid #ccc; padding: 5px;">You are able to modify this comment:
            <input class="confirmVerify" type="button" value="confirm"/>&nbsp;<input class="cancelVerify" type="button" value="refute"/></div>
    </c:if>
</li>
</c:forEach>