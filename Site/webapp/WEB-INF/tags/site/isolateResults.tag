<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>

<%@ attribute name="strategy"
	      type="org.gusdb.wdk.model.jspwrap.StrategyBean"
              required="true"
              description="Strategy Id we are looking at"
%>
<c:set var="wdkStep" value="${requestScope.wdkStep}"/>
<c:set var="wdkAnswer" value="${wdkStep.answerValue}"/>
<c:set var="qName" value="${wdkAnswer.question.fullName}" />
<c:set var="modelName" value="${applicationScope.wdkModel.name}" />
<c:set var="recordClass" value="${wdkAnswer.question.recordClass}" />
<c:set var="recordName" value="${recordClass.fullName}" />
<c:set var="recHasBasket" value="${recordClass.useBasket}" />
<c:set var="clustalwIsolatesCount" value="0" />
<c:set var="dispModelName" value="${applicationScope.wdkModel.displayName}" />

<c:set var="eupathIsolatesQuestion">${fn:containsIgnoreCase(recordName, 'IsolateRecordClasses.IsolateRecordClass') 
  && (fn:containsIgnoreCase(modelName, 'CryptoDB') 
  || fn:containsIgnoreCase(modelName, 'ToxoDB') 
  || fn:containsIgnoreCase(modelName, 'EuPathDB') 
  || fn:containsIgnoreCase(modelName, 'GiardiaDB') 
  || fn:containsIgnoreCase(modelName, 'PlasmoDB'))}</c:set> 

<jsp:useBean id="typeMap" class="java.util.HashMap"/>
<c:set target="${typeMap}" property="singular" value="${wdkStep.displayType}"/>
<imp:getPlural pluralMap="${typeMap}"/>
<c:set var="type" value="${typeMap['plural']}"/>

<c:choose>
  <c:when test='${wdkAnswer.resultSize == 0}'>
        No results are retrieved
  </c:when>
  <c:otherwise>

<!-- pager -->
<pg:pager isOffset="true"
          scope="request"
          items="${wdk_paging_total}"
          maxItems="${wdk_paging_total}"
          url="${wdk_paging_url}"
          maxPageItems="${wdk_paging_pageSize}"
          export="currentPageNumber=pageNumber">
  <c:forEach var="paramName" items="${wdk_paging_params}">
    <pg:param name="${paramName}" id="pager" />
  </c:forEach>
  <c:if test="${wdk_summary_checksum != null}">
    <pg:param name="summary" id="pager" />
  </c:if>
  <c:if test="${wdk_sorting_checksum != null}">
    <pg:param name="sort" id="pager" />
  </c:if>

<%--------- PAGING TOP BAR ----------%>
<c:url var="commandUrl" value="/processSummaryView.do?step=${wdkStep.stepId}&view=${wdkView.name}" />
<table width="100%">
	<tr class="subheaderrow">
	<th style="text-align: left;white-space:nowrap;"> 
	       <wdk:pager wdkAnswer="${wdkAnswer}" pager_id="top"/> 
	</th>
	<th style="text-align: right;white-space:nowrap;">
         <wdk:addAttributes wdkAnswer="${wdkAnswer}" commandUrl="${commandUrl}"/>
	</th>
  <%-- remove Reset button when new tree structure is activated --%>
  <c:if test="${not wdkAnswer.useCheckboxTree}">
  	<th style="text-align: right;white-space:nowrap;width:5%;">
	    &nbsp;
	    <input type="button" value="Reset Columns" onClick="resetAttr('${commandUrl}', this)" />
	  </th>
	</c:if>
	</tr>
</table>
<%--------- END OF PAGING TOP BAR ----------%>
	
<c:if test = "${eupathIsolatesQuestion}">
  <form name="checkHandleForm" method="post" action="/dosomething.jsp"> 
</c:if>
<!-- content of current page -->
<c:set var="sortingAttrNames" value="${wdkAnswer.sortingAttributeNames}" />
<c:set var="sortingAttrOrders" value="${wdkAnswer.sortingAttributeOrders}" />

