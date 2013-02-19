<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="refer"
              required="true"
              description="page calling this tag"
%>
<%@ attribute name="title"
              required="false"
              description="record class"
%>
<c:set var="project" value="${wdkModel.name}"/>

<c:if test="${project == 'PlasmoDB'  &&
           ( refer == 'question' && fn:containsIgnoreCase(title,'pathway') ||
				     refer == 'question' && fn:containsIgnoreCase(title,'compound') ||
             refer == 'recordPage' && fn:containsIgnoreCase(title,'pathway') ||
             refer == 'recordPage' && fn:containsIgnoreCase(title,'compound') ) }">

       This <i>beta-release</i> of Metabolic Pathways data sets incorporates a subset of PubChem records and KEGG pathways.  Future releases will include additional metabolites and other small molecules, and mapping onto additional pathways (including MPMP, MetaCyc, etc).  

       Please explore the site and 
			 <a onclick="poptastic(this.href); return false;" target="_blank" href='<c:url value='/help.jsp'/>'>contact us</a> 
			 with your feedback. 
</c:if>
