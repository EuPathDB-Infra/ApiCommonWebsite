<%@ 
    page contentType="text/xml"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<root>
<c:set var="strategy" value="${requestScope.wdkStrategy}" />
<site:xml_strat first_step="${strategy.latestStep}" stratName="${strategy.name}" stratId="${strategy.strategyId}"/>
</root>
<%--
<c:set var="wdkAnswer" value="${requestScope.wdkAnswer}" />
<c:set var="history" value="${requestScope.wdkHistory}" />
<c:set var="model" value="${applicationScope.wdkModel}" />
<c:set var="strategy" value="${requestScope.wdkStrategy}" />
<c:set var="step" value="${requestScope.wdkStep}"/>
<div id="containerDiv">
<site:BreadCrumbs strategy="${strategy}" strat_step="${step}"/>
</div>--%>

