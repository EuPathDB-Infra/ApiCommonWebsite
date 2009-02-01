<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="modelName" value="${wdkModel.displayName}"/>

<table width="100%" border="0" cellspacing="1" cellpadding="1">
<tr>


        <td  width="50%" valign="top">
<div class="innertube2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpBySourceId" linktext="SNP ID(s)" existsOn="A C P T"/>
                </tr>

                
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByGeneId" linktext="Gene ID" existsOn="A C P T"/>
                </tr>
            </table>
</div>
        </td>

<%--
	<td width="1" class="blueVcalLine"></td>
--%>
	<td width="1"></td>

        <td  width="50%" valign="top">
<div class="innertube2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByAlleleFrequency" linktext="AlleleFrequency" existsOn="A P"/>
                </tr>
<tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByLocation" linktext="Chromosomal Location" existsOn="A C P T"/>
                </tr>

            </table>
</div>
        </td>

</tr>
</table>
