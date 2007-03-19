<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>


<!-- get wdkAnswer from requestScope -->
<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>
<c:set value="${requestScope.wdkHistory}" var="history"/>
<c:set value="${requestScope.wdkAnswer}" var="wdkAnswer"/>
<c:set var="modelName" value="${applicationScope.wdkModel.name}" />
<c:set var="historyId" value="${param['wdk_history_id']}"/>
<c:if test="${historyId == null}">
    <c:set var="historyId" value="${requestScope.wdk_history_id}"/>
</c:if>

<%--
<c:set var="showOrthoLink" value="${fn:containsIgnoreCase(modelName, 'plasmodb')}" />
--%>

<c:set var="dispModelName" value="${applicationScope.wdkModel.displayName}" />
<c:set var="showOrthoLink" value="${fn:containsIgnoreCase(modelName, 'plasmodb') || fn:containsIgnoreCase(modelName, 'apiModel')}" />

<c:set var="global" value="${wdkUser.globalPreferences}"/>
<c:set var="showParam" value="${global['preference_global_show_param']}"/>

<!-- display page header with wdkAnswer's recordClass's type as banner -->
<c:set value="${wdkAnswer.recordClass.type}" var="wdkAnswerType"/>
<c:set var="qName" value="${wdkAnswer.question.fullName}" />


<site:header title="${wdkModel.displayName} : Query Result"
                 banner="${wdkAnswerType} Results"
                 parentDivision="Queries & Tools"
                 parentUrl="/showQuestionSetsFlat.do"
                  divisionName="Summary Result"
                 division="queries_tools"/>
                 

<script language="JavaScript" type="text/javascript">
<!--

var showParam = "${showParam}";


function enableRename() {
   var nameText = document.getElementById('nameText');
   nameText.style.display = 'none';
   
   var nameInput = document.getElementById('nameInput');
   nameInput.style.display='block';
   
   var nameBox = document.getElementById('customHistoryName');
   nameBox.value = '${history.customName}';
   nameBox.select();
   nameBox.focus();
}

function disableRename() {
   var nameInput = document.getElementById('nameInput');
   nameInput.style.display='none';
   
   var nameText = document.getElementById('nameText');
   nameText.style.display = 'block';
}

function savePreference()
{
    // construct url
    var url = "<c:url value='/savePreference.do'/>";
    url = url + "?preference_global_show_param=" + showParam;
    
    // commit the preference
    var xmlObj = null;

	if(window.XMLHttpRequest){
		xmlObj = new XMLHttpRequest();
	} else if(window.ActiveXObject){
		xmlObj = new ActiveXObject("Microsoft.XMLHTTP");
	} else {
        // ajax is not supported??
		return;
	}
	
	xmlObj.open( 'GET', url, true );
	xmlObj.send('');

}

function showParameter(isShow) 
{
    var showLink = document.getElementById("showParamLink");
    var showArea = document.getElementById("showParamArea");

    showParam = isShow;
      
    if (isShow == "yes") {
        showLink.innerHTML = "<a href=\"#\" onclick=\"return showParameter('no');\">Hide</a>";
        showArea.style.display = "block";
    } else {
        showLink.innerHTML = "<a href=\"#\" onclick=\"return showParameter('yes');\">Show</a>";
        showArea.style.display = "none";
    }
    
    // save preference via ajax
    savePreference();
    
    return false;
}


function removeAttr() {
    var attributeSelect = document.getElementById("removeAttributes");
    var index = attributeSelect.selectedIndex;
    var attribute = attributeSelect.options[index].value;
    
    if (attribute.length == 0) return;
    
    var pageUrl = "<c:url value='showSummary.do?wdk_history_id=${historyId}"
        + "&summaryQuestion=${qName}&command=remove&attribute=" + attribute + "' />";
        
    window.location.href = pageUrl;
}


function addAttr() {
    var attributeSelect = document.getElementById("addAttributes");
    var index = attributeSelect.selectedIndex;
    var attribute = attributeSelect.options[index].value;
    
    if (attribute.length == 0) return;
    
    var pageUrl = "<c:url value='showSummary.do?wdk_history_id=${historyId}"
        + "&summaryQuestion=${qName}&command=add&attribute=" + attribute + "' />";
        
    window.location.href = pageUrl;
}


