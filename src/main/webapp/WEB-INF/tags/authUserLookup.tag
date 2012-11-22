<%@ include file="/common/taglibs.jsp" %><%@
        attribute name="allUserNamesByIdMap" required="true" type="java.util.Map" %><%@
        attribute name="userId" required="true" type="java.lang.String" %><c:choose><c:when
        test="${not empty allUserNamesByIdMap[userId]}">${allUserNamesByIdMap[userId]}</c:when
        ><c:otherwise>${ala:replaceAll(userId, "\\@\\w+", "@..")}</c:otherwise></c:choose>

