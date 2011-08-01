<%@ include file="/common/taglibs.jsp" %><%@ 
attribute name="label" required="true" type="java.lang.String" %><%@
attribute name="raw" required="false" type="java.util.Map" %><%@
attribute name="processed" required="false" type="java.util.Map" %>
<td>
    ${label}
</td>
<td>
    <table class="inner">
        <c:forEach var="attr" items="${raw}">
            <tr><td>${attr.key}</td><td>${attr.value}</td></tr>
        </c:forEach>
    </table>
</td>
<td>
    <table class="inner">
        <c:forEach var="attr" items="${processed}">
            <tr><td>${attr.key}</td><td>${attr.value}</td></tr>
        </c:forEach>
    </table>
</td>