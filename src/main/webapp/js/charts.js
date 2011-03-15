/**
 * scripts for charts that make direct jsonp calls to biocache services
 */

/*******                                   *****
 *******       TAXON BREAKDOWN CHART       *****
 *******                                   *****/

var instanceUid = 'dp20';
var taxaBreakdownUrl = "http://ala-bie1.vm.csiro.au:8080/biocache-service/breakdown/institutions/" + instanceUid;
/************************************************************\
*
\************************************************************/
function jpLoadTaxonChart(name, rank) {
  var url = taxaBreakdownUrl + "/rank/" + rank;
  if (name != undefined) {
    url = url + "/name/" + name;
  }
  url = url + ".json";
  $.ajax({
    url: url,
    dataType: 'jsonp',
    error: function(jqXHR, textStatus, errorThrown) {
      alert(textStatus + ": " + errorThrown);
    },
    success: function(data) {
      var dataTable = jpBuildDataTable(data, name, rank);
      jpDrawTaxonChart(dataTable)
    }
  });
}
/************************************************************\
* Converts biocache json to Google VIS DataTable
\************************************************************/
function jpBuildDataTable(data, name, rank) {
  var table = new google.visualization.DataTable();
  table.addColumn('string', data.rank);
  table.addColumn('number', 'count');

  if (data.taxa == undefined) {
    alert("no data");
  }
  for (var i = 0; i < data.taxa.length; i++) {
    table.addRow([data.taxa[i].label,data.taxa[i].count]);
  }
  table.setTableProperty('rank', data.rank);
  if (name == undefined) {
    table.setTableProperty('scope', 'all');
  } else {
    table.setTableProperty('name', name);
  }
  return table
}
/************************************************************\
* Draw the chart
\************************************************************/
function jpDrawTaxonChart(dataTable) {
  var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
  var options = {
      width: 400,
      height: 380,
      chartArea: {left:0, top:30, width:"90%", height: "75%"},
      is3D: false,
      titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
      sliceVisibilityThreshold: 0,
      legend: "left"
  };
  if (dataTable.getTableProperty('scope') == "all") {
    options.title = "Records by " + dataTable.getTableProperty('rank');
  } else {
    options.title = dataTable.getTableProperty('name') + " records by " + dataTable.getTableProperty('rank');
  }
  // only set the reset link text the first time in
  if ($('span#resetTaxonChart').html() == 'Reset') {
      $('span#resetTaxonChart').html("Reset to " + dataTable.getTableProperty('rank'));
  }
  google.visualization.events.addListener(chart, 'select', function() {
    var rank = dataTable.getTableProperty('rank');
    var name = dataTable.getValue(chart.getSelection()[0].row,0);
    // add genus to name if we are at species level
    var scope = dataTable.getTableProperty('scope');
    if (scope == "genus" && rank == "species") {
      name = dataTable.getTableProperty('name') + " " + name;
    }
    // drill down unless already at species
    if (rank != "species") {
      $('div#taxonChart').html('<img style="margin-left: 230px;margin-top:174px;margin-bottom: 174px;" class="taxon-loading" alt="loading..." src="/images/ajax-loader.gif"/>');
      jpLoadTaxonChart(dataTable.getValue(chart.getSelection()[0].row,0), dataTable.getTableProperty('rank'));
    }
    // show reset link
    $('span#resetTaxonChart').html("<img src='/images/go-left.png'/>&nbsp;&nbsp;<img src='/images/go-right-disabled.png'/>");
  });

  chart.draw(dataTable, options);

  // show taxon caption
  $('div#taxonChartCaption').css('visibility', 'visible');
}
/************************************************************\
*
\************************************************************/
function jpResetTaxonChart() {
  $('div#taxonChart').html('<img style="margin-left: 230px;margin-top: 174px;margin-bottom: 174px;" class="taxon-loading" alt="loading..." src="/images/ajax-loader.gif"/>');
  jpLoadTaxonChart(null, 'phylum');
  $('span#resetTaxonChart').html("<img src='/images/go-left-disabled.png'/>&nbsp;&nbsp;<img src='/images/go-right-disabled.png'/>");
}

/*******                                   *****
 *******       TYPES BREAKDOWN CHART       *****
 *******                                   *****/

