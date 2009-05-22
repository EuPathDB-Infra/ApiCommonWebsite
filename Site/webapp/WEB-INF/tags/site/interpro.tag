<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<link rel="stylesheet" href="<c:url value='/misc/Top_menu.css' />" type="text/css">


<%-- get wdkQuestion; setup requestScope HashMap to collect help info for footer --%>
<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<jsp:useBean scope="request" id="helps" class="java.util.LinkedHashMap"/>
<c:set var="qForm" value="${requestScope.questionForm}"/>
<%-- display page header with wdkQuestion displayName as banner --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />
<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<c:set var="recordType" value="${wdkQuestion.recordClass.type}"/>

<%--CODE TO SET UP THE SITE VARIABLES --%>
<c:if test="${wdkModel.displayName eq 'ApiDB'}">
    <c:set var="portalsProp" value="${props['PORTALS']}" />
</c:if>
<c:if test="${wdkModel.displayName eq 'ApiDB'}">
     <div id="question_Form">
</c:if>
<h1>Identify ${recordType}s based on ${wdkQuestion.displayName}</h1>
<table border=0 width=100% cellpadding=3 cellspacing=0 bgcolor=white class=thinTopBorders> 

 <tr>
  <td bgcolor=white valign=top>

<%-- show all params of question, collect help info along the way --%>
<c:set value="Help for question: ${wdkQuestion.displayName}" var="fromAnchorQ"/>
<jsp:useBean id="helpQ" class="java.util.LinkedHashMap"/>

<%-- put an anchor here for linking back from help sections --%>
<A name="${fromAnchorQ}"></A>
<!--html:form method="get" action="/processQuestion.do" -->
<html:form styleId="form_question" method="post" enctype='multipart/form-data' action="/processQuestion.do">
<input type="hidden" name="questionFullName" value="${wdkQuestion.fullName}"/>

<!-- show error messages, if any -->
<wdk:errors/>

<%-- the js has to be included here in order to appear in the step form --%>
<script type="text/javascript" src='<c:url value="/assets/js/wdkQuestion.js"/>'></script>
<script src="js/lib/jquery.autocomplete.js" type="text/javascript"></script>
<script src="js/AjaxInterpro.js" type="text/javascript"></script>

