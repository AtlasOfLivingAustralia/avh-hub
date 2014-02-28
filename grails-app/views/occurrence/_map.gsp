<%@ page contentType="text/html;charset=UTF-8" %>
<style type="text/css">

#leafletMap {
    cursor: pointer;
    font-size: 12px;
    line-height: 18px;
}

#leafletMap, input {
    margin: 0px;
}

.leaflet-control-layers-base  {
    font-size: 12px;
}

.leaflet-control-layers-base label,  .leaflet-control-layers-base input, .leaflet-control-layers-base button, .leaflet-control-layers-base select, .leaflet-control-layers-base textarea {
    margin:0px;
    height:20px;
    font-size: 12px;
    line-height:18px;
    width:auto;
}

.leaflet-control-layers {
    opacity:0.8;
    filter:alpha(opacity=80);
}

.leaflet-control-layers-overlays label {
    font-size: 12px;
    line-height: 18px;
    margin-bottom: 0px;
}

.leaflet-drag-target {
    line-height:18px;
    font-size: 12px;
}

i.legendColour {
    -webkit-background-clip: border-box;
    -webkit-background-origin: padding-box;
    -webkit-background-size: auto;
    background-attachment: scroll;
    background-clip: border-box;
    background-image: none;
    background-origin: padding-box;
    background-size: auto;
    display: inline-block;
    height: 12px;
    line-height: 12px;
    width: 14px;
    margin-bottom: -5px;
    margin-left:2px;
    margin-right:2px;
    opacity:1;
    filter:alpha(opacity=100);
}

i#defaultLegendColour {
    margin-bottom: -2px;
    margin-left: 2px;
    margin-right: 5px;
}

.legendTable {
    padding: 0px;
    margin: 0px;
}

a.colour-by-legend-toggle {
    color: #000000;
    text-decoration: none;
    cursor: auto;
    display: block;
    font-family: 'Helvetica Neue', Arial, Helvetica, sans-serif;
    font-size: 14px;
    font-style: normal;
    font-variant: normal;
    font-weight: normal;
    line-height: 18px;
    text-decoration: none solid rgb(0, 120, 168);
    padding:10px;
}

</style>

<table id="mapLayerControls">
<tr>
    <td>
        <label for="colourBySelect">Colour by:&nbsp;</label>

        <div class="layerControls">
            <select name="colourFacets" id="colourBySelect">
                <option value="">None</option>
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
    <td class="pull-right">
        <g:set var='spatialPortalLink' value="${sr.urlParameters}"/>
        <g:set var='spatialPortalUrlParams' value="${grailsApplication.config.spatialPortalUrlParams}"/>
        <div id="downloadMaps" class="btn btn-small">
            <a id="spatialPortalLink"
               href="${grailsApplication.config.spatialPortalUrl}${spatialPortalLink}${spatialPortalUrlParams}">View in spatial portal</a>
        </div>
        <div id="downloadMaps" class="btn btn-small">
            <a href="#downloadMap" id="downloadMapLink" title="Download a publication quality map">
                <i class="icon-download"></i> Download map</a>
        </div>
    </td>
</tr>
</table>

<div id="leafletMap" class="span12" style="height:600px;"></div>

<div id="template" style="display:none">
    <div class="colourbyTemplate">
        <a class="colour-by-legend-toggle colour-by-control" href="#" title="Map legend">Legend</a>
        <form class="leaflet-control-layers-list">
            <div class="leaflet-control-layers-overlays">
                <div style="overflow:auto; max-height:400px;">
                    <a href="#" class="hideColourControl pull-right" style="padding-left:10px;"><i class="icon-remove icon-grey"></i></a>
                    <table class="legendTable"></table>
                </div>
            </div>
        </form>
    </div>
</div>


<div id="recordPopup" style="display:none;">
    <a href="#">View records at this point</a>
</div>


