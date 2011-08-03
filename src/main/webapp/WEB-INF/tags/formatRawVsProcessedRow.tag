<%@ include file="/common/taglibs.jsp" %><%@ 
attribute name="label" required="true" type="java.lang.String" %><%@
attribute name="raw" required="false" type="java.util.Map" %><%@
attribute name="processed" required="false" type="java.util.Map" %>
<td>
    ${label}
</td>
<td class="noPad">
    <table class="inner">
        <c:forEach var="attr" items="${raw}">
            <tr><td class="label">${attr.key}:</td><td>${attr.value}</td></tr>
        </c:forEach>
    </table>
</td>
<td class="noPad">
    <table class="inner">
        <c:forEach var="attr" items="${processed}">
            <tr><td class="label">${attr.key}:</td><td>${attr.value}</td></tr>
        </c:forEach>
    </table>
</td>