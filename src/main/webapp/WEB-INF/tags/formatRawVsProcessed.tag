<%@ include file="/common/taglibs.jsp" %><%@ 
attribute name="map" required="true" type="java.util.Map" %>
<c:forEach var="group" items="${map}">
    <c:choose>
        <c:when test="${not empty group.value}">
            <c:forEach var="field" items="${group.value}" varStatus="status">
                <c:set var="grayBg">${(status.index % 2 == 0) ? 'grey-bg': ''}</c:set>
                <c:set var="rawRecordedBy"><alatag:authUserLookup userId="${field.raw}" allUserNamesByIdMap="${userNamesByIdMap}" allUserNamesByNumericIdMap="${userNamesByNumericIdMap}"/></c:set>
                <c:set var="proRecordedBy"><alatag:authUserLookup userId="${field.processed}" allUserNamesByIdMap="${userNamesByIdMap}" allUserNamesByNumericIdMap="${userNamesByNumericIdMap}"/></c:set>
                <tr>
                    <c:if test="${status.first}">
                        <td rowspan="${fn:length(group.value)}">${group.key}</td>
                    </c:if>
                    <td class="${grayBg} dwc">${field.name}</td>
                    <td class="${grayBg}">${(field.name == 'recordedBy' && fn:contains(field.raw,'@')) ? rawRecordedBy : field.raw}<%-- we're obfuscating email addresses --%></td>
                    <td class="${grayBg}">${(field.name == 'recordedBy' && fn:contains(field.processed,'@')) ? proRecordedBy : field.processed}<%-- we're obfuscating email addresses --%></td>
                </tr>
            </c:forEach>
        </c:when>
    </c:choose>
</c:forEach>