<%@ page contentType="text/html;charset=UTF-8" %>
<style type="text/css">

#leafletMap {
    cursor: pointer;
    font-size: 12px;
    line-height: 18px;
}
#leafletMap, input {
    margin:0px;
}
</style>

<table id="mapLayerControls">
<tr>
    <td>
        <label for="colourFacets">Colour by:&nbsp;</label>
        <div class="layerControls">
            <select name="colourFacets" id="colourFacets">
                <option value=""> None </option>
                <g:each var="facetResult" in="${facets}">
                    <g:set var="Defaultselected">
                        <g:if test="${defaultColourBy && facetResult.fieldName == defaultColourBy}">selected="selected"</g:if>
                    </g:set>
                    <g:if test="${facetResult.fieldResult.size() > 1}">
                        <option value="${facetResult.fieldName}" ${Defaultselected}>
                            <alatag:formatDynamicFacetName fieldName="${facetResult.fieldName}"/>
                        </option>
                    </g:if>
                </g:each>
            </select>
        </div>
    </td>
    <g:if test="${skin == 'avh'}">
        <td>
            <label for="envLyrList">Environmental layer:&nbsp;</label>
            <div class="layerControls">
                <select id="envLyrList">
                    <option value="">None</option>
                </select>
            </div>
        </td>
        </tr>
        <tr>
    </g:if>
    <td>
        <label for="sizeslider">Size:</label>
        <div class="layerControls">
            <span id="sizeslider-val">4</span>
            <div id="sizeslider"></div>
        </div>
    </td>
    <td>
        <g:set var='spatialPortalLink' value="${sr.urlParameters}"/>
        <g:set var='spatialPortalUrlParams' value="${grailsApplication.config.spatialPortalUrlParams}" />
        <div id="downloadMaps" class="btn btn-small">
            <a id="spatialPortalLink" href="${grailsApplication.config.spatialPortalUrl}${spatialPortalLink}${spatialPortalUrlParams}">View in spatial portal</a>
        </div>
        <div id="downloadMaps" class="btn btn-small">
            <a href="#downloadMap" id="downloadMapLink" title="Download a publication quality map">Download map</a>
        </div>
    </td>
</tr>
</table>

<div id="leafletMap" class="span12" style="height:600px;"></div>
<div id="template" style="display:none">
    <div class="colourbyTemplate">
        <a class="leaflet-control-layers-toggle colour-by-control" href="#" title="Layers"></a>
        <form class="leaflet-control-layers-list">
            <div class="leaflet-control-layers-base">
                <label>
                    <span>Colour by: </span>
                    <select name="colourBySelect">
                        <option>Specimen type</option>
                        <option>Dataset</option>
                        <option>Collector</option>
                    </select>
                </label>
            </div>
            <div class="leaflet-control-layers-separator"></div>
            <div class="leaflet-control-layers-overlays">
                <label><input type="checkbox" class="leaflet-control-layers-selector" checked=""><span>
                    <img src="http://biocache.ala.org.au/ws/occurrences/legend?colourby=3368652&amp;width=10&amp;height=10&amp;qc="/> Observation</span></label>
                <label><input type="checkbox" class="leaflet-control-layers-selector" checked=""><span>
                    <img src="http://biocache.ala.org.au/ws/occurrences/legend?colourby=3368652&amp;width=10&amp;height=10&amp;qc="/> Specimen</span></label>
                <label><input type="checkbox" class="leaflet-control-layers-selector" checked=""><span>
                    <img src="http://biocache.ala.org.au/ws/occurrences/legend?colourby=3368652&amp;width=10&amp;height=10&amp;qc="/> GenomicDNA</span></label>
                <label><input type="checkbox" class="leaflet-control-layers-selector" checked=""><span>
                    <img src="http://biocache.ala.org.au/ws/occurrences/legend?colourby=3368652&amp;width=10&amp;height=10&amp;qc="/> Image</span></label>
            </div>
        </form>
    </div>
</div>

<div id="recordPopup" style="display:none;">
    <a href="#">View records at this point</a>
</div>


<r:script>

    var MAP_VAR = {
        colourlist : new Array('3366cc', 'dc3912', 'ff99', '109618', '9999', '99c6', 'dd4477',
                '66aa', 'b82e2e', '316395', '994499', '22aa99', 'aaaa11', '6633cc', 'e673', '8b0707',
                '651067', '329262', '5574a6', '3b3eac', 'b77322', '16d620', 'b91383', 'f4359e', '9c5935',
                'a9c413', '2a778d', '668d1c', 'bea413', '0c5922', '743411'),
        mappingUrl : "${mappingUrl}",
        query : "${searchString}",
        queryDisplayString : "${queryDisplayString}",
        facetLimit : 30,
        foffset : 0,
        map : null,
        queryLayers : new Array(),
        overlays : {},
        baseLayers : null,
        layerControl : null,
        currentLayers : []
    };

    function initialiseMap(){

        //add a base layer
        var cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
                cmUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';

        var minimal   = L.tileLayer(cmUrl, {styleId: 22677, attribution: cmAttr}),
                midnight  = L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr}),
                motorways = L.tileLayer(cmUrl, {styleId: 46561, attribution: cmAttr});

        var gmap_layer = new L.Google('ROADMAP');
        var gmap_terrain_layer = new L.Google('TERRAIN');
        var gmap_sat_layer = new L.Google('SATELLITE');
        var gmap_hybrid_layer = new L.Google('HYBRID');

        MAP_VAR.baseLayers = {
            "Minimal" : minimal,
            "Night view" : midnight,
            "Road" : gmap_layer,
            "Terrain" : gmap_terrain_layer,
            "Hybrid" : gmap_hybrid_layer,
            "Satellite" : gmap_sat_layer
        };

        MAP_VAR.map = L.map('leafletMap', {
            center: [-23.6,133.6],
            zoom: 4
        });

        //add the default base layer
        MAP_VAR.map.addLayer(minimal);

        MAP_VAR.layerControl = L.control.layers(MAP_VAR.baseLayers, MAP_VAR.overlays, {collapsed:true});
        MAP_VAR.layerControl.addTo(MAP_VAR.map);

        addLayersByFacet();

        MAP_VAR.map.on('click', onMapClick);

        var MyControl = L.Control.extend({
            options: {
                position: 'topright',
                collapsed: true
            },
            onAdd: function (map) {
                // create the control container with a particular class name
                var $controlToAdd = $('.colourbyTemplate').clone();
                var container = L.DomUtil.create('div', 'leaflet-control-layers');
                var $container = $(container);
                $container.attr('aria-haspopup', true);
                $container.html($controlToAdd.html());
                return container;
            }
        });

