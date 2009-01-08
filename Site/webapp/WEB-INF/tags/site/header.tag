<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="title"
              description="Value to appear in page's title"
%>
<%-----------------------------%>

<%@ attribute name="banner"
              required="false"
              description="Value to appear at top of page"
%>

<%@ attribute name="bannerPreformatted"
              required="false"
              description="Value to appear at top of page"
%>

<%@ attribute name="logo"
              required="false"
              description="relative url for logo to display, or no logo if set to 'none'"
%>

<%@ attribute name="parentDivision"
              required="false"
%>

<%@ attribute name="parentUrl"
              required="false"
%>

<%@ attribute name="divisionName"
              required="false"
%>

<%@ attribute name="division"
              required="false"
%>

<%@ attribute name="isBannerImage"
              required="false"
%>
<%@ attribute name="releaseDate"
              required="false"
%>
<%@ attribute name="bannerSuperScript"
              required="false"
%>

<%@ attribute name="summary"
              required="false"
              description="short text description of the page"
%>

<%@ attribute name="headElement"
              required="false"
              description="additional head elements"
%>

<%@ attribute name="bodyElement"
              required="false"
              description="additional body elements"
%>

<%---------------------------%>
<%@ attribute name="refer" 
 			  type="java.lang.String"
			  required="false" 
			  description="Page calling this tag"
%>

<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />
<c:set var="siteName" value="${applicationScope.wdkModel.name}" />

<html xmlns="http://www.w3.org/1999/xhtml">

<!--[if IE]>
<style type="text/css" media="screen">
	body {
		behavior: url(/assets/css/csshover.htc);
		font-size: 100%;
	}

	*html .ts_ie {
		margin-left:-20px;
	}

	#menu ul li {
		float: left; width: 100%;
	}
	
	#menu ul li a {
		height: 1%;
	} 

	#menu a, #menu h2 {
		font: bold 0.7em/1.4em arial, helvetica, sans-serif;
	}

	.twoColHybLt #sidebar1 { 
		padding-top: 30px; 
	}
	
	.twoColHybLt #mainContent { 
		zoom: 1; padding-top: 15px; 
	}
	
	#menu_lefttop {
		/*width: 220px;*/
		margin-top: 8px;
		position: absolute;
		left: 6px;
		top: 129px;
	}
	
	*html .menu_lefttop_drop{
		padding-left:8px;
		padding-right:19px;
	}
	
	*html #info {
	   width: 250px;
	   min-height: 240px;
	   height:auto;
	   background-image: /assets/images/bubble_backgrnd.png);
	   background-repeat: repeat-y;
	   text-align: left;
	   padding-top: 2px;
	   padding-left: 19px;
	   z-index: 99;
	}
	
	*html #infobottom{
		width:250px;
		margin:0px -3px 0px;
	}
	
	*html table tr td{
		vertical-align: top;
	}
	
	*html #contentcolumn, *html #contentcolumn{
		width:100%
	}
	
	*html .rightarrow2 {
		left: .5em;
		top: -3.4em;
	}
	
	*html .crumb_details {
		width: 500px;
		z-index: 999;
	}
	
	*html .operation {
		z-index: -1;
	}
	
	a.redbutton {
		z-index: -1;
	}
		
</style>
<![endif]-->



<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${title}</title>
<link rel="icon" type="image/png" href="/assets/images/${project}/favicon.ico"> <%-- standard --%>
<link rel="shortcut icon" href="/assets/images/${project}/favicon.ico"> <%-- for IE7 --%>
<link href="/assets/css/${project}.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/assets/css/history.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="/assets/css/Strategy.css" />
<link rel="StyleSheet" href="/assets/css/filter_menu.css" type="text/css"/>

<style type="text/css">
<!--
body {
	background-image: url(/assets/images/${project}/background_s.jpg);
	background-repeat: repeat-x;
    }
body {
behavior: url(/assets/css/csshover.htc);
}
#header {
	height: 104px;
	background-image: url(/assets/images/${project}/backgroundtop_s.jpg);
}
#header p {
	font-size: 9px;
}
-->
</style>

<site:jscript refer="${refer}"/>
${headElement}
</head>

<body>


<div id="header2">
   <div id="header_rt">
   <div align="right"><div id="toplink">
   <a href="#skip"><img src="/assets/images/transparent1.gif" alt="Skip navigational links" width="1" height="1" border="0" /></a>
   <c:choose>
   <c:when test="${project == 'TriTrypDB'}">
     <img  usemap="#partof" src="/assets/images/${project}/partofeupath.png" />
   </c:when>
   <c:otherwise>
     <a href="http://eupathdb.org"><img src="/assets/images/${project}/partofeupath.png" alt="Link to EuPathDB homepage"/></a>   
   </c:otherwise>
   </c:choose>
   </div></div>
       <div id="bottom">
	  <site:quickSearch /><br />
	  <div id="nav_topdiv">
      <ul id="nav_top">
      <li>
      <a href="#">About ${siteName}<img src="/assets/images/${project}/menu_divider5.png" alt="" width="17" height="9" /></a>
      		<ul>
          <li><a href="#">Who We Are</a></li>
          <li><a href="#">What We Do</a></li>
          <li><a href="#">What You Can Do Here</a></li>
          <li><a href="<c:url value='showXmlDataContent.do?name=XmlQuestions.News'/>">News</a></li>
          <li><a href="#">Acknowledgements</a></li>
        	</ul>
        </li>
      <li>
      <a href="#">Help<img src="/assets/images/${project}/menu_divider5.png" alt="" width="17" height="9" /></a>
      		<ul>
          <li><a href="#">Web Tutorials</a></li>
          <li><a href="#">Community Links</a></li>
          <li><a href="#">Glossary of Terms</a></li>
          <li><a href="#">Website Statistics</a></li>
        	</ul>
        </li>
      <li>
      <a href="<c:url value="/help.jsp"/>">Contact Us<img src="/assets/images/${project}/menu_divider5.png" alt="" width="17" height="9" /></a></li>
      <li>
      <a href="#">Log In/Register</a> <%-- possible style when a user is login....<a href="#">Logout</a>
 	  <br /><b style='color:black'>John Doe</b> | <a href="#">Profile</a>
	  --%></li>      
      </ul>
      </div>
      	  
       </div>
   </div>

<%--
crypto width="318" height="64"    version    date  
tryp          282           72
--%>
<c:if test="${fn:containsIgnoreCase(project, 'CryptoDB')}">
     <c:set var="width" value="318" />
     <c:set var="height" value="64" />
     <c:set var="version" value="4.0" />
     <c:set var="date" value="January 15th, 2009" />
</c:if>

<c:if test="${fn:containsIgnoreCase(project, 'TriTrypDB')}">
     <c:set var="width" value="320" />
     <c:set var="height" value="72" />
     <c:set var="version" value="1.0" />
     <c:set var="date" value="January 15th, 2009" />
</c:if>



   <p><a href="/"><img src="/assets/images/${project}/title_s.png" alt="Link to ${project} homepage" 
	width="${width}" height="${height}" align="left" /></a></p>
   <p>&nbsp;</p>
   <p>Version ${version}<br />
   ${date}</p>
</div> 


<c:if test="${project == 'TriTrypDB'}">
  <map name="partof">
  <area shape=rect coords="0,0 172,22" href="http://eupathdb.org" alt="EuPathDB home page">
  <area shape=rect coords="310,0 380,22" href="http://www.genedb.org" alt="GeneDB home page">
  </map>
</c:if>


<site:menubar />
