<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>


<!-- get wdkAnswer from requestScope -->
<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>
<c:set var="history" value="${requestScope.wdkHistory}"/>
<c:set var="historyId" value="${history.historyId}"/>
<c:set var="wdkAnswer" value="${requestScope.wdkAnswer}"/>
<c:set var="qName" value="${wdkAnswer.question.fullName}" />
<c:set var="modelName" value="${applicationScope.wdkModel.name}" />
<c:set var="summaryUrl" value="${wdk_summary_url}" />
<c:set var="commandUrl">
    <c:url value="/processSummary.do?${wdk_query_string}" />
</c:set>

<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />

<c:set var="dispModelName" value="${applicationScope.wdkModel.displayName}" />
<c:set var="showOrthoLink" value="${fn:containsIgnoreCase(modelName, 'plasmodb') || fn:containsIgnoreCase(modelName, 'apidb') || fn:containsIgnoreCase(modelName, 'CryptoDB')}" />

<c:set var="cryptoIsolatesQuestion" value="${fn:containsIgnoreCase(qName, 'Isolate') && fn:containsIgnoreCase(modelName, 'CryptoDB')}" />

<c:set var="global" value="${wdkUser.globalPreferences}"/>
<c:set var="showParam" value="${global['preference_global_show_param']}"/>

<!-- display page header with wdkAnswer's recordClass's type as banner -->
<c:set value="${wdkAnswer.recordClass.type}" var="wdkAnswerType"/>


<site:header title="${wdkModel.displayName} : Query Result"
                 banner="${wdkAnswerType} Results"
                 parentDivision="Queries & Tools"
                 parentUrl="/showQuestionSetsFlat.do"
                  divisionName="Summary Result"
                 division="queries_tools"/>
                 

<script language="JavaScript" type="text/javascript">
<!--

var showParam = "${showParam}";

function goToIsolate() {
   var form = document.checkHandleForm;
   var cbs = form.selectedFields;
   var url = "/cgi-bin/isolateClustalw?project_id=CryptoDB;isolate_ids=";
   for (var i=0; i<cbs.length; i++) {
         if(cbs[i].checked) {
       url += cbs[i].value + ",";
               }
   }
   window.location.href = url;
 }


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


function addAttr() {
    var attributeSelect = document.getElementById("addAttributes");
    var index = attributeSelect.selectedIndex;
    var attribute = attributeSelect.options[index].value;
    
    if (attribute.length == 0) return;

    var url = "${commandUrl}&command=add&attribute=" + attribute;
    window.location.href = url;
}


function resetAttr() {
    if (confirm("Are you sure you want to reset the column configuration back to the default?")) {
        var url = "${commandUrl}&command=reset";
        window.location.href = url;
    }
}

function create_Portal_Record_Url(recordName, projectId, primaryKey, portal_url) {
	//var portal_url = "";
	if(portal_url.length == 0){
		if(projectId == 'CryptoDB'){
			portal_url = "http://www.cryptodb.org/cryptodb/showRecord.do?name=" + recordName + "&project_id=&source_id=" + primaryKey;
		} else if(projectId == 'PlasmoDB'){
			portal_url = "http://www.plasmodb.org/plasmo/showRecord.do?name=" + recordName + "&project_id=&source_id=" + primaryKey;
		} else if(projectId == 'ToxoDB'){
			portal_url = "http://www.toxodb.org/toxo/showRecord.do?name=" + recordName + "&project_id=&source_id=" + primaryKey;
		} else if(projectId == 'GiardiaDB'){
			portal_url = "http://www.giardiadb.org/giardiadb/showRecord.do?name=" + recordName + "&project_id=" + projectId + "&source_id=" + primaryKey;
		} else if(projectId == 'TrichDB'){
			portal_url = "http://www.trichdb.org/trichdb/showRecord.do?name=" + recordName + "&project_id=" + projectId + "&source_id=" + 	primaryKey;
		} else if(projectId == 'ApiDB'){
			portal_url = "http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=nucleotide&cmd=search&term=" + primaryKey; 
		}
		window.location = portal_url;
	} else {
		recordName = parse_Url(portal_url, "name");
		primaryKey = parse_Url(portal_url, "source_id");
		create_Portal_Record_Url(recordName,projectId,primaryKey,"");
	} 
}

function parse_Url( url, parameter_name )
{
  parameter_name = parameter_name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+parameter_name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( url );
  if( results == null )
    return "";
  else
    return results[1];
}


//-->
</script>


