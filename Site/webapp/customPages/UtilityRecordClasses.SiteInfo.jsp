<%--
Required query:
        <sqlQuery name="CurrentInstance" isCacheable='false'>
            <paramRef ref="params.primaryKey"/> 
            <column name="global_name" />
            <column name="host_name" />
            <column name="address" />
            <column name="version" />
            <column name="system_date" />
           <sql> 
            <![CDATA[           
            select 
                global_name, 
                ver.banner version,
                UTL_INADDR.get_host_name as host_name,
                UTL_INADDR.get_host_address as address,
                to_char(sysdate, 'Dy DD-Mon-YYYY HH24:MI:SS') as system_date
            from global_name, v$version ver
            where lower(ver.banner) like '%oracle%'
             ]]>
           </sql>
        </sqlQuery>


OPTIONAL, to test dblink. Allowed column names are
cryptolink, plasmolink, toxolink 
       <sqlQuery name="PingPlasmo" isCacheable='false'>
            <paramRef ref="params.primaryKey"/> 
            <column name="plasmolink" />
            <sql> 
            <![CDATA[           
            select 
                global_name as plasmolink
            from global_name@plasmo
             ]]>
           </sql>
        </sqlQuery>


--%>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%/* get wdkRecord from proper scope */%>
<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>

<%/* display page header with recordClass type in banner */%>
<c:set value="${wdkRecord.recordClass.type}" var="recordType"/>

<html>
<head>
<title>${pageContext.request.serverName} Site Info</title>
</head>

<body>
<p>
<b>Oracle instance</b>: ${wdkRecord.attributes['global_name'].value}</b><br>
<b>Hosted on</b>: ${wdkRecord.attributes['host_name'].value} (${wdkRecord.attributes['address'].value})<br>
<b>Oracle Version</b>: ${wdkRecord.attributes['version'].value}<br>
<b>Date</b>: ${wdkRecord.attributes['system_date'].value}

<p>
<c:if test="${!empty wdkRecord.recordClass.attributeFields['cryptolink']}">
    <br>
    CryptoDB dblink:
    <c:catch var="e">
        ${wdkRecord.attributes['cryptolink'].value}
    </c:catch>
    <c:if test="${e!=null}">
        <font color="#CC0033">not responding</font>
    </c:if>
</c:if>

<c:if test="${!empty wdkRecord.recordClass.attributeFields['toxolink']}">
    <br>
    ToxoDB dblink:
    <c:catch var="e">
        ${wdkRecord.attributes['toxolink'].value}
    </c:catch>
    <c:if test="${e!=null}">
        <font color="#CC0033">not responding</font>
    </c:if>
</c:if>

<c:if test="${!empty wdkRecord.recordClass.attributeFields['plasmolink']}">
    <br>
    PlasmoDB dblink:
    <c:catch var="e">
        ${wdkRecord.attributes['plasmolink'].value}
    </c:catch>
    <c:if test="${e!=null}">
        <font color="#CC0033">not responding</font>
    </c:if>
</c:if>

</body>
</html>

