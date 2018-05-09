<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Control Panel User Permissions"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>CP Users</b> tool allows admins to create and manage control panel user logins.  (It is an extra, separate from the CP Permissions tool, because Neptune supports other means of authenticating
  control panel users, such as LDAP, Active Directory, or other authentication mechanisms.)
</p>

<p>
  To add a new control panel user, enter the user's first name, last name, email and password, and click the Add User button.
  The password must have at least six characters, containing at least one letter and one number.
</p>

<p>
  You may update the users's first and last name and email without knowing his/her password, simply by leaving the password field blank.  If you wish to reset the user's password,
  enter it and update the record.  PASSWORDS ARE ONE-WAY ENCRYPTED AND CANNOT BE RETRIEVED.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