<table border=0 width=100% cellpadding=3 cellspacing=0 bgcolor=white class=thinTopBorders> 

 <tr>
  <td bgcolor=white valign=top>


<!-- display question and param values and result size for wdkAnswer -->
<table border="0" width="100%" cellspacing="1" cellpadding="1">
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
            <c:when test="${wdkAnswer.isBoolean}">
                <div>
                    <%-- boolean question --%>
                    <nested:root name="wdkAnswer">
                        <jsp:include page="/WEB-INF/includes/bqShowNode.jsp"/>
                    </nested:root>
                </div>

                <c:set var="recordClass" value="${wdkAnswer.question.recordClass}"/>

            </c:when>
            <c:otherwise>
                <wdk:showParams wdkAnswer="${wdkAnswer}" />
            </c:otherwise>
          </c:choose>
          </div>
       </td>
    </tr>
    
    <!-- display result size -->
    <tr>
       <td valign="top" align="right" width="10" nowrap><b>Results:&nbsp; </b></td>
       <td valign="top" align="left" ${paddingStyle}>
          <c:choose>
            <c:when test="${wdkAnswer.filter == null}">
              ${wdkAnswer.resultSize}
            </c:when>
            <c:otherwise>
              ${history.filterSize}
            </c:otherwise>
          </c:choose>
 <c:if test="${wdkAnswer.resultSize == 0}">
              <c:if test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
                 <site:apidbSummary/>
             </c:if>
   </c:if>

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
	       
	       <c:set var="recordClass" value="${wdkAnswer.recordClass}"/>
           <c:set var="rsName" value="${recordClass.fullName}"/>
           <c:set var="isGeneRec" value="${fn:containsIgnoreCase(rsName, 'GeneRecordClass')}"/>
           <c:set var="isContigRec" value="${fn:containsIgnoreCase(rsName, 'ContigRecordClass')}"/>
	       <c:if test="${isGeneRec && showOrthoLink}">
	           &nbsp;|&nbsp;
               <c:set var="datasetId" value="${wdkAnswer.datasetId}"/>
               <c:set var="dsColUrl" value="showQuestion.do?questionFullName=InternalQuestions.GenesByOrthologs&geneHistoryId=${wdkUser.signature}:${historyId}&plasmodb_dataset=${datasetId}&questionSubmit=Get+Answer&goto_summary=0"/>
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

<c:choose>
  <c:when test="${wdkAnswer.filter == null}">
    <c:set value="all_results" var="curFilter" />
  </c:when>
  <c:otherwise>
    <c:set value="${wdkAnswer.filter.name}" var="curFilter" />
  </c:otherwise>
</c:choose>

