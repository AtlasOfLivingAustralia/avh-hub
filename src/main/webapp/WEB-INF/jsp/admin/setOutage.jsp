<%--
  Created by IntelliJ IDEA.
  User: dos009
  Date: 27/06/13
  Time: 10:24 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="decorator" content="${skin}"/>
    <title>ALA Admin - Outage Message</title>
</head>
<body>
    <div class="row-fluid">
        <h1>Admin - Outage Message</h1>
    </div>
    <form method="POST" class="form-horizontal">
        <div class="warning">
            <c:if test="${message}">${message}</c:if>
        </div>
        <div class="control-group">
            <label class="control-label" for="message">Outage Message</label>
            <div class="controls">
                <textarea name="message" id="message" class="span4" rows="4">${outageBanner.message}</textarea>
                <span class="help-inline">This text will appear on all pages for the<br> period specified in the date fields below</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="startDate">Start Date</label>
            <div class="controls">
                <input type="text" name="startDate" id="startDate" class="span2" value="<fmt:formatDate value="${outageBanner.startDate}" pattern="yyyy-MM-dd"/>"/>
                <span class="help-inline"><code>yyyy-mm-dd</code> format</span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="endDate">End Date</label>
            <div class="controls">
                <input type="text" name="endDate" id="endDate" class="span2" value="<fmt:formatDate value="${outageBanner.endDate}" pattern="yyyy-MM-dd"/>"/>
                <span class="help-inline"><code>yyyy-mm-dd</code> format</span>
            </div>
        </div>
        <div class="control-group">
        <label class="control-label" for="endDate">Display message</label>
        <div class="controls">
            <input type="checkbox"name="showMessage" id="showMessage" class="span2" ${(not empty outageBanner.showMessage)?'checked="checked"':''}/>
            <span class="help-inline">check this to show the message (dates are still required to be valid)</span>
        </div>
        </div>
        <div class="control-group">
            <%--<label class="control-label" for="endDate"></label>--%>
            <div class="controls">
                <input type="submit" value="Submit" class="btn">
            </div>
        </div>
    </form>
</body>
</html>