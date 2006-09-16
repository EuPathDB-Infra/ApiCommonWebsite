<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="logic" uri="http://jakarta.apache.org/struts/tags-logic" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>

<site:header title="${wdkModel.displayName} :: Update User Profile"
                 banner="Update User Profile"
                 parentDivision="${wdkModel.displayName}"
                 parentUrl="/home.jsp"
                 divisionName="Update User Profile"
                 division="profile"/>

<script language="JavaScript" type="text/javascript">
<!--
function validateFields(e)
{
    if (typeof e != 'undefined' && !enter_key_trap(e)) {
        return;
    }

    if (document.profileForm.firstName.value == "") {
        alert('Please provide your first name.');
        document.profileForm.firstName.focus();
        return false;
    } else if (document.profileForm.lastName.value == "") {
        alert('Please provide your last name.');
        document.profileForm.lastName.focus();
        return false;
    } else if (document.profileForm.organization.value == "") {
        alert('Please provide the name of the organization you belong to.');
        document.profileForm.organization.focus();
        return false;
    } else {
        document.profileForm.saveButton.disabled = true;
        document.profileForm.submit();
        return true;
    }
}
//-->
</script>

<!-- get user object from session scope -->
<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>

<!-- display the success information, if the user registered successfully -->
<c:if test="${requestScope.profileSucceed != null}">

  <p><font color="blue">Your profile has been updated successfully.</font> </p>

</c:if>

<html:form method="POST" action='/processProfile.do' >

  <c:if test="${requestScope.refererUrl != null}">
     <input type="hidden" name="refererUrl" value="${requestScope.refererUrl}">
  </c:if>

  <table width="650">
    <tr>
      <th colspan="2"> User Profile </th>
    </tr>

<c:choose>
  <c:when test="${wdkUser == null || wdkUser.guest == true}">

    <tr>
      <td colspan="2">Please login to view or update your profile.</td>
    </tr>

  </c:when>

  <c:otherwise>

    <!-- check if there's an error message to display -->
    <c:if test="${requestScope.profileError != null}">
       <tr>
          <td colspan="2">
             <font color="red">${requestScope.profileError}</font>
          </td>
       </tr>
    </c:if>

    <tr>
      <td align="right" width="50%" nowrap>Email: </td>
      <td align="left">${wdkUser.email}</td>
    </tr>
    <tr>
      <td align="center" colspan="2" align="center">
         <a href="<c:url value='/showPassword.do'/>">Change Password</a>
      </td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> First Name: </td>
      <td align="left"><input type="text" name="firstName" value="${wdkUser.firstName}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap>Middle Name: </td>
      <td align="left"><input type="text" name="middleName" value="${wdkUser.middleName}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> Last Name:</td>
      <td align="left"><input type="text" name="lastName" value="${wdkUser.lastName}" size="20"></td>
    </tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> Institution:</td>
      <td align="left"><input type="text" name="organization" value="${wdkUser.organization}" size="50"></td>
    </tr>
    <tr>
    <td align="right" width="50%" nowrap>
          Send me email alerts about: 
    </td>
    <td nowrap>
        <c:set var="global" value="${wdkUser.globalPreferences}"/>
        <c:choose>
           <c:when test="${global['preference_global_email_apidb'] == 'on'}">
              <input type="checkbox" name="preference_global_email_apidb" checked>ApiDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_apidb">ApiDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${global['preference_global_email_cryptodb'] == 'on'}">
              <input type="checkbox" name="preference_global_email_cryptodb" checked>CryptoDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_cryptodb">CryptoDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${global['preference_global_email_plasmodb'] == 'on'}">
              <input type="checkbox" name="preference_global_email_plasmodb" checked>PlasmoDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_plasmodb">PlasmoDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${global['preference_global_email_toxodb'] == 'on'}">
              <input type="checkbox" name="preference_global_email_toxodb" checked>ToxoDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_toxodb">ToxoDB</input>
           </c:otherwise>
        </c:choose>
    </td>
    </tr>
    <tr>
       <td colspan="2" align="center">
           <input type="submit" name="saveButton" value="Save"  onclick="return validateFields();" />
       </td>
    </tr>

  </c:otherwise>

</c:choose>

  </table>
</html:form>

</div>
<site:footer/>
