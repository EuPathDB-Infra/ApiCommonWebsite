<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>

<c:set var="strategy" value="${requestScope.wdkStrategy}" />
<site:Results  strategyId="${strategy.strategyId}"/>




