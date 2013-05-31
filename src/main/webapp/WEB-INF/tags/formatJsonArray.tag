<%@ tag import="org.codehaus.jackson.map.ObjectMapper" %><%@
        include file="/common/taglibs.jsp" %><%@
        attribute name="text" required="true" type="java.lang.Object"
%><%
    ObjectMapper om = new ObjectMapper();
    StringBuffer sb = new StringBuffer();
    System.out.println("######## Attempting to format: " + text);
    if(text instanceof Object[]){
      jspContext.setAttribute("listToFormat",text);
    } else if(text instanceof String && text!=null){
      String json = (String) text;
      if(json.startsWith("[") && json.endsWith("]")){
        try {
            String[] jsonProps = om.readValue(json, String[].class);
            if(jsonProps !=null){
                jspContext.setAttribute("listToFormat",jsonProps);
            }
        } catch(Exception e1){
            try {
                out.print(sb.toString());
            } catch (Exception e) {
                throw new JspTagException("FormatJson: " + e.getMessage());
            }
        }
      } else {
            out.print(text);
      }
    }
%>
<c:forEach items="${listToFormat}" var="listItem">
    <spring:message code="${listItem}" text="${listItem}" />
</c:forEach>