<%--------- RESULTS  ----------%>
<div class="Results_Div flexigrid">
<div class="bDiv">
<div class="bDivBox">
<table class="Results_Table" width="100%" step="wdkStep.stepId">
<thead>
<tr class="headerrow">

  <c:if test="${recHasBasket}">
    <th>
      <c:choose>
        <c:when test="${wdkUser.guest}">
          <c:set var="basketClick" value="User.login()" />
        </c:when>
        <c:otherwise>
          <c:set var="basketClick" value="updateBasket(this,'page', '0', '${modelName}', '${wdkAnswer.recordClass.fullName}')" />
        </c:otherwise>
      </c:choose>
      <a href="javascript:void(0)" onclick="${basketClick}">
        <img class="head basket" src="wdk/images/basket_gray.png" height="16" width="16" value="0"/>
      </a>
    </th>
  </c:if>

  <c:set var="j" value="0"/>
  <c:forEach items="${wdkAnswer.summaryAttributes}" var="sumAttrib">
    <c:set var="attrName" value="${sumAttrib.name}" />
    <th id="${attrName}" align="left" valign="middle">
	    <table>
        <tr>
          <td>
		        <table>
              <tr>
                <td style="padding:0;">
                  <c:choose>
				            <c:when test="${!sumAttrib.sortable}">
				              <img src="<c:url value='wdk/images/results_arrw_up_blk.png'/>" border="0" alt="Sort up"/>
				            </c:when>
				            <c:when test="${attrName == sortingAttrNames[0] && sortingAttrOrders[0]}">
				              <img src="<c:url value='wdk/images/results_arrw_up_gr.png'/>"  alt="Sort up" 
				                  title="Result is sorted by ${sumAttrib}" />
				            </c:when>
				            <c:otherwise>
                      <%-- display sorting buttons --%>
                      <c:set var="resultsAction" value="javascript:GetResultsPage('${commandUrl}&command=sort&attribute=${attrName}&sortOrder=asc', true, true)" />
                      <a href="${resultsAction}" title="Sort by ${sumAttrib}">
                        <img src="wdk/images/results_arrw_up.png" alt="Sort up" border="0" />
                      </a>
                    </c:otherwise>
                  </c:choose> 
                </td>
              </tr>
              <tr>	
                <td style="padding:0;">
	        <c:choose>
            <c:when test="${!sumAttrib.sortable}">
	             <img src="<c:url value='wdk/images/results_arrw_dwn_blk.png'/>" border="0" />
	          </c:when>
            <c:when test="${attrName == sortingAttrNames[0] && !sortingAttrOrders[0]}">
              <img src="<c:url value='wdk/images/results_arrw_dwn_gr.png'/>" alt="Sort down" 
	                    title="Result is sorted by ${sumAttrib}" />
            </c:when>
            <c:otherwise>
              <%-- display sorting buttons --%>
              <c:set var="resultsAction" value="javascript:GetResultsPage('${commandUrl}&command=sort&attribute=${attrName}&sortOrder=desc', true, true)" />
              <a href="${resultsAction}" title="Sort by ${sumAttrib}">
              <img src="wdk/images/results_arrw_dwn.png" alt="Sort down" border="0" /></a>
            </c:otherwise>
          </c:choose>
                   </td>
                 </tr>
               </table>
             </td>
        <td style="white-space:nowrap;"><span title="${sumAttrib.help}">${sumAttrib.displayName}</span></td>
        <%-- <c:if test="${j != 0}">
          <div style="float:left;">
            <a href="javascript:void(0)">
              <img src="<c:url value='wdk/images/results_grip.png'/>" alt="" border="0" /></a>
          </div>
        </c:if> --%>
        <c:if test="${j != 0}">
          <td style="width:20px;">
            <%-- display remove attribute button --%>
            <c:set var="resultsAction" value="javascript:GetResultsPage('${commandUrl}&command=remove&attribute=${attrName}', true, true)" />
            <a href="${resultsAction}"
                        title="Remove ${sumAttrib} column">
              <img src="<c:url value='wdk/images/results_x.png'/>" alt="Remove" border="0" /></a>
          </td>
        </c:if>
         </tr>
      </table>
    </th>
  <c:set var="j" value="${j+1}"/>
  </c:forEach>
</tr>
</thead>
<tbody class="rootBody">

<c:set var="i" value="0"/>

<c:forEach items="${wdkAnswer.records}" var="record">

    <c:set value="${record.primaryKey}" var="primaryKey"/>
<c:choose>
  <c:when test="${i % 2 == 0}"><tr class="lines"></c:when>
  <c:otherwise><tr class="linesalt"></c:otherwise>
