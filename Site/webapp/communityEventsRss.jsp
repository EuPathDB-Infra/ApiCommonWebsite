<%@
    page contentType="text/xml" 
%><%@
    taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ 
    taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" 
%><%@
    taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"
%><%@ 
    taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><fmt:setLocale 
    value="en-US"
/><c:set
    var="wdkModel" value="${applicationScope.wdkModel}"
/><c:set
    var='projectName' value='${applicationScope.wdkModel.name}'
/><c:set 
    var="scheme" value="${pageContext.request.scheme}" 
/><c:set 
    var="serverName" value="${pageContext.request.serverName}"
/><c:set 
    var="contextPath" value="${pageContext.request.contextPath}" 
/><c:set 
    var='currentDataUrl'
    value='http://${serverName}/cgi-bin/xmlMessageRead?messageCategory=Event&projectName=${projectName}'
/><c:set
    var="linkTmpl" 
    value="${scheme}://${serverName}${contextPath}/communityEvents.jsp"
/><c:import
    url="http://mheiges.tritrypdb.org/cgi-bin/xmlMessageRead?messageCategory=Event&projectName=TriTrypDB" var="xml"
/><x:parse
    doc="${xml}" var="doc"
/><c:set
    var="dateStringPattern" value="dd MMMM yyyy HH:mm"
/><?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
    <title>${xmlAnswer.question.displayName}</title>
    <link>${linkTmpl}</link>
    <description>${wdkModel.displayName} Community Events</description>
    <language>en</language>

<x:forEach var="r" select="$doc/records/record">
  <c:set var="date"><x:out select="submissionDate"/></c:set>
  <c:set var="headline"><x:out select="event/name" escapeXml="false"/></c:set>
  <c:set var="tag">event-<x:out select="recid"/></c:set>
  <c:set var="exturl"><x:out select="event/url"/></c:set>
  <c:set var="item"><x:out select="event/description" escapeXml="false"/></c:set>
  <fmt:parseDate  var="pdate" pattern="${dateStringPattern}" value="${date}" parseLocale="en_US"/> 
  <fmt:formatDate value="${pdate}" pattern="EEE, dd MMM yyyy HH:mm:ss zzz" var="fdate"/>
  <item>
      <title>${headline}</title>
      <link>${exturl}</link>
      <description>  
      ${item}
      </description>
      <guid>${tag}</guid>
      <pubDate>${fdate}</pubDate>
      <author>${wdkModel.displayName}</author>
  </item>
</x:forEach>

</channel>
</rss>