var priorityOfTypes = ['holotype','lectotype','neotype','syntype','paratype','allotype','topotype','paralectotype','cotype','hapantotype','allolectotype','paraneotype'];
function drawTypesBreakdown(data) {
  var types = data.fieldResult;
  types.sort(typeSorter);
  // build data table
  var table = new google.visualization.DataTable();
  table.addColumn('string', 'Type');
  table.addColumn('number', 'Number of records');
  for (var i = 0; i < types.length; i++) {
    var label = types[i].label;
    if (label == 'type') {label = 'unknown type';}
    if (label != 'notatype') {
      table.addRow([label,types[i].count]);
    }
  }

  // chart options
  var options = {
      width: 485,
      height: 280,
      chartArea: {left:0, top:60, width:"80%", height: "90%"},
      title: 'Records by type status',
      titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
      sliceVisibilityThreshold: 0,
      legend: "left"
  };

  // create chart
  var chart = new google.visualization.PieChart(document.getElementById('typesChart'));

  // selection actions
  google.visualization.events.addListener(chart, 'select', function() {
    var name = table.getValue(chart.getSelection()[0].row,0);
    // reverse any presentation transforms
    if (name == 'unknown type') {name = 'type';}
    window.location.href = "http://ozcam-demo.ala.org.au:8080/occurrences/search?q=*:*&fq=type_status:" + name;
  });

  // draw
  chart.draw(table, options);
}

function typeSorter(a,b) {
  // assign a rank to each
  var aRank = 100;
  var bRank = 100;
  for (var i = 0; i < priorityOfTypes.length; i++) {
    if (priorityOfTypes[i] == a.label) { aRank = i;}
    if (priorityOfTypes[i] == b.label) { bRank = i;}
  }
  return aRank - bRank;
}


/*******                                   *****
 *******       STATE BREAKDOWN CHART       *****
 *******                                   *****/

function drawStatesBreakdown(data) {
  var drs = data.fieldResult;
  // build data table
  var table = new google.visualization.DataTable();
  table.addColumn('string', 'Type');
  table.addColumn('number', 'Number of records');
  for (var i = 0; i < drs.length; i++) {
    var label = drs[i].label;
    table.addRow([label,drs[i].count]);
  }

  // chart options
  var options = {
      width: 485,
      height: 280,
      chartArea: {left:0, top:60, width:"100%", height: "90%"},
      title: 'Records by state or territory',
      titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
      sliceVisibilityThreshold: 0,
      legend: "right"/*,
      colors: ["#0444B3","#FF0B12","#73182C","#E65A00","#377923","#FCD202","#455662","#006854","#0099CC"]*/

  };

  // create chart
  var chart = new google.visualization.PieChart(document.getElementById('statesChart'));

  // selection actions
  google.visualization.events.addListener(chart, 'select', function() {
    var name = table.getValue(chart.getSelection()[0].row,0);
    window.location.href = "http://ozcam-demo.ala.org.au:8080/occurrences/search?q=*:*&fq=state:" + name;
  });

  // draw
  chart.draw(table, options);
}


/*******                                      *****
 *******    INSTITUTION BREAKDOWN CHART       *****
 *******                                      *****/

var chart;
var instBreakdownJson = {empty: true};
var topLevel = true;
var instTable;
function loadInstChart() {
  //var url = biocacheServicesUrl + "occurrences/data-provider/" + instanceUid + ".json?pageSize=0";
  //var oldUrl = biocacheUrl + "occurrences/searchForUID.json?pageSize=0&q=" + instanceUid;
  if (instBreakdownJson.empty) {
    // load json one time only
    var url = "http://collections.ala.org.au/public/recordsByCollectionByInstitution.json";
    $.ajax({
        url: url,
        dataType: 'jsonp',
        success: function(data) {
          instBreakdownJson = data.breakdown;
          drawInstitutionBreakdown();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert(textStatus + ": " + errorThrown);//$('div#instChart').html(textStatus);
        }
    });
  } else {
    // json already loaded
    drawInstitutionBreakdown();
  }
}
function drawInstitutionBreakdown(data) {
  topLevel = true;
  var data = instBreakdownJson;
  // build data table
  instTable = new google.visualization.DataTable();
  instTable.addColumn('string', 'Institution');
  instTable.addColumn('number', 'Number of records');
  for (var i = 0; i < data.length; i++) {
    instTable.addRow([data[i].label,data[i].total]);
  }

  // chart options
  var options = {
      width: 510,
      height: 280,
      chartArea: {left:0, top:60, width:"100%", height: "90%"},
      title: 'Records by source institution',
      titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
      sliceVisibilityThreshold: 0,
      legend: "right",
      colors: ["#0099CC","#0444B3","#E65A00","#377923","#73182C","#455662","#FF0B12","#FCD202","#006854"]
  };

  // create chart
  chart = new google.visualization.PieChart(document.getElementById('instChart'));

  // selection actions
  google.visualization.events.addListener(chart, 'select', function() {
    // only take an action if we are at the institution level
    var label = instTable.getValue(chart.getSelection()[0].row,0);
    if (topLevel) {
      drawCollectionBreakdownChart(label);
      topLevel = false;
      // show reset link
      $('span#resetInstChart').html("<img src='/images/go-left.png'/>&nbsp;&nbsp;<img src='/images/go-right-disabled.png'/>");
      $('span#instChartCaption').html("Click a slice or legend to show records for the collection.");
    } else {
      var uid = instTable.getTableProperty('uid');
      var instData;
      for (var i = 0; i < instBreakdownJson.length; i++) {
        if(instBreakdownJson[i].uid == instTable.getTableProperty('uid')) {
          instData = instBreakdownJson[i].collections;
        }
      }
      if (instData != undefined) {
        var collectionUid;
        for (var i = 0; i < instData.length; i++) {
          if(instData[i].name == label) {
            collectionUid = instData[i].uid;
          }
        }
        window.location.href = "http://ozcam-demo.ala.org.au:8080/occurrences/search?q=*:*&fq=collection_uid:" + collectionUid;
      }
    }
  });

  // draw
  chart.draw(instTable, options);

  // show caption
  $('div#instChartCaptionBlock').css('visibility', 'visible');

}

