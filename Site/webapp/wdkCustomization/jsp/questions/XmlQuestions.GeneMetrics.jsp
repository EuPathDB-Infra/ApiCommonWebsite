<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>

<%-- get wdkXmlAnswer saved in request scope --%>
<c:set var="xmlAnswer" value="${requestScope.wdkXmlAnswer}"/>

<c:set var="banner" value="${xmlAnswer.question.displayName}"/>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set value="${wdkModel.displayName}" var="project"/>

<site:header  title="${project} :: Gene Metrics"
                 banner="${project} Gene Metrics"
                 parentDivision="${project}"
                 parentUrl="/home.jsp"
                 divisionName="allSites"
                 division="geneMetrics"/>

<c:set var="orgWidth" value=""/>  <%-- 4% --%>
<c:set var="ncbiTaxPage" value="http://130.14.29.110/Taxonomy/Browser/wwwtax.cgi?mode=Info&id=237895&lvl=3&p=mapview&p=has_linkout&p=blast_url&p=genome_blast&lin=f&keep=1&srchmode=5&unlock"/>


<table width="100%">
<tr><td><h2>EuPathDB Gene Metrics</h2></td>
    <td align="right"><a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.GenomeDataType"/>">EuPathDB Data Summary >>></a></td>
</tr>

<tr><td colspan="2">The EuPathDB <a href="http://pathogenportal.org"><b>Bioinformatics Resource Center (BRC)</b></a> designs, develops and maintains the <a href="http://eupathdb.org">EuPathDB</a>, <a href="http://cryptodb.org">CryptoDB</a>, <a href="http://giardiadb.org">GiardiaDB</a>, <a href="http://plasmodb.org">PlasmoDB</a>, <a href="http://toxodb.org">ToxoDB</a>, <a href="http://trichdb.org">TrichDB</a> and <a href="http://tritrypdb.org">TriTrypDB</a> websites. <br><br>
The Gene Metrics table summarizes the number of genes for the organisms currently available in EuPathDB, including their available evidence. High gene numbers (such as for rodent malaria parasites Pb, Pc & Py) reflect incomplete sequence assembly and redundant gene models. <br>
</td></tr>
</table>

<table  class="mytableStyle" width="100%">
<c:choose>
  <c:when test='${xmlAnswer.resultSize == 0}'>
    <tr><td>Not available.</td></tr></table>
  </c:when>
  <c:otherwise>

<%-- Organisms/species grouped by websites, alphabetically in each group --%>
<c:set var="bgcolor" value="#efefef"/> 
<tr class="mythStyle">
    <td style="background-color:white;border-right:3px solid grey;border-top:0px none;border-left:0 none;"></td>
    <td style="border-right:3px solid grey" colspan="3" class="mythStyle"><a href="http://cryptodb.org">CryptoDB</a></td>
    <td style="border-right:3px solid grey" colspan="3" class="mythStyle"><a href="http://giardiadb.org">GiardiaDB</a></td>
    <td style="border-right:3px solid grey" colspan="6" class="mythStyle"><a href="http://plasmodb.org">PlasmoDB</a></td>
    <td style="border-right:3px solid grey" colspan="2" class="mythStyle"><a href="http://toxodb.org">ToxoDB</a></td>
    <td style="border-right:3px solid grey" colspan="1" class="mythStyle"><a href="http://trichdb.org">TrichDB</a></td>
    <td colspan="5" class="mythStyle"><a href="http://tritrypdb.org">TriTrypDB</a></td>
</tr>
<tr class="mythStyle">
    <td style="border-right:3px solid grey" class="mythStyle" title="">Gene Metric</td>
    <td class="mythStyle" title="Cryptosporidium hominis, CryptoDB"><i>Ch</i></td>
    <td class="mythStyle" title="Cryptosporidium muris, CryptoDB"  ><i>Cm</i></td>
    <td style="border-right:3px solid grey" class="mythStyle" title="Cryptosporidium parvum, CryptoDB" ><i>Cp</i></td>
    <td class="mythStyle" title="Giardia_Assemblage_A_isolate_WB, GiardiaDB" ><i>GA</i></td>
    <td class="mythStyle" title="Giardia_Assemblage_B_isolate_GS, GiardiaDB" ><i>GB</i></td>
    <td style="border-right:3px solid grey" class="mythStyle" title="Giardia_Assemblage_E_isolate_P15, GiardiaDB" ><i>GE</i></td>
    <td class="mythStyle" title="Plasmodium berghei, PlasmoDB"><i>Pb</i></td>
    <td class="mythStyle" title="Plasmodium chabaudi, PlasmoDB"><i>Pc</i></td>
    <td class="mythStyle" title="Plasmodium falciparum, PlasmoDB"><i>Pf</i></td>
    <td class="mythStyle" title="Plasmodium knowlesi, PlasmoDB"><i>Pk</i></td>
    <td class="mythStyle" title="Plasmodium vivax, PlasmoDB"><i>Pv</i></td>
    <td style="border-right:3px solid grey" class="mythStyle" title="Plasmodium yoelii, PlasmoDB"><i>Py</i></td>
    <td class="mythStyle" title="Neospora caninum, ToxoDB"><i>Nc</i></td>
    <td style="border-right:3px solid grey" class="mythStyle" title="Toxoplasma gondii"><i>Tg</i></td>
    <td style="border-right:3px solid grey" class="mythStyle" title="Trichomonas vaginalis,TrichDB"><i>Tv</i></td>
    <td class="mythStyle" title="Leishmania braziliensis, TriTrypDB"><i>Lb</i></td>
    <td class="mythStyle" title="Leishmania infantum, TriTrypDB"><i>Li</i></td>
    <td class="mythStyle" title="Leishmania major, TriTrypDB"><i>Lm</i></td>
    <td class="mythStyle" title="Trypanosoma brucei, TriTrypDB"><i>Tb</i></td>
    <td class="mythStyle" title="Trypanosoma cruzi, TriTrypDB"><i>Tc</i></td>
