<%-- any content can be specified here e.g.: --%>
<%@ page pageEncoding="UTF-8" %>
<div class="section two-column-charts">
    <!--
    *******                                                  *****
    ******* STANDALONE SPECIMEN ACCUMULATION BREAKDOWN CHART *****
    *******                                                  *****
    -->
    <div style="margin-left:180px;">
    <div id='recordsAccumChart'>
      <img class='taxon-loading' alt='loading...' src='static/images/ajax-loader.gif'/>
    </div>
    <div id='recordsAccumChartCaption'>
      <span id='toggleAccumChart' class="resetChart" onclick='toggleLogScale()'>Use linear scale</span><br/>
      <span class='taxonChartCaption'>Click on a line to show records for that decade and institution.</span><br/>
    </div>
    <div id="raJson"></div>
    </div>

    <!--
    *******                                  *****
    ******* STANDALONE TAXON BREAKDOWN CHART *****
    *******                                  *****
    -->
    <div style="margin-top:45px;display:inline;float:left;">
    <div id='taxonChart'>
      <img style="margin-left: 230px;margin-top: 100px;margin-bottom: 120px;" class='taxon-loading' alt='loading...' src='static/images/ajax-loader.gif'/>
    </div>
    <div id='taxonChartCaption' style='visibility:hidden;'>
      <span id='resetTaxonChart'>
        <img src="static/images/go-left-disabled.png"/>&nbsp;&nbsp;<img src="static/images/go-right-disabled.png"/></span><br/>
      <span class='taxonChartCaption'>Click a slice or legend to drill into a group.</span>
    </div>
    </div>

    <!--
    *******                                   *****
    ******* STANDALONE GROUPS BREAKDOWN CHART *****
    *******                                   *****
    -->
    <div style="margin-top:40px;display:inline;float:right;padding-right:20px;">
      <div id='groupsChart'>
        <img class='taxon-loading' alt='loading...' src='/images/ajax-loader.gif'/>
      </div>
      <div id='groupsChartCaption'>
        <span class='taxonChartCaption'>Click a slice or legend to show records for that group.</span><br/>
      </div>
    </div>

    <div style="clear:both;"></div>

    <!--
    *******                                        *****
    ******* STANDALONE INSTITUTION BREAKDOWN CHART *****
    *******                                        *****
    -->
    <div style="margin-top:33px;display:inline;float:left;">
    <div id='instChart'>
      <img style="margin-left: 230px;margin-top: 174px;margin-bottom: 174px;" alt='loading...' src='static/images/ajax-loader.gif'/>
    </div>
    <div id='instChartCaptionBlock' style='visibility:hidden;'>
      <span id='resetInstChart' style="margin-left:133px;">
        <img src="static/images/go-left-disabled.png"/>&nbsp;&nbsp;<img src="static/images/go-right-disabled.png"/></span><br/>
      <span id="instChartCaption" class='taxonChartCaption'>Click a slice or legend to show the institution's collections.</span>
    </div>
    </div>

    <!--
    *******                                  *****
    ******* STANDALONE TYPES BREAKDOWN CHART *****
    *******                                  *****
    -->
    <div style="display:inline;float:right;margin-top:40px;">
    <div id='typesChart'>
      <img class='taxon-loading' alt='loading...' src='static/images/ajax-loader.gif'/>
    </div>
    <div id='typesChartCaption'>
      <span class='taxonChartCaption'>Click a slice or legend to show records of that type.</span><br/>
    </div>
    </div>

    <div style="clear:both;"></div>

    <!--
    *******                                  *****
    ******* STANDALONE STATE BREAKDOWN CHART *****
    *******                                  *****
    -->
    <div style="display:inline;float:none;margin-top:15px;">
    <div id='statesChart'>
      <img class='taxon-loading' alt='loading...' src='static/images/ajax-loader.gif'/>
    </div>
    <div id='statesChartCaption'>
      <span class='taxonChartCaption'>Click a slice or legend to show records for that state.</span><br/>
    </div>
    </div>

    <div style="clear:both;"></div>

  </div>
