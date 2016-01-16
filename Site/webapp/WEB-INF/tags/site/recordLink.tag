<?xml version="1.0" encoding="UTF-8"?>
<jsp:root version="2.0"
    xmlns:jsp="http://java.sun.com/JSP/Page"
    xmlns:c="http://java.sun.com/jsp/jstl/core"
    xmlns:wdk="urn:jsptagdir:/WEB-INF/tags/wdk">

  <jsp:directive.attribute
    name="primaryKeyAttributeValue"
    type="org.gusdb.wdk.model.record.attribute.PrimaryKeyAttributeValue"
    required="true"
    description="The primary key AttributeValue instance"
  />

  <jsp:directive.attribute
    name="recordClass"
    type="org.gusdb.wdk.model.jspwrap.RecordClassBean"
    required="true"
    description="The full name of the record class"
  />

  <jsp:directive.attribute
    name="displayValue"
    required="true"
    description="The display name of the primarykey"
  />

  <c:choose>

    <c:when test="${recordClass.fullName eq 'PathwayRecordClasses.PathwayRecordClass'}">
      <wdk:recordLink
        displayValue="${displayValue}"
        primaryKeyAttributeValue="${primaryKeyAttributeValue}"
        recordClass="${recordClass}"/>
    </c:when>

    <c:otherwise>
      <c:url var="recordLink" value="/app/record/${recordClass.urlSegment}" />
      <c:forEach items="${primaryKeyAttributeValue.values}" var="pkValue" varStatus="loop">
        <c:set var="recordLink" value="${recordLink}/${pkValue.value}" />
      </c:forEach>

      <a href="${recordLink}">${displayValue}</a>
    </c:otherwise>

  </c:choose>

</jsp:root>
