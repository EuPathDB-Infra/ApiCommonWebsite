<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>

<%@ attribute name="model"
             type="org.gusdb.wdk.model.jspwrap.WdkModelBean"
             required="false"
             description="Wdk Model Object for this site"
%>

<%@ attribute name="user"
              type="org.gusdb.wdk.model.jspwrap.UserBean"
              required="false"
              description="Currently active user object"
%>

<c:set var="strategiesMap" value="${user.strategiesByCategory}"/>
<c:set var="invalidStrategies" value="${user.invalidStrategies}"/>
<c:set var="modelName" value="${model.name}"/>
<c:set var="showOrthoLink" value="${fn:containsIgnoreCase(modelName, 'plasmodb') || fn:containsIgnoreCase(modelName, 'apidb') || fn:containsIgnoreCase(modelName, 'cryptodb')}" />

<!-- decide whether strategy history is empty -->
<c:choose>
  <c:when test="${user == null || user.strategyCount == 0}">
  <div style="font-size:120%;line-height:1.2em;text-indent:10em;padding:0.5em">You have no searches in your history. <p style="text-indent:5em;">Please run a search from the <a href="/">home</a> page, or by using the "New Search" menu above, or by selecting a search from the <a href="<c:url value="/queries_tools.jsp"/>">All Available Searches</a> page.</p></div>
  </c:when>
  <c:otherwise>
  <c:set var="typeC" value="0"/>
  <!-- begin creating tabs for history sections -->
  <ul id="history_tabs">
  <c:forEach items="${strategiesMap}" var="strategyEntry">
  <c:set var="type" value="${strategyEntry.key}"/>
  <c:set var="isGeneRec" value="${fn:containsIgnoreCase(type, 'GeneRecordClass')}"/>
  <c:set var="histList" value="${strategyEntry.value}"/>
  <c:set var="recDispName" value="${histList[0].latestStep.question.recordClass.type}"/>
  <c:set var="recTabName" value="${fn:substring(recDispName, 0, fn:indexOf(recDispName, ' '))}"/>

  <c:set var="typeC" value="${typeC+1}"/>
  <c:if test="${typeC != 1}">
    <li>|</li>
  </c:if>
  <li>
  <a id="tab_${recTabName}" onclick="displayHist('${recTabName}')"
  href="javascript:void(0)">${recDispName}&nbsp;Strategies</a></li>
  </c:forEach>
  <c:if test="${fn:length(invalidStrategies) > 0}">
    <li>
      <a id="tab_invalid" onclick="displayHist('invalid')"
       href="javascript:void(0)">Invalid&nbsp;Strategies</a></li>
  </c:if>
  <li class="cmplt_hist_link">
    <a id="tab_cmplt" onclick="displayHist('cmplt')" href="javascript:void(0)">All My Queries</a>
  </li>
  </ul>
<!-- should be a div instead of a table -->
<table class="history_controls clear_all">
   <tr>
      <td><a class="check_toggle" onclick="selectAllHist()" href="javascript:void(0)">select all</a>&nbsp|&nbsp;
          <a class="check_toggle" onclick="selectNoneHist()" href="javascript:void(0)">select none</a></td>
      <td></td>
      <td class="medium">
         <!-- display "delete button" -->
         <input type="button" value="Delete" onclick="deleteStrategies('deleteStrategy.do?strategy=')"/>
      </td>
   </tr>
</table>

<c:set var="typeC" value="0"/>
<c:set var="strategiesMap" value="${user.unsavedStrategiesByCategory}"/>
<!-- form for renaming strategies; action is set in javascript -->
<form id="browse_rename" action="javascript:return false;" onsubmit="return validateSaveForm(this);">
<!-- begin creating history sections to display strategies -->
<c:forEach items="${strategiesMap}" var="strategyEntry">
  <c:set var="type" value="${strategyEntry.key}"/>
  <c:set var="isGeneRec" value="${fn:containsIgnoreCase(type, 'GeneRecordClass')}"/>
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:set var="recDispName" value="${strategies[0].latestStep.question.recordClass.type}"/>
  <c:set var="recTabName" value="${fn:substring(recDispName, 0, fn:indexOf(recDispName, ' '))}"/>

  <c:set var="typeC" value="${typeC+1}"/>
  <c:choose>
    <c:when test="${typeC == 1}">
      <div id="unsaved-strategies" class="panel_${recTabName} history_panel">
    </c:when>
    <c:otherwise>
      <div id="saved-strategies" class="panel_${recTabName} history_panel">
    </c:otherwise> 
  </c:choose>
  <site:strategyTable strategies="${strategies}" wdkUser="${wdkUser}" prefix="Unsaved" />
