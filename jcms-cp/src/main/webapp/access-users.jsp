<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=8; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%

  // initialize default user
  JcmsAccessUser u = new JcmsAccessUser();
  
  // control variables
  boolean insertuser = request.getParameter("insertuser")!=null;
  boolean updateuser = request.getParameter("updateuser")!=null;
  boolean deleteuser = request.getParameter("deleteuser")!=null;
  boolean updaterole = request.getParameter("updaterole")!=null;

  boolean confirmed = request.getParameter("confirmed")!=null;

  // no-change password text
  String noPasswordChange = "--- no change ---";
  
  try {

    // instantiate non-public access user
    if (request.getParameter("accessuser_id")!=null) {
      int accessuser_id = Integer.parseInt(request.getParameter("accessuser_id"));
      if (accessuser_id>0) u = new JcmsAccessUser(application, accessuser_id);
    }
    
    if (insertuser) {
      if (!request.getParameter("password").equals(noPasswordChange)) {
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        u.insert(request);
        message = "New user <b>"+u.email+"</b> has been added.";
      } else {
        error = "Please supply a valid password.";
      }
    }

    if (updateuser) {
      String emailOld = u.email;
      u.setEmail(request.getParameter("email"));
      boolean passwordUpdated = false;
      if (!request.getParameter("password").equals(noPasswordChange)) {
        u.setPassword(request.getParameter("password"));
        passwordUpdated = true;
      }
      u.update(request);
      message = "User <b>"+emailOld+"</b> email has been updated to <b>"+u.email+"</b>. ";
      if (passwordUpdated) message += "Password updated.";
    }

    if (deleteuser) {
      if (confirmed) {
        message = "User <b>"+u.email+"</b> removed.";
        u.delete(request);
      } else {
        error = "You must check the box to confirm removal of a user (it is permanent).";
      }
    }

    if (updaterole) {
      JcmsAccessRole ar = new JcmsAccessRole(application, Integer.parseInt(request.getParameter("accessrole_id")));
      boolean checked = (request.getParameter("checked")!=null);
      if (checked) {
        u.addRole(session, ar);
        message = "User <b>"+u.email+"</b> added to role <b>"+ar.accessrole+"</b>.";
      } else {
        u.removeRole(session, ar);
        message = "User <b>"+u.email+"</b> removed from role <b>"+ar.accessrole+"</b>.";
      }
    }

  } catch (Exception ex) {
    
    error = ex.toString();
    
  }

  // array of all access users
  JcmsAccessUser[] users = JcmsAccessUser.getAllJcmsAccessUsers(application);

  // array of all access roles
  JcmsAccessRole[] roles = JcmsAccessRole.getAllJcmsAccessRoles(application);

%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<form action="access-users.jsp" method="post">
  <table>
    <tr>
      <td valign="bottom">
        Access User<br/>
        <select name="accessuser_id" onChange="submit()">
          <option value="0">--- add user ---</option>
          <%
            for (int i=0; i<users.length; i++) {
                boolean selected = (u.accessuser_id==users[i].accessuser_id);
            %>
            <option <% if (selected) out.print("selected"); %> value="<%=users[i].accessuser_id%>"><%=users[i].email%></option>
            <%
            }
            %>
        </select>
      </td>
      <td valign="bottom">
        <td>Email<br/><input type="text" name="email" <% if (!u.isDefault()) { %>value="<%=u.email%>"<% } %> size="32"/></td>
        <td>Password<br/><input type="text" name="password" value="<%=noPasswordChange%>" size="24"/></td>
        <% if (u.accessuser_id==0) { %>
        <td valign="bottom"><input type="submit" class="insert" name="insertuser" value="Add User"/></td>
        <% } else { %>
        <td valign="bottom">
          <input type="submit" class="update" name="updateuser" value="Update User" />
          <input type="checkbox" name="confirmed" value="true" />
          <input type="submit" class="delete" name="deleteuser" value="Remove User" />
        </td>
        <% } %>
    </tr>
  </table>
</form>

<% if (!u.isDefault()) { %>
<h3>Roles</h3>
<table>
  <%
    for (int i=0; i<roles.length; i++) {
    %>
    <tr>
      <td>
        <form action="access-users.jsp" method="post">
          <input type="hidden" name="updaterole" value="true"/>
          <input type="hidden" name="accessuser_id" value="<%=u.accessuser_id%>"/>
          <input type="hidden" name="accessrole_id" value="<%=roles[i].accessrole_id%>"/>
          <input type="checkbox" name="checked" <% if (u.isMember(application,roles[i])) out.print("checked"); %> onClick="submit()" value="true"/>
        </form>
      </td>
      <td><%=roles[i].accessrole%></td>
    </tr>
    <% } %>
</table>
<% } %>
    
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