function resetAttr() {
    if (confirm("Are you sure to reset the column layout?")) {
        var pageUrl = "<c:url value='showSummary.do?wdk_history_id=${historyId}"
            + "&summaryQuestion=${qName}&command=reset' />";
        
        window.location.href = pageUrl;
    }
}


//-->
</script>


<table border=0 width=100% cellpadding=3 cellspacing=0 bgcolor=white class=thinTopBottomBorders> 

 <tr>
  <td bgcolor=white valign=top>


<!-- display question and param values and result size for wdkAnswer -->
<table border="0" cellspacing="1" cellpadding="1">
    <c:set var="paddingStyle" value="" />
    <c:if test="${history.boolean}">
       <c:set var="paddingStyle" value="style='padding-left:40px;'" />
    </c:if>
    
    <!-- display query name -->
    <tr>
       <td valign="top" align="right" width="10" nowrap><b>Query:&nbsp; </b></td>
          <html:form method="get" action="/renameHistory.do">
       <td valign="top" align="left" ${paddingStyle}>
             <div id="nameText" onclick="enableRename()">
                <table border='0' cellspacing='2' cellpadding='0'>
                   <tr>
                      <td align="left">${history.customName}</td>
                      <td align="right"><input type="button" value="Rename" onclick="enableRename()" /></td>
                   </tr>
                </table>
             </div>
             <div id="nameInput" style="display:none">
                <table border='0' cellspacing='2' cellpadding='0'>
                   <tr>
                      <td><input name='wdk_history_id' type='hidden' value="${history.historyId}"/></td>
                      <td><input id='customHistoryName' name='customHistoryName' type='text' size='50' 
                                maxLength='2000' value="${history.customName}"/></td>
                      <td><input type='submit' value='Update'></td>
                      <td><input type='reset' value='Cancel' onclick="disableRename()"/></td>
                   </tr>
                </table>
             </div>
       </td>
          </html:form>
    </tr>

    <!-- display parameters -->
    <tr>
       <td valign="top" align="right" width="10" nowrap><b>Details:&nbsp; </b></td>
       <td align="left" valign="bottom">
          <div ${paddingStyle} id="showParamLink">
                <c:choose>
                   <c:when test="${showParam == 'yes'}">
                      <a href="#" onclick="return showParameter('no');">Hide</a>
                   </c:when>
                   <c:otherwise>
                      <a href="#" onclick="return showParameter('yes');">Show</a>
                   </c:otherwise>
                </c:choose>
            </div>
       </td>
    </tr>
    <tr>
       <td></td>
       <td ${paddingStyle}>
          <!-- a section to display/hide params -->
          <c:choose>
             <c:when test="${showParam == 'yes'}">
                <div id="showParamArea" style="background:#EEEEEE;">
             </c:when>
             <c:otherwise>
                <div id="showParamArea" style="display:none; background:#EEEEEE;">
             </c:otherwise>
          </c:choose>
             <c:choose>
                <c:when test="${history.boolean}">
                   <div>
                      <!-- boolean question -->
                      <nested:root name="wdkAnswer">
                         <jsp:include page="/WEB-INF/includes/bqShowNode.jsp"/>
                      </nested:root>
	               </div>
                </c:when>
                <c:otherwise>
	            <div ${paddingStyle}>
                   <!-- simple question -->
                   <c:set value="${wdkAnswer.internalParams}" var="params"/>
                   <c:set value="${wdkAnswer.question.paramsMap}" var="qParamsMap"/>
                   <c:set value="${wdkAnswer.question.displayName}" var="wdkQuestionName"/>
                   <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                         <td align="right" valign="top"><i>Query</i></td>
                         <td valign="top">&nbsp;:&nbsp;</td>
                         <td>${wdkQuestionName}</td>
                      </tr>
                      <c:forEach items="${qParamsMap}" var="p">
                         <c:set var="pNam" value="${p.key}"/>
                         <c:set var="qP" value="${p.value}"/>
                         <c:set var="aP" value="${params[pNam]}"/>
                         <c:if test="${qP.isVisible}">
                            <tr>
                               <td align="right" valign="top"><i>${qP.prompt}</i></td>
                               <td>&nbsp;:&nbsp;</td>
                               <td>
                                  <c:choose>
                                     <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.DatasetParamBean'}">
                                        <jsp:setProperty name="qP" property="combinedId" value="${aP}" />
                                        <c:set var="dataset" value="${qP.dataset}" />  
                                        "${dataset.summary}"
                                        <c:if test='${dataset.uploadFile != null && dataset.uploadFile != ""}'>
                                           from file &lt;${dataset.uploadFile}&gt;
                                        </c:if>
                                     </c:when>
                                     <c:otherwise>
                                        ${aP}
                                     </c:otherwise>
                                  </c:choose>
                               </td>
                            </tr>
                         </c:if>
                      </c:forEach>
                   </table>
                </div>
                </c:otherwise>
             </c:choose>
         </div>
       </td>
    </tr>
    
    <!-- display result size -->
    <tr>
       <td valign="top" align="right" width="10" nowrap><b>Results:&nbsp; </b></td>
       <td valign="top" align="left" ${paddingStyle}>
          ${wdkAnswer.resultSize}
          <c:if test="${wdkAnswer.resultSize > 0}">
             (showing ${wdk_paging_start} to ${wdk_paging_end})
              <c:if test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
                 <site:apidbSummary/>
             </c:if>
          </c:if>
       </td>
    </tr>
    <tr>
       <td colspan="2" align="left">
           <a href="downloadHistoryAnswer.do?wdk_history_id=${historyId}">
               Download</a>&nbsp;|&nbsp;
           <a href="<c:url value="/showQueryHistory.do"/>">Combine with other results</a>
	       
           <c:set value="${wdkAnswer.recordClass.fullName}" var="rsName"/>
           <c:set var="isGeneRec" value="${fn:containsIgnoreCase(rsName, 'GeneRecordClass')}"/>
           <c:set var="isContigRec" value="${fn:containsIgnoreCase(rsName, 'ContigRecordClass')}"/>
	       <c:if test="${isGeneRec && showOrthoLink}">
	           &nbsp;|&nbsp;
               <c:set var="datasetId" value="${wdkAnswer.datasetId}"/>
               <c:set var="dsColUrl" value="showQuestion.do?questionFullName=InternalQuestions.GenesByOrthologs&historyId=${wdkUser.signature}:${historyId}&plasmodb_dataset=${datasetId}&questionSubmit=Get+Answer&goto_summary=0"/>
               <a href='<c:url value="${dsColUrl}"/>'>Orthologs</a>
           </c:if>
	       
               <c:set value="${wdkAnswer.question.fullName}" var="qName" />
	       <c:if test="${history.boolean == false}">
	           &nbsp;|&nbsp;
                   <c:set value="${wdkAnswer.questionUrlParams}" var="qurlParams"/>
	           <c:set var="questionUrl" value="" />
                   <a href="showQuestion.do?questionFullName=${qName}${qurlParams}&questionSubmit=Get+Answer&goto_summary=0">
	           Revise query</a>
	       </c:if>
       </td>
    </tr>
