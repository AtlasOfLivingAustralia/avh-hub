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
        <input type="hidden" name="url" id="downloadUrl" value="${biocacheServiceUrl}/occurrences/download<c:out value="${searchResults.urlParameters}"/>"/>
        <input type="hidden" name="url" id="downloadChecklistUrl" value="${biocacheServiceUrl}/occurrences/facets/download<c:out value="${searchResults.urlParameters}"/>"/>
        <input type="hidden" name="url" id="downloadFieldGuideUrl" value="${pageContext.request.contextPath}/occurrences/fieldguide/download<c:out value="${searchResults.urlParameters}"/>"/>
        <c:if test="${not empty downloadExtraFields}">
            <input type="hidden" name="extra" id="extraFields" value="${downloadExtraFields}"/>
        </c:if>
        <fieldset>
            <p><label for="email">Email</label>
                <input type="text" name="email" id="email" value="${pageContext.request.remoteUser}" size="30"  />
            </p>
            <p><label for="filename">File Name</label>
                <input type="text" name="filename" id="filename" value="data" size="30"  />
            </p>
            <p><label for="reasonTypeId" style="vertical-align: top">Download Reason</label>
                <select name="reasonTypeId" id="reasonTypeId">
                    <option value="">-- select a reason --</option>
                    <c:forEach var="it" items="${LoggerReason}">
                        <option value="${it.id}">${it.name}</option>
                    </c:forEach>
                </select>
            </p>
            <c:set var="sourceId">
                <c:forEach var="it" items="${LoggerSources}">
                    <c:if test="${fn:toUpperCase(skin) == it.name}">${it.id}</c:if>
                </c:forEach>
            </c:set>
            <input type="hidden" name="sourceTypeId" id="sourceTypeId" value="${sourceId}"/>
            <input type="submit" value="Download All Records" id="downloadSubmitButton"/>&nbsp;
            <input type="submit" value="Download Species Checklist" id="downloadCheckListSubmitButton"/>&nbsp;
            <input type="submit" value="Download Species Field Guide" id="downloadFieldGuideSubmitButton"/>&nbsp;
            <!--
            <input type="reset" value="Cancel" onClick="$.fancybox.close();"/>
            -->
            <p style="margin-top:10px;">
                <strong>Note</strong>: The field guide may take several minutes to prepare and download.
            </p>
            <div id="statusMsg" style="text-align: center; font-weight: bold; "></div>
        </fieldset>
    </form>
    <script type="text/javascript">

        $(document).ready(function() {
            // catch download submit button
            $("#downloadSubmitButton").click(function(e) {
                e.preventDefault();
                var downloadUrl = $("input#downloadUrl").val().replace(/\\ /g, " ");
                var reason = $("#reason").val();
                if(typeof reason == "undefined")
                    reason = "";
                downloadUrl = downloadUrl + "&type=&email="+$("#email").val()+"&sourceTypeId="+$("#sourceTypeId").val()+"&reasonTypeId="+
                        $("#reasonTypeId").val()+"&file="+$("#filename").val()+"&extra="+$(":input#extraFields").val();
                //alert("downloadUrl = " + downloadUrl);
                window.location.href = downloadUrl;
                notifyDownloadStarted();
            });
            // catch checklist download submit button
            $("#downloadCheckListSubmitButton").click(function(e) {
                e.preventDefault();
                var downloadUrl = $("input#downloadChecklistUrl").val().replace(/\\ /g, " ")+"&facets=species_guid&lookup=true&file="+
                       $("#filename").val()+"&sourceTypeId="+$("#sourceTypeId").val()+"&reasonTypeId="+$("#reasonTypeId").val();
                //alert("downloadUrl = " + downloadUrl);
                window.location.href = downloadUrl;
                notifyDownloadStarted();
            });

            // catch checklist download submit button
            $("#downloadFieldGuideSubmitButton").click(function(e) {
                e.preventDefault();
                var downloadUrl = $("input#downloadFieldGuideUrl").val().replace(/\\ /g, " ")+"&facets=species_guid"+"&sourceTypeId="+
                        $("#sourceTypeId").val()+"&reasonTypeId="+$("#reasonTypeId").val();
                window.open(downloadUrl);
                notifyDownloadStarted();
            });
        });

        function notifyDownloadStarted() {
            $("#statusMsg").html("Download has commenced");
            window.setTimeout(function() {
                $("#statusMsg").html("");
                $.fancybox.close();
            }, 2000);
        }

    </script>
</div>