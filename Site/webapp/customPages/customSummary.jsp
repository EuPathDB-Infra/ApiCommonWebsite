<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>

<%-- from customQueryHistory --%>
<%-- get wdkUser saved in session scope --%>
<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<%-- end from customQueryHistory --%>

<c:set var="dsCol" value="${param.dataset_column}"/>
<c:set var="dsColVal" value="${param.dataset_column_label}"/>

<c:set var="model" value="${applicationScope.wdkModel}" />
<c:set var="showHist" value="${requestScope.showHistory}" />
<c:set var="strategies" value="${requestScope.wdkActiveStrategies}"/>
<c:set var="modelName" value="${applicationScope.wdkModel.name}" />

<c:set var="commandUrl">
    <c:url value="/processSummary.do?${wdk_query_string}" />
</c:set>

<c:set var="headElement">
<link rel="stylesheet" href="/assets/css/flexigrid/flexigrid.css" type="text/css"/>
</c:set>
<site:header refer="customSummary" headElement="${headElement}"/>
<site:dyk />
<c:set var="scheme" value="${pageContext.request.scheme}" />
<c:set var="serverName" value="${pageContext.request.serverName}" />
<c:set var="request_uri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<c:set var="request_uri" value="${fn:substringAfter(request_uri, '/')}" />
<c:set var="request_uri" value="${fn:substringBefore(request_uri, '/')}" />
<c:set var="exportBaseUrl" value = "${scheme}://${serverName}/${request_uri}/importStrategy.do?strategy=" />

<%-- inline script for initial load of summary page --%>
<script type="text/javascript" language="javascript">
        var guestUser = '${wdkUser.guest}';
        init_strat_ids = ${strategies};
        <c:if test="${wdkUser.viewStrategyId != null && wdkUser.viewStepId != null}">
          init_view_strat = "${wdkUser.viewStrategyId}";
          init_view_step = "${wdkUser.viewStepId}";
        </c:if>
        $(document).ready(function(){
		// tell jQuery not to cache ajax requests.
		$.ajaxSetup ({ cache: false}); 
		exportBaseURL = '${exportBaseUrl}';
		var current = getCurrentTabCookie();
		if (!current || current == null)
			showPanel('strategy_results');
		else
	                showPanel(current);
	});

  function goToIsolate() {
    var form = document.checkHandleForm;
    var cbs = form.selectedFields;
    var count = 0;
    var url = "/cgi-bin/isolateClustalw?project_id=${modelName};isolate_ids=";
    for (var i=0; i<cbs.length; i++) {
      if(cbs[i].checked) {
      url += cbs[i].value + ",";
      count++;
      }
    }
    if(count < 2) {
      alert("Please select at lease two isolates to run ClustalW");
      return false;
    }
    window.location.href = url;
  }

</script>


<%--------------- TABS ---------------%>

<div id="strategy_workspace" class="h2center">
My Search Strategies Workspace
</div>


<ul id="strategy_tabs">
<%-- showPanel() is in filter_menu.js --%>

   <li><a id="tab_strategy_new" title="START a NEW strategy, or CLICK to access the page with all available searches"   
	href="javascript:showPanel('strategy_new')" >New Strategy</a></li>
   <li><a id="tab_strategy_results" title="Graphical display of your opened strategies. To close a strategy click on the right top corner X." 
	onclick="this.blur()" href="javascript:showPanel('strategy_results')">Run Strategies</a></li>
   <li><a id="tab_search_history" title="Summary of all your strategies. From here you can open/close strategies on the 'Run Strategies' tab, our graphical display." 
	onclick="this.blur()" href="javascript:showPanel('search_history')">Browse Strategies</a></li>
   <li><a id="tab_sample_strat"  onclick="this.blur()" title="View some examples of linear and non-linear strategies." 
	href="javascript:showPanel('sample_strat')">Sample Strategies</a></li>
   <li><a id="tab_help" 
	href="javascript:showPanel('help')">Help</a></li>


</ul>





<%--------------- REST OF PAGE ---------------%>
<div id="strategy_results">

	<div id="Strategies">
	</div>

	<input type="hidden" id="target_step" value="${stepNumber+1}"/>

	<br/>

	<div id="Workspace">&nbsp;
	</div> 

</div>

<div id="search_history">
</div>

<div id="sample_strat">
        <site:sampleStrategies wdkModel="${wdkModel}" wdkUser="${wdkUser}" />
</div>

<div id="help">
        <site:helpStrategies wdkModel="${wdkModel}" wdkUser="${wdkUser}" />
</div>

<div id="strategy_new">
        <site:queryGrid  from="tab"/>
</div>



<site:footer />