//        map.addControl(new MyControl());

        %{--$('.colour-by-control').click(function(){--}%
            %{--$(this).parent().addClass('leaflet-control-layers-expanded');--}%
        %{--});--}%


    L.Util.requestAnimFrame(MAP_VAR.map.invalidateSize, MAP_VAR.map, !1, MAP_VAR.map._container);

    $('#colourFacets').change(function() {
        //remove the existing layers
//        alert('Colour by: ' + $('#colourFacets').val())
        addLayersByFacet();
    });
}

    function addLayersByFacet(){

        console.log('Current layers - ' + MAP_VAR.currentLayers.length);
        $.each(MAP_VAR.currentLayers, function(index, value){
            console.log('Removing - ' + MAP_VAR.currentLayers[index]);
            MAP_VAR.map.removeLayer(MAP_VAR.currentLayers[index]);
        });

        MAP_VAR.currentLayers = [];

        var colourByFacet = $('#colourFacets').val();

        var envProperty = "color:ff9900;name:circle;size:5;opacity:1"

        if(colourByFacet){
            envProperty = "colormode:" + colourByFacet +";name:circle;size:5;opacity:1"
        }

        var layer = L.tileLayer.wms(MAP_VAR.mappingUrl + "/webportal/wms/reflect" + MAP_VAR.query, {
            layers: 'ALA:occurrences',
            format: 'image/png',
            transparent: true,
            attribution: "${grailsApplication.config.skin.orgNameLong}",
            bgcolor:"0x000000",
            outline:"true",
            ENV: envProperty
        });
        MAP_VAR.layerControl.addOverlay(layer, 'query layer');
        MAP_VAR.map.addLayer(layer);
        MAP_VAR.currentLayers.push(layer);
    }



%{--function addLayersByFacetXXXXXX(map, layerControl, colourByFacet){--}%

    %{--var jsonUri = BC_CONF.biocacheServiceUrl + "/occurrences/search.json"--}%
        %{--+ query +--}%
        %{--"&flimit=" + facetLimit + "&foffset=" + foffset + "&pageSize=0";--}%


    %{--if(colourByFacet){--}%
       %{--jsonUri = jsonUri + "&facets=" + colourByFacet;--}%
    %{--}--}%

    %{--jsonUri = jsonUri + "&callback=?";--}%

    %{--//remove existing layers--}%


    %{--$.each(currentLayers, function(value, index){--}%
        %{--layerControl.removeLayer(currentLayers[index]);--}%
    %{--});--}%

    %{--currentLayers = [];--}%


    %{--$.getJSON(jsonUri, function(data) {--}%
        %{--//console.log("data",data);--}%
        %{--if (data.totalRecords && data.totalRecords > 0) {--}%
            %{--$.each(data.facetResults[0].fieldResult, function(index, value){--}%
                %{--console.log(value.label + " = " + value.count);--}%
                %{--if(value.count > 0){--}%
                    %{--var queryLayer = L.tileLayer.wms(mappingUrl + "/webportal/wms/reflect" + query + '&fq=' + colourByFacet + '%3A'+ value.label, {--}%
                        %{--layers: 'ALA:occurrences',--}%
                        %{--format: 'image/png',--}%
                        %{--transparent: true,--}%
                        %{--attribution: "${grailsApplication.config.skin.orgNameLong}",--}%
                        %{--bgcolor:"0x000000",--}%
                        %{--outline:"true",--}%
                        %{--ENV: "color:" + colourlist[index] +";name:circle;size:5;opacity:1"--}%
                    %{--});--}%
                    %{--layerControl.addOverlay(queryLayer, value.label);--}%
                    %{--map.addLayer(queryLayer);--}%
                    %{--currentLayers.push(queryLayer);--}%
                %{--}--}%
            %{--});--}%
        %{--}--}%
    %{--});--}%
%{--}--}%


function onMapClick(e) {
//    alert('clicked');

    var popup = L.popup()
        .setLatLng(e.latlng)
        .setContent("<div>Loading....</div>")
        .openOn(MAP_VAR.map);

    $.ajax({
        url: MAP_VAR.mappingUrl + "/occurrences/info" + MAP_VAR.query,
        jsonp: "callback",
        dataType: "jsonp",
        data: {
            zoom: MAP_VAR.map.getZoom(),
            lat: e.latlng.lat,
            lon: e.latlng.lng,
            radius: 20,
            format: "json"
        },
        success: function(response) {
            if(response.count){
                popup.setContent("<div><h3>Records: " + response.count + "</h3></div>");
            } else {
                popup.setContent("<div>No records at this point</div>");
            }
        }
    });
}
</r:script>