</table>


<hr>

<!-- handle empty result set situation -->
<c:choose>
  <c:when test='${wdkAnswer.resultSize == 0}'>
    No results for your query
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
  <pg:param name="wdk_history_id" id="pager" value="${historyId}" />
  <!-- pager on top -->
  <wdk:pager pager_id="top"/> 

<div align="right">
  <table cellspacing="0" cellpadding="0" border="0">
    <tr>
       <td nowrap>
           <%-- display a list of displaying attributes to be removed --%>
           <c:set var="removeAttributes" value="${wdkAnswer.summaryAttributes}" />
           &nbsp;
           <select id="removeAttributes" name="removeAttributes" onChange="removeAttr();">
               <option value="">--- Remove Column ---</option>
               <c:set var="j" value="0"/>
               <c:forEach items="${removeAttributes}" var="attribute">
                 <c:if test="${j != 0}">
                   <option value="${attribute.name}">${attribute.displayName}</option>
                 </c:if>
                 <c:set var="j" value="${j+1}"/>
               </c:forEach>
           </select>
       </td>
       <td nowrap>
           <%-- display a list of sortable attributes --%>
           <c:set var="addAttributes" value="${wdkAnswer.sortableAttributes}" />
           &nbsp;
           <select id="addAttributes" onChange="addAttr()">
               <option value="">--- Add Column ---</option>
               <c:forEach items="${addAttributes}" var="attribute">
                 <option value="${attribute.name}">${attribute.displayName}</option>
               </c:forEach>
           </select>
       </td>
       <td nowrap>
          <input type="button" value="Reset Columns" onClick="resetAttr()" />
       </td>
    </tr>
  </table>
