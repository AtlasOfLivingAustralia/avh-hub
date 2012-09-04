<%-- 
    Document   : downloadDiv
    Created on : Feb 25, 2011, 4:20:32 PM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@ include file="/common/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="download">
    <p id="termsOfUseDownload">
        By downloading this content you are agreeing to use it in accordance with the Atlas of Living Australia
        <a href="http://www.ala.org.au/about/terms-of-use/#TOUusingcontent">Terms of Use</a> and any Data Provider
        Terms associated with the data download.
        <br/><br/>
        Please provide the following details before downloading (* required):
    </p>
    <form id="downloadForm">
        <input type="hidden" name="searchParams" id="searchParams" value="<c:out value="${searchResults.urlParameters}"/>"/>
        <c:choose>
            <c:when test="${clubView}">
                <input type="hidden" name="url" id="downloadUrl" value="${pageContext.request.contextPath}/proxy/download/download"/>
                <input type="hidden" name="url" id="fastDownloadUrl" value="${pageContext.request.contextPath}/proxy/download/index/download"/>
            </c:when>
            <c:otherwise>
                <input type="hidden" name="url" id="downloadUrl" value="${biocacheServiceUrl}/occurrences/download"/>
                <input type="hidden" name="url" id="fastDownloadUrl" value="${biocacheServiceUrl}/occurrences/index/download"/>
            </c:otherwise>
        </c:choose>
        <input type="hidden" name="url" id="downloadChecklistUrl" value="${biocacheServiceUrl}/occurrences/facets/download"/>
        <input type="hidden" name="url" id="downloadFieldGuideUrl" value="${pageContext.request.contextPath}/occurrences/fieldguide/download"/>
        <input type="hidden" name="extra" id="extraFields" value="${downloadExtraFields}"/>
        <input type="hidden" name="sourceTypeId" id="sourceTypeId" value="${sourceId}"/>

        <fieldset>
            <div><label for="email">Email</label>
                <input type="text" name="email" id="email" value="${pageContext.request.remoteUser}" size="30"  />
            </div>
            <div><label for="filename">Filename</label>
                <input type="text" name="filename" id="filename" value="data" size="30"  />
            </div>
            <div><label for="reasonTypeId" style="vertical-align: top">Download reason *</label>
                <select name="reasonTypeId" id="reasonTypeId">
                    <option value="">-- select a reason --</option>
                    <c:forEach var="it" items="${LoggerReason}">
                        <option value="${it.id}">${it.name}</option>
                    </c:forEach>
                </select>
            </div>
            <c:set var="sourceId">
                <c:forEach var="it" items="${LoggerSources}">
                    <c:if test="${fn:toUpperCase(skin) == it.name}">${it.id}</c:if>
                </c:forEach>
            </c:set>
            <div>
                <label for="filename"div style="float: left;">Download type</label>
                <div style="display: inline-block; width: 55%; float: left; padding-left: 5px;">
                    <input type="radio" name="downloadType" value="fast" class="tooltip" title="Faster download but fewer fields are included" checked="checked"/>&nbsp;All Records (fast)<br/>
                    <input type="radio" name="downloadType" value="detailed" class="tooltip" title="Slower download but all fields are included"/>&nbsp;All Records (detailed)<br/>
                    <input type="radio" name="downloadType" value="checklist"  class="tooltip" title="Lists all taxa from the current search results"/>&nbsp;Species Checklist<br/>
                    <c:if test="${skin != 'avh'}">
                        <input type="radio" name="downloadType" value="fieldGuide" class="tooltip" title="PDF file listing species with images and distribution maps"/>&nbsp;Species Field Guide
                    </c:if>
                </div>
            </div>

            <div style="clear: both; text-align: center;">
                <br/><input type="submit" value="Start Download" id="downloadStart" class="tooltip"/>
            </div>

            <div style="margin-top:10px;">
                <strong>Note</strong>: The field guide may take several minutes to prepare and download.
            </div>
            <div id="statusMsg" style="text-align: center; font-weight: bold; "></div>
        </fieldset>
    </form>
    <script type="text/javascript">

        $(document).ready(function() {
            // catch download submit button
            // Note the unbind().bind() syntax - due to Jquery ready being inside <body> tag.

            // start download button
            $(":input#downloadStart").unbind("click").bind("click",function(e) {
                e.preventDefault();
                var downloadType = $('input:radio[name=downloadType]:checked').val();

                if (validateForm()) {
                    if (downloadType == "fast") {
                        var downloadUrl = generateDownloadPrefix($(":input#fastDownloadUrl").val())+"&email="+$("#email").val()+"&sourceTypeId="+$("#sourceTypeId").val()+"&reasonTypeId="+
                                $("#reasonTypeId").val()+"&file="+$("#filename").val()+"&extra="+$(":input#extraFields").val();
                        //alert("downloadUrl = " + downloadUrl);
                        window.location.href = downloadUrl;
                        notifyDownloadStarted();
                    } else if (downloadType == "detailed") {
                        var downloadUrl = generateDownloadPrefix($(":input#downloadUrl").val())+"&email="+$("#email").val()+"&sourceTypeId="+$("#sourceTypeId").val()+"&reasonTypeId="+
                                $("#reasonTypeId").val()+"&file="+$("#filename").val()+"&extra="+$(":input#extraFields").val();
                        //alert("downloadUrl = " + downloadUrl);
                        window.location.href = downloadUrl;
                        notifyDownloadStarted();
                    } else if (downloadType == "checklist") {
                        var downloadUrl = generateDownloadPrefix($("input#downloadChecklistUrl").val())+"&facets=species_guid&lookup=true&file="+
                                $("#filename").val()+"&sourceTypeId="+$("#sourceTypeId").val()+"&reasonTypeId="+$("#reasonTypeId").val();
                        //alert("downloadUrl = " + downloadUrl);
                        window.location.href = downloadUrl;
                        notifyDownloadStarted();
                    } else if (downloadType == "fieldGuide") {
                        var downloadUrl = generateDownloadPrefix($("input#downloadFieldGuideUrl").val())+"&facets=species_guid"+"&sourceTypeId="+
                                $("#sourceTypeId").val()+"&reasonTypeId="+$("#reasonTypeId").val();
                        window.open(downloadUrl);
                        notifyDownloadStarted();
                    } else {
                        alert("download type not recognised");
                    }
                }
            });


        });

        function generateDownloadPrefix(downloadUrlPrefix) {
            downloadUrlPrefix = downloadUrlPrefix.replace(/\\ /g, " ");
            var searchParams = $(":input#searchParams").val();
            if (searchParams) {
                downloadUrlPrefix += searchParams;
            } else {
                // EYA page is JS driven
                downloadUrlPrefix += "?q=*:*&lat="+$('#latitude').val()+"&lon="+$('#longitude').val()+"&radius="+$('#radius').val();
                if (speciesGroup && speciesGroup != "ALL_SPECIES") {
                    downloadUrlPrefix += "&fq=species_group:" + speciesGroup;
                }
            }

            return downloadUrlPrefix;
        }

        function notifyDownloadStarted() {
            $("#statusMsg").html("Download has commenced");
            window.setTimeout(function() {
                $("#statusMsg").html("");
                $.fancybox.close();
            }, 2000);
        }

        function validateForm() {
            var isValid = false;
            var reasonId = $("#reasonTypeId option:selected").val();

            if (reasonId) {
                isValid = true;
            } else {
                $("#reasonTypeId").focus();
                $("label[for='reasonTypeId']").css("color","red");
                alert("Please select a \"download reason\" from the drop-down list");
            }

            return isValid;
        }

    </script>
</div>