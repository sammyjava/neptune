<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/init.inc" %>
<%
  // override page title
  p.title = "Password Reset";
  p.headtitle = siteName + " : " + p.title;

  // output vars
  String error = null;
  String message = null;

  // logic
  boolean sendEmail = request.getParameter("submitemail")!=null;
  boolean keyProvided = request.getParameter("key")!=null;
  boolean keyMatch = false;
  boolean resetPassword = request.getParameter("newpass")!=null;
  boolean passwordReset = false;
  boolean mailSent = false;
  
  // posted vars
  String email = request.getParameter("email");
  if (email!=null) email = email.trim().toLowerCase();

  if (sendEmail) {
    if (Authentication.isValidEmail(email)) {
      try {
        // get user, create key, send reset URL
        JcmsAccessUser jau = new JcmsAccessUser(application, email);
        jau.createResetKey(application);
        Mailer mailer = new Mailer();
        String msg = "You have requested to reset your password on the "+siteName+" website.  In order to do so, please visit the following page:\n";
        msg += "\n";
        msg += request.getRequestURL()+"?key="+jau.resetkey+"\n";
        msg += "\n";
        mailer.send(Setting.getString(application, "access_passwordreset_fromaddress"), Setting.getString(application, "access_passwordreset_fromname"),
		    jau.email, "", "Password reset for the "+siteName+" website", msg);
	mailSent = true;
      } catch (Exception ex) {
        error = ex.getMessage();
      }
    } else {
      error = "You have supplied a blank or invalid email address.";
    }
  }

  if (keyProvided) {
    String key = request.getParameter("key");
    try {
      JcmsAccessUser jau = JcmsAccessUser.getByResetKey(application, key);
      keyMatch = true;
    } catch (Exception ex) {
      error = ex.getMessage();
    }
  }

  if (resetPassword) {
    String key = request.getParameter("key");
    String newpass = request.getParameter("newpass");
    String newpassrepeat = request.getParameter("newpassrepeat");
    try {
      // input validation
      if (newpass==null || newpass.trim().length()==0) {
        error = "You have not supplied a new password. Please enter your new password twice.";
      } else if (newpassrepeat==null || newpassrepeat.trim().length()==0) {
        error = "You have not supplied a repeat of your new password.  Please enter your new password twice.";
      } else if (!newpass.equals(newpassrepeat)) {
        error = "Your two password entries do not match.  Please try again.";
      } else {
        JcmsAccessUser jau = JcmsAccessUser.getByResetKey(application, key);
        jau.resetPassword(application, newpass);
        passwordReset = true;
      }
    } catch (Exception ex) {
      error = ex.getMessage();
    }
  }
%>
<%@ include file="/WEB-INF/include/head.jhtml" %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header.jhtml" %><% } %>
<% if (showNavPrimary) { %><%@ include file="/WEB-INF/include/nav-primary.jhtml" %><% } %>
<% if (navPrimaryDhtmlEnable) { %><%@ include file="/WEB-INF/include/dhtml.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader.jhtml" %><% } %>
<!-- main region -->
<table id="main" cellspacing="0" width="100%">
  <tr>
    <% if (showSidebar) { %><td id="main-left" valign="top"><% } %>
      <% if (showSidebar) { %><%@ include file="/WEB-INF/include/sidebar-top.jhtml" %><% } %>
      <% if (showSidebar && showNavSecondary && !showNavVertical) { %><%@ include file="/WEB-INF/include/nav-secondary.jhtml" %><% } %>
      <% if (showSidebar && showNavVertical) { %><%@ include file="/WEB-INF/include/nav-vertical.jhtml" %><% } %>
      <% if (showSidebar) { %><%@ include file="/WEB-INF/include/sidebar-bottom.jhtml" %><% } %>
    <% if (showSidebar) { %></td><% } %>
    <td id="main-right" valign="top">
      <% if (showBreadCrumbs) { %><%@ include file="/WEB-INF/include/breadcrumbs.jhtml" %><% } %>
      <% if (showPageTitle) { %><%@ include file="/WEB-INF/include/pagetitle.jhtml" %><% } %>
      <table id="l1" cellspacing="0" width="100%">
        <tr>
          <td valign="top" id="l1_p1">
            <% if (error!=null) { %><div class="error"><%=error%></div><% } %>
            <% if (passwordReset) { %>
            <p>
              Your password has been reset.  You may now log into the site with your new password.
            </p>
            <% } else if (keyMatch) { %>
            <p>
              Enter your new password twice, and submit the form to reset your site access password.
            </p>
            <form method="post" class="access">
              <table class="access">
                <tr>
                  <td align="right">Enter new password:</td>
                  <td><input type="password" size="16" name="newpass"/></td>
                </tr>
                <tr>
                  <td align="right">Repeat new password:</td>
                  <td><input type="password" size="16" name="newpassrepeat"/></td>
                </tr>
                <tr>
                  <td colspan="2" align="right"><input type="submit" class="submit" name="resetpassword" value="Reset Password"/></td>
                </tr>
              </table>
            </form>
            <% } else if (mailSent) { %>
            <p>
              A password reset URL has been sent to <b><%=email%></b>.
            </p>
            <p>
              Check your email and follow the instructions given there to reset your password.
            </p>
            <% } else { %>
            <p>
              To reset your password, submit your email address below.
            </p>
            <form method="post" class="access">
              <table class="access">
                <tr>
                  <td>Email:</td>
                  <td><input type="text" size="32" name="email" value="<%=Util.blankIfNull(email)%>"/></td>
                  <td><input type="submit" class="submit" name="submitemail" value="Submit"/></td>
                </tr>
              </table>
            </form>
            <p>
              A password reset URL will be sent to you via email.  You must use that URL to reset your password.
            </p>
            <% } %>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer.jhtml" %><% } %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/foot.jhtml" %>
