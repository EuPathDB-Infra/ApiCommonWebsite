<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="logic" uri="http://jakarta.apache.org/struts/tags-logic" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>

<site:header title="${wdkModel.displayName} :: Registration"
                 banner="Registration and Subscription"
                 parentDivision="${wdkModel.displayName}"
                 parentUrl="/home.jsp"
                 divisionName="User Registration"
                 division="register"/>

<script language="JavaScript" type="text/javascript">
<!--
function validateFields(e)
{
    if (typeof e != 'undefined' && !enter_key_trap(e)) {
        return;
    }

    var email = document.registerForm.email.value;
    var pat = email.indexOf('@');
    var pdot = email.lastIndexOf('.');
    var len = email.length;

    if (email == '') {
        alert('Please provide your email address.');
        document.registerForm.email.focus();
        return false;
    } else if (pat<=0 || pdot<pat || pat==len-1 || pdot==len-1) {
        alert('The format of the email is invalid.');
        document.registerForm.email.focus();
        return false;
    } else if (email != document.registerForm.confirmEmail.value) {
        alert('The emails do not match. Please enter it again.');
        document.registerForm.email.focus();
        return false;
    } else if (document.registerForm.firstName.value == "") {
        alert('Please provide your first name.');
        document.registerForm.firstName.focus();
        return false;
    } else if (document.registerForm.lastName.value == "") {
        alert('Please provide your last name.');
        document.registerForm.lastName.focus();
        return false;
    } else if (document.registerForm.organization.value == "") {
        alert('Please provide the name of the organization you belong to.');
        document.registerForm.organization.focus();
        return false;
    } else {
        document.registerForm.registerButton.disabled = true;
        document.registerForm.submit();
        return true;
    }
}
//-->
</script>

<div id="contentwrapper">
        <div id="contentcolumn2">
                <div class="innertube">


<!-- get user object from session scope -->
<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>

<!-- display page header with recordClass type in banner -->
<c:set value="${wdkRecord.recordClass.type}" var="recordType"/>

<!-- display the success information, if the user registered successfully -->
<c:choose>
  <c:when test="${requestScope.registerSucceed != null}">

  <div align="center">
  <h1>
    <b>You have registered successfully.</b>
  </h1>

  <p>We have sent you an email with a temporary password.</p>
  <p>Please login and change your password to one that you'll remember.
  </p>
  </div>

  </c:when>

  <c:otherwise>
  <!-- continue registration fomr -->

<html:form method="POST" action='/processRegister.do' >

  <c:if test="${requestScope.refererUrl != null}">
     <input type="hidden" name="refererUrl" value="${requestScope.refererUrl}">
  </c:if>

  <div align="left">

<p> IMPORTANT: If you already registered in another site (ApiDB, CryptoDB ,GiardiaDB, PlasmoDB, ToxoDB or TrichDB) you do NOT need to register again.

<p><b>Why register/subscribe</b>? So you can:
<ul>
<li><i>optionally</i> receive infrequent alerts (at most monthly)
<li>comment on genes and sequences
<li>have your query history return the next time you login.
<li>set site preferences, such as items per page displayed in the query result
  </div>
<hr>
  <div align="center">


  <table width="650">

<c:choose>
  <c:when test="${wdkUser != null && wdkUser.guest != true}">

    <tr>
      <td colspan="2"><p>You are logged in. </p>
        <p>To change your password or profile go <a href="<c:url value='/showProfile.do'/>">here</a>.</p></td>
    </tr>

  </c:when>

  <c:otherwise>

    <!-- check if there's an error message to display -->
    <c:if test="${requestScope.registerError != null}">
       <tr>
          <td colspan="2">
             <font color="red">${requestScope.registerError}</font>
          </td>
       </tr>
    </c:if>

    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> Email: </td>
      <td align="left"><input type="text" name="email" value="${requestScope.email}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> Confirm Email: </td>
      <td align="left"><input type="text" name="confirmEmail" value="${requestScope.email}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> First Name: </td>
      <td align="left"><input type="text" name="firstName" value="${requestScope.firstName}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap>Middle Name: </td>
      <td align="left"><input type="text" name="middleName" value="${requestScope.middleName}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> Last Name: </td>
      <td align="left"><input type="text" name="lastName" value="${requestScope.lastName}" size="20"></td>
    </tr>
    <tr>
      <td align="right" width="50%" nowrap><font color="red">*</font> Institution: </td>
      <td align="left"><input type="text" name="organization" value="${requestScope.organization}" size="50"></td>
    </tr>
    <tr>
    <td align="right" width="50%" nowrap>
          Send me email alerts about: 
    </td>
    <td nowrap>
        <c:choose>
           <c:when test="${requestScope.preference_global_email_apidb != null}">
              <input type="checkbox" name="preference_global_email_apidb" checked>ApiDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_apidb">ApiDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${requestScope.preference_global_email_cryptodb != null}">
              <input type="checkbox" name="preference_global_email_cryptodb" checked>CryptoDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_cryptodb">CryptoDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${requestScope.preference_global_email_giardiadb != null}">
              <input type="checkbox" name="preference_global_email_giardiadb" checked>GiardiaDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_giardiadb">GiardiaDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${requestScope.preference_global_email_plasmodb != null}">
              <input type="checkbox" name="preference_global_email_plasmodb" checked>PlasmoDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_plasmodb">PlasmoDB</input>
           </c:otherwise>
        </c:choose>
        <c:choose>
           <c:when test="${requestScope.preference_global_email_toxodb != null}">
              <input type="checkbox" name="preference_global_email_toxodb" checked>ToxoDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_toxodb">ToxoDB</input>
           </c:otherwise>
        </c:choose>

        <c:choose>
           <c:when test="${requestScope.preference_global_email_trichdb != null}">
              <input type="checkbox" name="preference_global_email_trichdb" checked>TrichDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_trichdb">TrichDB</input>
           </c:otherwise>
        </c:choose>
          <c:choose>
           <c:when test="${requestScope.preference_global_email_tritrypdb != null}">
              <input type="checkbox" name="preference_global_email_tritrypdb" checked>TriTrypDB</input>
           </c:when>
           <c:otherwise>
              <input type="checkbox" name="preference_global_email_tritrypdb">TriTrypDB</input>
           </c:otherwise>
        </c:choose>
    </td>
    </tr>
    <tr>
       <td colspan="2" align="center">
           <input type="submit" name="registerButton" value="Submit"  onclick="return validateFields();" />
       </td>
    </tr>

  </c:otherwise>

</c:choose>

  </table>
</html:form>


  </c:otherwise>

</c:choose>

</div>
<hr>
<b>Privacy</b> 
<p>How we will use your email: 
<ul>
<li>confirm your subscription
<li>send you the infrequent alerts you have subscribed to.  You may always unsubscribe.
<li>nothing else.  We will not release the email list.  
</ul>
<p>
How we will use your name and institution:
<ul>
<li>if you add a comment to a Gene or a Sequence, your name and institution will be displayed with the comment 
<li>nothing else.  We will not release your name or institution.  
</ul>

                </div>
        </div>
</div>


<site:footer/>