</div>

<!-- content of current page -->
<table width="100%" border="1" cellpadding="6" cellspacing="0">
<tr class="headerRow">

<c:set var="sortingAttrNames" value="${wdkAnswer.sortingAttributeNames}" />
<c:set var="sortingAttrOrders" value="${wdkAnswer.sortingAttributeOrders}" />

  <c:set var="j" value="0"/>

  <c:forEach items="${wdkAnswer.summaryAttributes}" var="sumAttrib">
    <th align="left">
      <c:set var="attrName" value="${sumAttrib.name}" />
      <table border="0" cellspacing="0" cellpadding="0">
        <tr class="headerCleanRow">
            <th align="center" valign="middle" colspan="3">${sumAttrib.displayName}</th>
        </tr>
        <tr class="headerCleanRow">
            <th align="right" valign="middle" width="40%" nowrap>
                <%-- display arrange attribute buttons --%>
                <c:if test="${j != 0 && j != 1}">
                    <a href="<c:url value='/showSummary.do?wdk_history_id=${historyId}&summaryQuestion=${qName}&command=arrange&attribute=${attrName}&left=true' />" 
                       title="Move ${sumAttrib} left">
                        <img src="<c:url value='/images/move_left.gif' />" border="0" /></a>
                </c:if>
                <c:if test="${j != 0 && j != fn:length(wdkAnswer.summaryAttributes) - 1}">
                    <a href="<c:url value='/showSummary.do?wdk_history_id=${historyId}&summaryQuestion=${qName}&command=arrange&attribute=${attrName}&left=false' />" 
                       title="Move ${sumAttrib} right">
                        <img src="<c:url value='/images/move_right.gif' />" border="0" /></a>
                </c:if>
                &nbsp;
            </th>
            <th align="center" valign="middle" width="10%">
                <div>
                <c:choose>
                    <c:when test="${attrName == sortingAttrNames[0] && sortingAttrOrders[0]}">
                        <img src="<c:url value='images/sort_up_h.gif' />" 
                             title="Result is sorted by ${sumAttrib}" />
                    </c:when>
                    <c:otherwise>
                        <%-- display sorting buttons --%>
                        <a href="<c:url value='/showSummary.do?wdk_history_id=${historyId}&summaryQuestion=${qName}&command=sort&attribute=${attrName}&sortOrder=asc' />" 
                           title="Sort by ${sumAttrib}">
                            <img src="<c:url value='/images/sort_up.gif' />" border="0" /></a>
                    </c:otherwise>
                </c:choose>
                </div>
                <div>
                <c:choose>
                    <c:when test="${attrName == sortingAttrNames[0] && !sortingAttrOrders[0]}">
                        <img src="<c:url value='images/sort_down_h.gif' />" 
                             title="Result is reverse sorted by ${sumAttrib}" />
                    </c:when>
                    <c:otherwise>
                        <%-- display sorting buttons --%>
                        <a href="<c:url value='/showSummary.do?wdk_history_id=${historyId}&summaryQuestion=${qName}&command=sort&attribute=${attrName}&sortOrder=desc' />" 
                           title="Reverse sort by ${sumAttrib}">
                            <img src="<c:url value='/images/sort_down.gif' />" border="0" /></a>
                    </c:otherwise>
                </c:choose>
                </div>
            </th>
            <th align="left" valign="middle" width="40%">
                &nbsp;
                <c:if test="${j != 0}">
                    <%-- display remove attribute buttons --%>
                    <a href="<c:url value='/showSummary.do?wdk_history_id=${historyId}&summaryQuestion=${qName}&command=remove&attribute=${attrName}' />" 
                       title="Remove ${sumAttrib} column">
                        <img src="<c:url value='/images/remove.gif' />" border="0" /></a>
                </c:if>
            </th>
        </tr>
      </table>
    </th>
    <c:set var="j" value="${j+1}"/>
  </c:forEach>