<r:script>

    var cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
            cmUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';

    var minimal = L.tileLayer(cmUrl, {styleId: 22677, attribution: cmAttr});

    var MAP_VAR = {
        mappingUrl : "${mappingUrl}",
        query : "${searchString}",
        queryDisplayString : "${queryDisplayString}",
        map : null,
        overlays : {},
        baseLayers : {
            "Minimal" : minimal,
            "Night view" : L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr}),
            "Road" : new L.Google('ROADMAP'),
            "Terrain" : new L.Google('TERRAIN'),
            "Satellite" : new L.Google('HYBRID')
        },
        layerControl : null,
        currentLayers : [],
        additionalFqs : '',
    };

    var ColourByControl = L.Control.extend({
        options: {
            position: 'topright',
            collapsed: false
        },
        onAdd: function (map) {
            // create the control container with a particular class name
            var $controlToAdd = $('.colourbyTemplate').clone();
            var container = L.DomUtil.create('div', 'leaflet-control-layers');
            var $container = $(container);
            $container.attr("id","colourByControl");
            $container.attr('aria-haspopup', true);
            $container.html($controlToAdd.html());
            return container;
        }
    });

    function initialiseMap(){

        if(MAP_VAR.map != null){
            return;
        }

        //initialise map
        MAP_VAR.map = L.map('leafletMap', {
            center: [-23.6,133.6],
            zoom: 4,
            scrollWheelZoom: false
        });

        //add the default base layer
        MAP_VAR.map.addLayer(minimal);

        MAP_VAR.layerControl = L.control.layers(MAP_VAR.baseLayers, MAP_VAR.overlays, {collapsed:true, position:'topleft'});
        MAP_VAR.layerControl.addTo(MAP_VAR.map);

        addQueryLayer(true);

        MAP_VAR.map.addControl(new ColourByControl());

        L.Util.requestAnimFrame(MAP_VAR.map.invalidateSize, MAP_VAR.map, !1, MAP_VAR.map._container);

        $('#colourBySelect').change(function(e) {
            MAP_VAR.additionalFqs = '';
            addQueryLayer(true);
        });

        $('.colour-by-control').click(function(e){

            if($(this).parent().hasClass('leaflet-control-layers-expanded')){
                $(this).parent().removeClass('leaflet-control-layers-expanded');
                $('.colour-by-legend-toggle').show();
            } else {
                $(this).parent().addClass('leaflet-control-layers-expanded');
                $('.colour-by-legend-toggle').hide();
            }
            e.preventDefault();
            e.stopPropagation();
            return false;
        });

        $('#colourByControl').mouseover(function(e){
            MAP_VAR.map.dragging.disable();
            MAP_VAR.map.off('click', pointLookup);
        });

        $('#colourByControl').mouseout(function(e){
            MAP_VAR.map.dragging.enable();
            MAP_VAR.map.on('click', pointLookup);
        });

        $('.hideColourControl').click(function(e){
            $('#colourByControl').removeClass('leaflet-control-layers-expanded');
            $('.colour-by-legend-toggle').show();
            e.preventDefault();
            e.stopPropagation();
            return false;
        });

        //enable the point lookup
        //MAP_VAR.map.on('click', pointLookup);
        var clickCount = 0;
        MAP_VAR.map.on('click', function(e) {
            clickCount += 1;
            if (clickCount <= 1) {
                setTimeout(function() {
                    if (clickCount <= 1) {
                        pointLookup(e);
                    }
                    clickCount = 0;
                }, 400);
            }
        });
    }

    /**
     * A tile layer to map colouring the dots by the selected colour.
     */
    function addQueryLayer(redraw){

        console.log('Current layers - ' + MAP_VAR.currentLayers.length);
        $.each(MAP_VAR.currentLayers, function(index, value){
            console.log('Removing - ' + MAP_VAR.currentLayers[index]);
            MAP_VAR.map.removeLayer(MAP_VAR.currentLayers[index]);
            MAP_VAR.layerControl.removeLayer(MAP_VAR.currentLayers[index]);
        });

        MAP_VAR.currentLayers = [];

        var colourByFacet = $('#colourBySelect').val();

        var envProperty = "color:${grailsApplication.config.map.pointColour};name:circle;size:5;opacity:1"

        if(colourByFacet){
            envProperty = "colormode:" + colourByFacet +";name:circle;size:5;opacity:1"
        }

        var layer = L.tileLayer.wms(MAP_VAR.mappingUrl + "/webportal/wms/reflect" + MAP_VAR.query + MAP_VAR.additionalFqs, {
            layers: 'ALA:occurrences',
            format: 'image/png',
            transparent: true,
            attribution: "${grailsApplication.config.skin.orgNameLong}",
            bgcolor:"0x000000",
            outline:"true",
            ENV: envProperty
        });

        if(redraw){
             if(!colourByFacet){
                $('.legendTable').html('');
                addDefaultLegendItem("${grailsApplication.config.map.pointColour}");
             } else {
                //update the legend
                $('.legendTable').html('<tr><td>Loading legend....</td></tr>');
                $.ajax({
                    url: "${grailsApplication.config.security.cas.contextPath}/occurrence/legend" + MAP_VAR.query + "&cm=" + colourByFacet + "&type=application/json",
                    success: function(data) {
                        $('.legendTable').html('');

                        $.each(data, function(index, legendDef){
                            var legItemName = legendDef.name ? legendDef.name : 'Not specified';
                            addLegendItem(legItemName, legendDef.red,legendDef.green,legendDef.blue );
                        });

                        $('.layerFacet').click(function(e){
                            var controlIdx = 0;
                            MAP_VAR.additionalFqs = '';
                            $('#colourByControl').find('.layerFacet').each(function(idx, layerInput){
                                var include =  $(layerInput).is(':checked');

                                if(!include){
                                    MAP_VAR.additionalFqs = MAP_VAR.additionalFqs + '&HQ=' + controlIdx;
                                }
                                controlIdx = controlIdx + 1;
                                addQueryLayer(false);
                            });
                            console.log('additionalFqs: ' + MAP_VAR.additionalFqs);
                        });
                    }
                });
            }
        }
        MAP_VAR.layerControl.addOverlay(layer, 'Occurrences');
        MAP_VAR.map.addLayer(layer);
        MAP_VAR.currentLayers.push(layer);
    }

    function addDefaultLegendItem(pointColour){
        $(".legendTable")
            .append($('<tr>')
                .append($('<td>')
                    .append($('<i>')
                        .addClass('legendColour')
                        .attr('style', "background-color:#"+ pointColour + ";")
                        .attr('id', 'defaultLegendColour')
                    )
                    .append($('<span>')
                        .addClass('legendItemName')
                        .html("All records")
                    )
                )
        );
    }

    function addLegendItem(name, red, green, blue){
        $(".legendTable")
            .append($('<tr>')
                .append($('<td>')
                    .append($('<input>')
                        .attr('type', 'checkbox')
                        .attr('checked', 'checked')
                        .attr('id', name)
                        .addClass('layerFacet')
                        .addClass('leaflet-control-layers-selector')
                    )
                )
                .append($('<td>')
                    .append($('<i>')
                        .addClass('legendColour')
                        .attr('style', "background-color:rgb("+ red +","+ green +","+ blue + ");")
                    )
                    .append($('<span>')
                        .addClass('legendItemName')
                        .html(name)
                    )
                )
        );
    }

    function rgbToHex(redD, greenD, blueD){
        var red = parseInt(redD);
        var green = parseInt(greenD);
        var blue = parseInt(blueD);

        var rgb = blue | (green << 8) | (red << 16);
        return rgb.toString(16);
    }

    /**
     * Event handler for point lookup.
     * @param e
     */
    function pointLookup(e) {

        console.log('pointLookup fired');
        console.log(e.target);

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