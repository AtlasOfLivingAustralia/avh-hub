<%-- 
    Document   : annotationEditor
    Created on : Mar 7, 2011, 1:22:22 PM
    Author     : jac24n
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common/taglibs.jsp" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Annotation Editor</title>
                <script type="text/javascript">

            /**
             * JQuery on document ready callback
             */
            $(document).ready(function() {
                // bind to form submit for assertions
                $("form#issueForm").submit(function(e) {
                    e.preventDefault();
                    var comment = $("#issueComment").val();
                    var code = $("#issue").val();
                    var userId = '${userId}';
                    var userDisplayName = '${userDisplayName}';
                    if(code!=""){
                        $.post("${pageContext.request.contextPath}/occurrences/${uuid}/assertions/add",
                            { code: code, comment: comment, userId: userId, userDisplayName: userDisplayName},
                            function(data) {
                                alert("Thanks for flagging the problem!");
                                parent.$.fancybox.close();
                            }
                        );
                    } else {
                        alert("Please supply a issue type");
                    }
                });

                                // bind to form "close" button
                $("input#close").live("click", function(e) {
                    // close the popup
                    parent.$.fancybox.close();
                });
            }); // end JQuery document ready
        </script>
    </head>
    <body>
        <h1>Annotating record ${uuid}</h1>
        <c:choose>
            <c:when test="${empty userId}">
                <div id="loginOrFlag">
                    Login please
                    <a href="https://auth.ala.org.au/cas/login?service=${initParam.serverName}${pageContext.request.contextPath}/occurrences/annotate/${uuid}">Click here</a>
                </div>
            </c:when>
            <c:otherwise>
                <div id="loginOrFlag">
                    You are logged in as  <strong>${userDisplayName} (${userId})</strong>.
                    <form id="issueForm">
                        <p style="margin-top:20px;">
                            <label for="issue">Issue type:</label>
                            <select name="issue" id="issue">
                                <c:forEach items="${errorCodes}" var="code">
                                    <option value="${code.code}"><spring:message code="${code.name}" text="${code.name}"/></option>
                                </c:forEach>
                            </select>
                        </p>
                        <p style="margin-top:30px;">
                            <label for="comment" style="vertical-align:top;">Comment:</label>
                            <textarea name="comment" id="issueComment" style="width:380px;height:150px;" placeholder="Please add a comment here..."></textarea>
                        </p>
                        <p style="margin-top:20px;">
                            <input id="issueFormSubmit" type="submit" value="Submit" />
                            <input type="button" id="close" value="Cancel"/>
                            <span id="submitSuccess"></span>
                        </p>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </body>
</html>
