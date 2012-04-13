<%-- 
    Document   : downloadDiv
    Created on : Feb 25, 2011, 4:20:32 PM
    Author     : "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
--%>
<%@ include file="/common/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="downloadMap">
    <h2>Download publication map</h2>
    <form id="downloadMapForm">
        <input id="mapDownloadUrl" type="hidden" value="http://biocache-test.ala.org.au/ws/webportal/wms/image"/>
        <fieldset>
            <p><label for="format">Format</label>
                <select name="format" id="format">
                   <option value="jpg">JPEG</option>
                   <option value="png">PNG</option>
                </select>
            </p>
            <p>
                <label for="dpi">Quality (DPI)</label>
                <select name="dpi" id="dpi">
                    <option value="100">100</option>
                    <option value="300" selected="true">300</option>
                    <option value="600">600</option>
                </select>
            </p>
            <p>
                <label for="pradiusmm">Point radius (mm)</label>
                <select name="pradiusmm" id="pradiusmm">
                    <option>1</option>
                    <option>2</option>
                    <option>3</option>
                    <option>4</option>
                    <option>5</option>
                    <option>6</option>
                    <option>7</option>
                    <option>8</option>
                    <option>9</option>
                    <option>10</option>
                </select>
            </p>
            <p>
                <label for="popacity">Opacity (mm)</label>
                <select name="popacity" id="popacity">
                    <option>1</option>
                    <option>0.9</option>
                    <option>0.8</option>
                    <option>0.7</option>
                    <option>0.6</option>
                    <option>0.5</option>
                    <option>0.4</option>
                    <option>0.3</option>
                    <option>0.2</option>
                    <option>0.1</option>
                </select>
            </p>
            <p>
                <label for="pcolour">Color</label>
                <input type="text" name="pcolour" id="pcolour" value="0000FF" size="6"  />
            </p>
            <p>
                <label for="widthmm">Width (mm)</label>
                <input type="text" name="widthmm" id="widthmm" value="150" />
            </p>
            <!--
            <p>
                <label for="scale">Include scale</label>
                <checkbox name="scale" id="scale" value="on"/>
            </p>
            -->
            <p>
                <label for="baselayer">Base layer</label>
                <select name="baselayer" id="baselayer">
                    <option value="aus1">States & Territories</option>
                    <option value="aus2">Local government areas</option>
                    <option value="ibra_merged">IBRA</option>
                    <option value="ibra_sub_merged">IBRA sub regions</option>
                    <option value="imcra4_pb">IMCRA</option>
                </select>
            </p>
            <p>
                <label for="fileName">File name (without extension)</label>
                <input type="text" name="fileName" id="fileName" value="MyMap"/>
            </p>
            <p>
                <input id="submitDownloadMap" type="button" value="Download map" />
            </p>
        </fieldset>
    </form>
    <!--
    $('#mapDownloadUrl').val()
    extents=142,-45,151,-38
    &q=macropus
    &format=jpg
    &dpi=100
    &pradiusmm=1
    &popacity=0.8
    &pcolour=0000FF
    &widthmm=150
    &scale=on
    &baselayer=aus2
    -->
    <script type="text/javascript">

       $('#submitDownloadMap').click(function(){downloadMapNow();});

       function downloadMapNow(){

           var bounds = map.getBounds();
           var ne =  bounds.getNorthEast();
           var sw =  bounds.getSouthWest();
           var extents = sw.lng() + ',' + sw.lat() + ',' + ne.lng() + ','+ ne.lat();

           var downloadUrl =  $('#mapDownloadUrl').val() +
                   '${searchRequestParams.urlParams}' +
                   //'&extents=' + '142,-45,151,-38' +  //need to retrieve the
                   '&extents=' + extents +  //need to retrieve the
                   '&format=' + $('#format').val() +
                   '&dpi=' + $('#dpi').val() +
                   '&pradiusmm=' + $('#pradiusmm').val() +
                   '&popacity=' + $('#popacity').val() +
                   '&pcolour=' + $('#pcolour').val() +
                   '&widthmm=' + $('#widthmm').val() +
                   '&scale=' + $('#scale').val() +
                   '&baselayer=' + $('#baselayer').val()+
                   '&fileName=' + $('#fileName').val()+'.'+$('#format').val().toLowerCase()

           document.location.href = downloadUrl;
       }
    </script>
</div>