</div>
</c:forEach>
<!-- end of showing strategies grouped by RecordTypes -->


<c:set var="typeC" value="0"/>
<c:set var="strategiesMap" value="${user.savedStrategiesByCategory}"/>
<!-- begin creating history sections to display strategies -->
<c:forEach items="${strategiesMap}" var="strategyEntry">
  <c:set var="type" value="${strategyEntry.key}"/>
  <c:set var="isGeneRec" value="${fn:containsIgnoreCase(type, 'GeneRecordClass')}"/>
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:set var="recDispName" value="${strategies[0].latestStep.question.recordClass.type}"/>
  <c:set var="recTabName" value="${fn:substring(recDispName, 0, fn:indexOf(recDispName, ' ')-1)}"/>

  <c:set var="typeC" value="${typeC+1}"/>
  <c:choose>
    <c:when test="${typeC == 1}">
      <div class="panel_${recTabName} history_panel">
    </c:when>
    <c:otherwise>
      <div class="panel_${recTabName} history_panel">
    </c:otherwise> 
  </c:choose>
  <site:strategyTable strategies="${strategies}" wdkUser="${wdkUser}" prefix="Saved" />
</div>
</c:forEach>
<!-- end of showing strategies grouped by RecordTypes -->
</form>

<c:set var="scheme" value="${pageContext.request.scheme}" />
<c:set var="serverName" value="${pageContext.request.serverName}" />
<c:set var="request_uri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<c:set var="request_uri" value="${fn:substringAfter(request_uri, '/')}" />
<c:set var="request_uri" value="${fn:substringBefore(request_uri, '/')}" />
<c:set var="exportBaseUrl" value = "${scheme}://${serverName}/${request_uri}/importStrategy.do?strategy=" />

<!-- popups for save/rename forms -->
<c:set var="strategiesMap" value="${user.strategiesByCategory}"/>
<c:forEach items="${strategiesMap}" var="strategyEntry">
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:forEach items="${strategies}" var="strategy">
    <c:if test="${strategy.isSaved}">
    <c:set var="exportURL" value="${exportBaseUrl}${strategy.importId}" />
    <div class='modal_div export_link' id="hist_share_${strategy.strategyId}" style="right:15em;">
      <span class='dragHandle'>
        <a class='close_window' href='javascript:closeModal()'>
          <img alt='Close' src='/assets/images/Close-X-box.png'/>
        </a>
      </span>
      <p>Copy and Paste URL below to Email or Bookmark:</p>
      <input type='text' size="${fn:length(exportURL)}" value="${exportURL}"/>
    </div>
    </c:if>
    <c:if test="${!wdkUser.guest}">
    <c:set var="saveHeader" value="Save As"/>
    <div class='modal_div save_strat' id="hist_save_${strategy.strategyId}" style="right:15em;">
      <span class='dragHandle'>
        <div class="modal_name">
          <h2>${saveHeader}</h2>
        </div>
        <a class='close_window' href='javascript:closeModal()'>
          <img alt='Close' src='/assets/images/Close-X-box.png'/>
        </a>
      </span>
      <form onsubmit='return validateSaveForm(this);' action="javascript:saveStrategy('${strategy.strategyId}', true, true)">
        <input type='hidden' value="${strategy.strategyId}" name='strategy'/>
        <input type='text' value="${strategy.name}" name='name'/>
        <input type='submit' value='Save'/>
      </form>
    </div>
    </c:if>
  </c:forEach>
</c:forEach>


<%-- invalid strategies, if any --%>
<c:if test="${fn:length(invalidStrategies) > 0}">
  <c:choose>
    <c:when test="${typeC == 0}">
      <div class="panel_invalid history_panel">
    </c:when>
    <c:otherwise>
      <div class="panel_invalid history_panel">
    </c:otherwise>
  </c:choose>
    <site:strategyTable strategies="${user.invalidStrategies}" wdkUser="${wdkUser}" prefix="Invalid" />
  </div>
</c:if>

<div class="panel_cmplt history_panel">
  <h1>All Queries</h1>
  <site:completeHistory model="${model}" user="${user}" />
</div>

<table class="history_controls">
   <tr>
      <td><a class="check_toggle" onclick="selectAllHist()" href="javascript:void(0)">select all</a>&nbsp|&nbsp;
          <a class="check_toggle" onclick="selectNoneHist()" href="javascript:void(0)">select none</a></td>
      <td class="medium">
         <!-- display "delete button" -->
         <input type="button" value="Delete" onclick="deleteStrategies('deleteStrategy.do?strategy=')"/>
      </td>
   </tr>
</table>

  </c:otherwise>
</c:choose> 
<!-- end of deciding strategy emptiness -->

