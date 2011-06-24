<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>

<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>
<c:set var="attrs" value="${wdkRecord.attributes}"/>

<c:catch var="err">
  <c:set var="snp_position" value="${attrs['start_min'].value}"/>
  <c:set var="start" value="${snp_position-25}"/>
  <c:set var="end"   value="${snp_position+25}"/>
   <c:if test="${attrs['gene_strand'].value == 'reverse'}">
    <c:set var="revCompOn" value="1"/>
   </c:if>
  <c:set var="sequence_id" value="${attrs['seq_source_id'].value}"/>
  <c:set var="dataset_provider" value="${attrs['dataset'].value}"/>
</c:catch>

<c:set var="primaryKey" value="${wdkRecord.primaryKey}"/>
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="projectId" value="${pkValues['project_id']}" />
<c:set var="id" value="${pkValues['source_id']}" />

<site:header title="${wdkModel.displayName} : SNP ${id}"
             banner="SNP ${id}"
             refer="recordPage"
             divisionName="SNP Record"
             division="queries_tools"/>

<c:choose>
<c:when test="${!wdkRecord.validRecord}">
  <h2 style="text-align:center;color:#CC0000;">The SNP '${id}' was not found.</h2>
</c:when>
<c:otherwise>

<%-- quick tool-box for the record --%>
<site:recordToolbox />


<div class="h2center" style="font-size:160%">
 	SNP
</div>

<div class="h3center" style="font-size:130%">
	${primaryKey}<br>
	<wdk:recordPageBasketIcon />
</div>

<table border=0 width=100% cellpadding=7 cellspacing=0 bgcolor=white
       class=thinTopBorders>
 <tr>
  <td bgcolor=white valign=top>


<!-- Overview -->
<c:set var="attr" value="${attrs['snp_overview']}" />
<wdk:toggle name="${attr.displayName}"
    displayName="${attr.displayName}" isOpen="true"
    content="${attr.value}" />

<!-- Gene context -->
<c:set var="attr" value="${attrs['gene_context']}" />
<wdk:toggle name="${attr.displayName}"
    displayName="${attr.displayName}" isOpen="true"
    content="${attr.value}" />


<wdk:wdkTable tblName="Strains" isOpen="true"/>

<!-- isolate summary -->
<wdk:wdkTable tblName="IsolatesAlleleFrequency" isOpen="true"/>
<wdk:wdkTable tblName="Isolates" isOpen="false"/>


<c:if test="${dataset_provider == 'Broad_SNPs' || dataset_provider == 'NIH, Broad, and Sanger SNPs'}">
<c:set var="showAlignmts">

  <c:catch var="e">
  <c:import url="http://${pageContext.request.serverName}/cgi-bin/displaySnpAlignments.pl?snpId=${id}&width=25&project_id=${projectId}" />
  </c:catch>
  <c:if test="${e!=null}"> 
      <site:embeddedError 
          msg="<font size='-2'>temporarily unavailable</font>" 
          e="${e}" 
      />
  </c:if>
</c:set>

<wdk:toggle name="SequenceAlignment"
    displayName="Sequence Alignment"
    content="${showAlignmts}"
    isOpen="true"/>
</c:if>

<br/>
<site:mercatorMAVID cgiUrl="/cgi-bin" projectId="${projectId}" revCompOn="${revCompOn}"
                      contigId="${sequence_id}" start="${start}" end="${end}" bkgClass="rowMedium" cellPadding="0" availableGenomes="3D7,Dd2,HB3, and IT"/>

<br/>
<wdk:wdkTable tblName="Providers_other_SNPs" isOpen="true"/>


</td></tr>
</table>


</c:otherwise>
</c:choose>

<site:footer/>

<site:pageLogger name="snp page" />