</tr>

<c:set var="i" value="0"/>
<c:forEach items="${wdkAnswer.records}" var="record">

<c:choose>
  <c:when test="${i % 2 == 0}"><tr class="rowLight"></c:when>
  <c:otherwise><tr class="rowMedium"></c:otherwise>
</c:choose>

  <c:set var="j" value="0"/>

  <c:forEach items="${wdkAnswer.summaryAttributeNames}" var="sumAttrName">
    <c:set value="${record.summaryAttributes[sumAttrName]}" var="recAttr"/>
    <c:set var="align" value="align='${recAttr.alignment}'" />
    <c:set var="nowrap">
        <c:if test="${recAttr.nowrap}">nowrap</c:if>
    </c:set>
    <td ${align} ${nowrap}>
      <c:set var="recNam" value="${record.recordClass.fullName}"/>
      <c:set var="fieldVal" value="${recAttr.briefValue}"/>
      <c:choose>
        <c:when test="${j == 0}">

          <c:choose>
            <c:when test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
               
              <c:set value="${record.primaryKey}" var="primaryKey"/>
              <c:choose>
                <c:when test = "${primaryKey.projectId == 'cryptodb'}">
                  <a href="http://www.cryptodb.org/cryptodb/showRecord.do?name=${recNam}&project_id=&primary_key=${primaryKey.recordId}" 
                     target="cryptodb">CryptoDB:${primaryKey.recordId}</a>
                </c:when>
                <c:when test = "${primaryKey.projectId=='plasmodb'}" >
                  <c:if test="${isContigRec}">
                    <c:set var="recNam" value="SequenceRecordClasses.SequenceRecordClass"/>
                  </c:if>
                  <a href="http://www.plasmodb.org/plasmo/showRecord.do?name=${recNam}&project_id=&primary_key=${primaryKey.recordId}"  
                     target="plasmodb">PlasmoDB:${primaryKey.recordId}</a>
                </c:when>
                <c:when test = "${primaryKey.projectId=='toxodb'}" >
                  <c:if test="${isContigRec}">
                    <c:set var="recNam" value="SequenceRecordClasses.SequenceRecordClass"/>
                  </c:if>
                  <a href="http://www.toxodb.org/toxo/showRecord.do?name=${recNam}&project_id=&primary_key=${primaryKey.recordId}"  target="toxodb">ToxoDB:${primaryKey.recordId}</a>
                </c:when>
              </c:choose>
            
            </c:when>
            <c:otherwise>

              <%-- display a link to record page --%>
              <c:set value="${record.primaryKey}" var="primaryKey"/>
              <a href="showRecord.do?name=${recNam}&project_id=${primaryKey.projectId}&primary_key=${primaryKey.recordId}">${fieldVal}</a>

            </c:otherwise>
          </c:choose>

        </c:when>   <%-- when j=0 --%>
        <c:otherwise>

          <!-- need to know if fieldVal should be hot linked -->
          <c:choose>
            <c:when test="${recAttr.value.class.name eq 'org.gusdb.wdk.model.LinkValue'}">
              <a href="${recAttr.value.url}">${recAttr.value.visible}</a>
            </c:when>
            <c:otherwise>
              ${fieldVal}
            </c:otherwise>
          </c:choose>

        </c:otherwise>
      </c:choose>
    </td>
    <c:set var="j" value="${j+1}"/>

  </c:forEach>
</tr>
<c:set var="i" value="${i+1}"/>
</c:forEach>

</tr>
</table>

<br>

  <!-- pager at bottom -->
  <wdk:pager pager_id="bottom"/>
</pg:pager>

  </c:otherwise>
</c:choose>


  </td>
  <td valign=top class=dottedLeftBorder></td> 
</tr>
</table> 

<site:footer/>
