<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="refer" 
 			  type="java.lang.String"
			  required="true" 
			  description="Page calling this tag"
%>
<%-- JQuery library is included by WDK 
<!-- JQuery Library -->
<script type="text/javascript" src="/assets/js/lib/jquery-1.2.6.js"></script>
--%>

<!-- JQuery Drag And Drop Plugin -->

<c:if test="${refer == 'customSummary'}">
	<!-- JQuery Drag And Drop Plugin -->
	<script type="text/javascript" src="/assets/js/lib/jqDnR.js"></script>
	<!-- JQuery BlockUI Plugin -->
	<script type="text/javascript" src="/assets/js/lib/jquery.blockUI.js"></script>
	<!-- filter menu javascript -->
	<script type="text/javascript" src="/assets/js/filter_menu.js"></script>
	<!-- Strategy Interaction javascript -->
	<script type="text/javascript" src="/assets/js/js-utils.js"></script>
	<script type="text/javascript" src="/assets/js/Strategy.js"></script>
	<script type="text/javascript" src="/assets/js/strategyWriter.js"></script>
	<script type="text/javascript" src="/assets/js/step.js"></script>
	<script type="text/javascript" src="/assets/js/StrategyAction.js"></script>
	<script type="text/javascript" src="/assets/js/pager.js"></script>
	<script type="text/javascript" src="/assets/js/lib/flexigrid/flexigrid.js"></script>
	<script type="text/javascript" src="/assets/js/lib/flexigrid/flexifluid.js"></script>
	<!-- Results Page AJAX Javascript code -->
	<script type="text/javascript" src="/assets/js/results_page.js"></script>

</c:if>

<%-- js for quick seach box --%>
<script type="text/javascript" src="/assets/js/quicksearch.js"></script>
 

<c:if test="${refer == 'blastQuestion'}">
        <script type="text/javascript" src="/assets/js/blast.js"></script>
</c:if>

<!-- dynamic query grid code -->
<script type="text/javascript" src="/assets/js/dqg.js"></script>
<script type="text/javascript" src="/assets/js/newitems.js"></script>


<!-- dynamic query grid code -->
<script type="text/javascript" src="/assets/js/questionPage.js"></script>
<!-- dynamic query grid code -->
<!--<script type="text/javascript" src="/assets/js/Top_menu.js"></script>-->


<!-- Record Page GBrowse Javascript code -->
<%--<script type="text/javascript" src="/gbrowse/wz_tooltip_3.45.js"></script>--%>
<!-- history page code -->
<script type="text/javascript" src="/assets/js/history.js"></script>

<script type="text/javascript" src="<c:url value='/js/treeControl.js'/>"></script>

<script type="text/javascript" src="/assets/js/api.js"></script>
<script type="text/javascript" src="/assets/js/htmltooltip.js"></script>

<!-- fix to transparent png images in IE 7 -->
<!--[if lt IE 7.]>
<script type="text/javascript" src="/assets/js/pngfix.js"></script>
<![endif]-->

<!-- js for Contact Us window -->
<script type='text/javascript' src='<c:url value="/js/newwindow.js"/>'></script>

<!-- js for popups in query grid and other.... -->
<script type='text/javascript' src='<c:url value="/js/overlib.js"/>'></script>

<%-- show/hide the tables in the record page --%>
<script type='text/javascript' src="/assets/js/show_hide_tables.js"></script>

