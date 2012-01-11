<%@ include file="/common/taglibs.jsp" %><%@ 
attribute name="map" required="true" type="java.util.Map" %>
<c:forEach var="group" items="${map}">
    <c:choose>
        <c:when test="${not empty group.value}">
            <c:forEach var="field" items="${group.value}" varStatus="status">
                <c:set var="grayBg">${(status.index % 2 == 0) ? 'grey-bg': ''}</c:set>
                <tr>
                    <c:if test="${status.first}">
                        <td rowspan="${fn:length(group.value)}">${group.key}</td>
                    </c:if>
                    <td class="${grayBg} dwc">${field.name}</td>
                    <td class="${grayBg}">${(field.name == 'recordedBy' && fn:contains(field.raw,'@')) ? fn:substringBefore(field.raw,'@') : field.raw}<%-- we're obfuscating email addresses --%></td>
                    <td class="${grayBg}">${(field.name == 'recordedBy' && fn:contains(field.processed,'@')) ? fn:substringBefore(field.processed,'@') : field.processed}<%-- we're obfuscating email addresses --%></td>
                </tr>
            </c:forEach>
        </c:when>
    </c:choose>
<%--    
    <tr>
        <td rowspan="${fn:length(group.value)}">
            ${group.key}
        </td>
        <c:choose>
            <c:when test="${not empty group.value}">
                <c:forEach var="field" items="${group.value}" varStatus="status">
                    <td class="${(status.index % 2 == 0) ? 'grey-bg': ''}">
                        ${field.name}
                    </td>
                    <td class="${(status.index % 2 == 0) ? 'grey-bg': ''}">
                        ${field.raw}
                    </td>
                    <td class="${(status.index % 2 == 0) ? 'grey-bg': ''}">
                        ${field.processed}
                    </td>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <td colspan="3">&nbsp;</td>
            </c:otherwise>
        </c:choose>
    </tr>
--%>
</c:forEach>