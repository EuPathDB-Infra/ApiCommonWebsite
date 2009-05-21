<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="modelName" value="${applicationScope.wdkModel.name}" />
<c:set var="sName" value="${fn:substringBefore(modelName,'DB')}" />
<c:set var="cycName" value="${sName}Cyc" />


<c:choose>
	<c:when test="${fn:containsIgnoreCase(modelName, 'ApiDB')}">
		<c:set var="listOrganisms" value="Cryptosporidium, Giardia, Plasmodium, Toxoplasma, Neospora, Trichomonas, Trypanosoma, Leishmania"/>
	</c:when>
        <c:when test="${fn:containsIgnoreCase(modelName, 'CryptoDB')}">
		<c:set var="listOrganisms" value="Cryptosporidium"/>
	</c:when>
<c:when test="${fn:containsIgnoreCase(modelName, 'ToxoDB')}">
                <c:set var="listOrganisms" value="Toxoplasma,Neospora"/>
        </c:when>

	<c:when test="${fn:containsIgnoreCase(modelName, 'PlasmoDB')}">
		<c:set var="listOrganisms" value="Plasmodium"/>
	</c:when>
 <c:when test="${fn:containsIgnoreCase(modelName, 'GiardiaDB')}">
		<c:set var="listOrganisms" value="Giardia"/>
	</c:when>
 <c:when test="${fn:containsIgnoreCase(modelName, 'TrichDB')}">
		<c:set var="listOrganisms" value="Trichomonas"/>
	</c:when>

 <c:when test="${fn:containsIgnoreCase(modelName, 'TriTrypDB')}">
		<c:set var="listOrganisms" value="Leishmania,Trypanosoma"/>
	</c:when>

</c:choose> 

<div id="info">
    	<ul>
		<li><a href="<c:url value="/showQuestion.do?questionFullName=UniversalQuestions.UnifiedBlast"/>"><strong>BLAST</strong></a>
			<ul><li>Identify Sequence Similarities</li></ul>
		</li>
		<li><a href="<c:url value="/srt.jsp"/>"><strong>Sequence Retrieval</strong></a>
			<ul><li>Retrieve Specific Sequences using IDs and coordinates</li></ul>
		</li>
		<li><a href="/common/PubCrawler/"><strong>PubMed and Entrez</strong></a>
			<ul><li>View the Latest <i>${listOrganisms}</i> Pubmed and Entrez Results</li></ul>
		</li>

<c:if test="${sName != 'Api'}">
		<li><a href="/cgi-bin/gbrowse/${modelName}/"><strong>GBrowse</strong></a>
			<ul><li>View Sequences and Features in the GMOD Genome Browser</li></ul>
		</li>
</c:if>


<c:choose>
<c:when test="${sName == 'Crypto'}">
          
                <li><a href="http://apicyc.apidb.org/CPARVUM/server.html"><strong>${cycName}</strong></a>
                        <ul><li>Explore Automatically Defined Metabolic Pathways</li></ul>
                </li>
</c:when>
<c:when test="${sName == 'Api'}">
          
                <li><a href="http://apicyc.apidb.org/"><strong>${cycName}</strong></a>
                        <ul><li>Explore Automatically Defined Metabolic Pathways</li></ul>
                </li>
</c:when>
<c:when test="${sName == 'Plasmo' || sName == 'Toxo'}">
          
                <li><a href="http://apicyc.apidb.org/${sName}/server.html"><strong>${cycName}</strong></a>
                        <ul><li>Explore Automatically Defined Metabolic Pathways</li></ul>
                </li>
</c:when>
<c:otherwise>   <%----- fill in 2 empty lines to keep buckets aligned -----%>
                <li>&nbsp;<ul><li>&nbsp;</li></ul></li> 

</c:otherwise>
</c:choose>

    	</ul>
</div>

<div id="infobottom" class="tools">
</div><!--end info-->
