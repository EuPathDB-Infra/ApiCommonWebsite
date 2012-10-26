<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<%-- partial is used for internal questions in queryList.tag --%>
<c:choose>
  <c:when test="${requestScope.partial != 'true'}">
    <imp:pageFrame title="Search for ${wdkQuestion.recordClass.type}s by ${wdkQuestion.displayName}" refer="question">
      <imp:questionPageContent/>
    </imp:pageFrame>
    <!-- log screen and browser window size for awstats; excluded when page is called by Ajax (internal
       questions; partial == true)  because it breaks IE7. When using internal questions, the parent 
       question page will still call this once.
    -->
    <script language="javascript" type="text/javascript" src="/js/awstats_misc_tracker.js" ></script>
    <noscript><img src="/js/awstats_misc_tracker.js?nojs=y" height="0" width="0" border="0" style="display: none"></noscript>
  </c:when>
  <c:otherwise>
    <%-- need to output page meta to force the content to be UTF-8 --%>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3c.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type"/>
      </head>
      <body>
        <imp:questionPageContent/>
      </body>
    </html>
  </c:otherwise>
</c:choose>