function drawCollectionBreakdownChart(label) {
  // extract data section for name
  var collData;
  var name, uid;
  for (var i = 0; i < instBreakdownJson.length; i++) {
    if(instBreakdownJson[i].label == label) {
      collData = instBreakdownJson[i].collections;
      name = instBreakdownJson[i].name;
      uid = instBreakdownJson[i].uid;
    }
  }
  var nameLabel;
  if (name == "Museum Victoria") {
    nameLabel = name;
  } else {
    nameLabel = 'the ' + name;
  }
  // build data table
  instTable = new google.visualization.DataTable();
  instTable.addColumn('string', 'Collection');
  instTable.addColumn('number', 'Number of records');
  for (var i = 0; i < collData.length; i++) {
    instTable.addRow([collData[i].name,collData[i].count]);
  }
  instTable.setTableProperty('uid',uid);
  instTable.setTableProperty('name',name);
  // chart options
  var options = {
      width: 510,
      height: 280,
      chartArea: {left:0, top:60, width:"100%", height: "90%"},
      title: 'Records by collections for ' + nameLabel,
      titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
      sliceVisibilityThreshold: 0,
      legend: "right"
  };

  // draw chart
  chart.draw(instTable, options);

  // set caption
  $('div#instChartCaption').html("");

}

function resetInstChart() {
  $('div#instChart').html('<img style="margin-left: 230px;margin-top: 140px;margin-bottom: 110px;" alt="loading..." src="/images/ajax-loader.gif"/>');
  topLevel = true;
  loadInstChart();
  $('span#instChartCaption').html("Click a slice or legend to show the institution's collections.");
  $('span#resetInstChart').html("<img src='/images/go-left-disabled.png'/>&nbsp;&nbsp;<img src='/images/go-right-disabled.png'/>");
}


