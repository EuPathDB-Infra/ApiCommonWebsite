<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="synd" uri="http://crashingdaily.com/taglib/syndication" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>





<c:url var="feedPath" value="/communityEventsRss.jsp" />
<c:set var="rss_Url">
http://${pageContext.request.serverName}${feedPath}
</c:set>

<c:catch var="feedex">
 <synd:feed feed="allFeeds" timeout="5000">
     ${rss_Url}
 </synd:feed>


<ul id='communityEventList'>
<c:forEach items="${allFeeds.entries}" var="e" begin="0" end="3" >
  <fmt:formatDate var="fdate" value="${e.publishedDate}" pattern="d MMMM yyyy"/>
  <li id="${e.uri}"><a href='${fn:trim(e.link)}'>${e.title}</a></li>
</c:forEach>
  <li style='list-style:circle;'><a href='<c:url value="/communityEvents.jsp"/>'>Full Events Page</a></li>
</c:catch>
<c:if test="${feedex != null}">
  <li><i>temporarily unavailable ${feedex}</i></li>
</c:if>
</ul>
