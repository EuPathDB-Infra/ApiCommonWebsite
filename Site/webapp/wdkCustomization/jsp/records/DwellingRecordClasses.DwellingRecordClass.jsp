<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- get wdkRecord from proper scope --%>
<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>
<c:set var="attrs" value="${wdkRecord.attributes}"/>
<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="toDay"  value="<%=new java.util.Date()%>" />

<c:set var="primaryKey" value="${wdkRecord.primaryKey}"/>
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="id" value="${pkValues['source_id']}" />

<c:set var="recordName" value="${wdkRecord.recordClass.displayName}" />

<c:catch var="err">
<%-- force RecordInstance.fillColumnAttributeValues() to run
      and set isValidRecord to false if appropriate. 
      wdkRecord.isValidRecord is tested in the project's RecordClass --%>
<c:set var="junk" value="${attrs['name']}"/>
</c:catch>

<imp:pageFrame title="${id}"
             divisionName="DwellingRecord"
             refer="recordPage"
             division="queries_tools">


<div class="h2center" style="font-size:160%">
 	Dwelling
</div>

<div class="h3center" style="font-size:130%">
	${primaryKey}<br>
	<imp:recordPageBasketIcon />
</div>

<c:set var="attr" value="${attrs['overview']}"/>
<c:set var="start_date" value="01-aug-2011"/>
 <c:set var="end_date"  value="01-JUN-2015"/>


<imp:panel 
    displayName="${attr.displayName}"
    content="${attr.value}"
    attribute="${attr.name}" />


<c:set var="append" value="" />


<imp:wdkTable tblName="Characteristics" isOpen="true"/>

<imp:wdkTable tblName="UncategorizedCharacteristics" isOpen="false"/>

<imp:wdkTable tblName="ParticipantLinks" isOpen="true"/>

<imp:wdkTable tblName="mosquitoCollections" isOpen="true"/>
<div align="center">
<img align="middle"  src="/cgi-bin/dataPlotter.pl?project_id=PlasmoDB&id=${id}&enddate=${end_date}&startdate=${start_date}&type=DwellingLightTrap&fmt=png&thumb=0"/>

</div>

</imp:pageFrame>
