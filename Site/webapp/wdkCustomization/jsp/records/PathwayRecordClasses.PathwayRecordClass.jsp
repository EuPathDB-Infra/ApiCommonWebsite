<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>

<%/* get wdkRecord from proper scope */%>
<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>
<c:set var="attrs" value="${wdkRecord.attributes}"/>
<c:set var="props" value="${applicationScope.wdkModel.properties}" />

<c:set var="primaryKey" value="${wdkRecord.primaryKey}"/>
<c:set var="recordName" value="${wdkRecord.recordClass.displayName}" />
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="projectId" value="${pkValues['project_id']}" />
<c:set var="id" value="${pkValues['source_id']}" />
<c:set var="projectIdLowerCase" value="${fn:toLowerCase(projectId)}"/>
<c:set var="pathwayImageId" value="${attrs['image_id'].value}" />
<c:set var="pathwayName" value="${attrs['description'].value}" />

<imp:pageFrame title="${wdkModel.displayName} : Met Pathway ${id}"
             refer="recordPage"
             banner="Met Pathway ${id}"
             divisionName="${recordName} Record"
             division="queries_tools">

<c:choose>
  <c:when test="${!wdkRecord.validRecord}">
    <h2 style="text-align:center;color:#CC0000;">The ${recordName} '${id}' was not found.</h2>
  </c:when>
<c:otherwise>

<%-- quick tool-box for the record --%>
<imp:recordToolbox />


<div class="h2center" style="font-size:160%">
 	Metabolic Pathway
</div>

<div class="h3center" style="font-size:130%">
	${id} -  ${pathwayName}<br>
	<imp:recordPageBasketIcon />
</div>


<%--#############################################################--%>

<c:set var="append" value="" />

<c:set var="attr" value="${attrs['overview']}" />
<imp:panel 
    displayName="${attr.displayName}"
    content="${attr.value}" 
    attribute="${attr.name}"/>

<br>
<%--
<br>
<div align="center">
<img align="middle" src="/cgi-bin/colorKEGGmap.pl?model=${projectId}&pathway=${id}" usemap="#pathwayMap"/>
<imp:pathwayMap projectId="${projectId}" pathway="${id}" />
</div>
<br>

<iframe  src="<c:url value='/pathway-dynamic-view.jsp?model=${projectId}&pathway=${id}' />"  width=100% height=800 align=middle>
</iframe> 
--%>


<!-- CYTOSCAPE start-->
 <!-- Flash embedding utility (needed to embed Cytoscape Web) -->
 <script type="text/javascript" src="/js/AC_OETags.min.js"></script>
        
<!-- Cytoscape Web JS API (needed to reference org.cytoscapeweb.Visualization) -->
 <script type="text/javascript" src="/js/cytoscapeweb.min.js"></script> 

<script src="${pageContext.request.contextPath}/wdkCustomization/js/records/PathwayRecordClasses.PathwayRecordClass.js"></script>

<script type="text/javascript">
  // get xgmml and draw the visualization
  $(function() {
    drawVisualization("${id}");
  });
</script>        

    <style>
            /* The Cytoscape Web container must have its dimensions set. */
            html, body { height: 100%; width: 100%; padding: 0; margin: 0; }
            #cytoscapeweb { width: 100%; height: 100%; padding-bottom: 26px; }
            .link { text-decoration: underline; color: #0b94b1; cursor: pointer; }
        </style>

 <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
 <style>
  #draggable {z-index:1000;margin-left:18px;position:absolute;margin-top: 400px; background-color:white;border:1px solid black; border-radius:5px; width: 300px; padding: 0.5em; }
  #cytoscapeweb { border:1px solid black; border-radius:5px;  }
  #vis-menu {
    background: -webkit-linear-gradient(rgb(191,191,191), rgb(121,121,121));
    background: -o-linear-gradient(rgb(191,191,191), rgb(121,121,121));
    background: -moz-linear-gradient(rgb(191,191,191), rgb(121,121,121));
    background: linear-gradient(rgb(191,191,191), rgb(121,121,121));
    background-color: rgb(171,171,171);
    margin-bottom: inherit;
    width: auto;
  }
  #vis-menu li {
    z-index: 96;
  }
</style>

<script>
$(function() {
$( "#draggable" ).draggable({ iframeFix: '#cytoscapeweb embed' });
});
</script>

<div id="draggable" style="">
  <p>Click on nodes or edges for more info.  We have highlighed enzyme nodes in <font color="red">red</font> where we have mappped the EC Number to at least one Gene ID.   You can drag this box around to if the image is too large.</p>
<br />
</div>

<ul id="vis-menu" class="sf-menu">
    <li><a href="#">File</a>
        <ul>
            <li> <a href="javascript:exportVisualization('xgmml')">XGMML file</a></li>
            <li> <a href="javascript:exportVisualization('png')">image file</a></li>
 	</ul>
    </li>
    <li><a href="javascript:void(0)">Layout</a>
        <ul>
            <li><a  href="javascript:void(0)" onclick="changeLayout('Preset')">Kegg</a></li>
            <li><a  href="javascript:void(0)" onclick="changeLayout('ForceDirected')">ForceDirected</a></li>
            <li><a href="javascript:void(0)" onclick="changeLayout('Tree')">Tree</a></li>
            <li><a href="javascript:void(0)" onclick="changeLayout('Circle')">Circle</a></li>
            <li><a href="javascript:void(0)" onclick="changeLayout('Radial')">Radial</a></li>
        </ul>
    </li>
    <li><a href="#">Paint Expt.</a>
        <ul>
            <li><a href="javascript:void(0)" onclick="changeExperiment('')">Default</a></li>
<c:set value="${wdkRecord.tables['PathwayGraphs']}" var="pathwayGraphs"/>
<c:forEach var="row" items="${pathwayGraphs}">
            <li><a href="javascript:void(0)" onclick="changeExperiment('${row['internal'].value}')">${row['display_name'].value}</a></li>
</c:forEach>
        </ul>
    </li>
</ul>


 <div id="cytoscapeweb">
  Cytoscape Web will replace the contents of this div with your graph.
 </div>

<BR>
 <div align="right">
<a href="http://cytoscapeweb.cytoscape.org/">
    <img src="http://cytoscapeweb.cytoscape.org/img/logos/cw_s.png" alt="Cytosca
pe Web"/></a>
</div>

<br />
<br />
<!-- CYTOSCAPE end-->



<%-- Reaction Table ------------------------------------------------%>
  <imp:wdkTable tblName="CompoundsMetabolicPathways" isOpen="true"/>

</c:otherwise>
</c:choose>


  <c:set var="reference">
 <br>Data for Metabolic Pathways were procured from the <a href="http://www.kegg.jp/">Kyoto Encyclopedia of Genes and Genomes (KEGG)</a>.<br>
 This data was mapped to EC Numbers obtained from <a href="<c:url value='/getDataset.do?display=detail#Genomes and Annotation'/>">the official genome annotations of organisms</a>, and Compounds from the NCBI repository.<br>
 The images and maps for KEGG pathways are copyright of <a href="http://www.kanehisa.jp/">Kanehisa Laboratories</a>.
Coloring of the KEGG maps was performed in house with custom scripts and annotation information.<br>
  </c:set>
<br>
<br>

<imp:panel 
    displayName="Data Source"
    content="${reference}" />
<br>

<%------------------------------------------------------------------%>

<hr>


</imp:pageFrame>

