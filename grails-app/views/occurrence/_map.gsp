<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container-fluid">
    <div class="row-fluid">
        <div id="leafletMap" class="span12" style="height:600px;"></div>
    </div>
</div>

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
<r:script>

    var mappingUrl = "${mappingUrl}";
    var query = "${searchString}";

    var queryDisplayString = "${queryDisplayString}";

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

        //add an occurrence layer for macropus
        var queryLayer = L.tileLayer.wms(mappingUrl + "/webportal/wms/reflect" + query, {
            layers: 'ALA:occurrences',
            format: 'image/png',
            transparent: true,
            attribution: "Atlas of Living Australia",
            bgcolor:"0x000000",
            outline:"true",
            ENV: "color:5574a6;name:circle;size:5;opacity:1"
        });

        var speciesLayers = new L.LayerGroup();
        queryLayer.addTo(speciesLayers);

        var map = L.map('leafletMap', {
            center: [-23.6,133.6],
            zoom: 4,
            layers: [minimal, motorways, speciesLayers]
        });

        var baseLayers = {
            "Minimal": minimal,
            "Night view": midnight,
            "Road" : gmap_layer,
            "Terrain" : gmap_terrain_layer,
            "Hybrid" : gmap_hybrid_layer,
            "Satellite" : gmap_sat_layer
        };

        var overlays = {
            "Your query" : queryLayer
        };

        L.control.layers(baseLayers, overlays, {collapsed:false}).addTo(map);

        map.on('click', onMapClick);

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

        map.addControl(new MyControl());

        $('.colour-by-control').click(function(){
            $(this).parent().addClass('leaflet-control-layers-expanded');
        })

        L.Util.requestAnimFrame(map.invalidateSize,map,!1,map._container);
    }

    function onMapClick(e) {
        $.ajax({
            url: mappingUrl + "/occurrences/info",
            jsonp: "callback",
            dataType: "jsonp",
            data: {
                q: "${q}",
                fq: "${fq}",
                zoom: map.getZoom(),
                lat: e.latlng.lat,
                lon: e.latlng.lng,
                radius: 20,
                format: "json"
            },
            success: function(response) {
                if(response.count){
                    var popup = L.popup()
                        .setLatLng(e.latlng)
                        .setContent("<div><h3>Test</h3>Occurrences at this point: " + response.count + "</div>")
                        .openOn(map);
                }
            }
        });
    }
</r:script>