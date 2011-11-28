<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="random" uri="http://jakarta.apache.org/taglibs/random-1.0" %><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- TRANSPARENT PNGS for IE6 --%>
<%--  <script defer type="text/javascript" src="/assets/js/pngfix.js"></script>   --%>

<%-- get wdkModel saved in application scope --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="modelName" value="${wdkModel.displayName}"/>
<c:set var="version" value="${wdkModel.version}"/>
<c:set var="qSetMap" value="${wdkModel.questionSetsMap}"/>

<%-- GENE  --%>
<c:set var="gqSet" value="${qSetMap['GeneQuestions']}"/>
<c:set var="gqMap" value="${gqSet.questionsMap}"/>

<c:set var="geneByIdQuestion" value="${gqMap['GeneBySingleLocusTag']}"/>
<c:set var="gidqpMap" value="${geneByIdQuestion.paramsMap}"/>
<c:set var="geneIdParam" value="${gidqpMap['single_gene_id']}"/>

<c:set var="geneByTextQuestion" value="${gqMap['GenesByTextSearch']}"/>
<c:set var="gkwqpMap" value="${geneByTextQuestion.paramsMap}"/>
<c:set var="textParam" value="${gkwqpMap['text_expression']}"/>
<c:set var="timestampParam" value="${gkwqpMap['timestamp']}"/>
<c:set var="sessionId" value="${sessionScope['sessionId']}"/>

<c:catch var="orgParam_exception">
	<c:set var="orgParam" value="${gkwqpMap['text_search_organism']}"/>
</c:catch>

<%-- get the organisms from the param --%>
<c:set var="listOrganisms" value="" />
<c:forEach items="${orgParam.vocabMap}" var="item">
  <c:set var="term" value="${item.key}" />
  <c:if test="${fn:length(listOrganisms) > 0}">
    <c:set var="listOrganisms" value="${listOrganisms}," />
  </c:if>
  <c:set var="listOrganisms" value="${listOrganisms}${term}" />
</c:forEach>

<c:if test="${orgParam_exception != null}">
	<span style="position:absolute;top:30px;right:150px;font-style:italics;font-size:90%;color:#CC0033;">
		Error. search temporarily unavailable</span>
</c:if>

<div id="quick-search" session-id="${sessionId}">
	<table style="float:right;margin-bottom:10px">
           <tr>

<!-- GENE ID -->
             <td title="Use * as a wildcard in a gene ID. Click on 'Gene ID' to enter multiple Gene IDs."><div align="right">
               <html:form method="get" action="/processQuestionSetsFlat.do">
          		<label><b><a href="<c:url value='/showQuestion.do?questionFullName=GeneQuestions.GeneByLocusTag'/>" >Gene ID:</a></b></label>
         		<input type="hidden" name="questionFullName" value="GeneQuestions.GeneBySingleLocusTag"/>
	  			<input type="text" class="search-box" name="value(${geneIdParam.name})" value="${geneIdParam.default}" />  <!-- size is defined in class -->
	  			<input type="hidden" name="questionSubmit" value="Get Answer"/>
	  			<input name="go" value="go" type="image" src="/assets/images/mag_glass.png" alt="Click to search" width="23" height="23" class="img_align_middle" />
          	   </html:form>
			 </div></td>

<!-- TEXT SEARCH -->
             <td title="Use * as a wildcard, as in *inase, kin*se, kinas*. Do not use AND, OR. Use quotation marks to find an exact phrase. Click on 'Gene Text Search' to access the advanced gene search page."><div align="right">
               <html:form method="get" action="/processQuestionSetsFlat.do">
          		<label><b><a href="<c:url value='/showQuestion.do?questionFullName=GeneQuestions.GenesByTextSearch'/>" >Gene Text Search:</a></b></label>

          <c:set var="textFields" value="Gene ID,Alias,Gene product,GO terms and definitions,Gene notes,User comments,Protein domain names and descriptions,EC descriptions"/>
          <c:if test="${fn:containsIgnoreCase(modelName, 'PlasmoDB')}">
             <c:set var="textFields" value="${textFields},Release 5.5 Genes"/>
          </c:if>
          <c:if test="${fn:containsIgnoreCase(modelName, 'TriTrypDB') || fn:containsIgnoreCase(modelName, 'EuPathDB')}">
             <c:set var="textFields" value="${textFields},Phenotype"/>
          </c:if>
          <c:if test="${fn:containsIgnoreCase(modelName, 'ToxoDB') || fn:containsIgnoreCase(modelName, 'GiardiaDB')}">
             <c:set var="textFields" value="${textFields},Community annotation"/>
          </c:if>
          <c:if test="${not fn:containsIgnoreCase(modelName, 'CryptoDB') && not fn:containsIgnoreCase(modelName, 'GiardiaDB') && not fn:containsIgnoreCase(modelName, 'TrichDB') && not fn:containsIgnoreCase(modelName, 'TriTrypDB')}">
             <c:set var="textFields" value="${textFields},Metabolic pathway names and descriptions"/>
          </c:if>
           		<input type="hidden" name="questionFullName" value="GeneQuestions.GenesByTextSearch"/>
		        <input type="hidden" name="array(${orgParam.name})" value="${listOrganisms}"/>
          		<input type="hidden" name="array(text_fields)" value="${textFields}"/>
          		<input type="hidden" name="array(whole_words)" value="no"/>
          		<input type="hidden" name="value(max_pvalue)" value="-30"/>
          		<input type="text" class="search-box ts_ie" name="value(${textParam.name})" value="${textParam.default}"/>
                        <input type="hidden" name="value(timestamp)" value="${timestampParam.default}"/>
          		<input type="hidden" name="questionSubmit" value="Get Answer"/>
	  			<input name="go" value="go" type="image" src="/assets/images/mag_glass.png" alt="Click to search" width="23" height="23" class="img_align_middle" />
          	   </html:form>
			 </div></td>
            </tr>
	</table>
</div>
