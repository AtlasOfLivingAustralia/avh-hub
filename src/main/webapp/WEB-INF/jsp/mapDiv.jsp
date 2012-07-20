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
        <input id="mapDownloadUrl" type="hidden" value="http://biocache.ala.org.au/ws/webportal/wms/image"/>
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
                    <option>0.1</option>
                    <option>0.2</option>
                    <option>0.3</option>
                    <option>0.4</option>
                    <option>0.5</option>
                    <option>0.6</option>
                    <option>0.7</option>
                    <option>0.8</option>
                    <option>0.9</option>
                    <option selected="true">1</option>
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
                <label for="popacity">Opacity</label>
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
            <p id="colourPickerWrapper">
                <label for="pcolour">Color</label>
                <%--<input type="text" name="pcolour" id="pcolour" value="0000FF" size="6"  />--%>
                <select name="pcolour" id="pcolour">
                    <option value="ffffff">#ffffff</option>
                    <option value="ffccc9">#ffccc9</option>
                    <option value="ffce93">#ffce93</option>
                    <option value="fffc9e">#fffc9e</option>
                    <option value="ffffc7">#ffffc7</option>
                    <option value="9aff99">#9aff99</option>
                    <option value="96fffb">#96fffb</option>
                    <option value="cdffff">#cdffff</option>
                    <option value="cbcefb">#cbcefb</option>
                    <option value="cfcfcf">#cfcfcf</option>
                    <option value="fd6864">#fd6864</option>
                    <option value="fe996b">#fe996b</option>
                    <option value="fffe65">#fffe65</option>
                    <option value="fcff2f">#fcff2f</option>
                    <option value="67fd9a">#67fd9a</option>
                    <option value="38fff8">#38fff8</option>
                    <option value="68fdff">#68fdff</option>
                    <option value="9698ed">#9698ed</option>
                    <option value="c0c0c0">#c0c0c0</option>
                    <option value="fe0000">#fe0000</option>
                    <option value="f8a102">#f8a102</option>
                    <option value="ffcc67">#ffcc67</option>
                    <option value="f8ff00">#f8ff00</option>
                    <option value="34ff34">#34ff34</option>
                    <option value="68cbd0">#68cbd0</option>
                    <option value="34cdf9">#34cdf9</option>
                    <option value="6665cd">#6665cd</option>
                    <option value="9b9b9b">#9b9b9b</option>
                    <option value="cb0000">#cb0000</option>
                    <option value="f56b00">#f56b00</option>
                    <option value="ffcb2f">#ffcb2f</option>
                    <option value="ffc702">#ffc702</option>
                    <option value="32cb00">#32cb00</option>
                    <option value="00d2cb">#00d2cb</option>
                    <option value="3166ff">#3166ff</option>
                    <option value="6434fc">#6434fc</option>
                    <option value="656565">#656565</option>
                    <option value="9a0000">#9a0000</option>
                    <option value="ce6301">#ce6301</option>
                    <option value="cd9934">#cd9934</option>
                    <option value="999903">#999903</option>
                    <option value="009901">#009901</option>
                    <option value="329a9d">#329a9d</option>
                    <option value="3531ff" selected="selected">#3531ff</option>
                    <option value="6200c9">#6200c9</option>
                    <option value="343434">#343434</option>
                    <option value="680100">#680100</option>
                    <option value="963400">#963400</option>
                    <option value="986536">#986536</option>
                    <option value="646809">#646809</option>
                    <option value="036400">#036400</option>
                    <option value="34696d">#34696d</option>
                    <option value="00009b">#00009b</option>
                    <option value="303498">#303498</option>
                    <option value="000000">#000000</option>
                    <option value="330001">#330001</option>
                    <option value="643403">#643403</option>
                    <option value="663234">#663234</option>
                    <option value="343300">#343300</option>
                    <option value="013300">#013300</option>
                    <option value="003532">#003532</option>
                    <option value="010066">#010066</option>
                    <option value="340096">#340096</option>
                </select>
            </p>
            <p>
                <label for="widthmm">Width (mm)</label>
                <input type="text" name="widthmm" id="widthmm" value="150" />
            </p>
            <p>
                <label for="scale_on">Include scale</label>
                <input type="radio" name="scale" value="on" id="scale_on" checked="checked"/> Yes &nbsp;
                <input type="radio" name="scale" value="off" /> No
            </p>
            <p>
                <label for="outline">Outline points</label>
                <input type="radio" name="outline" value="true" id="outline" checked="checked"/> Yes &nbsp;
                <input type="radio" name="outline" value="false" /> No
            </p>
            <p>
                <label for="baselayer">Base layer</label>
                <select name="baselayer" id="baselayer">
                    <option value="world">World outline</option>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/jquery.colourPicker.css" type="text/css" media="screen" />
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.colourPicker.js"></script>
    <script type="text/javascript">

       $('#pcolour').colourPicker({
           ico:    '${pageContext.request.contextPath}/static/images/jquery.colourPicker.gif',
           title:    false
       });
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
                   '&pcolour=' + $(':input[name=pcolour]').val().toUpperCase() +
                   '&widthmm=' + $('#widthmm').val() +
                   '&scale=' + $(':input[name=scale]:checked').val() +
                   '&outline=' + $(':input[name=outline]:checked').val() +
                   '&baselayer=' + $('#baselayer').val()+
                   '&fileName=' + $('#fileName').val()+'.'+$('#format').val().toLowerCase()
           document.location.href = downloadUrl;
       }
    </script>
</div>