<%-- 
    Document   : downloadDiv
    Created on : Feb 25, 2011, 4:20:32 PM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@ include file="/common/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="download">
    <p id="termsOfUseDownload">
        By downloading this content you are agreeing to use it in accordance with the Atlas
        <a href="http://www.ala.org.au/about/terms-of-use/#TOUusingcontent">Terms of Use</a>
        and individual <a href=" http://www.ala.org.au/support/faq/#q29">Data Provider Terms</a>.
        <br/><br/>
        Please provide the following <b>optional</b> details before downloading:
    </p>
    <form id="downloadForm">
        <input type="hidden" name="url" id="downloadUrl" value="${biocacheServiceUrl}/occurrences/download${searchResults.urlParameters}"/>
        <fieldset>
            <p><label for="email">Email</label>
                <input type="text" name="email" id="email" value="${pageContext.request.remoteUser}" size="30"  /></p>
            <p><label for="filename">File Name</label>
                <input type="text" name="filename" id="filename" value="data" size="30"  /></p>
            <p><label for="reason" style="vertical-align: top">Download Reason</label>
                <textarea name="reason" rows="5" cols="30" id="reason"  ></textarea></p>
            <input type="submit" value="Download File" id="downloadSubmitButton"/>&nbsp;
            <input type="reset" value="Cancel" onClick="$.fancybox.close();"/>
        </fieldset>
    </form>
</div>