/*******                                       *****
 *******  RECORDS ACCUMULATION BREAKDOWN CHART *****
 *******                                       *****/

  var useStaticData = true;
  var saveStaticData = false;
  var accumChart;
  var accumTable;
  var accumOptions;
  var rawData;
  function loadRecordsAccumulation() {
    var url = "http://collections.ala.org.au/public/recordsByDecadeByInstitution.json";
    if (useStaticData) { url = url + "?static=true";}
    if (saveStaticData) { url = url + "?save=true";}
    $.ajax({
      url: url,
      dataType: 'jsonp',
      error: function(jqXHR, textStatus, errorThrown) {
        alert(textStatus);
      },
      success: function(data) {
        drawRecordsAccumulation(data);
      }
    });
  }
  function drawRecordsAccumulation(data) {
    rawData = data;
    // build data table
    accumTable = new google.visualization.DataTable();
    accumTable.addRows(17);
    accumTable.addColumn('string', 'Decade');
    for (var i = 0; i < 17; i++) {
      accumTable.setValue(i, 0, (i * 10 + 1850) + 's');
    }
    for (var i = 0; i < data.length; i++) {
      accumTable.addColumn('number', data[i].label);
      loadRecords(data[i], accumTable, i + 1);
    }

    //$('div#raJson').html(accumTable.toJSON());

    // chart options
    accumOptions = {
        width: 650,
        height: 340,
        vAxis: {logScale: true, title: "num records (log scale)", format: "#,###,###"},
        //vAxis: {logScale: false, title: "number of records", format: "#,###,###"},
        chartArea: {left: 80, width:"55%"},
        title: 'Records accumulated by decade',
        titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
        sliceVisibilityThreshold: 0,
        legend: "right",
        colors: ["#0444B3","#377923","#FCD202","#FF0B12","#E65A00","#455662","#73182C","#006854","#0099CC"]
    };

    // create chart
    accumChart = new google.visualization.LineChart(document.getElementById('recordsAccumChart'));

    // selection actions
    google.visualization.events.addListener(accumChart, 'select', function() {
      var selection = accumChart.getSelection()[0];
      var instData = rawData[selection.column - 1];
      var search = (instData.uid.substr(0,2)=="in" ? "&fq=institution_uid:" : "&fq=collection_uid:") + instData.uid;
      var searchUrl = "http://ozcam-demo.ala.org.au:8080/occurrences/search?q=*:*" + search;
      if (selection.row != undefined) {
        var decadeStart = selection.row * 10 + 1850;
        var decadeEnd = selection.row * 10 + 1850 + 10;
        searchUrl = searchUrl + "&fq=occurrence_date:[" + decadeStart + "-01-01T12:00:00Z%20TO%20" + decadeEnd + "-01-01T12:00:00Z]";
      }
      window.location.href = searchUrl;
    });

    // draw
    accumChart.draw(accumTable, accumOptions);
  }

  function loadRecords(inst, table, col) {
    table.setValue(0, col , inst.d1850);
    table.setValue(1, col , inst.d1860);
    table.setValue(2, col , inst.d1870);
    table.setValue(3, col , inst.d1880);
    table.setValue(4, col , inst.d1890);
    table.setValue(5, col , inst.d1900);
    table.setValue(6, col , inst.d1910);
    table.setValue(7, col , inst.d1920);
    table.setValue(8, col , inst.d1930);
    table.setValue(9, col , inst.d1940);
    table.setValue(10, col , inst.d1950);
    table.setValue(11, col , inst.d1960);
    table.setValue(12, col , inst.d1970);
    table.setValue(13, col , inst.d1980);
    table.setValue(14, col , inst.d1990);
    table.setValue(15, col , inst.d2000);
    table.setValue(16, col , inst.d2010);
  }

  function toggleLogScale() {
    if ($('span#toggleAccumChart').html() == "Use log scale") {
      accumOptions.vAxis = {logScale: true, title: "num records (log scale)", format: "#,###,###"}
      accumChart.draw(accumTable, accumOptions);
      $('span#toggleAccumChart').html('Use linear scale');
    } else {
      accumOptions.vAxis = {logScale: false, title: "number of records", format: "#,###,###"}
      accumChart.draw(accumTable, accumOptions);
      $('span#toggleAccumChart').html('Use log scale');
    }
  }


/*******                                   *****
 *******    LOAD FACETS FOR ALL RECORDS    *****
 *******                                   *****/

function loadFacetCharts() {
    // bio-cache facets data
    var url = biocacheServicesUrl + "occurrences/search.json?q=*:*&pageSize=0";
    $.ajax({
      url: url,
      dataType: 'jsonp',
      cache: false,
      error: function(jqXHR, textStatus, errorThrown) {
        alert(textStatus);
      },
      success: function(data) {
        //var facets = data.facetResults; // services version
        var facets = data.facetResults;
        var foundTypesData = false;
        var foundStatesData = false;
        for (var i = 0; i < facets.length; i++) {
          if (facets[i].fieldName == 'type_status') {
            drawTypesBreakdown(facets[i]);
            foundTypesData = true;
          }
          if (facets[i].fieldName == 'state') {
            drawStatesBreakdown(facets[i]);
            foundStatesData = true;
          }
        }
        if (!foundTypesData) {
          $('div#typesChart').css('display', 'none');
        }
        if (!foundStatesData) {
          $('div#statesChart').css('display', 'none');
        }
      }
    });

}


/*******                                   *****
 *******      Specify charts to load       *****
 *******                                   *****/
var biocacheServicesUrl = "http://ala-bie1.vm.csiro.au:8080/biocache-service/";

function hubChartsOnLoadCallback() {

  loadInstChart();

  loadFacetCharts();

  jpLoadTaxonChart(null,"phylum");  // start with all phyla

  loadRecordsAccumulation();
}