</tr>

  <c:forEach items="${xmlAnswer.recordInstances}" var="record">

	 <c:set var="Metric_Type" value="${record.attributesMap['Metric_Type']}"/>
	 <c:set var="Ch" value="${record.attributesMap['Cryptosporidium_hominis']}"/>
 	 <c:set var="Cm" value="${record.attributesMap['Cryptosporidium_muris']}"/>
	 <c:set var="Cp" value="${record.attributesMap['Cryptosporidium_parvum']}"/>
	 <c:set var="GA" value="${record.attributesMap['Giardia_Assemblage_A_isolate_WB']}"/>
	 <c:set var="GB" value="${record.attributesMap['Giardia_Assemblage_B_isolate_GS']}"/>
	 <c:set var="GE" value="${record.attributesMap['Giardia_Assemblage_E_isolate_P15']}"/>
	 <c:set var="Lb" value="${record.attributesMap['Leishmania_braziliensis']}"/>
	 <c:set var="Li" value="${record.attributesMap['Leishmania_infantum']}"/>
	 <c:set var="Lm" value="${record.attributesMap['Leishmania_major']}"/>
         <c:set var="Nc" value="${record.attributesMap['Neospora_caninum']}"/>
	 <c:set var="Pb" value="${record.attributesMap['Plasmodium_berghei']}"/>
	 <c:set var="Pc" value="${record.attributesMap['Plasmodium_chabaudi']}"/>
	 <c:set var="Pf" value="${record.attributesMap['Plasmodium_falciparum']}"/>
	 <c:set var="Pk" value="${record.attributesMap['Plasmodium_knowlesi']}"/>
	 <c:set var="Pv" value="${record.attributesMap['Plasmodium_vivax']}"/>
	 <c:set var="Py" value="${record.attributesMap['Plasmodium_yoelii']}"/>
	 <c:set var="Tg" value="${record.attributesMap['Toxoplasma_gondii']}"/>
	 <c:set var="Tv" value="${record.attributesMap['Trichomonas_vaginalis']}"/>
         <c:set var="Tb" value="${record.attributesMap['Trypanosoma_brucei']}"/> 
         <c:set var="Tc" value="${record.attributesMap['Trypanosoma_cruzi']}"/> 



<tr class="mytdStyle">
    <td style="border-right:3px solid grey" class="mytdStyle" align="left" title="${record.attributesMap['Description']}">${Metric_Type}</td>
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Ch}</td>
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Cm}</td>
    <td style="background-color:${bgcolor};border-right:3px solid grey" class="mytdStyle" align="right">${Cp}</td>
    <td class="mytdStyle" align="right">${GA}</td>
    <td class="mytdStyle" align="right">${GB}</td>
    <td style="border-right:3px solid grey" class="mytdStyle" align="right">${GE}</td>
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Pb}</td>
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Pc}</td>
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Pf}</td>
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Pk}</td>    
    <td style="background-color:${bgcolor}" class="mytdStyle" align="right">${Pv}</td>
    <td style="background-color:${bgcolor};border-right:3px solid grey" class="mytdStyle" align="right">${Py}</td>
    <td class="mytdStyle" align="right">${Nc}</td>
    <td style="border-right:3px solid grey"class="mytdStyle" align="right">${Tg}</td>
    <td style="background-color:${bgcolor};border-right:3px solid grey" class="mytdStyle" align="right">${Tv}</td>
    <td class="mytdStyle" align="right">${Lb}</td>
    <td class="mytdStyle" align="right">${Li}</td>
    <td class="mytdStyle" align="right">${Lm}</td>
    <td class="mytdStyle" align="right">${Tb}</td>
    <td class="mytdStyle" align="right">${Tc}</td>
</tr>
 
  </c:forEach>



  </table>


<table width="100%">
<tr><td>
<font size="-1"><i><b>Cryptosporidium</b>: Cp, C. parvum; Ch, C. hominis; <b>Giardia</b> GA, G.Assemblage_A_isolate_WB; GB, G.Assemblage_B_isolate_GS; GE, G.Assemblage_E_isolate_P15; <b>Neospora</b>: Nc, N. caninum; <b>Leishmania</b>: Lb, L. braziliensis; Li, L. infantum; Lm, L. major;  <b>Plasmodium</b>: Pb, P. berghei; Pc, P. chabaudi; Pf, P. falciparum; Pk, P. knowlesi; Pv, P. vivax; Py, P. yoelii; <b>Toxoplasma</b>: Tg, T. gondii; <b>Trichomonas</b>: Tv, T. vaginalis; <b>Trypanosoma</b>: Tb, T. brucei; Tc, T. cruzi.)</i></font><br>
</td></tr>
</table>

  </c:otherwise>
</c:choose>





<site:footer/>
