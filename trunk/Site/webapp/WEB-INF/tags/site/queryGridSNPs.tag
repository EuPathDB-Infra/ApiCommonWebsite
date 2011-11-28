<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="modelName" value="${wdkModel.displayName}"/>

<table width="100%" border="0" cellspacing="1" cellpadding="1">
<tr>


        <td  width="50%" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpBySourceId" linktext="SNP ID(s)" existsOn="A C P T"/>
                </tr>

                
<c:choose>
<c:when test="${fn:containsIgnoreCase(modelName,'eupath')||fn:containsIgnoreCase(modelName,'toxo') }">
                <tr>
                    <site:queryGridMakeUrl qset="InternalSnpQuestions" qname="SnpsByGeneId" linktext="Gene ID" existsOn="A Am C P T Tt"/>
                </tr>
</c:when>
<c:when test="${fn:containsIgnoreCase(modelName,'tritryp')||fn:containsIgnoreCase(modelName,'amoeba') }">
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="HtsSnpsByGeneId" linktext="Gene ID" existsOn="A Am C P T Tt"/>
                </tr>
</c:when>
<c:otherwise>
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByGeneId" linktext="Gene ID" existsOn="A Am C P T Tt"/>
                </tr>
</c:otherwise>
</c:choose>

<c:choose>
<c:when test="${fn:containsIgnoreCase(modelName,'eupath')||fn:containsIgnoreCase(modelName,'toxo') }">
                <tr>
                    <site:queryGridMakeUrl qset="InternalSnpQuestions" qname="SnpsByLocation" linktext="Genomic Location" existsOn="A Am C P T Tt"/>
                </tr>
</c:when>
<c:when test="${fn:containsIgnoreCase(modelName,'tritryp')||fn:containsIgnoreCase(modelName,'amoeba') }">
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="HtsSnpsByLocation" linktext="Genomic Location" existsOn="A Am C P T Tt"/>
                </tr>
</c:when>
<c:otherwise>
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByLocation" linktext="Genomic Location" existsOn="A Am C P T Tt"/>
                </tr>
</c:otherwise>
</c:choose>

            </table>
        </td>

<%--
	<td width="1" class="blueVcalLine"></td>
--%>
	<td width="1"></td>

        <td  width="50%" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByAlleleFrequency" linktext="Allele Frequency" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByIsolatePattern" linktext="Isolate Comparison" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByIsolateType" linktext="Isolate Assay" existsOn="A P"/>
                </tr>

            </table>
        </td>

</tr>
</table>