<!-- display basic filters -->
<div class="filter">
<table cellpadding="5" border="1">
  <tr>
    <th>All Results</th>
    <th>Tg Results</th>
    <th>Tg Genes</th>
    <th>Nc Genes</th>
  </tr>
  <tr align="center">
    <c:choose>
      <c:when test="${curFilter eq 'all_results'}">
        <td class="selected">${wdkAnswer.resultSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=all_results">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'all_tg_results'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=all_tg_results">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'toxo_genes'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=toxo_genes">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'neospora_genes'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=neospora_genes">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
  </tr>
</table>
</div>

<div class="filter">
<table cellpadding="5" border="1">
  <tr>
    <th colspan="2">GT1</th>
    <th colspan="2">ME49</th>
    <th colspan="2">VEG</th>
    <th>All Tg Strains</th>
  </tr>
  <tr align="center">
    <c:choose>
      <c:when test="${curFilter eq 'gt1_genes'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=gt1_genes">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'gt1_instances'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=gt1_instances">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'me49_genes'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=me49_genes">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'me49_instances'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=me49_instances">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'veg_genes'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=veg_genes">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'veg_instances'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=veg_instances">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
    <c:choose>
      <c:when test="${curFilter eq 'each_tg_instance'}">
        <td class="selected">${wdkHistory.filterSize}
      </c:when>
      <c:otherwise>
        <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=each_tg_instance">&nbsp;</a>
      </c:otherwise>
    </c:choose></td>
  </tr>
</table>
</div>

<div class="clear_all"><span id="toggle_filter">Hide</span> comparison of similarities and differences between strains.</div>

<!-- display "advanced" filters -->
<div id="advanced_filters">
   <div class="filter">
      <table cellpadding="5" border="1">
        <tr>
          <td>Tg genes minus GT1</td>
          <c:choose>
            <c:when test="${curFilter eq 'all_min_gt1'}">
              <td class="selected">${wdkHistory.filterSize}
            </c:when>
            <c:otherwise>
              <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=all_min_gt1">&nbsp;</a>
            </c:otherwise>
          </c:choose></td>
        </tr>
        <tr>
          <td>Tg genes minus ME49</td>
          <c:choose>
            <c:when test="${curFilter eq 'all_min_me49'}">
              <td class="selected">${wdkHistory.filterSize}
            </c:when>
            <c:otherwise>
              <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=all_min_me49">&nbsp;</a>
            </c:otherwise>
          </c:choose></td>
        </tr>
        <tr>
          <td>Tg genes minus VEG</td>
          <c:choose>
            <c:when test="${curFilter eq 'all_min_veg'}">
              <td class="selected">${wdkHistory.filterSize}
            </c:when>
            <c:otherwise>
              <td><a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=all_min_veg">&nbsp;</a>
            </c:otherwise>
          </c:choose></td>
        </tr>
      </table>
   </div>
   <div class="filter labels">
     <ul>
       <li class="top_label">GT1</li>
       <li class="bottom_label">ME49</li>
     </ul>
   </div>
   <c:choose>
     <c:when test="${curFilter eq 'gt1_min_me49'}">
       <div class="filter diagram gt1_me49 gt1_selected">
     </c:when>
     <c:when test="${curFilter eq 'gt1_int_me49'}">
       <div class="filter diagram gt1_me49 int_selected">
     </c:when>
     <c:when test="${curFilter eq 'me49_min_gt1'}">
       <div class="filter diagram gt1_me49 me49_selected">
     </c:when>
     <c:otherwise>
       <div class="filter diagram gt1_me49">
     </c:otherwise>
   </c:choose>
     <ul>
       <c:choose>
         <c:when test="${curFilter eq 'gt1_min_me49'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=gt1_min_me49">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
       <c:choose>
         <c:when test="${curFilter eq 'gt1_int_me49'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=gt1_int_me49">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
       <c:choose>
         <c:when test="${curFilter eq 'me49_min_gt1'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=me49_min_gt1">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
     </ul>
   </div>
   <div class="filter labels">
     <ul>
       <li class="top_label">GT1</li>
       <li class="bottom_label">VEG</li>
     </ul>
   </div>
   <c:choose>
     <c:when test="${curFilter eq 'gt1_min_veg'}">
       <div class="filter diagram gt1_veg gt1_selected">
     </c:when>
     <c:when test="${curFilter eq 'gt1_int_veg'}">
       <div class="filter diagram gt1_veg int_selected">
     </c:when>
     <c:when test="${curFilter eq 'veg_min_gt1'}">
       <div class="filter diagram gt1_veg veg_selected">
     </c:when>
     <c:otherwise>
       <div class="filter diagram gt1_veg">
     </c:otherwise>
   </c:choose>
     <ul>
       <c:choose>
         <c:when test="${curFilter eq 'gt1_min_veg'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=gt1_min_veg">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
       <c:choose>
         <c:when test="${curFilter eq 'gt1_int_veg'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=gt1_int_veg">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
       <c:choose>
         <c:when test="${curFilter eq 'veg_min_gt1'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=veg_min_gt1">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
     </ul>
   </div>
   <div class="filter labels">
     <ul>
       <li class="top_label">ME49</li>
       <li class="bottom_label">VEG</li>
     </ul>
   </div>
   <c:choose>
     <c:when test="${curFilter eq 'me49_min_veg'}">
       <div class="filter diagram me49_veg me49_selected">
     </c:when>
     <c:when test="${curFilter eq 'me49_int_veg'}">
       <div class="filter diagram me49_veg int_selected">
     </c:when>
     <c:when test="${curFilter eq 'veg_min_me49'}">
       <div class="filter diagram me49_veg veg_selected">
     </c:when>
     <c:otherwise>
       <div class="filter diagram me49_veg">
     </c:otherwise>
   </c:choose>
     <ul>
       <c:choose>
         <c:when test="${curFilter eq 'me49_min_veg'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=me49_min_veg">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
       <c:choose>
         <c:when test="${curFilter eq 'me49_int_veg'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=me49_int_veg">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
       <c:choose>
         <c:when test="${curFilter eq 'veg_min_me49'}">
           <li class="selected">${wdkHistory.filterSize}
         </c:when>
         <c:otherwise>
         <li>
           <a class="filter_link" href="getFilterLink.do?wdk_history_id=${historyId}&filter=veg_min_me49">&nbsp;</a>
         </c:otherwise>
       </c:choose>
       </li>
     </ul>
   </div>
</div>

<hr class="clear_all"/>

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
  <c:forEach var="paramName" items="${wdk_paging_params}">
    <pg:param name="${paramName}" id="pager" />
  </c:forEach>
  <c:if test="${wdk_summary_checksum != null}">
    <pg:param name="summary" id="pager" />
  </c:if>
  <c:if test="${wdk_sorting_checksum != null}">
    <pg:param name="sort" id="pager" />
  </c:if>

  <table cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
      <td nowrap> 
        <!-- pager on top -->
        <wdk:pager pager_id="top"/> 
      </td>
      <td nowrap align="right">
           <%-- display a list of sortable attributes --%>
           <c:set var="addAttributes" value="${wdkAnswer.displayableAttributes}" />
           <select id="addAttributes" onChange="addAttr()">
               <option value="">--- Add Column ---</option>
               <c:forEach items="${addAttributes}" var="attribute">
                 <option value="${attribute.name}">${attribute.displayName}</option>
               </c:forEach>
           </select>
      </td>
      <td nowrap align="right" width="5%">
         &nbsp;
         <input type="button" value="Reset Columns" onClick="resetAttr()" />
      </td>
    </tr>
  </table>

<!-- content of current page -->
<table width="100%" border="0" cellpadding="3" cellspacing="0">


<tr class="headerRow">
  <c:forEach items="${wdkAnswer.summaryAttributes}" var="sumAttrib">
    <th align="center" valign="middle">
      ${sumAttrib.displayName}
    </th>
  </c:forEach>
</tr>

<tr class="headerButtonRow">

    <c:set var="sortingAttrNames" value="${wdkAnswer.sortingAttributeNames}" />
    <c:set var="sortingAttrOrders" value="${wdkAnswer.sortingAttributeOrders}" />

    <c:set var="j" value="0"/>

    <c:forEach items="${wdkAnswer.summaryAttributes}" var="sumAttrib">
        <th align="center" valign="middle">
            <c:set var="attrName" value="${sumAttrib.name}" />
      
            <table border="0" cellspacing="2" cellpadding="0">
                <tr class="headerInternalRow">
                    <td valign="middle">
                        <c:choose>
                            <c:when test="${j != 0 && j != 1}">
                                <%-- display arrange attribute buttons --%>
                                <a href="${commandUrl}&command=arrange&attribute=${attrName}&left=true" 
                                   title="Move ${sumAttrib} left">
                                    <img src="<c:url value='/images/move_left.gif' />" border="0" /></a>
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value='/images/move_left_g.gif' />" border="0" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td valign="middle">
                    <div>
                        <c:choose>
                            <c:when test="${!sumAttrib.sortable}">
                                <img src="<c:url value='/images/sort_up_g.gif' />" border="0" />
                            </c:when>
                            <c:when test="${attrName == sortingAttrNames[0] && sortingAttrOrders[0]}">
                                <img src="<c:url value='images/sort_up_h.gif' />" 
                                    title="Result is sorted by ${sumAttrib}" />
                            </c:when>
                            <c:otherwise>
                                <%-- display sorting buttons --%>
                                <a href="${commandUrl}&command=sort&attribute=${attrName}&sortOrder=asc"
                                    title="Sort by ${sumAttrib}">
                                    <img src="<c:url value='/images/sort_up.gif' />" border="0" /></a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${!sumAttrib.sortable}">
                                <img src="<c:url value='/images/sort_down_g.gif' />" border="0" />
                            </c:when>
                            <c:when test="${attrName == sortingAttrNames[0] && !sortingAttrOrders[0]}">
                                <img src="<c:url value='images/sort_down_h.gif' />" 
                                    title="Result is reverse sorted by ${sumAttrib}" />
                            </c:when>
                            <c:otherwise>
                                <%-- display sorting buttons --%>
                                <a href="${commandUrl}&command=sort&attribute=${attrName}&sortOrder=desc"
                                    title="Reverse sort by ${sumAttrib}">
                                    <img src="<c:url value='/images/sort_down.gif' />" border="0" /></a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    </td>
                    <td valign="middle">
                        <c:choose>
                            <c:when test="${j != 0 && j != fn:length(wdkAnswer.summaryAttributes) - 1}">
                                <a href="${commandUrl}&command=arrange&attribute=${attrName}&left=false"
                                   title="Move ${sumAttrib} right">
                                    <img src="<c:url value='/images/move_right.gif' />" border="0" /></a>
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value='/images/move_right_g.gif' />" border="0" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td valign="middle">
                        <c:choose>
                            <c:when test="${j != 0}">
                                <%-- display remove attribute buttons --%>
                                <a href="${commandUrl}&command=remove&attribute=${attrName}"
                                    title="Remove ${sumAttrib} column">
                                    <img src="<c:url value='/images/remove.gif' />" border="0" /></a>
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value='/images/remove_g.gif' />" border="0" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </th>
        <c:set var="j" value="${j+1}"/>
    </c:forEach>
</tr>


<c:if test = "${cryptoIsolatesQuestion}">
   <form name="checkHandleForm" method="post" action="/dosomething.jsp">

   <tr><td colspan="10" align="center"> 
       
       <c:if test = "${cryptoIsolatesQuestion}">
          <table width="100%" border="0" cellpadding="3" cellspacing="0">
         <tr align=center>
         <th>  Please select at least two isolates to run ClustalW
              <input type="button" value="Run ClustalW on Checked Strains" onClick="goToIsolate()" />
         </th>
	 </tr>
         </table>
       </c:if>
   </td></tr>

</c:if>

<c:set var="i" value="0"/>


<c:forEach items="${wdkAnswer.records}" var="record">
               
<c:set var="primaryKey" value="${record.primaryKey}"/>
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="projectId" value="${pkValues['project_id']}" />
<c:set var="recordId" value="${pkValues['source_id']}" />
<c:set var="summaryAttributes" value="${record.summaryAttributes}"/>
   
<c:choose>
  <c:when test="${i % 2 == 0}"><tr class="rowLight"></c:when>
  <c:otherwise><tr class="rowMedium"></c:otherwise>
</c:choose>

  <c:set var="j" value="0"/>

  <c:forEach items="${wdkAnswer.summaryAttributeNames}" var="sumAttrName">
    <c:set var="recAttr" value="${summaryAttributes[sumAttrName]}"/>
    <c:set var="align" value="align='${recAttr.attributeField.align}'" />
    <c:set var="nowrap">
        <c:if test="${recAttr.attributeField.nowrap}">nowrap</c:if>
    </c:set>

    <td ${align} ${nowrap}>
      <c:set var="recNam" value="${record.recordClass.fullName}"/>
      <c:set var="fieldVal" value="${recAttr.briefValue}"/>
      <c:choose>
        <c:when test="${j == 0}">




        <c:choose>
           <c:when test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
              
			  <a href="javascript:create_Portal_Record_Url('${recNam}', '${projectId}', '${recordId}','')">
				${projectId}:${recordId}</a>
           </c:when>

           <c:when test = "${cryptoIsolatesQuestion}">

              <%-- display a link to record page --%>
              <nobr><a href="showRecord.do?name=${recNam}&project_id=${projectId}&source_id=${recordId}">${fieldVal}</a><input type="checkbox" name="selectedFields" value="${source_id}"></nobr>

           </c:when>

            <c:otherwise>

              <%-- display a link to record page --%>
              <a href="showRecord.do?name=${recNam}&project_id=${projectId}&source_id=${recordId}">${fieldVal}</a>

            </c:otherwise>
        </c:choose>

        </c:when>   <%-- when j=0 --%>

        <c:otherwise>

          <!-- need to know if fieldVal should be hot linked -->
          <c:choose>
			<c:when test="${fieldVal == null || fn:length(fieldVal) == 0}">
               <span style="color:gray;">N/A</span>
            </c:when>
            <c:when test="${recAttr.value.class.name eq 'org.gusdb.wdk.model.LinkAttributeValue'}">
              	<c:choose>
				 <c:when test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
					<a href="javascript:create_Portal_Record_Url('','${record.projectId}','','${recAttr.value.url}')">${recAttr.value.displayText}</a>
	             </c:when>
				 <c:otherwise>
					<a href="${recAttr.value.url}">${recAttr.value.displayText}</a>
				 </c:otherwise>
				</c:choose>
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


<c:if test = "${cryptoIsolatesQuestion}">
  </form>
</c:if>

</tr>
</table>


<c:if test = "${cryptoIsolatesQuestion}">
<table width="100%" border="0" cellpadding="3" cellspacing="0">
  <tr align=center>
    <th> 
      <input type="button" value="Run Clustalw on Checked Strains" onClick="goToIsolate()" />
    </th>
	</tr>
</table>
</c:if>



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