</c:choose>

	<c:if test="${recHasBasket}">
          <td>
            <c:set var="basket_img" value="basket_gray.png"/>
            <c:choose>
              <c:when test="${!wdkUser.guest}">
	        <c:set value="${record.attributes['in_basket']}" var="is_basket"/>
                <c:set var="basketTitle" value="Click to add this item to the basket." />
	        <c:if test="${is_basket == '1'}">
	          <c:set var="basket_img" value="basket_color.png"/>
                  <c:set var="basketTitle" value="Click to remove this item from the basket." />
                </c:if>
                <c:set var="basketClick" value="updateBasket(this, 'single', '${primaryKey.value}', '${modelName}', '${recordName}')" />
              </c:when>
              <c:otherwise>
                <c:set var="basketTitle" value="Please log in to use the basket." />
              </c:otherwise>
            </c:choose>
	    <a href="javascript:void(0)" onclick="${basketClick}">
	      <img title="${basketTitle}" class="basket" value="${is_basket}" src="wdk/images/${basket_img}" width="16" height="16"/>
	    </a>
          </td>
	</c:if>

  <c:set var="j" value="0"/>

  <c:forEach items="${wdkAnswer.summaryAttributeNames}" var="sumAttrName">
    <c:set value="${record.summaryAttributes[sumAttrName]}" var="recAttr"/>
    <c:set var="align" value="align='${recAttr.attributeField.align}'" />
    <c:set var="nowrap">
        <c:if test="${j == 0 || recAttr.attributeField.nowrap}">white-space:nowrap;</c:if>
    </c:set>

    <c:set var="pkValues" value="${primaryKey.values}" />
    <c:set var="projectId" value="${pkValues['project_id']}" />
    <c:set var="id" value="${pkValues['source_id']}" />

    <td ${align} style="${nowrap}padding:3px 2px"><div>
      <c:set var="recNam" value="${record.recordClass.fullName}"/>
      <c:set var="fieldVal" value="${recAttr.briefDisplay}"/>
      <c:choose>
        <c:when test="${j == 0}">

      <div class="primaryKey" fvalue="${fieldVal}" style="display:none;">
        <c:forEach items="${pkValues}" var="pkValue">
          <span key="${pkValue.key}">${pkValue.value}</span>
        </c:forEach>
      </div>

        <c:choose>
           <c:when test = "${eupathIsolatesQuestion && record.summaryAttributes['data_type'] eq 'Sequencing Typed'}">
              <%-- add checkbox --%>
              <a href="showRecord.do?name=${recNam}&project_id=${projectId}&source_id=${id}">${fieldVal}</a><input type="checkbox" name="selectedFields" style="margin-top: 0px; margin-bottom: 0px;" value="${primaryKey.value}">
            <c:set var="clustalwIsolatesCount" value="${clustalwIsolatesCount + 1}"/>
           </c:when>
            <c:otherwise>
              <%-- display a link to record page --%>
		<a class="primaryKey_||_${id}" href="showRecord.do?name=${recNam}&project_id=${projectId}&source_id=${id}">${fieldVal}</a>
            </c:otherwise>
        </c:choose>

        </c:when>   <%-- when j=0 --%>

	<c:otherwise>

          <!-- need to know if fieldVal should be hot linked -->
          <c:choose>
			<c:when test="${fieldVal == null || fn:length(fieldVal) == 0}">
               <span style="color:gray;">N/A</span>
            </c:when>
            <c:when test="${recAttr.class.name eq 'org.gusdb.wdk.model.LinkAttributeValue'}">
               <c:choose>
		  <c:when test="${fn:containsIgnoreCase(dispModelName, 'EuPathDB')}">
		    <a href="javascript:create_Portal_Record_Url('','${projectId}','','${recAttr.url}')">
                      ${recAttr.displayText}</a>
	          </c:when>
	          <c:otherwise>
		    <a href="${recAttr.url}">${recAttr.displayText}</a>
		  </c:otherwise>
	       </c:choose>
            </c:when>
            <c:otherwise>
              ${fieldVal}
            </c:otherwise>
          </c:choose>

        </c:otherwise>
      </c:choose>
    </div></td>
    <c:set var="j" value="${j+1}"/>

  </c:forEach>
</tr>
<c:set var="i" value="${i+1}"/>
</c:forEach>

</tr>

</tbody>
</table>
</div>
</div>
</div>
<%--------- END OF RESULTS  ----------%>

<c:if test = "${eupathIsolatesQuestion && clustalwIsolatesCount > 1}">
<table width="100%" border="0" cellpadding="3" cellspacing="0">
	<tr align=center>
    	  <td> <b><br/> 
     	  Please select at least two isolates to run ClustalW. Note: only isolates from a single results page will be aligned. <br/>
     	  Increase the page size in advanced paging to increase the number that can be aligned).  </b>
    	  </td>
  	</tr>
	<tr>
	  <td align=center> 
	  <input type="button" value="Run Clustalw on Checked Strains" onClick="goToIsolate(this)" />
<!--
	  <input type="button" name="CheckAll" value="Check All" onClick="checkboxAll(this)">
	  <input type="button" name="CheckAll" value="Check All" 
		onClick="checkboxAll($(this).parents('form[name=checkHandleForm]').find('input:checkbox[name=selectedFields]'))">
-->
	  <input type="button" name="CheckAll" value="Check All" 
		onClick="checkboxAll($('input:checkbox[name=selectedFields]'))">
      	  <input type="button" name="UnCheckAll" value="Uncheck All" 
		onClick="checkboxNone($('input:checkbox[name=selectedFields]'))">
	  </td>
	</tr>
</table>
</c:if>

<c:if test = "${eupathIsolatesQuestion}">
  </form>
</c:if>

<%--------- PAGING BOTTOM BAR ----------%>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
	<tr class="subheaderrow">
	<th style="text-align:left;white-space:nowrap;"> 
	       <imp:pager wdkAnswer="${wdkAnswer}" pager_id="bottom"/> 
	</th>
	<th style="text-align:right;white-space:nowrap;">
		&nbsp;
	</th>
	<th style="text-align:right;white-space:nowrap;width:5%;">
	    &nbsp;
	</th>
	</tr>
</table>
<%--------- END OF PAGING BOTTOM BAR ----------%>
</pg:pager>


  </c:otherwise>
</c:choose>
