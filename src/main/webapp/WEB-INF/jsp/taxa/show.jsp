<%-- 
    Document   : collection
    Created on : Feb 22, 2011, 11:49:55 AM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="hostName" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}"/>
<c:set var="queryContext" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.queryContext"/></c:set>
<c:set var="hubDisplayName" scope="request"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="biocacheServiceUrl" scope="request"><ala:propertyLoader bundle="hubs" property="biocacheRestService.biocacheUriPrefix"/></c:set>
<c:set var="spatialPortalUrl" scope="request"><ala:propertyLoader bundle="hubs" property="spatialPortalUrl"/></c:set>
<c:set var="bieWebappContext" scope="request"><ala:propertyLoader bundle="hubs" property="bieWebappContext"/></c:set>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="decorator" content="${skin}"/>
        <title>${taxon.scientificName} | ${hubDisplayName}</title>
        <script type="text/javascript">
            /**
             * JQuery on document ready callback
             */
            $(document).ready(function() {
              $("a.imgThumb").fancybox({titlePosition: 'inside'});
                
              $('img.distroLegend').each(function(i, n) {
               // if img doesn't load, then hide its surround div
                $(this).error(function() {
                    //alert("img error");
                    $(this).parent().hide();
                 });
                 // IE hack as IE doesn't trigger the error handler
                 if ($.browser.msie && !n.complete) {
                     //alert("IE img error");
                     $(this).parent().hide();
                 }
              });                
            });
        </script>
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty taxon}">
                <div id="headingBar" class="fullWidthHeader">
                    <h1>${taxon.rank}: <span id="taxonName"><alatag:formatSciName rankId="${taxon.rankId}" name="${taxon.scientificName}"/> ${taxon.author}</span></h1>
                    <h2>${taxon.allCommonNames}</h2>
                </div>
                <div id="SidebarBox">
                    <div class="sidebar">
                        <c:forEach var="image" items="${taxon.images}">
                            <div class="imageThumb">
                                <a href="${image.repoLocation}" title="Source: <a href='${image.isPartOf}' target='_blank'>${image.infoSourceName}</a><br/>Creator: ${(not empty image.creator) ? image.creator : 'N/A'}<br/>Rights: <a href='${image.licence}' target='_blank'>${(not empty image.rights) ? image.rights : ''}</a>${(empty image.licence) ? 'N/A' : ''}"
                                   class="imgThumb" rel="thumbs"><img src="${image.thumbnail}" title="Source: ${image.infoSourceName} ${(not empty image.creator) ? 'by' :''} ${image.creator}" alt="${image.title}"/></a>
                            </div>
                        </c:forEach>
                        &nbsp;
                    </div>
                </div><!-- end div#SidebarBox --> 
                <div id="content2">

                    <div><img src="${biocacheServiceUrl}/density/map?q=lft:[${taxon.left} TO ${taxon.right}] AND ${queryContext}"/></div>
                    <div><img class="img.distroLegend" src="${biocacheServiceUrl}/density/legend?q=lft:[${taxon.left} TO ${taxon.right}] AND ${queryContext}"/></div>

                    <c:if test="${not empty taxon.description}">
                        <h3>Description</h3>
                        <div class="taxaDescription">${taxon.description}</div>
                    </c:if>
                    <c:if test="${not empty taxon.classification}">
                        <h3>Classification</h3>
                        <div class="taxaDescription">${taxon.classification}</div>
                    </c:if>
                    <c:if test="${not empty taxon.references}">
                        <br/>
                        <h3>References</h3>
                        <ul>
                            <c:forEach var="ref" items="${taxon.references}">
                               <li>${ref}</li>
                            </c:forEach>
                        </ul>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <h2>Not Found</h2>
                <div>The requested taxon page "${guid}" could not be found.</div>
            </c:otherwise>
        </c:choose>
    </body>
</html>
