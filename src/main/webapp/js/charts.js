/**
 * scripts for charts that make direct jsonp calls to biocache services
 */

/*******                                  *****
******* STANDALONE TAXON BREAKDOWN CHART *****
*******                                  *****/
var taxaBreakdownUrl = "http://ala-bie1.vm.csiro.au:8080/biocache-service/breakdown/institutions/";
/************************************************************\
*
\************************************************************/
function jpLoadTaxonChart(uid, name, rank) {
  var url = taxaBreakdownUrl + uid + "/rank/" + rank;
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
      height: 400,
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
      $('div#taxonChart').html('<img class="taxon-loading" alt="loading..." src="http://collections.ala.org.au/images/ala/ajax-loader.gif"/>');
      jpLoadTaxonChart("dp20", dataTable.getValue(chart.getSelection()[0].row,0), dataTable.getTableProperty('rank'));
    }
    // show reset link if we were at top level
    if ($('span#resetTaxonChart').html() == "") {
      $('span#resetTaxonChart').html("Reset to " + dataTable.getTableProperty('rank'));
    }
  });

  chart.draw(dataTable, options);

  // show taxon caption
  $('div#taxonChartCaption').css('visibility', 'visible');
}
/************************************************************\
*
\************************************************************/
function jpResetTaxonChart() {
  $('div#taxonChart').html('<img class="taxon-loading" alt="loading..." src="http://collections.ala.org.au/images/ala/ajax-loader.gif"/>');
  jpLoadTaxonChart("dp20", null, 'phylum');
  $('span#resetTaxonChart').html("");
}