<c:set var="hasOrganism" value="false"/>
<c:set value="${wdkQuestion.paramMapByGroups}" var="paramGroups"/>
<div class="params">
<c:forEach items="${paramGroups}" var="paramGroupItem">
    <c:set var="group" value="${paramGroupItem.key}" />
    <c:set var="paramGroup" value="${paramGroupItem.value}" />
  
    <%-- detemine starting display style by displayType of the group --%>
    <c:set var="groupName" value="${group.displayName}" />
    <c:set var="displayType" value="${group.displayType}" />
    <div name="${wdkQuestion.name}_${group.name}"
         class="param-group" 
         type="${displayType}">
    <c:choose>
        <c:when test="${displayType eq 'empty'}">
            <%-- output nothing else --%> 
            <div class="group-detail">
        </c:when>
        <c:when test="${displayType eq 'ShowHide'}">
            <c:set var="display">
                <c:choose>
                    <c:when test="${group.visible}">block</c:when>
                    <c:otherwise>none</c:otherwise>
                </c:choose>
            </c:set>
            <c:set var="image">
                <c:choose>
                    <c:when test="${group.visible}">minus.gif</c:when>
                    <c:otherwise>plus.gif</c:otherwise>
                </c:choose>
            </c:set>
            <div class="group-title">
                <img class="group-handle" src='<c:url value="/images/${image}" />' />
                ${groupName}
            </div>
            <div class="group-detail" style="display:${display};">
                <div class="group-description">${group.description}</div>
        </c:when>
        <c:otherwise>
            <div class="group-title">${groupName}</div>
            <div class="group-detail">
                <div class="group-description">${group.description}</div>
        </c:otherwise>
    </c:choose>
    
    <table border="0" width="100%">
    
    <c:set var="paramCount" value="${fn:length(paramGroup)}"/>
    <%-- display parameter list --%>
    <c:forEach items="${paramGroup}" var="paramItem">
        <c:set var="pNam" value="${paramItem.key}" />
        <c:set var="qP" value="${paramItem.value}" />
        
        <c:set var="isHidden" value="${qP.isVisible == false}"/>
        <c:set var="isReadonly" value="${qP.isReadonly == true}"/>
  
        <%-- hide invisible params --%>
        <c:choose>
            <%--<c:when test="${isHidden}"><html:hidden property="myProp(${qP.class.name})"/></c:when>--%>
            <c:when test="${isHidden}">
        <c:choose>
           <c:when test="${fn:containsIgnoreCase(wdkModel.displayName, 'ApiDB')}">
            <c:choose>
                   <c:when test="${pNam eq 'signature'}">
                    <html:hidden property="myProp(${pNam})" value="${wdkUser.signature}"/>
                   </c:when>
                   <c:otherwise>
                        <html:hidden property="myProp(${pNam})"/>
                   </c:otherwise>
            </c:choose>
           </c:when>

		   <c:when test="${pNam eq 'domain_database'}">
	          <input type="hidden" name="myProp(${pNam})" id="domain_database_list" value="${qP.default}" />
	          <script type="text/javascript">loadSelectedData();</script>
	       </c:when>
	
           <c:otherwise>
                <html:hidden property="myProp(${pNam})"/>
           </c:otherwise>
        </c:choose>
        </c:when>
            <c:otherwise> <%-- visible param --%>
                <%-- an individual param (can not use fullName, w/ '.', for mapped props) --%>
                <tr>
                    <c:choose>


					<c:when test="${pNam eq 'domain_database'}">
				      <tr><td align="right"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip"><jsp:getProperty name="qP" property="prompt"/></b></td><td>
				      <select name="myMultiProp(domain_database)" id="domain_database_list" onChange="loadSelectedData();">
				          <c:forEach items="${qP.vocab}" var="flatVoc">
				              <option value="${flatVoc}">${flatVoc}</option>
				          </c:forEach>
				      </select>
				      </td>

				      <%-- reload term list on back button --%>
				      <!--<script type="text/javascript">
				      //if ( document.getElementById('domain_database_list').selectedIndex != 0 ) loadSelectedData();
				      </script>-->

				    </c:when>
				    <c:when test="${pNam eq 'domain_accession'}">
				          <tr><td align="right"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip"><jsp:getProperty name="qP" property="prompt"/></b></td><td>
				          <input type="text" id="searchBox" name="myProp(${pNam})" size="50" class="form_box"/>
				          </td>
				    </c:when>



                        <c:when test="${fn:containsIgnoreCase(pNam,'organism') && wdkModel.displayName eq 'ApiDB'}">
                            <c:set var="hasOrganism" value="true"/>
                            <td width="300" align="left" valign="top" rowspan="${paramCount}" cellpadding="5">
                                <table border="0">
                                    <tr>
                                    <td ><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">${qP.prompt}&nbsp;&nbsp;&nbsp;</b>
                                    <c:set var="anchorQp" value="HELP_${fromAnchorQ}_${pNam}"/>
                                    <c:set target="${helpQ}" property="${anchorQp}" value="${qP}"/>
                                    <a href="#${anchorQp}">
                                    <img valign="bottom" src="/assets/images/help.png" border="0" alt="Help"></a><br>
                                    <site:cardsOrgansimParamInput qp="${qP}" portals="${portalsProp}" />
                                    </td>
                                    </tr>
                                </table>
                             </td>
                             <td valign="top" align="center">
			         <table border="0">
                        </c:when>
                        
                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.EnumParamBean'}">
                            <td align="right" valign="top"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">${qP.prompt}</b></td>
                            <td align="left" valign="top">
                                <wdk:enumParamInput qp="${qP}" />
                            </td>
                        </c:when>
                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.HistoryParamBean'}">
                            <td align="right" valign="top"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">${qP.prompt}</b></td>
                            <td align="left" valign="top">
                                <wdk:answerParamInput qp="${qP}" />
                            </td>
                        </c:when>
                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.DatasetParamBean'}">
                            <td align="right" valign="top"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">${qP.prompt}</b></td>
                            <td align="left" valign="top">
                                <wdk:datasetParamInput qp="${qP}" />
                            </td>
                        </c:when>
                        <c:otherwise>  <%-- not enumParam --%>
                            <c:choose>
                                <c:when test="${isReadonly}">
                                    <td align="right" valign="top"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">${qP.prompt}</b></td>
                                    <td align="left" valign="top">
                                        <bean:write name="qForm" property="myProp(${pNam})"/>
                                        <html:hidden property="myProp(${pNam})"/>
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td align="right" valign="top"><b id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">${qP.prompt}</b></td>
                                    <td align="left" valign="top">
                                        <html:text property="myProp(${pNam})" size="35" />
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${!fn:containsIgnoreCase(pNam,'organism')}">
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td valign="top" width="50" nowrap>
                            <c:set var="anchorQp" value="HELP_${fromAnchorQ}_${pNam}"/>
                            <c:set target="${helpQ}" property="${anchorQp}" value="${qP}"/>
                            <a id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">
                            	<img src="/assets/images/help.png" border="0" alt="Help">
    						</a>
                        </td>
                    </c:if>
                </tr>
            </c:otherwise> <%-- end visible param --%>
        </c:choose>
        
        </c:forEach> <%-- end of forEach params --%>
        
        <%-- detemine ending display style by displayType of the group --%>
        <c:if test="${hasOrganism}"></table></c:if>
        </table>
    
        <%-- prepare the help info --%>
        <c:forEach items="${paramGroup}" var="paramItem">
            <c:set var="pNam" value="${paramItem.key}" />
            <c:set var="qP" value="${paramItem.value}" />
            
            <c:set var="isHidden" value="${qP.isVisible == false}"/>
            <c:set var="isReadonly" value="${qP.isReadonly == true}"/>
    
                <c:if test="${!isHidden}">
                        <c:if test="${!fn:containsIgnoreCase(pNam,'organism')}">
                	        <div class="htmltooltip" id="help_${pNam}_tip">${qP.help}</div>
                        </c:if>
                </c:if>
            
        </c:forEach>
    
        </div> <%-- end of group-detail div --%>
    </div> <%-- end of param-group div --%>

</c:forEach> <%-- end of foreach on paramGroups --%>

</div> <%-- end of params div --%>

<c:set target="${helps}" property="${fromAnchorQ}" value="${helpQ}"/>

<div class="filter-button"><html:submit property="questionSubmit" value="Get Answer"/></div>
</html:form>

<c:if test="${wdkModel.displayName eq 'ApiDB'}">
    </div><!--End Question Form Div-->
</c:if>

<hr>
<%-- display description for wdkQuestion --%>
<p id="query-description-section"><b>Query description: </b><jsp:getProperty name="wdkQuestion" property="description"/></p>

<%-- get the attributions of the question if not ApiDB --%>
<c:if test = "${project != 'EuPathDB'}">
<hr>
<%-- get the property list map of the question --%>
<c:set var="propertyLists" value="${wdkQuestion.propertyLists}"/>

<%-- display the question specific attribution list --%>
<%-- site:attributions attributions="${propertyLists['specificAttribution']}" caption="Data sources" /--%>

</c:if>

 <%-- </td>--%>
  <td valign=top class=dottedLeftBorder></td> 

</tr>
</table> 

