<%@ include file="/common/taglibs.jsp" %><%@
attribute name="compareRecord" required="true" type="java.util.Map" %><%@
attribute name="fieldsMap" required="true" type="java.util.Map" %><%@
attribute name="group" required="true" type="java.lang.String" %><%@
attribute name="exclude" required="true" type="java.lang.String" %>
<c:forEach items="${compareRecord[group]}" var="cr">
    <c:set var="key" value="${cr.name}" />
    <c:if test="${empty fieldsMap[key] && !fn:contains(exclude, key)}">
        <alatag:occurrenceTableRow annotate="true" section="dataset" fieldCode="${cr.name}" fieldName="<span class='dwc'>${cr.name}</span>">
            <c:choose>
                <c:when test="${not empty cr.processed && not empty cr.raw && cr.processed == cr.raw}">${cr.processed}</c:when>
                <c:when test="${empty cr.raw && not empty cr.processed}">${cr.processed}</c:when>
                <c:when test="${not empty cr.raw && empty cr.processed}">${cr.raw}</c:when>
                <c:otherwise>${cr.processed} <br/><span class="originalValue">Supplied as ${cr.raw}</span></c:otherwise>
            </c:choose>
        </alatag:occurrenceTableRow>
    </c:if>
</c:forEach>